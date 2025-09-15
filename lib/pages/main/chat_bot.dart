import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pin_grow/service/socket.dart';
import 'package:pin_grow/view_model/auth_view_model.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatBotPage extends StatefulHookConsumerWidget {
  const ChatBotPage({super.key});

  @override
  ConsumerState<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends ConsumerState<ChatBotPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  /**final WebSocketChannel _channel = WebSocketChannel.connect(
    Uri.parse('ws://echo.websocket.events'),
  ); */

  final FlutterWebSocket flutterWebSocket = FlutterWebSocket();
  WebSocket? socket;
  final List messages = [];

  void setStateMessage(data) {
    print("[chat_main.dart] (setStateMessage) 업데이트 할 값 : $data");
    setState(() => messages.add(data));
  }

  void createSocket() async {
    try {
      final authState = ref.read(authViewModelProvider);

      socket = await flutterWebSocket.getSocket();

      // 클라이언트 초기 설정 (서버측 클라이언트 정보 알림용 메시지 전송)
      flutterWebSocket.addMessage(
        socket,
        authState.user?.nickname ?? 'user',
        "",
        "init",
      );

      socket?.listen((data) {
        print("[DEBUG] (createSocket) 서버로부터 받은 값 : $data");
        setState(() {
          setStateMessage(data);
        });
      });
    } catch (e) {
      print("[DEBUG] (createSocket) 소켓 서버 접속 오류 $e");
    }
  }

  void sendMessage() {
    if (_controller.text.trim().isNotEmpty) {
      final authState = ref.read(authViewModelProvider);

      String message = _controller.text; // 메시지 내용
      String messageType = ""; // 메시지 타입

      messageType = "all";

      // 웹소켓 서버에 메시지 내용 전송
      flutterWebSocket.addMessage(
        socket,
        authState.user?.nickname ?? 'user',
        message,
        messageType,
      );

      _controller.clear();
    }
  }

  bool _isBot(dynamic username) {
    return username == 'bot';
  }

  @override
  void initState() {
    super.initState();

    createSocket();
  }

  @override
  void dispose() {
    //_channel.sink.close();
    socket!.close();
    super.dispose();
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/icons/chat_bot_icon.png',
                          width: 38.r,
                          height: 38.r,
                        ),
                      ],
                    ),
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: messages.length,
                        itemBuilder: (BuildContext context, int index) {
                          // 추가된 메시지 내용
                          print(
                            "[chat_area.dart] (build) 추가된 메시지 내용 : ${messages[index]}",
                          );

                          // JSON 문자열을 맵으로 변환
                          Map<String, dynamic> data = jsonDecode(
                            messages[index],
                          );

                          return Stack(
                            children: [
                              Positioned(
                                left: 0,
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minWidth: 52.w,
                                    minHeight: 33.h,
                                    maxWidth: 285.w,
                                  ),
                                  child: Card(
                                    margin: EdgeInsets.fromLTRB(0, 8.h, 0, 8.h),
                                    child: Container(
                                      width:
                                          285, // loading -> 52, loaded -> 285
                                      padding: EdgeInsets.fromLTRB(
                                        24.w,
                                        24.h,
                                        24.w,
                                        24.h,
                                      ), // loading -> none, loaded -> all(24)
                                      child: Text(data['message']),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
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
                              sendMessage();

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
}
