import 'package:flutter/material.dart';
import 'package:scan_vision_app/cadastro_livro/cadastro_livro_view.dart';
import 'package:scan_vision_app/cadastro_pagina/cadastro_pagina_view.dart';
import 'package:scan_vision_app/models/livro_model.dart';
import 'package:scan_vision_app/models/pagina_model.dart';
import 'package:scan_vision_app/visualizar_pagina/visualizar_pagina_view.dart';
import 'package:scan_vision_app/core/common/routes.dart';
import 'package:scan_vision_app/home/home_view.dart';
import 'package:scan_vision_app/paginas/paginas_view.dart';
import 'package:scan_vision_app/splash/splash_view.dart';

class RouteGenerator {
  static Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splash:
        {
          return MaterialPageRoute(
            builder: (_) => SplashView(),
          );
        }
      case Routes.home:
        {
          return MaterialPageRoute(
            builder: (_) => HomeView(),
          );
        }
      case Routes.cadastroLivro:
        {
          var livro = settings.arguments as Livro;

          return MaterialPageRoute(
            builder: (_) => CadastroLivroView(
              livro: livro,
            ),
          );
        }
      case Routes.cadastroPagina:
        {
          var arguments = settings.arguments as Map<String, dynamic>;

          return MaterialPageRoute(
            builder: (_) => CadastroPaginaView(
              pagina: arguments["pagina"],
              livroKey: arguments["livroKey"],
            ),
            fullscreenDialog: true,
          );
        }
      case Routes.visualizarPagina:
        {
          var pagina = settings.arguments as Pagina;

          return MaterialPageRoute(
            builder: (_) => VisualizarPaginaView(
              pagina: pagina,
            ),
          );
        }
      case Routes.paginas:
        {
          var livro = settings.arguments as Livro;

          return MaterialPageRoute(
            builder: (_) => PaginasView(livro: livro),
          );
        }
    }
  }
}
