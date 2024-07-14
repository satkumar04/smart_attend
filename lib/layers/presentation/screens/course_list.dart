import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:smart_attendance/layers/data/model/student.dart';
import 'package:smart_attendance/layers/presentation/screens/login.dart';

final List<Student> entries = <Student>[
  const Student(name: 'MLT 100', isSelected: false),
  const Student(name: 'PYL 100', isSelected: false),
  const Student(name: 'CML 100', isSelected: false),
  const Student(name: 'APL 100', isSelected: true),
  const Student(name: 'NEN 100', isSelected: false)
];
final ButtonStyle flatButtonStyle = TextButton.styleFrom(
  foregroundColor: Colors.black87,
  minimumSize: const Size(88, 36),
  padding: const EdgeInsets.symmetric(horizontal: 16),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(2)),
  ),
);
final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
  foregroundColor: Colors.black87,
  backgroundColor: const Color.fromARGB(255, 233, 50, 50),
  minimumSize: const Size(100, 60),
  padding: const EdgeInsets.symmetric(horizontal: 88, vertical: 8),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
  ),
);

class CourseList extends StatelessWidget {
  const CourseList({super.key});
//background: #E43E3A;

  @override
  Widget build(BuildContext context) {
    AlignmentGeometry _alignment = Alignment.centerRight;
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
        body: Container(
          color: Colors.white,
          child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Courses List',
                    style: TextStyle(
                        fontFamily: 'segou',
                        fontSize: 22,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: entries.length,
                      itemBuilder: (context, position) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              Get.off(const Login(),
                                  transition: Transition.fade,
                                  duration: const Duration(seconds: 1));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: entries[position].isSelected
                                    ? const Color(0xFFCDFFCC)
                                    : const Color(0xFFFFFFFF),
                                border: Border.all(
                                  color: const Color.fromARGB(255, 16, 6, 3),
                                  style: BorderStyle.solid,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: [
                                    Text(
                                      entries[position].name,
                                      style: const TextStyle(fontSize: 16.0),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    entries[position].isSelected
                                        ? const Icon(
                                            Icons.check_circle,
                                            color: Colors.green,
                                            size: 20.0,
                                          )
                                        : Container()
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    )
                        .animate()
                        .fade()
                        .then(delay: 1.ms)
                        .slideX(begin: 1, end: 0, duration: 700.ms),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: raisedButtonStyle,
                      onPressed: () {},
                      child: const Text(
                        "Mark Attendance",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                        .animate()
                        .fade()
                        .then(delay: 1.ms)
                        .slideY(begin: 3, end: 0, duration: 700.ms),
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  const Text(
                    "Powered by Lucify",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              )),
        ));
  }
}
