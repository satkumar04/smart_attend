import 'package:flutter/material.dart';

void main() {
  runApp(const ScalingExampleAppTwo());
}

class ScalingExampleAppTwo extends StatelessWidget {
  const ScalingExampleAppTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
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
                  color: Colors.blue,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height)),
        ),
      ],
    );
  }
}
