import 'package:flutter/material.dart';

void main() {
  runApp(const AnimatedSizeExampleAppTwo());
}

class AnimatedSizeExampleAppTwo extends StatelessWidget {
  const AnimatedSizeExampleAppTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.green,
        body: Center(
          child: AnimatedSizeExampleTwo(),
        ),
      ),
    );
  }
}

class AnimatedSizeExampleTwo extends StatefulWidget {
  const AnimatedSizeExampleTwo({super.key});

  @override
  State<AnimatedSizeExampleTwo> createState() => _AnimatedSizeExampleState();
}

class _AnimatedSizeExampleState extends State<AnimatedSizeExampleTwo>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    animation = CurvedAnimation(parent: controller, curve: Curves.easeOut);
    controller.repeat(reverse: false);
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: ScaleTransition(
            scale: animation,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              height: 120,
              width: 120,
              child: Image.asset(
                'assets/images/logo.png',
              ),
            ),
          ),
        ),
      ],
    );
  }
}
