import 'package:flutter/material.dart';
import 'package:health_tracker_flutter/services/gemini_service.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Message> _messages = [];
  final GeminiService _geminiService =
      GeminiService(); // Initialize GeminiService

  void _sendMessage() async {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _messages.add(Message(text: _controller.text, isUser: true));
        _controller.clear();
      });

      // Call the Gemini service to get the AI response
      String? aiResponse =
          await _geminiService.callGenerativeAI(_messages.last.text);
      setState(() {
        _messages
            .add(Message(text: aiResponse ?? "No response", isUser: false));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            child: Image.asset("assets/trainer_photo.png"),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessage(_messages[index]);
              },
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildMessage(Message message) {
    final isUser = message.isUser;

    return Row(
      mainAxisAlignment:
          isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!isUser)
          CircleAvatar(backgroundImage: AssetImage("assets/trainer_photo.png")),
        const SizedBox(width: 8),
        ClipPath(
          clipper: isUser ? UserMessageClipper() : AIMessageClipper(),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isUser
                  ? const Color.fromARGB(255, 127, 255, 68)
                  : Colors.purple[700],
              borderRadius: BorderRadius.circular(20),
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth:
                    MediaQuery.of(context).size.width * 0.75, // Limit width
              ),
              child: RichText(
                text: TextSpan(
                  children: _buildTextSpans(message.text),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        if (isUser)
          CircleAvatar(backgroundImage: AssetImage("assets/user_photo.png")),
      ],
    );
  }

  // Method to build text spans for RichText
  List<TextSpan> _buildTextSpans(String message) {
    // Clean the response and prepare spans
    message = message.replaceAll(
        RegExp(r'\*\*'), ''); // Remove special bold formatting

    // Split by spaces to create TextSpan for each word
    final words = message.split(' ');
    return words.map((word) {
      return TextSpan(
        text: word + ' ', // Add space back after each word
        style: const TextStyle(color: Colors.white),
      );
    }).toList();
  }

  Widget _buildInputArea() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}

class Message {
  final String text;
  final bool isUser;

  Message({required this.text, required this.isUser});
}

class UserMessageClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width - 20, 0);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width - 20, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 20);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class AIMessageClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(20, 0);
    path.lineTo(0, size.height / 2);
    path.lineTo(20, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 20);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
