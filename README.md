# Flutter Chat App with OpenAI Integration

Welcome to the AI Chat With AI, an open-source mobile application that utilizes OpenAI's GPT for generating chats about certain topics. This app allows users to watch AI chatting with AI on a regular chat screen about a topic they select.

## Try it out now!
Contact me to get an APK version with an active OpenAI API key to try out the app:
- Email: yahyaalabyadh71@gmail.com
- Whatsapp: https://api.whatsapp.com/send?phone=967771307445

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

1. Create a new file named `.env` in the `lib` directory.
 
2. Get an API key from your OpenAI account by navigating to this page: https://platform.openai.com/api-keys
**Note:** Make sure your account has enough credit to use the API. You can check your usage on this page: https://platform.openai.com/usage

4. Open the `.env` file and add the following line, replacing `your_openai_api_key` with your actual OpenAI API key:

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

## Contributing

Feel free to contribute to the project by submitting issues or pull requests. We welcome your feedback and suggestions.

**Note:** If you're experiencing slow chat, that's because of the requests limit recently implemented by OpenAI, which is 3 RPM (Request Per Minute). This limit increases with payments to the use of the API via your account.
