import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:smart_attendance/layers/presentation/screens/animated_size_two.dart';
import 'package:smart_attendance/layers/presentation/screens/login.dart';
import 'package:get/get.dart';
import 'package:smart_attendance/layers/presentation/screens/loginone.dart';

double generateBorderRadius() => Random().nextDouble() * 64;
double generateMargin() => Random().nextDouble() * 64;
Color generateColor() => Color(0xFFFFFFFF & Random().nextInt(0xFFFFFFFF));

void main() {
  runApp(const SplashPageScreen());
}

class SplashPageScreen extends StatelessWidget {
  const SplashPageScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return  GetMaterialApp(
       theme:  ThemeData(scaffoldBackgroundColor: const Color.fromARGB(255, 251, 56, 56)),
       home: const SplashPage(),
     );
  }
}

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
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
       FlutterNativeSplash.remove();
       
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
                      curve: Curves.ease,
                      duration: const Duration(milliseconds: 800),
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
        onEnd: () {
          // Navigator.of(context).push<void>(_createRoute());
          //
          //  Get.to(()=> const Login(),transition: Transition.downToUp,duration: const Duration(seconds: 1));
          //Get.to(()=> const Login());
          // Get.to(const Login());
          Get.off(const Login(),
              transition: Transition.fade,
              duration: const Duration(seconds: 1));
        },
      ),
    );
  }

  Route _createRoute() {
    return PageRouteBuilder<SlideTransition>(
      pageBuilder: (context, animation, secondaryAnimation) => const LoginOne(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var tween =
            Tween<Offset>(begin: const Offset(0.0, 5.0), end: Offset.infinite);
        var curveTween = CurveTween(curve: Curves.bounceInOut);

        return SlideTransition(
          position: animation.drive(curveTween).drive(tween),
          child: child,
        );
      },
    );
  }

  void gotoScreen() {
    Navigator.of(context).pushReplacement(_createRoute());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
