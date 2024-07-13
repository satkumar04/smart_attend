import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:smart_attendance/layers/presentation/screens/animated_size_two.dart';

double generateBorderRadius() => Random().nextDouble() * 64;
double generateMargin() => Random().nextDouble() * 64;
Color generateColor() => Color(0xFFFFFFFF & Random().nextInt(0xFFFFFFFF));

void main() {
  runApp(const AnimatedSizeExampleApp());
}

class AnimatedSizeExampleApp extends StatelessWidget {
  const AnimatedSizeExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: AnimatedSizeExample(),
    );
  }
}

class AnimatedSizeExample extends StatefulWidget {
  const AnimatedSizeExample({super.key});

  @override
  State<AnimatedSizeExample> createState() => _AnimatedSizeExampleState();
}

class _AnimatedSizeExampleState extends State<AnimatedSizeExample>
    with SingleTickerProviderStateMixin {
  late double _size;
  late double _sizeHeight;
  bool _large = false;
  bool _isVisible = false;
  Timer? _timer;
  int _remainingSeconds = 10;
  late Color color;
  late double borderRadius;
  late double margin;
  double padValue = 0;

  void _updateSize() {
    setState(() {
      _size = _large ? 250.0 : 120.0;
      _sizeHeight = _large ? 250.0 : 120.0;
      _large = !_large;

      _remainingSeconds--;
    });
  }

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void didChangeDependencies() {
    _size = MediaQuery.of(context).size.width;
    _sizeHeight = MediaQuery.of(context).size.height;
    super.didChangeDependencies();
  }

  void _startCountdown() {
    const oneSecond = Duration(seconds: 1);
    _timer = Timer.periodic(oneSecond, (Timer timer) {
      if (_remainingSeconds <= 0) {
        setState(() {
          timer.cancel();
        });
      } else {
        _updateSize();
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: AnimatedPadding(
        padding: EdgeInsets.only(bottom: padValue),
        duration: const Duration(milliseconds: 190),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  color: Colors.white,
                  child: AnimatedSize(
                      curve: Curves.easeIn,
                      duration: const Duration(seconds: 1),
                      onEnd: () {
                        setState(() {
                          _isVisible = true;
                        });
                      },
                      child: SizedBox(
                        width: _size,
                        height: _sizeHeight,
                        child: _isVisible
                            ? const AnimatedSizeExampleAppTwo()
                            : const SizedBox(),
                      )),
                ),
                const SizedBox(
                  height: 10,
                ),
                AnimatedAlign(
                  alignment:
                      !_isVisible ? Alignment.centerRight : Alignment.center,
                  duration: const Duration(seconds: 1),
                  curve: Curves.fastEaseInToSlowEaseOut,
                  child: _isVisible
                      ? const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'SmartAttend',
                              style:
                                  TextStyle(fontSize: 30, color: Colors.white),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                          ],
                        )
                      : const SizedBox(
                          width: 10,
                        ),
                  onEnd: () {
                    setState(() {
                      padValue = 200;
                    });
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
