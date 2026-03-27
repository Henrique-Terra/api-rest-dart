import 'dart:convert';
import 'package:shelf/shelf.dart';

Middleware authMiddleware() {
  return (Handler innerHandler) {
    return (Request request) async {
      final authHeader = request.headers['authorization'];

      if (authHeader == null) {
        return Response.forbidden(
          jsonEncode({'erro': 'Acesso negado. Token não informado.'}),
          headers: {'content-type': 'application/json'},
        );
      }

      final tokenValido = authHeader == '123' || authHeader == 'Bearer 123';

      if (!tokenValido) {
        return Response.forbidden(
          jsonEncode({'erro': 'Acesso negado. Token inválido.'}),
          headers: {'content-type': 'application/json'},
        );
      }

      return innerHandler(request);
    };
  };
}