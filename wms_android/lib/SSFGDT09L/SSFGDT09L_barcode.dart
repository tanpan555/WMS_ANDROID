import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/custom_appbar.dart';
import 'package:wms_android/Global_Parameter.dart' as globals;

class Ssfgdt09lBarcode extends StatefulWidget {
  final String pWareCode;
  final String pErpOuCode;
  final String pOuCode;
  final String pAttr1;
  final String pAppUser;
  final String pDocNo;
  final String pDocType;
  final String pMoDoNO;
  Ssfgdt09lBarcode({
    required this.pWareCode,
    required this.pErpOuCode,
    required this.pOuCode,
    required this.pAttr1,
    required this.pAppUser,
    required this.pDocNo,
    required this.pDocType,
    required this.pMoDoNO,
    Key? key,
  }) : super(key: key);
  @override
  _Ssfgdt09lBarcodeState createState() => _Ssfgdt09lBarcodeState();
}

class _Ssfgdt09lBarcodeState extends State<Ssfgdt09lBarcode> {
  String barCode = '';
  String locator = '';
  String itemCode = '';
  String lotNo = '';
  String quantity = '';
  String lotQty = '';
  String lotUnit = '';

  FocusNode _barcodeFocusNode = FocusNode();
  TextEditingController barcodeController = TextEditingController();
  TextEditingController locatorController = TextEditingController();
  TextEditingController itemCodeController = TextEditingController();
  TextEditingController lotNoController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController lotQtyController = TextEditingController();
  TextEditingController lotUnitController = TextEditingController();

  @override
  void dispose() {
    _barcodeFocusNode.dispose();
    barcodeController.dispose();
    locatorController.dispose();
    itemCodeController.dispose();
    lotNoController.dispose();
    quantityController.dispose();
    lotQtyController.dispose();
    lotUnitController.dispose();
    super.dispose();
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  void initState() {
    super.initState();
    // เพิ่ม Listener ให้กับ FocusNode ของ barcodeController
    // เพิ่ม Listener ให้กับ FocusNode ของ barcodeController
    _barcodeFocusNode.addListener(() {
      if (!_barcodeFocusNode.hasFocus) {
        // เมื่อสูญเสียโฟกัสจาก barcodeController ให้ทำการอัปเดตค่า lotNo
        setState(() {
          barCode = barcodeController.text;

          if (barCode.contains(' ')) {
            List<String> parts = barCode.split(' ');
            lotNo = parts.sublist(1).join(' ');
            lotNoController.text = lotNo; // อัปเดตค่าของ lotNoController
          } else {
            lotNo = barCode;
            lotNoController.text = lotNo; // อัปเดตค่าของ lotNoController
          }
        });
      }
    });

    // Listener สำหรับ lotNoController เพื่ออัปเดต lotNo ทุกครั้งที่มีการเปลี่ยนแปลง
    lotNoController.addListener(() {
      setState(() {
        lotNo = lotNoController.text; // ใช้ค่าสุดท้ายจาก lotNoController
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF17153B),
      appBar: CustomAppBar(title: 'Scan จ่ายสินค้า'),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
              child: Column(children: [
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      print('barCode : $barCode Type : ${barCode.runtimeType}');
                      print(
                          'barcodeController : $barcodeController Type : ${barcodeController.runtimeType}');
                      print('lotNo : $lotNo Type : ${lotNo.runtimeType}');
                      print(
                          'lotNoController : $lotNoController Type : ${lotNoController.runtimeType}');
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 103, 58, 183),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    minimumSize: const Size(10, 20),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  ),
                  child: const Text(
                    'Check DATA',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 5,
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Colors.yellow[200], // พื้นหลังสีเหลืองอ่อน
                      border: Border.all(
                        color: Colors.black, // ขอบสีดำ
                        width: 2.0, // ความกว้างของขอบ 2.0
                      ),
                      borderRadius: BorderRadius.circular(
                          8.0), // เพิ่มมุมโค้งให้กับ Container
                    ),
                    child: Center(
                      child: Text(
                        widget.pDocNo,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14, // ปรับขนาดตัวอักษรตามที่ต้องการ
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Colors.yellow[200], // พื้นหลังสีเหลืองอ่อน
                      border: Border.all(
                        color: Colors.black, // ขอบสีดำ
                        width: 2.0, // ความกว้างของขอบ 2.0
                      ),
                      borderRadius: BorderRadius.circular(
                          8.0), // เพิ่มมุมโค้งให้กับ Container
                    ),
                    child: Center(
                      child: Text(
                        widget.pMoDoNO,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14, // ปรับขนาดตัวอักษรตามที่ต้องการ
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // --------------------------------------------------------------------------------------------------
            TextFormField(
              controller: barcodeController,
              focusNode: _barcodeFocusNode,
              decoration: const InputDecoration(
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.white,
                labelText: 'Barcode',
                labelStyle: TextStyle(
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // --------------------------------------------------------------------------------------------------
            TextFormField(
              controller: locatorController,
              readOnly: true,
              decoration: const InputDecoration(
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.white,
                labelText: 'Locator ตัดจ่าย',
                labelStyle: TextStyle(
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // --------------------------------------------------------------------------------------------------
            TextFormField(
              controller: itemCodeController,
              readOnly: true,
              decoration: InputDecoration(
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.grey[300],
                labelText: 'Item Code',
                labelStyle: const TextStyle(
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // --------------------------------------------------------------------------------------------------
            TextFormField(
              controller: lotNoController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.white,
                labelText: 'Lot Number',
                labelStyle: TextStyle(
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // --------------------------------------------------------------------------------------------------
            TextFormField(
                controller: quantityController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Quantity',
                  labelStyle: TextStyle(
                    color: Colors.black87,
                  ),
                ),
                onChanged: (value) {
                  setState(
                    () {
                      quantity = value;
                    },
                  );
                }),
            const SizedBox(height: 20),
            // --------------------------------------------------------------------------------------------------
            TextFormField(
              controller: lotQtyController,
              readOnly: true,
              decoration: const InputDecoration(
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.white,
                labelText: 'Current Locator',
                labelStyle: TextStyle(
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // --------------------------------------------------------------------------------------------------
            TextFormField(
              controller: itemCodeController,
              readOnly: true,
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                    RegExp(r'[0-9.]')), // อนุญาตเฉพาะตัวเลขและจุดทศนิยม
              ],
              decoration: InputDecoration(
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.yellow[200],
                labelText: 'รวมรายการจ่าย',
                labelStyle: const TextStyle(
                  color: Colors.black87,
                ),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            // --------------------------------------------------------------------------------------------------
            TextFormField(
              controller: itemCodeController,
              readOnly: true,
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                    RegExp(r'[0-9.]')), // อนุญาตเฉพาะตัวเลขและจุดทศนิยม
              ],
              decoration: InputDecoration(
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.yellow[200],
                labelText: 'รวมจำนวนจ่าย',
                labelStyle: const TextStyle(
                  color: Colors.black87,
                ),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            // --------------------------------------------------------------------------------------------------
          ]))),
      bottomNavigationBar: BottomBar(),
    );
  }
}
