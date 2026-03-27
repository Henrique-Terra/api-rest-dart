import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;

import 'package:api_rest_dart/database/database.dart';
import 'package:api_rest_dart/middlewares/auth_middleware.dart';
import 'package:api_rest_dart/routes/tarefa_routes.dart';

void main() async {
  AppDatabase();

  final router = TarefaRoutes().router;

  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(authMiddleware())
      .addHandler(router.call);

  final server = await io.serve(handler, InternetAddress.anyIPv4, 8080);

  print('Servidor rodando em: http://${server.address.host}:${server.port}');
}