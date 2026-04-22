import 'dart:convert';
import 'package:shelf/shelf.dart';

import '../models/projeto.dart';
import '../repositories/projeto_repository.dart';

class ProjetoHandler {
  final ProjetoRepository repository = ProjetoRepository();

  Future<Response> criar(Request request) async {
    try {
      final body = await request.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;

      final nome = data['nome'];
      final descricao = data['descricao'];

      if (nome == null || descricao == null) {
        return Response(
          400,
          body: jsonEncode({'erro': 'Campos obrigatórios ausentes.'}),
          headers: {'content-type': 'application/json'},
        );
      }

      final projeto = Projeto(nome: nome as String, descricao: descricao as String);
      final id = repository.criar(projeto);

      return Response(
        201,
        body: jsonEncode({'mensagem': 'Projeto criado com sucesso.', 'id': id}),
        headers: {'content-type': 'application/json'},
      );
    } catch (e) {
      return Response(
        500,
        body: jsonEncode({'erro': 'Erro ao criar projeto.', 'detalhe': '$e'}),
        headers: {'content-type': 'application/json'},
      );
    }
  }

  Response listar(Request request) {
    try {
      final projetos = repository.listarTodos();
      return Response.ok(
        jsonEncode(projetos.map((p) => p.toJson()).toList()),
        headers: {'content-type': 'application/json'},
      );
    } catch (e) {
      return Response(
        500,
        body: jsonEncode({'erro': 'Erro ao listar projetos.', 'detalhe': '$e'}),
        headers: {'content-type': 'application/json'},
      );
    }
  }

  Response buscarPorId(Request request, String id) {
    try {
      final projeto = repository.buscarPorId(int.parse(id));

      if (projeto == null) {
        return Response(
          404,
          body: jsonEncode({'erro': 'Projeto não encontrado.'}),
          headers: {'content-type': 'application/json'},
        );
      }

      return Response.ok(
        jsonEncode(projeto.toJson()),
        headers: {'content-type': 'application/json'},
      );
    } catch (e) {
      return Response(
        500,
        body: jsonEncode({'erro': 'Erro ao buscar projeto.', 'detalhe': '$e'}),
        headers: {'content-type': 'application/json'},
      );
    }
  }

  Future<Response> atualizar(Request request, String id) async {
    try {
      final body = await request.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;

      final nome = data['nome'];
      final descricao = data['descricao'];

      if (nome == null || descricao == null) {
        return Response(
          400,
          body: jsonEncode({'erro': 'Campos obrigatórios ausentes.'}),
          headers: {'content-type': 'application/json'},
        );
      }

      final projeto = Projeto(nome: nome as String, descricao: descricao as String);
      final atualizado = repository.atualizar(int.parse(id), projeto);

      if (!atualizado) {
        return Response(
          404,
          body: jsonEncode({'erro': 'Projeto não encontrado.'}),
          headers: {'content-type': 'application/json'},
        );
      }

      return Response.ok(
        jsonEncode({'mensagem': 'Projeto atualizado com sucesso.'}),
        headers: {'content-type': 'application/json'},
      );
    } catch (e) {
      return Response(
        500,
        body: jsonEncode({'erro': 'Erro ao atualizar projeto.', 'detalhe': '$e'}),
        headers: {'content-type': 'application/json'},
      );
    }
  }

  Response deletar(Request request, String id) {
    try {
      final deletado = repository.deletar(int.parse(id));

      if (!deletado) {
        return Response(
          404,
          body: jsonEncode({'erro': 'Projeto não encontrado.'}),
          headers: {'content-type': 'application/json'},
        );
      }

      return Response(204);
    } catch (e) {
      return Response(
        500,
        body: jsonEncode({'erro': 'Erro ao remover projeto.', 'detalhe': '$e'}),
        headers: {'content-type': 'application/json'},
      );
    }
  }
}