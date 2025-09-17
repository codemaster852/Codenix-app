import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

// Models data based on the website's JavaScript
const models = [
  {
    'id': 'nix-0.5',
    'name': 'Nix 0.5',
    'emoji': 'ðŸ§Ÿâšï¸',
    'shortDescription': 'Lightweight & fast for simple tasks.',
    'portfolio':
        'Nix 0.5 is a compact and efficient model optimized for speed and low-resource environments. It\'s perfect for simple, high-throughput tasks like basic text classification, keyword extraction, and quick Q&A.',
    'features': ['Lightweight & fast', 'Text results only'],
    'tryLink': 'nix05.html'
  },
  {
    'id': 'nix-1',
    'name': 'Nix 1',
    'emoji': 'ðŸ§â°€',
    'shortDescription': 'Balanced performance for general use.',
    'portfolio':
        'Nix 1 is our flagship general-purpose model. It offers a strong balance of performance, speed, and reasoning capabilities, making it a versatile choice for a wide range of applications including content creation, summarization, and complex chat interactions.',
    'features': [
      'Image generation',
      'Video generation',
      'QR code generation',
      'Voice generation',
      'Text result'
    ],
    'tryLink': 'nix.html'
  },
  {
    'id': 'nix-1.5',
    'name': 'Nix 1.5',
    'emoji': 'ðŸ“',
    'shortDescription': 'Our most powerful and capable model.',
    'portfolio':
        'Nix 1.5 represents the cutting edge of our research. With an expanded architecture and training dataset, it excels at highly complex tasks that require deep domain knowledge, nuanced understanding, and sophisticated problem-solving.',
    'features': [
      'Image generation',
      'Video generation',
      'QR code generation',
      'Voice generation',
      'Text results',
      'Docs generation',
      'Video generation with sound',
      'Search'
    ],
    'tryLink': 'nix1o5.html'
  },
  {
    'id': 'codenix',
    'name': 'Codenix',
    'emoji': 'ðŸ§¯',
    'shortDescription': 'Specialized for code generation.',
    'portfolio':
        'Codenix is a variant of the Nix family, fine-tuned specifically for software development tasks. It understands code syntax, structure, and logic, making it an invaluable assistant for developers.',
    'features': [
      'Code generation in 20+ languages',
      'Debugging and code explanation',
      'Unit test generation',
      'API documentation writing'
    ],
    'tryLink': 'codenix.html'
  },
  {
    'id': 'gemini',
    'name': 'Gemini',
    'emoji': 'ðŸ¤¨â°',
    'shortDescription': 'Google\'s powerful multimodal model.',
    'portfolio':
        'Integration with Gemini, Google\'s natively multimodal model that can understand and operate across text, images, video, audio, and code. It offers powerful general capabilities and is available through our unified API.',
    'features': [
      'Multimodal reasoning (text, image, audio)',
      'Access to Google\'s latest research',
      'Scalable for enterprise use-cases',
      'Seamless integration with Google Cloud'
    ],
    'tryLink': 'gemini.html'
  },
  {
    'id': 'deepseek',
    'name': 'DeepSeek',
    'emoji': 'ðŸ§¥',
    'shortDescription': 'Open-source model focused on code.',
    'portfolio':
        'We provide access to the DeepSeek Coder series, a powerful open-source family of models trained from scratch on a large code dataset. It excels at code completion, generation, and software-related instruction tasks.',
    'features': [
      'Expert in coding and math',
      'Trained on 2 trillion tokens',
      'Supports a wide range of programming languages',
      'High performance on HumanEval and MBPP benchmarks'
    ],
    'tryLink': 'deepseek.html'
  }
];

void main() {
  runApp(const CodenixApp());
}

class CodenixApp extends StatelessWidget {
  const CodenixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Codenix AI Studio',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF4F46E5),
        scaffoldBackgroundColor: const Color(0xFF0A0F1F),
        fontFamily: 'Inter',
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF111827),
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFFEAEAEA)),
          bodyMedium: TextStyle(color: Color(0xFFEAEAEA)),
          titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic>? _selectedModel;

  void _onModelSelected(Map<String, dynamic> model) {
    setState(() {
      _selectedModel = model;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width > 600;
    return Scaffold(
      body: isLargeScreen
          ? Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: ModelList(onModelSelected: _onModelSelected),
                ),
                Expanded(
                  child: ModelDetails(model: _selectedModel),
                ),
              ],
            )
          : ModelList(
              onModelSelected: (model) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ModelDetailsScreen(model: model),
                  ),
                );
              },
            ),
    );
  }
}

class ModelList extends StatelessWidget {
  final Function(Map<String, dynamic>) onModelSelected;

