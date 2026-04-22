import 'package:shelf_router/shelf_router.dart';

import '../handlers/tarefa_handler.dart';

class TarefaRoutes {
  final TarefaHandler handler = TarefaHandler();

  Router get router {
    final router = Router();

    router.post('/tarefas', handler.criar);
    router.get('/tarefas', handler.listar);
    router.get('/tarefas/<id>', handler.buscarPorId);
    router.put('/tarefas/<id>', handler.atualizar);
    router.delete('/tarefas/<id>', handler.deletar);

    return router;
  }
}