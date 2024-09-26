import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:wms_android/styles.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/custom_appbar.dart';
import 'package:wms_android/Global_Parameter.dart' as globals;
import 'SSFGDT12_card.dart';

class Ssfgdt12Search extends StatefulWidget {
  final String pWareCode;
  final String pWareName;
  final String pErpOuCode;
  final String p_attr1;
  Ssfgdt12Search({
    Key? key,
    required this.pWareCode,
    required this.pWareName,
    required this.pErpOuCode,
    required this.p_attr1,
  }) : super(key: key);
  @override
  _Ssfgdt12SearchState createState() => _Ssfgdt12SearchState();
}

class _Ssfgdt12SearchState extends State<Ssfgdt12Search> {
  int p_flag = 1;
  String pDocNo = '';
  String selectedItem = 'รอตรวจนับ';
  String status = 'N';
  String selectedDate = '';
  TextEditingController _dateController = TextEditingController();
  final TextEditingController _controller = TextEditingController();
  final String sDateFormat = "dd/MM/yyyy";
  final List<String> dropdownItems = [
    'ทั้งหมด',
    'รอตรวจนับ',
    'กำลังตรวจนับ',
    'ยืนยันตรวจนับแล้ว',
    'กำลังปรับปรุงจำนวน/มูลค่า',
    'ยืนยันปรับปรุงจำนวน/มูลค่าแล้ว',
  ]; // รายการใน dropdown

  @override
  void initState() {
    super.initState();
    print(
        'pWareCode in search page : ${widget.pWareCode} Type : ${widget.pWareCode.runtimeType}');
    print(
        'pWareName in search page : ${widget.pWareName} Type : ${widget.pWareName.runtimeType}');
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );

    if (pickedDate != null) {
      // Format the date as dd/MM/yyyy
      String formattedDate = new DateFormat('dd/MM/yyyy').format(pickedDate);
      if (mounted) {
        setState(() {
          _dateController.text = formattedDate;
          selectedDate = _dateController.text;
        });
      }
    }
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF17153B),
      appBar: CustomAppBar(title: 'ผลการตรวจนับ'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _controller,
              decoration: InputDecoration(
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.white,
                labelText: 'เลขที่ใบตรวจนับ',
                labelStyle: const TextStyle(
                  color: Colors.black87,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  pDocNo = value;
                });
              },
            ),
            const SizedBox(height: 8),
            //////////////////////////////////////////////////////////////////////////////////////
            TextFormField(
              controller: _dateController,
              decoration: InputDecoration(
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.white,
                labelText: 'วันที่เตรียมข้อมูลตรวจนับ',
                labelStyle: const TextStyle(
                  color: Colors.black87,
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today), // ไอคอนที่อยู่ขวาสุด
                  onPressed: () async {
                    // กดไอคอนเพื่อเปิด date picker
                    _selectDate(context);
                  },
                ),
              ),
              onChanged: (value) {
                selectedDate = value;
              },
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField2<String>(
              value: selectedItem,
              items: dropdownItems
                  .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      ))
                  .toList(),
              decoration: InputDecoration(
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.white,
                labelText: 'สถานะ',
                labelStyle: const TextStyle(
                  color: Colors.black87,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  selectedItem = value ?? '';
                  switch (selectedItem) {
                    case 'ทั้งหมด':
                      status = '1';
                      break;
                    case 'รอตรวจนับ':
                      status = 'N';
                      break;
                    case 'กำลังตรวจนับ':
                      status = 'T';
                      break;
                    case 'ยืนยันตรวจนับแล้ว':
                      status = 'X';
                      break;
                    case 'กำลังปรับปรุงจำนวน/มูลค่า':
                      status = 'A';
                      break;
                    case 'ยืนยันปรับปรุงจำนวน/มูลค่าแล้ว':
                      status = 'B';
                      break;
                    default:
                      status = 'Unknown';
                  }
                });
              },
            ),
            const SizedBox(height: 20),
            //////////////////////////////////////////////////////////////////////////////////////
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Container(
                //   decoration: BoxDecoration(
                //     color: Colors.grey[300],
                //     borderRadius: BorderRadius.circular(8.0),
                //   ),
                //   child: IconButton(
                //     iconSize: 20.0,
                //     icon: Image.asset(
                //       'assets/images/eraser_red.png',
                //       width: 50.0,
                //       height: 25.0,
                //     ),
                //     onPressed: () {
                //       _controller.clear();
                //       _dateController.clear();
                //       setState(() {
                //         pDocNo = '';
                //         selectedDate = '';
                //         selectedItem = 'รอตรวจนับ';
                //         status = 'N';
                //       });
                //     },
                //   ),
                // ),
                ElevatedButton(
                  onPressed: () {
                    _controller.clear();
                    _dateController.clear();
                    setState(() {
                      pDocNo = '';
                      selectedDate = '';
                      selectedItem = 'รอตรวจนับ';
                      status = 'N';
                    });
                  },
                  style: AppStyles.EraserButtonStyle(),
                  child: Image.asset(
                    'assets/images/eraser_red.png', // ใส่ภาพจากไฟล์ asset
                    width: 50, // กำหนดขนาดภาพ
                    height: 25,
                  ),
                ),
                const SizedBox(width: 20),
                const SizedBox(width: 20),
                //////////////////////////////////////////////////////
                /// //////////////////////////////////////////////////////
                ElevatedButton(
                  onPressed: () {
                    _navigateToPage(
                        context,
                        Ssfgdt12Card(
                          docNo: pDocNo,
                          date: selectedDate,
                          status: status,
                          pWareCode: widget.pWareCode,
                          p_flag: p_flag,
                          browser_language: globals.BROWSER_LANGUAGE,
                          pErpOuCode: widget.pErpOuCode,
                          p_attr1: widget.p_attr1,
                        )
                        //
                        );
                  },
                  style: AppStyles.SearchButtonStyle(),
                  child: Image.asset(
                    'assets/images/search_color.png', // ใส่ภาพจากไฟล์ asset
                    width: 50, // กำหนดขนาดภาพ
                    height: 25,
                  ),
                ),
                // Container(
                //   decoration: BoxDecoration(
                //     color: Colors.white,
                //     borderRadius: BorderRadius.circular(8.0),
                //   ),
                //   child: IconButton(
                //     iconSize: 20.0,
                //     icon: Image.asset(
                //       'assets/images/search_color.png',
                //       width: 50.0,
                //       height: 25.0,
                //     ),
                //     onPressed: () {
                //       _navigateToPage(
                //           context,
                //           Ssfgdt12Card(
                //             docNo: pDocNo,
                //             date: selectedDate,
                //             status: status,
                //             pWareCode: widget.pWareCode,
                //             p_flag: p_flag,
                //             browser_language: globals.BROWSER_LANGUAGE,
                //             pErpOuCode: widget.pErpOuCode,
                //             p_attr1: widget.p_attr1,
                //           )
                //           //
                //           );
                //     },
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(),
    );
  }
}
