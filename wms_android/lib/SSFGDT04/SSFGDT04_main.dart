import 'package:flutter/material.dart';
import 'package:wms_android/custom_appbar.dart';
import 'package:wms_android/custom_drawer.dart';

class Ssfgdt04Main extends StatefulWidget {
  const Ssfgdt04Main({Key? key}) : super(key: key);

  @override
  _Ssfgdt04MainState createState() => _Ssfgdt04MainState();
}

class _Ssfgdt04MainState extends State<Ssfgdt04Main> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const CustomDrawer(),
      body: Center(
        child: Text("รับตรง (ไม่อ้าง PO)"),
      ),
    );
  }
}
