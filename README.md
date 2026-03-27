# API REST em Dart - CRUD de Tarefas

Projeto desenvolvido em Dart com o objetivo de implementar uma API REST simples com:

- CRUD completo da entidade tarefas
- Persistência em banco SQLite
- Middleware de autenticação com token fixo

## Tecnologias utilizadas

- Dart
- Shelf
- Shelf Router
- SQLite

## Autenticação

As rotas são protegidas por middleware.

Header esperado:

Authorization: 123

## Rotas

- POST /tarefas
- GET /tarefas
- GET /tarefas/:id
- PUT /tarefas/:id
- DELETE /tarefas/:id

## Como executar

```bash
dart pub get
dart run bin/server.dart