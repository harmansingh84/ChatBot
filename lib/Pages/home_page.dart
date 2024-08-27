

import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ChatMessage> messages = [];
  final Gemini gemini = Gemini.instance;
  XFile? uploadedFile;
  String? lastLocation;

  ChatUser currentUser = ChatUser(id: '0', firstName: "User");
  ChatUser geminiUser = ChatUser(
    id: '1',
    firstName: "Reclaim",
   
    
  );

  @override
  void initState() {
    super.initState();
    _sendInitialMessage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        title: Image.asset(
          "lib/images/Reclaim.png",
          width: 50,
        ),
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: DashChat(
        inputOptions: InputOptions(
          inputDecoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: 'Type a message',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            suffixIcon: IconButton(
              onPressed: _sendMediaMessage,
              icon: Icon(Icons.image),
              color: Colors.blue,
            ),
          ),
        ),
        currentUser: currentUser,
        onSend: _sendMessage,
        messages: messages,
      
      ),
    );
  }

  void _sendMessage(ChatMessage chatMessage) {
    setState(() {
      messages = [chatMessage, ...messages];
    });
    _handleUserResponse(chatMessage.text);
  }

  void _sendInitialMessage() {
    ChatMessage initialMessage = ChatMessage(
      user: geminiUser,
      createdAt: DateTime.now(),
      text: "Hello! How can I help you today?",
    );
    ChatMessage optionMessage = ChatMessage(
      user: geminiUser,
      createdAt: DateTime.now(),
      text: "1: Would you like to report a missing item?\n2: Information about the company",
    );
    setState(() {
      messages = [optionMessage, initialMessage, ...messages];
    });
  }

  void _handleUserResponse(String response) {
  if (response.contains('1')) {
    ChatMessage uploadPrompt = ChatMessage(
      user: geminiUser,
      createdAt: DateTime.now(),
      text: "Please upload a picture of the missing item.",
    );
    setState(() {
      messages = [uploadPrompt, ...messages];
    });
  } else if (response.contains('2')) {
    ChatMessage companyInfo = ChatMessage(
      user: geminiUser,
      createdAt: DateTime.now(),
      text: "Reclaim is a company dedicated to helping you find lost items. We use advanced technology to assist in locating and returning your valuable belongings.",
    );
    setState(() {
      messages = [companyInfo, ...messages];
    });
    _displayOptions();
  } else if (uploadedFile != null && lastLocation == null) {
    lastLocation = response;
    ChatMessage confirmationMessage = ChatMessage(
      user: geminiUser,
      createdAt: DateTime.now(),
      text: "Got it. Your image and location have been saved.",
    );
    setState(() {
      messages = [confirmationMessage, ...messages];
    });
    // Save the image and location here
    _displayOptions();
  } else {
    _displayOptions();
  }
}

void _displayOptions() {
  ChatMessage optionMessage = ChatMessage(
    user: geminiUser,
    createdAt: DateTime.now(),
    text: "1: Would you like to report a missing item?\n2: Information about the company",
  );
  setState(() {
    messages = [optionMessage, ...messages];
  });
}


 void _sendMediaMessage() async {
  ImagePicker picker = ImagePicker();
  uploadedFile = await picker.pickImage(source: ImageSource.gallery);
  if (uploadedFile != null) {
    ChatMessage chatMessage = ChatMessage(
      user: currentUser,
      createdAt: DateTime.now(),
      text: "Describe this picture",
      medias: [
        ChatMedia(
          url: uploadedFile!.path,
          fileName: "",
          type: MediaType.image,
        ),
      ],
    );
    setState(() {
      messages = [chatMessage, ...messages];
    });
    ChatMessage locationPrompt = ChatMessage(
      user: geminiUser,
      createdAt: DateTime.now(),
      text: "Where did you last see this item?",
    );
    setState(() {
      messages = [locationPrompt, ...messages];
    });
  }
}
}