# Chatbot App — Rasa Proxy & Flutter Integration

This folder contains a minimal Node.js proxy that forwards chat messages from the Flutter app to a local Rasa server, plus a small Flutter `ChatService` and `ChatScreen` widget.

Prerequisites
- Node.js (16+), npm
- Rasa running locally (default REST webhook at `http://localhost:5005/webhooks/rest/webhook`)
- Flutter (for the mobile/web client)

Quick start — proxy
1. Install dependencies:

```bash
cd "ai chatbot/chatbot_app"
npm install
```

2. Start the proxy (default port 3000):

```bash
# start proxy
npm start

# or run with auto-reload during development
npm run dev
```

3. (Optional) Run the simple proxy test after starting the proxy:

```bash
npm test
```

Notes for Rasa
- The proxy forwards POSTs to the Rasa REST webhook at `http://localhost:5005/webhooks/rest/webhook` by default.
- You can override the URL using the `RASA_URL` environment variable.

Flutter client
- The Flutter `ChatService` lives at `lib/services/chat_service.dart`.
- Update `ChatService.baseUrl` if the proxy runs on a different host/port.
- Use the `ChatScreen` widget at `lib/features/chat/chat_screen.dart` (already wired to `/chat` route in `lib/core/router/app_router.dart`).

Security
- Do not hardcode secrets in source. For web testing, configure tokens securely or use a backend proxy.

Extending
- You can add authentication, logging to a file, or a persistent message store to the proxy.
# chatbot_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