  const ModelList({super.key, required this.onModelSelected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Codenix AI Studio'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: models.length,
        itemBuilder: (context, index) {
          final model = models[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color(0xFF1F2937),
              child: Text(
                model['emoji'] as String,
                style: const TextStyle(fontSize: 24),
              ),
            ),
            title: Text(model['name'] as String),
            subtitle: Text(model['shortDescription'] as String),
            onTap: () => onModelSelected(model),
          );
        },
      ),
    );
  }
}

class ModelDetails extends StatelessWidget {
  final Map<String, dynamic>? model;

  const ModelDetails({super.key, this.model});

  @override
  Widget build(BuildContext context) {
    if (model == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.auto_awesome, size: 100, color: Color(0xFF4F46E5)),
            SizedBox(height: 20),
            Text(
              'Welcome to the Studio',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text('Select a model to start'),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                model!['name'] as String,
                style:
                    const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ChatScreen(modelName: model!['name'] as String)),
                  );
                },
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Try Model'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4F46E5),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          _buildInfoCard(
            'Portfolio',
            model!['portfolio'] as String,
          ),
          const SizedBox(height: 20),
          _buildFeaturesCard(
            'Core Features',
            model!['features'] as List<dynamic>,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String content) {
    return Card(
      color: const Color(0xFF1F2937),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFa5b4fc)),
            ),
            const SizedBox(height: 10),
            Text(content, style: const TextStyle(height: 1.5)),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesCard(String title, List<dynamic> features) {
    return Card(
      color: const Color(0xFF1F2937),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFa5b4fc)),
            ),
            const SizedBox(height: 10),
            ...features.map(
              (feature) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    const Icon(Icons.check, color: Color(0xFFa5b4fc), size: 18),
                    const SizedBox(width: 10),
                    Expanded(child: Text(feature.toString())),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ModelDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> model;
  const ModelDetailsScreen({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(model['name'] as String),
      ),
      body: ModelDetails(model: model),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String modelName;
  const ChatScreen({super.key, required this.modelName});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;
  final String _apiKey = 'sk-fe4e0931579f4138913ad5dd243cce14'; // From deepseek.html
  final String _geminiApiKey = 'AIzaSyD7hibrmo4DGuYDXSPbu0sWqh-mKYi6Z5U'; // From gemini.html

  Future<void> _sendMessage() async {
    final message = _controller.text;
    if (message.isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'content': message});
      _isLoading = true;
    });
    _controller.clear();

    String botReply;
    try {
      if (widget.modelName == 'DeepSeek') {
        botReply = await _getDeepSeekReply(message);
      } else if (widget.modelName == 'Gemini') {
        botReply = await _getGeminiReply(message);
      } else {
        // Fallback for other models from nix.html and nix1o5.html (uses ActivePieces webhook)
        botReply = await _getActivePiecesReply(message);
      }
    } catch (e) {
      botReply = 'Error: ${e.toString()}';
    }

    setState(() {
      _messages.add({'role': 'bot', 'content': botReply});
      _isLoading = false;
    });
  }

  Future<String> _getDeepSeekReply(String message) async {
    final response = await http.post(
      Uri.parse('https://api.deepseek.com/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey',
      },
      body: jsonEncode({
        'model': 'deepseek-chat',
        'messages': [
          {'role': 'system', 'content': 'You are a helpful assistant.'},
          {'role': 'user', 'content': message}
        ],
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'];
    } else {
      return 'Failed to get reply from DeepSeek.';
    }
  }

  Future<String> _getGeminiReply(String message) async {
    final response = await http.post(
      Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$_geminiApiKey'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': [
          {
            'parts': [
              {'text': message}
            ]
          }
        ]
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['candidates'][0]['content']['parts'][0]['text'];
    } else {
      return 'Failed to get reply from Gemini.';
    }
  }

  Future<String> _getActivePiecesReply(String message) async {
      // Using the webhook from nix1o5.html as it's the more advanced one
    final response = await http.post(
      Uri.parse('https://cloud.activepieces.com/api/v1/webhooks/WR43cDYER0O9TiHq8exAH/sync'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'question': message}),
    );

    if (response.statusCode == 200) {
        try {
            final data = jsonDecode(response.body);
            // Handle various response types from the webhook
            if (data['answer'] != null) return data['answer'];
            if (data['image'] != null) return "Image generated: ${data['image']}";
            if (data['video'] != null) return "Video generated: ${data['video']}";
            if (data['audio'] != null) return "Audio generated: ${data['audio']}";
            return "Received a complex response. Please check the website for full support.";
        } catch (e){
             return response.body; // Return plain text if not JSON
        }
    } else {
      return 'Failed to get reply from Nix model.';
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.modelName} Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message['role'] == 'user';
                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: isUser
                          ? Theme.of(context).primaryColor
                          : const Color(0xFF333333),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Text(
                      message['content']!,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Ask ${widget.modelName} anything...',
                      filled: true,
                      fillColor: const Color(0xFF2a2a2a),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8.0),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                  style: IconButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
