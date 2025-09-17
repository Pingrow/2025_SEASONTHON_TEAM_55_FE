import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:linear_progress_bar/ui/dots_indicator.dart';
import 'package:pin_grow/model/chat_message.dart';
import 'package:pin_grow/service/indicators.dart';
import 'package:pin_grow/service/socket.dart';
import 'package:pin_grow/view_model/auth_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatBotPage extends StatefulHookConsumerWidget {
  const ChatBotPage({super.key});

  @override
  ConsumerState<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends ConsumerState<ChatBotPage> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  WebSocketChannel? _channel;
  bool _isTyping = false;

  ChatMessage? _currentBotMessage;

  @override
  void initState() {
    super.initState();

    _loadDraft();
    _connectWebSocket();
    _addWelcomeMessages();
    _controller.addListener(() {
      setState(() {}); // 입력 변경 시 sendButton 활성화/비활성화
    });
  }

  @override
  void dispose() {
    super.dispose();

    _saveDraft();
    _controller.dispose();
    _scrollController.dispose();
    _channel?.sink.close();
  }

  Future<void> _loadDraft() async {
    final prefs = await SharedPreferences.getInstance();
    final draft = prefs.getString('draftMessage');
    if (draft != null) {
      _controller.text = draft;
      await prefs.remove('draftMessage');
    }
  }

  Future<void> _saveDraft() async {
    final prefs = await SharedPreferences.getInstance();
    if (_controller.text.isNotEmpty) {
      await prefs.setString('draftMessage', _controller.text);
    }
  }

  // JS: addWelcomeMessages
  void _addWelcomeMessages() {
    const welcomeMessages = ["안녕하세요! 핀그로우 챗봇입니다. 어떤 금융 경제 용어가 궁금하신가요?"];

    if (_messages.isEmpty) {
      for (var i = 0; i < welcomeMessages.length; i++) {
        Future.delayed(Duration(seconds: i + 1), () {
          _addMessage(welcomeMessages[i], isUser: false);
        });
      }
    }
  }

  void _connectWebSocket() {
    final wsUrl = Uri.parse('ws://3.107.105.153:5001/chatbot/ws');

    try {
      _channel = WebSocketChannel.connect(wsUrl);
      _channel!.stream.listen(
        (data) => _handleWebSocketMessage(jsonDecode(data)),
        onDone: () {
          print('WebSocket disconnected');
          Future.delayed(const Duration(seconds: 3), _connectWebSocket);
        },
        onError: (error) {
          print('WebSocket error: $error');
        },
      );
    } catch (e) {
      print('WebSocket connection failed: $e');
    }
  }

  // JS: handleWebSocketMessage
  void _handleWebSocketMessage(Map<String, dynamic> data) {
    setState(() {
      switch (data['type']) {
        case 'start':
          _isTyping = false;
          _currentBotMessage = ChatMessage(text: '', isUser: false);
          _messages.add(_currentBotMessage!);
          break;
        case 'chunk':
          if (_currentBotMessage != null) {
            // 1. 기존 텍스트에 새로운 청크를 더합니다.
            final newText = _currentBotMessage!.text + (data['content'] ?? '');

            // 2. 새로운 텍스트로 ChatMessage 객체를 생성합니다.
            final updatedMessage = ChatMessage(text: newText, isUser: false);

            // 3. 리스트의 마지막 메시지를 새 메시지로 교체합니다.
            _messages[_messages.length - 1] = updatedMessage;

            // 4. (가장 중요) 현재 봇 메시지 참조를 새로운 객체로 업데이트합니다.
            _currentBotMessage = updatedMessage;
          }
          _scrollToBottom(); // 청크마다 부드럽게 스크롤
          break;
        case 'complete':
          if (_currentBotMessage != null) {
            final List<String> terms = List<String>.from(
              data['related_terms'] ?? [],
            );

            final finalMessage = ChatMessage(
              text: _currentBotMessage!.text,
              isUser: false,
              relatedTerms: terms,
            );
            _messages[_messages.length - 1] = finalMessage;
          }
          _currentBotMessage = null;
          break;
        case 'error':
          _addMessage(data['message'] ?? '오류가 발생했습니다.', isUser: false);
          break;
      }
      _scrollToBottom();
    });
  }

  void _addMessage(String text, {required bool isUser}) {
    setState(() {
      _messages.add(ChatMessage(text: text, isUser: isUser));
      if (isUser) {
        _isTyping = true;
      } else {
        _isTyping = false;
      }
    });
    _scrollToBottom();
  }

  // JS: sendMessage
  void _sendMessage() async {
    final messageText = _controller.text.trim();
    if (messageText.isEmpty) return;

    _addMessage(messageText, isUser: true);
    _controller.clear();

    if (_channel != null && _channel!.closeCode == null) {
      // WebSocket으로 메시지 전송
      _channel!.sink.add(jsonEncode({'message': messageText}));
    } else {
      // HTTP Fallback
      try {
        final reply = await _sendToAPI(messageText);
        _addMessage(reply, isUser: false);
      } catch (e) {
        _addMessage('죄송합니다. 오류가 발생했습니다. 다시 시도해주세요.', isUser: false);
        print('API Error: $e');
      }
    }
  }

  // JS: sendToAPI
  Future<String> _sendToAPI(String message) async {
    // 실제 서버 주소로 변경해야 합니다.
    final response = await http.post(
      Uri.parse('/chatbot/chat'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'message': message}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return data['reply'] ??
          data['response'] ??
          data['message'] ??
          '응답을 받을 수 없습니다.';
    } else {
      throw Exception('Failed to load response');
    }
  }

  // JS: scrollToBottom
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    });

    return Scaffold(
      backgroundColor: Color(0x00000000),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(
          0,
          MediaQuery.of(context).padding.top,
          0,
          MediaQuery.of(context).padding.bottom,
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            GestureDetector(
              onTap: () {
                GoRouter.of(context).pop();
              },
              child: Container(color: Colors.transparent),
            ),

            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 385.w, maxHeight: 722.h),
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                padding: EdgeInsets.fromLTRB(18, 14, 18, 14),
                decoration: BoxDecoration(
                  color: Color(0xffffffff),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 53.w,
                      height: 3.h,
                      decoration: BoxDecoration(
                        color: Color(0xffC3C3C3),
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '챗봇',
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff374151),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: _messages.length + (_isTyping ? 1 : 0),
                        itemBuilder: (BuildContext context, int index) {
                          if (_isTyping && index == _messages.length) {
                            // JS: typing-indicator
                            return _buildMessageBubble(
                              ChatMessage(text: '...', isUser: false),
                              isTyping: true,
                            );
                          }
                          final message = _messages[index];
                          return _buildMessageBubble(message);
                        },
                      ),
                    ),

                    Container(
                      constraints: BoxConstraints(
                        //maxHeight: 136.h,
                        minHeight: 52.h,
                        maxWidth: 345.w,
                        minWidth: 345.w,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xffF1F4F6),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _controller,
                              decoration: InputDecoration(
                                //isDense: true,
                                constraints: BoxConstraints(
                                  maxHeight: 136.h,
                                  minHeight: 52.h,
                                  maxWidth: 265.w,
                                  minWidth: 265.w,
                                ),
                                contentPadding: EdgeInsets.fromLTRB(
                                  16.w,
                                  16.h,
                                  0,
                                  16.h,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none,
                                ),
                              ),

                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff6B7280),
                              ),
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              //print('[DEBUG]\n입력: ${_controller.text}');
                              _sendMessage();

                              //_channel.sink.add(_controller.text);

                              //_controller.clear();
                            },
                            child: Padding(
                              padding: EdgeInsetsGeometry.fromLTRB(
                                6.w,
                                5.h,
                                6.w,
                                5.h,
                              ),
                              child: Container(
                                constraints: BoxConstraints(
                                  minWidth: 58.w,
                                  minHeight: 42.h,
                                  maxWidth: 58.w,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 0.5,
                                    color: Color(0xffC1C1C1),
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  color: Color(0xffF7F7F7),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  '입력',
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xffABABAB),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        GoRouter.of(context).pop();
                      },
                      child: Padding(
                        padding: EdgeInsetsGeometry.fromLTRB(0, 20.h, 0, 20.h),
                        child: Text(
                          '닫기',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff7D7D7D),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message, {bool isTyping = false}) {
    final align = message.isUser
        ? CrossAxisAlignment.end
        : CrossAxisAlignment.start;
    final color = message.isUser ? Color(0xffF5F5F5) : Color(0xffC4E3D5);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 6.h),
      child: Column(
        crossAxisAlignment: align,
        children: [
          Padding(
            padding: EdgeInsetsGeometry.symmetric(vertical: 5.h),
            child: message.isUser
                ? Container()
                : Image.asset(
                    'assets/icons/chat_bot_icon.png',
                    width: 38.r,
                    height: 38.r,
                  ),
          ),
          Row(
            mainAxisAlignment: message.isUser
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                padding: isTyping
                    ? EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h)
                    : EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: isTyping
                    ? TypingIndicator()
                    : Text(
                        message.text,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff374151),
                        ),
                        textAlign: message.isUser
                            ? TextAlign.end
                            : TextAlign.start,
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
