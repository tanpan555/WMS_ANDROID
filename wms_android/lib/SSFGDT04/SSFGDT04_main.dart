import 'package:flutter/material.dart';
import 'package:wms_android/custom_appbar.dart';
import 'package:wms_android/custom_drawer.dart';
import 'package:wms_android/bottombar.dart';

class SSFGDT04_MAIN extends StatefulWidget {
  const SSFGDT04_MAIN({Key? key}) : super(key: key);

  @override
  _SSFGDT04_MAINState createState() => _SSFGDT04_MAINState();
}

class _SSFGDT04_MAINState extends State<SSFGDT04_MAIN> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const CustomDrawer(),
      body: Center(
        child: Text("รับตรง (ไม่อ้าง PO)"),
      ),
      bottomNavigationBar: BottomBar(),
    );
  }
}
