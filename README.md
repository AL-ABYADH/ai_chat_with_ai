# Flutter Chat App with OpenAI Integration

Welcome to the Flutter Chat App, an open-source mobile application that utilizes OpenAI's GPT for generating chat responses. This app allows users to engage in conversations with the AI, with the ability to save and continue conversations.

## Getting Started

Follow the steps below to set up and launch the Flutter Chat App on your local machine.

### Prerequisites

Make sure you have the following installed on your machine:

- Flutter SDK: [Flutter Installation Guide](https://flutter.dev/docs/get-started/install)
- Dart SDK: [Dart Installation Guide](https://dart.dev/get-dart)

### Installation

1. Clone the repository to your local machine:

   ```bash
   git clone https://github.com/your-username/flutter-chat-app.git
   ```

2. Navigate to the project directory:

   ```bash
   cd flutter-chat-app
   ```

3. Install dependencies:

   ```bash
   flutter pub get
   ```

### Configuration

1. Create a new file named `.env` in the `lib` directory next to the main file (`main.dart`).

2. Open the `.env` file and add the following line, replacing `your_openai_api_key` with your actual OpenAI API key:

   ```
   API_KEY_1=your_openai_api_key
   ```

   **Note:** Ensure that you do not share or upload this file to version control for security reasons.

### Launching the App

1. Connect a device or start an emulator:

   ```bash
   flutter devices
   flutter emulators --launch <emulator_id>
   ```

2. Run the app:

   ```bash
   flutter run
   ```

### Usage

- On the home screen, view the list of previous chats.
- Press the "Add New Chat" button to start a new conversation.
- Enter the topic and the first message to initiate the chat.
- Press "Start" to begin the conversation with the AI.
- Use the "Pause," "Back," and "Save/Discard" buttons for additional functionality.

## Contributing

Feel free to contribute to the project by submitting issues or pull requests. We welcome your feedback and suggestions.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
