import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/custom_appbar.dart';
import 'dart:ui';
import 'package:flutter/services.dart';
import '../styles.dart';
import 'SSFGPC04_WARE.dart';

class SSFGPC04_MAIN extends StatefulWidget {
  const SSFGPC04_MAIN({
    Key? key,
  }) : super(key: key);
  @override
  _SSFGPC04_MAINState createState() => _SSFGPC04_MAINState();
}

class _SSFGPC04_MAINState extends State<SSFGPC04_MAIN> {
  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(); // Default status
  String selectedDate = 'null'; // Allow null for the date
  String pSoNo = 'null';
  TextEditingController _dateController = TextEditingController();
  TextEditingController _controller = TextEditingController();
  TextEditingController _noteController = TextEditingController();
  final String sDateFormat = "dd-MM-yyyy";

  String? _dateError;

  @override
  void initState() {
    super.initState();
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
      String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
      if (mounted) {
        setState(() {
          _dateController.text = formattedDate;
          selectedDate = _dateController.text;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF17153B),
        appBar: const CustomAppBar(title: 'ประมวลผลก่อนการตรวจนับ'),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _dateController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter
                          .digitsOnly, // ยอมรับเฉพาะตัวเลข
                      LengthLimitingTextInputFormatter(
                          8), // จำกัดจำนวนตัวอักษรไม่เกิน 8 ตัว
                      DateInputFormatter(), // กำหนดรูปแบบ __/__/____
                    ],
                    onTap: () {
                      // อนุญาตให้ผู้ใช้กรอกวันที่เอง
                      _dateController.selection = TextSelection(
                        baseOffset: 0,
                        extentOffset: _dateController.text.length,
                      );
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: 'ณ วันที่',
                      labelStyle: TextStyle(color: Colors.black),
                      hintStyle:
                          const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                      filled: true,
                      fillColor: Colors.white,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today,
                            color: Color.fromARGB(255, 64, 64, 64)),
                        onPressed: () => _selectDate(context),
                      ),
                      errorText: _dateError, // แสดงข้อผิดพลาดที่นี่
                    ),
                    onChanged: (value) {
                      setState(() {
                        _dateController.text = value;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'เลขที่เอกสาร',
                      filled: true,
                      fillColor: Colors.grey[300],
                      labelStyle: TextStyle(color: Colors.black),
                      hintStyle:
                          const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                      border: InputBorder.none,
                    ),
                    controller: TextEditingController(text: 'AUTO'),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'หมายเหตุ',
                      filled: true,
                      fillColor: Colors.white,
                      labelStyle: TextStyle(color: Colors.black),
                      border: InputBorder.none,
                    ),
                    controller: _noteController,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          List<Map<String, dynamic>> selectedItems =
                              []; // Use your actual list here

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SSFGPC04_CARD(
                                soNo: pSoNo.isEmpty ? 'null' : pSoNo,
                                date: selectedDate.isEmpty
                                    ? 'null'
                                    : selectedDate, // Ensure selectedDate is passed
                                selectedItems:
                                    selectedItems, // Pass selectedItems correctly
                              ),
                            ),
                          );
                        },
                        style: AppStyles.ConfirmbuttonStyle(),
                        child: Text(
                          'CONFIRM',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomBar(currentPage: 'show'),
        );
  }
}

class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text;

    // กรองเฉพาะตัวเลข
    text = text.replaceAll(RegExp(r'[^0-9]'), '');

    // จัดรูปแบบเป็น DD/MM/YYYY
    if (text.length > 2 && text.length <= 4) {
      text = '${text.substring(0, 2)}/${text.substring(2)}';
    } else if (text.length > 4 && text.length <= 8) {
      text =
          '${text.substring(0, 2)}/${text.substring(2, 4)}/${text.substring(4)}';
    }

    // จำกัดความยาวไม่เกิน 10 ตัว (รวม /)
    if (text.length > 10) {
      text = text.substring(0, 10);
    }

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
