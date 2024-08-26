import 'package:flutter/material.dart';
import 'package:wms_android/custom_appbar.dart';
import 'package:wms_android/custom_drawer.dart';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/main.dart';
import 'SSFGDT17_CREATE.dart' as cr;

class SSFGDT17_BARCODE extends StatefulWidget {

  final String po_doc_no;
  final String? po_doc_type;
  final String? LocCode;


  SSFGDT17_BARCODE({required this.po_doc_no, this.po_doc_type, this.LocCode});

  @override
  _SSFGDT17_BARCODEState createState() => _SSFGDT17_BARCODEState();
}

class _SSFGDT17_BARCODEState extends State<SSFGDT17_BARCODE> {

  String currentSessionID = '';

  @override
  void initState() {
    super.initState();
    currentSessionID = SessionManager().sessionID;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const CustomDrawer(),
      body: Center(
        child: Text("Move Locator \n session: $currentSessionID"),
      ),
      bottomNavigationBar: BottomBar(),
    );
  }
}
