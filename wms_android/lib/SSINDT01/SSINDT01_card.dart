import 'package:flutter/material.dart';
import 'package:wms_android/custom_appbar.dart';
import 'package:wms_android/custom_drawer.dart';
import 'SSINDT01_form.dart';

class Ssindt01Card extends StatefulWidget {
  const Ssindt01Card({Key? key}) : super(key: key);

  @override
  _Ssindt01CardState createState() => _Ssindt01CardState();
}

class _Ssindt01CardState extends State<Ssindt01Card> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const CustomDrawer(),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                Color.fromARGB(255, 68, 0, 255), // กำหนดสีพื้นหลังเป็นสีแดง
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Ssindt01Form()),
            );
          },
          child: const Text(
            'Form',
            style: TextStyle(
              color: Colors.white, // กำหนดสีข้อความเป็นสีขาว
            ),
          ),
        ),
      ),
    );
  }
}
