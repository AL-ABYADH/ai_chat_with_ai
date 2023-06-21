import 'package:flutter/material.dart';

class Typing extends StatefulWidget {
  final String direction;
  const Typing({required this.direction, super.key});

  @override
  _TypingState createState() => _TypingState();
}

class _TypingState extends State<Typing> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _animation = Tween<double>(begin: 0.0, end: 2.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    )..addListener(() {
        setState(() {});
      });

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: widget.direction == 'left'
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        children: [
          Dot(animationValue: _animation.value),
          const SizedBox(width: 8.0),
          Dot(animationValue: _animation.value - 0.5),
          const SizedBox(width: 8.0),
          Dot(animationValue: _animation.value - 1.0),
        ],
      ),
    );
  }
}

class Dot extends StatelessWidget {
  final double animationValue;

  const Dot({super.key, required this.animationValue});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8.0,
      height: 8.0,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey,
      ),
      transform: Matrix4.translationValues(
        0.0,
        -10.0 * animationValue.abs(),
        0.0,
      ),
    );
  }
}
