import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:smart_attendance/layers/data/model/attendance.dart';

import '../widgets/dropdown_widget.dart';

final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
  foregroundColor: Colors.black87,
  backgroundColor: const Color.fromARGB(255, 233, 50, 50),
  minimumSize: const Size(100, 60),
  padding: const EdgeInsets.symmetric(horizontal: 88, vertical: 8),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
  ),
);

final List<Attendance> entries = <Attendance>[
  const Attendance(date: '12 June 2024', day: 'Monday', status: 'Present'),
  const Attendance(date: '14 June 2024', day: 'Wednesday', status: 'Present'),
  const Attendance(date: '15 June 2024', day: 'Thursday', status: 'Absent'),
  const Attendance(date: '16 June 2024', day: 'Friday', status: 'Present'),
  const Attendance(date: '17 June 2024', day: 'Saturday', status: 'Present'),
  const Attendance(date: '19 June 2024', day: 'Monday', status: 'Present'),
];

void main() {
  runApp(const LoginScreen());
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      home: AttendanceDetails(),
    );
  }
}
//background: #DADADA;

class AttendanceDetails extends StatelessWidget {
  const AttendanceDetails({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: const Color(0xFFDADADA),
              ),
              child: const Icon(
                Icons.navigate_before_rounded,
                color: Colors.black,
                size: 30.0,
              ),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 40,
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'MTL 100',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'ro',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.place,
                      color: Colors.red,
                      size: 20.0,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'LH 121',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Icon(
                      Icons.watch_later,
                      color: Colors.red,
                      size: 20.0,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      '11:00 AM',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ],
                ),
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
                    .slideY(begin: 7, end: 0, duration: 700.ms),
              ),
              const SizedBox(
                height: 40,
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Attendance history and statisticsdsdsdsd',
                        style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(226, 0, 0, 0),
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.clip,
                        maxLines: 2,
                      ),
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 25),
                      child: DropdownButtonExample(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20,),
              Expanded(
                child: ListView.builder(
                  itemCount: entries.length,
                  itemBuilder: (context, position) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                      child: Container(
                        height: 30,
                         decoration: BoxDecoration(
                                  color: entries[position].status == 'Present'
                                      ? const Color(0xFFCDFFCC)
                                      : const Color(0xFFFFE3E3),
                                  border: Border.all(
                                    color: const Color.fromARGB(255, 16, 6, 3),
                                    style: BorderStyle.solid,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(3.0),
                                ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(entries[position].date),
                            Text(entries[position].day),
                            Text(entries[position].status)
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
               const Text(
                    "Powered by Lucify",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
            ],
          ),
        ));
  }
}
