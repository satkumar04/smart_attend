import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() {
  runApp(const SplashPageScreen());
}

class SplashPageScreen extends StatelessWidget {
  const SplashPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
          scaffoldBackgroundColor: Color.fromARGB(255, 252, 246, 246)),
      home: const FadeInAndSlide(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/images/logo.png"),
        )),
      ),
    );
  }
}

class FadeInAndSlide extends StatefulWidget {
  const FadeInAndSlide({super.key});

  @override
  State<FadeInAndSlide> createState() => _FadeInAndSlideState();
}

class _FadeInAndSlideState extends State<FadeInAndSlide> {
  String logo = "assets/images/profile.png";
  String branding = "ConnelBlaze";
  String logoText = "Splasha";
  bool isDone = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          isDone
              ? Center(
                  child: Text(
                    logoText,
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                )
                  .animate()
                  .fadeIn(duration: 1000.ms)
                  .then(delay: 600.ms)
                  .slideX(begin: -0.07, end: 0.2)
                  .then(delay: 1000.ms)
                  .slideX(end: -0.3, duration: 1200.ms)
                  .then(delay: 200.ms)
                  .fadeOut(duration: 1000.ms)
              : Container(),
          Center(
                  child: Image.asset(
            logo,
            width: 100,
          ))
              .animate()
              .fadeIn(duration: 3000.ms)
              .then(delay: 1200.ms)
              .slideX(end: -0.2, duration: 2000.ms)
              .callback(
                  duration: 600.ms,
                  callback: (_) {
                    setState(() {
                      isDone = true;
                    });
                  })
              .then(delay: 6500.ms)
              .slideX(end: 0.2)
              .then(delay: 1000.ms)
              .scaleXY(end: 10, duration: 1000.ms)
              .then(delay: 1000.ms)
              .callback(callback: (_) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomePage()));
          }),
          Positioned(
            bottom: 5,
            child: Text(
              branding,
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
