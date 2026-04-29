# Full Stack em Dart - Projetos e Tarefas

Projeto desenvolvido em Dart com o objetivo de implementar uma API REST com:

- CRUD completo das entidades Projetos e Tarefas
- Relacionamento 1:N entre Projeto (pai) e Tarefa (filho)
- Persistência em banco SQLite
- Middleware de autenticação com token fixo
- Tela Flutter de listagem consumindo a API

## Tecnologias utilizadas

- Dart
- Shelf
- Shelf Router
- SQLite
- Flutter
- http (Flutter)

## Autenticação

As rotas são protegidas por middleware.

Header esperado:

```
Authorization: 123
```

## Rotas

### Projetos

- GET /projetos
- GET /projetos/:id
- POST /projetos
- PUT /projetos/:id
- DELETE /projetos/:id

### Tarefas

- GET /tarefas
- GET /tarefas/:id
- GET /projetos/:id/tarefas
- POST /tarefas
- PUT /tarefas/:id
- DELETE /tarefas/:id

## Como executar o backend

```bash
cd backend
dart pub get
dart run bin/server.dart
```

## Como executar o frontend

```bash
cd frontend
flutter pub get
flutter run
```

O endereço `10.0.2.2` aponta para a máquina host no emulador Android. Para dispositivo físico ou iOS Simulator, substitua pelo IP local da máquina.

## Postman

Importe o arquivo `postman/collection.json` no Postman. A variável `{{base_url}}` aponta para `http://localhost:8080`.
