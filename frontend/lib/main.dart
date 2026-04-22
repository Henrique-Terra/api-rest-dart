import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const AppTarefas());
}

class Tarefa {
  final int id;
  final String titulo;
  final String descricao;
  final bool concluida;
  final int projetoId;

  Tarefa({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.concluida,
    required this.projetoId,
  });

  factory Tarefa.fromJson(Map<String, dynamic> json) {
    return Tarefa(
      id: json['id'] as int,
      titulo: json['titulo'] as String,
      descricao: json['descricao'] as String,
      concluida: json['concluida'] as bool,
      projetoId: json['projeto_id'] as int,
    );
  }
}

class AppTarefas extends StatelessWidget {
  const AppTarefas({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gerenciador de Tarefas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const TarefasListaPage(),
    );
  }
}

class TarefasListaPage extends StatefulWidget {
  const TarefasListaPage({super.key});

  @override
  State<TarefasListaPage> createState() => _TarefasListaPageState();
}

class _TarefasListaPageState extends State<TarefasListaPage> {
  static const String _baseUrl = 'http://localhost:8080';
  static const String _token = '123';

  List<Tarefa> _tarefas = [];
  bool _carregando = true;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    setState(() {
      _carregando = true;
      _erro = null;
    });

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/tarefas'),
        headers: {
          'Authorization': _token,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> dados = jsonDecode(response.body);
        setState(() {
          _tarefas = dados.map((item) => Tarefa.fromJson(item)).toList();
          _carregando = false;
        });
      } else {
        setState(() {
          _erro = 'Erro do servidor: ${response.statusCode}';
          _carregando = false;
        });
      }
    } catch (e) {
      setState(() {
        _erro = 'Não foi possível conectar à API.\nVerifique se o servidor está rodando.';
        _carregando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarefas'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Recarregar',
            onPressed: _carregarDados,
          ),
        ],
      ),
      body: _buildConteudo(),
    );
  }

  Widget _buildConteudo() {
    if (_carregando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_erro != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                _erro!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _carregarDados,
                icon: const Icon(Icons.refresh),
                label: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      );
    }

    if (_tarefas.isEmpty) {
      return const Center(
        child: Text(
          'Nenhuma tarefa cadastrada.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _tarefas.length,
      itemBuilder: (context, index) {
        final tarefa = _tarefas[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: tarefa.concluida
                  ? Colors.green.shade100
                  : Colors.orange.shade100,
              child: Icon(
                tarefa.concluida ? Icons.check : Icons.hourglass_empty,
                color: tarefa.concluida ? Colors.green : Colors.orange,
              ),
            ),
            title: Text(
              tarefa.titulo,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                decoration: tarefa.concluida
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tarefa.descricao),
                const SizedBox(height: 4),
                Text(
                  'Projeto #${tarefa.projetoId} · ${tarefa.concluida ? "Concluída" : "Pendente"}',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
            isThreeLine: true,
          ),
        );
      },
    );
  }
}