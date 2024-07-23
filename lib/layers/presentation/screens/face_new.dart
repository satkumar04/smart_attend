import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
  foregroundColor: Colors.black87,
  backgroundColor: const Color.fromARGB(255, 233, 50, 50),
  minimumSize: const Size(100, 60),
  padding: const EdgeInsets.symmetric(horizontal: 88, vertical: 8),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
  ),
);
void main() {
  runApp(const LoginScreen());
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      home: FaceNew(),
    );
  }
}

class FaceNew extends StatefulWidget {
  const FaceNew({super.key});

  @override
  State<FaceNew> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<FaceNew> with TickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      /// [AnimationController]s can be created with `vsync: this` because of
      /// [TickerProviderStateMixin].
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addListener(() {
        setState(() {});
      });
    controller.repeat(reverse: false);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const Text(
          'SmartAttend',
          style: TextStyle(
            color: Color(0xFFE43E3A),
            fontFamily: 'segoe',
            fontSize: 20,
            fontWeight: FontWeight.normal,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () => {},
            icon: Image.asset(
              'assets/images/profile.png',
            ),
            padding: const EdgeInsets.only(right: 20),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(25),
                ),
                boxShadow: [
                  BoxShadow(
                      color: Colors.red, blurRadius: 10, offset: Offset(-5, 6)),
                ],
              ),
              width: double.infinity,
              height: 371,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 400,
                    height: 400,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/user.jpg'),
                        fit: BoxFit.cover,
                      ),
                      color: Colors.blue,
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    ),
                    // child: Image.asset(
                    //   'assets/images/user.jpg',
                    //   width: double.infinity,
                    //   fit: BoxFit.cover,
                    // ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(
                          0.3,
                        ),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(25),
                          bottomRight: Radius.circular(25),
                        ),
                      ),
                      height: 50,
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: LinearProgressIndicator(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          color: Colors.red,
                          value: controller.value,
                          semanticsLabel: 'Linear progress indicator',
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            'Timer 15..14..13 seconds left',
            style: TextStyle(fontSize: 14, color: Colors.black),
            textAlign: TextAlign.center,
          ),
          const Text(
            'Keep your app in Foreground',
            style: TextStyle(fontSize: 14, color: Colors.red),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: ElevatedButton(
              style: raisedButtonStyle,
              onPressed: () {},
              child: const Text(
                "Capture",
                style: TextStyle(color: Colors.white),
              ),
            )
                .animate()
                .fade()
                .then(delay: 1.ms)
                .slideY(begin: 3, end: 0, duration: 700.ms),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Powered by Lucify",
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
