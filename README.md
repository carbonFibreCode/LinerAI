# LineRAI - AI Chat Application

LineRAI is an AI-powered chat application built with Flutter and Firebase. It provides users with an interactive chat interface to communicate with an AI assistant.

## Features

- Real-time chat functionality
- AI-powered responses
- User authentication
- Message pagination
- Offline support
- Quick action suggestions

## Getting Started

### Prerequisites

- Flutter SDK
- Firebase account
- Gemini API key (for AI functionality)

### Installation

1. Clone the repository:
   ```
   git clone https://github.com/carbonFibreCode/linerai.git
   ```

2. Install dependencies:
   ```
   flutter pub get
   ```

3. Set up Firebase:
   - Create a new Firebase project
   - Add your Firebase configuration files to the project
   - Enable Firestore and Authentication in your Firebase console

4. Configure environment variables:
   - Create a `.env` file in the project root
   - Add your Gemini API key:
     ```
     GEMINI_API_KEY=your_api_key_here
     ```

5. Run the app:
   ```
   flutter run
   ```

## Project Structure

- `lib/`
  - `data/`: Data models and providers
  - `screens/`: UI screens
  - `widgets/`: Reusable UI components
  - `utils/`: Utility functions and constants
  - `services/`: Firebase and AI service implementations

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
