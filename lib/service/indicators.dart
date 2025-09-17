import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TypingIndicator extends StatefulWidget {
  const TypingIndicator({
    super.key,
    this.dotsCount = 3, // 점의 개수
    this.dotSize = 5.0, // 점 크기
  });

  final int dotsCount;
  final double dotSize;

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

// SingleTickerProviderStateMixin은 애니메이션을 위한 Ticker를 제공합니다.
class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;

  @override
  void initState() {
    super.initState();

    // 1. 애니메이션 컨트롤러 초기화
    // (점 개수 * 0.5초) 동안 애니메이션이 한 사이클을 돕니다.
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500 * widget.dotsCount),
    )..repeat(); // 애니메이션 무한 반복

    // 2. 애니메이션 설정
    // 컨트롤러의 값(0.0 ~ 1.0)을 정수(0, 1, 2...)로 변환합니다.
    _animation = StepTween(
      begin: 0,
      end: widget.dotsCount,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose(); // 위젯이 제거될 때 컨트롤러도 제거
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // AnimatedBuilder는 애니메이션 값이 변경될 때마다 UI를 다시 그립니다.
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return DotsIndicator(
          dotsCount: widget.dotsCount,
          // 3. 애니메이션의 현재 값을 position으로 사용
          position: (_animation.value % widget.dotsCount).toDouble(),
          decorator: DotsDecorator(
            size: Size.square(widget.dotSize),
            activeSize: Size.square(widget.dotSize),
            color: Colors.grey.shade400,
            activeColor: Color(0xff6B7280),
          ),
        );
      },
    );
  }
}
