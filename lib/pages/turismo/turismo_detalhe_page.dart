import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_player/video_player.dart';

class TurismoDetalhePage extends StatefulWidget {
  final String nome;
  final String imagem;
  final String descricao;
  final double latitude;
  final double longitude;
  final String cidade;
  final String?
  docId; // opcional: se informado, o widget buscará imagens/extras no Firestore

  const TurismoDetalhePage({
    super.key,
    required this.nome,
    required this.imagem,
    required this.descricao,
    required this.latitude,
    required this.longitude,
    required this.cidade,
    this.docId,
  });

  @override
  State<TurismoDetalhePage> createState() => _TurismoDetalhePageState();
}

class _TurismoDetalhePageState extends State<TurismoDetalhePage> {
  double notaMedia = 0.0;
  int totalVotos = 0;
  bool carregando = true;

  List<String> imagensExtras = [];
  String? videoUrl;

  VideoPlayerController? videoController;
  bool videoInitialized = false;

  @override
  void initState() {
    super.initState();
    // Só carrega dados do Firestore se docId foi fornecido e não for vazio
    if (widget.docId != null && widget.docId!.trim().isNotEmpty) {
      carregarDados();
    } else {
      // não há docId: não tenta acessar Firestore — apenas mostra os dados passados pelo construtor
      setState(() {
        carregando = false;
      });
    }
  }

  Future<void> carregarDados() async {
    try {
      final docRef = FirebaseFirestore.instance
          .collection("turismo")
          .doc(widget.docId);
      final docSnap = await docRef.get();

      if (!mounted) return;

      if (docSnap.exists) {
        final data = docSnap.data() as Map<String, dynamic>;

        // pega somente até 10 imagens (se houver)
        final rawImgs = data["imagensExtras"];
        if (rawImgs is List) {
          imagensExtras = rawImgs
              .map((e) => e?.toString() ?? "")
              .where((s) => s.isNotEmpty)
              .take(10)
              .cast<String>()
              .toList();
        }

        videoUrl = (data["videoUrl"] as String?)?.trim();
        notaMedia = (data["notaMedia"] ?? 0).toDouble();
        totalVotos = (data["totalVotos"] ?? 0);

        // inicializa player somente se houver videoUrl válida
        if (videoUrl != null && videoUrl!.isNotEmpty) {
          videoController = VideoPlayerController.network(videoUrl!);
          await videoController!.initialize();
          videoInitialized = true;
        }
      }
    } catch (e) {
      // Falha ao buscar no Firestore — evita crash e mostra dados locais
      // ignore: avoid_print
      print("Erro ao carregar dados do Firestore: $e");
    } finally {
      if (mounted) setState(() => carregando = false);
    }
  }

  Future<void> avaliar(double nota) async {
    // avaliação local + envio para Firestore apenas se houver docId
    final novoTotal = totalVotos + 1;
    final novaMedia = ((notaMedia * totalVotos) + nota) / novoTotal;

    setState(() {
      notaMedia = novaMedia;
      totalVotos = novoTotal;
    });

    if (widget.docId != null && widget.docId!.trim().isNotEmpty) {
      try {
        await FirebaseFirestore.instance
            .collection("turismo")
            .doc(widget.docId)
            .update({"notaMedia": notaMedia, "totalVotos": totalVotos});
      } catch (e) {
        // ignore: avoid_print
        print("Erro ao enviar avaliação para Firestore: $e");
        // opcional: mostrar snackbar informando que envio falhou
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Avaliação local registrada, mas falha ao salvar."),
            ),
          );
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Avaliação registrada localmente (sem docId cadastrado).",
            ),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    videoController?.dispose();
    super.dispose();
  }

  Widget buildImagensExtras() {
    if (imagensExtras.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          const Text(
            "Imagens do local",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 120,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: imagensExtras.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, i) {
                final url = imagensExtras[i];
                return ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: url,
                    width: 160,
                    height: 120,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(
                      width: 160,
                      height: 120,
                      color: Colors.grey.shade200,
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (_, __, ___) => Container(
                      width: 160,
                      height: 120,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.broken_image),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildVideoPlayer() {
    if (videoController == null || !videoInitialized) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Vídeo do ponto turístico",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          AspectRatio(
            aspectRatio: videoController!.value.aspectRatio == 0
                ? 16 / 9
                : videoController!.value.aspectRatio,
            child: VideoPlayer(videoController!),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  videoController!.value.isPlaying
                      ? Icons.pause_circle
                      : Icons.play_circle,
                  size: 36,
                ),
                onPressed: () {
                  setState(() {
                    if (videoController!.value.isPlaying) {
                      videoController!.pause();
                    } else {
                      videoController!.play();
                    }
                  });
                },
              ),
              const SizedBox(width: 8),
              Text(videoController!.value.isPlaying ? "Pausar" : "Play"),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.nome)),
      body: carregando
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // IMAGEM PRINCIPAL
                  CachedNetworkImage(
                    imageUrl: widget.imagem,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(
                      height: 250,
                      color: Colors.grey.shade200,
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (_, __, ___) => Container(
                      height: 250,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.broken_image, size: 80),
                    ),
                  ),

                  // AVALIAÇÃO (mostra média + botão para votar)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Avaliação: ${notaMedia.toStringAsFixed(1)} ⭐ ( $totalVotos votos )",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: List.generate(5, (i) {
                            final nota = (i + 1).toDouble();
                            return IconButton(
                              onPressed: () => avaliar(nota),
                              icon: Icon(
                                notaMedia >= nota
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Colors.amber,
                                size: 32,
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),

                  // Imagens extras (até 10)
                  buildImagensExtras(),

                  // Vídeo (se houver)
                  buildVideoPlayer(),

                  // DESCRIÇÃO E BOTÃO MAPA
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.nome,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.redAccent,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              widget.cidade,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          widget.descricao,
                          style: const TextStyle(fontSize: 14, height: 1.4),
                        ),
                        const SizedBox(height: 12),
                        Center(
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              final url =
                                  'https://www.google.com/maps/search/?api=1&query=${widget.latitude},${widget.longitude}';
                              final uri = Uri.parse(url);
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(
                                  uri,
                                  mode: LaunchMode.externalApplication,
                                );
                              } else {
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Não foi possível abrir o mapa.',
                                      ),
                                    ),
                                  );
                                }
                              }
                            },
                            icon: const Icon(Icons.map),
                            label: const Text('Ver no Google Maps'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
