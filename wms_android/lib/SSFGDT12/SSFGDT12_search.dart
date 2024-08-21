import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/custom_appbar.dart';
import 'SSFGDT12_card.dart';

class Ssfgdt12Search extends StatefulWidget {
  final String pWareCode;
  Ssfgdt12Search({
    Key? key,
    required this.pWareCode,
  }) : super(key: key);
  @override
  _Ssfgdt12SearchState createState() => _Ssfgdt12SearchState();
}

class _Ssfgdt12SearchState extends State<Ssfgdt12Search> {
  //
  String pDocNo = ''; // ตัวแปรเก็บค่าเอกสาร
  final TextEditingController _controller =
      TextEditingController(); // ตัวควบคุม TextFormField

  String selectedDate = ''; // ตัวแปรเก็บค่าวันที่
  final TextEditingController _dateController =
      TextEditingController(); // ตัวควบคุม TextFormField สำหรับวันที่

  String selectedItem = ''; // เก็บสถานะที่เลือก
  String status = ''; // ตัวแปรที่จะเก็บค่า STATUS จริงๆ
  final List<String> dropdownItems = [
    'รอตรวจนับ',
    'กำลังตรวจนับ',
    'ยื่นยันตรวจนับแล้ว',
    'กำลังปรับปรุงจำนวน/มูลค่า',
    'ยืนยันปรับปรุงจำนวน/มูลค่าแล้ว',
  ]; // รายการใน dropdown

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      // Format the date as DD/MM/YYYY
      String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
      setState(() {
        _dateController.text = formattedDate;
        selectedDate = _dateController.text;
      });
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
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextFormField(
              controller: _controller,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(5.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(5.5),
                ),
                // prefixIcon: Icon(Icons.person, color: Colors.blue),
                hintText: 'เลขที่ใบตรวจนับ',
                hintStyle: TextStyle(color: Colors.blue),
                filled: true,
                fillColor: Colors.blue[50],
              ),
              onChanged: (value) {
                setState(() {
                  pDocNo = value;
                });
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _dateController,
              readOnly: true,
              onTap: () => _selectDate(context), // เปิด DatePicker เมื่อกด
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(5.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(5.5),
                ),
                hintText: 'เลือกวันที่',
                hintStyle: TextStyle(color: Colors.blue),
                filled: true,
                fillColor: Colors.blue[50],
                prefixIcon: Icon(Icons.calendar_today, color: Colors.blue),
              ),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: selectedItem.isEmpty ? null : selectedItem,
              items: dropdownItems
                  .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      ))
                  .toList(),
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(5.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(5.5),
                ),
                hintText: 'สถานะ',
                hintStyle: TextStyle(color: Colors.blue),
                filled: true,
                fillColor: Colors.blue[50],
              ),
              onChanged: (value) {
                setState(() {
                  selectedItem = value ?? '';
                  // กำหนดค่า STATUS ตามตัวเลือกที่เลือก
                  switch (selectedItem) {
                    case 'รอตรวจนับ':
                      status = 'N';
                      break;
                    case 'กำลังตรวจนับ':
                      status = 'T';
                      break;
                    case 'ยื่นยันตรวจนับแล้ว':
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _controller.clear(); // เคลียร์ค่าที่พิมพ์ไว้
                    _dateController.clear(); // เคลียร์วันที่
                    setState(() {
                      pDocNo = '';
                      selectedDate = '';
                      selectedItem = '';
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // สีของปุ่ม clear
                  ),
                  child: const Text('Clear'),
                ),
                ElevatedButton(
                  onPressed: pDocNo.isNotEmpty &&
                          selectedDate.isNotEmpty &&
                          selectedItem.isNotEmpty
                      ? () {
                          _navigateToPage(
                              context,
                              Ssfgdt12Card(
                                docNo: pDocNo,
                                date: selectedDate,
                                status: status,
                                pWareCode: widget.pWareCode != null
                                    ? widget.pWareCode
                                    : 'ย่ำแย่ๆ ware_code = null!!!!!!',
                              )
                              //
                              );
                        }
                      : null, // ปุ่มจะถูก disable ถ้าไม่มีค่าใน TextFormField
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // สีของปุ่ม search
                  ),
                  child: const Text('Search'),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(),
    );
  }
}
