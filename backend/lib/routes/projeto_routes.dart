import 'package:shelf_router/shelf_router.dart';

import '../handlers/projeto_handler.dart';
import '../handlers/tarefa_handler.dart';

class ProjetoRoutes {
  final ProjetoHandler projetoHandler = ProjetoHandler();
  final TarefaHandler tarefaHandler = TarefaHandler();

  Router get router {
    final router = Router();

    router.post('/projetos', projetoHandler.criar);
    router.get('/projetos', projetoHandler.listar);
    router.get('/projetos/<id>', projetoHandler.buscarPorId);
    router.put('/projetos/<id>', projetoHandler.atualizar);
    router.delete('/projetos/<id>', projetoHandler.deletar);

    router.get('/projetos/<id>/tarefas', tarefaHandler.listarPorProjeto);

    return router;
  }
}