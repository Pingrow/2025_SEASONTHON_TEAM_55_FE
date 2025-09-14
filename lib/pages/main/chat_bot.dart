import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pin_grow/model/user_model.dart';
import 'package:pin_grow/pages/onboarding/research_page_step5.dart';
import 'package:pin_grow/providers/onboarding_providers.dart';
import 'package:pin_grow/view_model/auth_view_model.dart';

class ChatBotPage extends StatefulHookConsumerWidget {
  const ChatBotPage({super.key});

  @override
  ConsumerState<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends ConsumerState<ChatBotPage> {
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);

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
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
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
                          ],
                        ),
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
                              print('[DEBUG]\n입력: ${_controller.text}');
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
