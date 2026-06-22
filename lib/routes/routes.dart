import 'package:flutter/material.dart';
import 'package:incaxias_appcx/devteam/devteam_page.dart';
import 'package:incaxias_appcx/pages/advogado/advogados_page.dart';
import 'package:incaxias_appcx/pages/bares/bares_page.dart';
import 'package:incaxias_appcx/pages/clinicas/clinicas_page.dart';
import 'package:incaxias_appcx/pages/cultura/cultura_page.dart';
import 'package:incaxias_appcx/pages/educacao/escolas_page.dart';
import 'package:incaxias_appcx/pages/emergencia/emergencia.dart';
import 'package:incaxias_appcx/pages/farmacia/farmacia_detalhe_page.dart';
import 'package:incaxias_appcx/pages/farmacia/farmacia_page.dart';
import 'package:incaxias_appcx/pages/hamburgueria/hamburguer_page.dart';
import 'package:incaxias_appcx/pages/instituicoes/academia/academia_page.dart';
import 'package:incaxias_appcx/pages/instituicoes/prefeitos/prefeitos_page.dart';
import 'package:incaxias_appcx/pages/lojas/lojas_page.dart';
import 'package:incaxias_appcx/pages/mototaxi/moto_taxi_page.dart';
import 'package:incaxias_appcx/pages/petshop/petshop_page.dart';
import 'package:incaxias_appcx/pages/saude/saude_page.dart';
import 'package:incaxias_appcx/pages/servicos/servicos_pages.dart';
import 'package:incaxias_appcx/pages/splash/splash_page.dart';
import 'package:incaxias_appcx/home_page.dart';
import 'package:incaxias_appcx/pages/eletricistas/eletricistas_page.dart';
import 'package:incaxias_appcx/pages/eventos/eventos_page.dart';
import 'package:incaxias_appcx/pages/hotel/hotel_page.dart';
import 'package:incaxias_appcx/pages/pizzarias/pizzaria_page.dart';
import 'package:incaxias_appcx/pages/taxi/taxi_page.dart';
import 'package:incaxias_appcx/pages/vagaemprego/vagas_detalhes_page.dart';
import 'package:incaxias_appcx/views/aluguel_page.dart';
import 'package:incaxias_appcx/views/vagas_page.dart';
import 'package:incaxias_appcx/widgets/main_navigation.dart';

/// 🌐 Centraliza todas as rotas do aplicativo
class AppRoutes {
  // 🔹 Nomes das rotas
  static const String splash = '/splash';
  static const String main = '/main'; // Navegação com Bottom Bar
  static const String home = '/home';
  static const String bares = '/bares';
  static const String pizzarias = '/pizzarias';
  static const String hoteis = '/hoteis';
  static const String eventos = '/eventos';
  static const String taxi = '/taxi';
  static const String eletricista = '/eletricistas';
  static const String cultura = '/cultura';
  static const String advogados = '/advogados';
  static const String clinicas = '/clinicas';
  static const String mototaxi = '/mototaxi';
  static const String prefeitos = '/prefeitos';
  static const String academia = '/academia';
  static const String lojas = '/lojas';
  static const String petshop = '/petshop';
  static const String farmacia = '/farmacia';
  static const String farmaciaDetalhe = '/farmaciaDetalhe';
  static const String hamburguer = '/hamburguer';
  static const String servicos = '/servicos';
  static const String emprego = '/emprego';
  static const String aluguel = '/aluguel';
  static const String vagaDetalhe = '/vagaDetalhe';
  static const String detalhesaluguel = '/detalhesaluguel';
  static const String saude = '/saude';
  static const String saudedetalhespage = '/saude';
  static const String emergencia = '/emergencia';
  static const String educacao = '/educar';

  static const String devteam = '/devteam';

  // 🔹 Mapa de rotas do app
  static Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    main: (context) => const MainNavigation(),
    home: (context) => const HomePage(),
    bares: (context) => const BaresPage(),
    pizzarias: (context) => const PizzariaPage(),
    hoteis: (context) => const HotelPage(),
    eventos: (context) => const EventosPage(),
    taxi: (context) => const TaxiPage(),
    eletricista: (context) => const EletricistasPage(),
    cultura: (context) => const CulturaPage(),
    advogados: (context) => const AdvogadosPage(),
    clinicas: (context) => const ClinicaPage(),
    mototaxi: (context) => const MotoTaxiPage(),
    prefeitos: (context) => const PrefeitosPage(),
    academia: (context) => const AcademiaPage(),
    lojas: (context) => const LojasPage(),
    petshop: (context) => const PetshopPage(),
    hamburguer: (context) => const HamburguerPage(),
    farmacia: (context) => const FarmaciaPage(),
    farmaciaDetalhe: (context) => const FarmaciaDetalhe(),
    servicos: (context) => const ServicosPage(),
    emprego: (context) => const VagasPage(),
    vagaDetalhe: (context) => const VagaDetalhePage(),
    aluguel: (context) => const AluguelPage(),
    saude: (context) => const SaudePage(),
    emergencia: (context) => const EmergencyPage(),
    educacao: (context) => const EscolasPage(),

    // Exemplo com lista vazia
    devteam: (context) => const DevTeamPage(empresaId: devteam),
  };
}
