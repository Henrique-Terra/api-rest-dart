import 'dart:convert';
import 'package:shelf/shelf.dart';

import '../models/tarefa.dart';
import '../repositories/tarefa_repository.dart';

class TarefaHandler {
  final TarefaRepository repository = TarefaRepository();

  Future<Response> criar(Request request) async {
    try {
      final body = await request.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;

      final titulo = data['titulo'];
      final descricao = data['descricao'];
      final concluida = data['concluida'];
      final projetoId = data['projeto_id'];

      if (titulo == null || descricao == null || concluida == null || projetoId == null) {
        return Response(
          400,
          body: jsonEncode({'erro': 'Campos obrigatórios ausentes.'}),
          headers: {'content-type': 'application/json'},
        );
      }

      final tarefa = Tarefa(
        titulo: titulo as String,
        descricao: descricao as String,
        concluida: concluida as bool,
        projetoId: projetoId as int,
      );

      final id = repository.criar(tarefa);

      return Response(
        201,
        body: jsonEncode({'mensagem': 'Tarefa criada com sucesso.', 'id': id}),
        headers: {'content-type': 'application/json'},
      );
    } catch (e) {
      return Response(
        500,
        body: jsonEncode({'erro': 'Erro ao criar tarefa.', 'detalhe': '$e'}),
        headers: {'content-type': 'application/json'},
      );
    }
  }

  Response listar(Request request) {
    try {
      final tarefas = repository.listarTodas();
      return Response.ok(
        jsonEncode(tarefas.map((t) => t.toJson()).toList()),
        headers: {'content-type': 'application/json'},
      );
    } catch (e) {
      return Response(
        500,
        body: jsonEncode({'erro': 'Erro ao listar tarefas.', 'detalhe': '$e'}),
        headers: {'content-type': 'application/json'},
      );
    }
  }

  Response buscarPorId(Request request, String id) {
    try {
      final tarefa = repository.buscarPorId(int.parse(id));

      if (tarefa == null) {
        return Response(
          404,
          body: jsonEncode({'erro': 'Tarefa não encontrada.'}),
          headers: {'content-type': 'application/json'},
        );
      }

      return Response.ok(
        jsonEncode(tarefa.toJson()),
        headers: {'content-type': 'application/json'},
      );
    } catch (e) {
      return Response(
        500,
        body: jsonEncode({'erro': 'Erro ao buscar tarefa.', 'detalhe': '$e'}),
        headers: {'content-type': 'application/json'},
      );
    }
  }

  Response listarPorProjeto(Request request, String projetoId) {
    try {
      final tarefas = repository.listarPorProjeto(int.parse(projetoId));
      return Response.ok(
        jsonEncode(tarefas.map((t) => t.toJson()).toList()),
        headers: {'content-type': 'application/json'},
      );
    } catch (e) {
      return Response(
        500,
        body: jsonEncode({'erro': 'Erro ao listar tarefas do projeto.', 'detalhe': '$e'}),
        headers: {'content-type': 'application/json'},
      );
    }
  }

  Future<Response> atualizar(Request request, String id) async {
    try {
      final body = await request.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;

      final titulo = data['titulo'];
      final descricao = data['descricao'];
      final concluida = data['concluida'];
      final projetoId = data['projeto_id'];

      if (titulo == null || descricao == null || concluida == null || projetoId == null) {
        return Response(
          400,
          body: jsonEncode({'erro': 'Campos obrigatórios ausentes.'}),
          headers: {'content-type': 'application/json'},
        );
      }

      final tarefa = Tarefa(
        titulo: titulo as String,
        descricao: descricao as String,
        concluida: concluida as bool,
        projetoId: projetoId as int,
      );

      final atualizado = repository.atualizar(int.parse(id), tarefa);

      if (!atualizado) {
        return Response(
          404,
          body: jsonEncode({'erro': 'Tarefa não encontrada.'}),
          headers: {'content-type': 'application/json'},
        );
      }

      return Response.ok(
        jsonEncode({'mensagem': 'Tarefa atualizada com sucesso.'}),
        headers: {'content-type': 'application/json'},
      );
    } catch (e) {
      return Response(
        500,
        body: jsonEncode({'erro': 'Erro ao atualizar tarefa.', 'detalhe': '$e'}),
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
          body: jsonEncode({'erro': 'Tarefa não encontrada.'}),
          headers: {'content-type': 'application/json'},
        );
      }

      return Response(204);
    } catch (e) {
      return Response(
        500,
        body: jsonEncode({'erro': 'Erro ao remover tarefa.', 'detalhe': '$e'}),
        headers: {'content-type': 'application/json'},
      );
    }
  }
}