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
  // TextEditingController _controller = TextEditingController();
  TextEditingController _noteController = TextEditingController();
  final String sDateFormat = "dd-MM-yyyy";
  final dateRegExp =
      RegExp(r"^(0[1-9]|[12][0-9]|3[01])/(0[1-9]|1[0-2])/\d{4}$");

  bool dateColorCheck = false;
  bool monthColorCheck = false;
  bool noDate = false;
  bool chkDate = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      final formattedDate = DateFormat('dd/MM/yyyy').format(picked);
      _dateController.text = formattedDate; // อัปเดตค่าใน TextFormField

      // อัปเดต selectedDate และ chkDate
      setState(() {
        selectedDate = formattedDate;
        chkDate =
            false; // ตั้งค่า chkDate เป็น false เนื่องจากมีการเลือกวันที่แล้ว
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF17153B),
      appBar:
          CustomAppBar(title: 'ประมวลผลก่อนการตรวจนับ', showExitWarning: false),
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
                    FilteringTextInputFormatter.digitsOnly, // ยอมรับเฉพาะตัวเลข
                    LengthLimitingTextInputFormatter(
                        8), // จำกัดจำนวนตัวอักษรไม่เกิน 8 ตัว
                    DateInputFormatter(), // กำหนดรูปแบบ DD/MM/YYYY
                  ],
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Colors.white,
                    labelText: 'ณ วันที่',
                    hintText: 'DD/MM/YYYY',
                    hintStyle: const TextStyle(
                      color: Colors.grey, // เปลี่ยนสี hint
                    ),
                    labelStyle: chkDate
                        ? const TextStyle(
                            color: Colors
                                .red, // เปลี่ยนเป็นสีแดงเมื่อวันที่ไม่ถูกต้อง
                          )
                        : const TextStyle(
                            color: Colors.black87, // สีปกติเมื่อวันที่ถูกต้อง
                          ),
                    suffixIcon: IconButton(
                      icon: const Icon(
                          Icons.calendar_today), // ไอคอนที่อยู่ขวาสุด
                      onPressed: () async {
                        // เปิด date picker เมื่อกดไอคอน
                        _selectDate(context);
                      },
                    ),
                  ),
                  onChanged: (value) {
                    selectedDate = value;
                    print('selectedDate : $selectedDate');

                    setState(() {
                      // ถ้าค่าว่างไม่ต้องแสดงอะไร
                      if (selectedDate.isEmpty) {
                        chkDate = false;
                        return;
                      }

                      // ตรวจสอบรูปแบบวันที่
                      if (RegExp(r'^\d{2}/\d{2}/\d{4}$')
                          .hasMatch(selectedDate)) {
                        chkDate = false; // วันที่ถูกต้อง
                      } else {
                        chkDate = true; // วันที่ไม่ถูกต้อง
                      }
                    });
                  },
                ),
                chkDate == true || noDate == true
                    ? const Padding(
                        padding: EdgeInsets.only(top: 4.0),
                        child: Text(
                          'กรุณาระบุรูปแบบวันที่ให้ถูกต้อง เช่น 31/01/2024',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 12, // ขนาดตัวอักษร
                          ),
                        ))
                    : const SizedBox.shrink(),
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
                            builder: (context) => SSFGPC04_WARE(
                              // soNo: pSoNo.isEmpty ? 'null' : pSoNo,
                              // date: selectedDate.isEmpty
                              //     ? 'null'
                              //     : selectedDate, // Ensure selectedDate is passed
                              selectedItems: selectedItems, // Pass selectedItems correctly
                            ),
                          ),
                        );
                      },
                      style: AppStyles.ConfirmbuttonStyle(),
                      child: Text(
                        'NEXT',
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
  bool dateColorCheck = false;
  bool monthColorCheck = false;
  bool noDate = false; // ตัวแปรเพื่อตรวจสอบว่ามีวันที่ไม่ถูกต้อง

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text;

    // กรองเฉพาะตัวเลข
    text = text.replaceAll(RegExp(r'[^0-9]'), '');

    String day = '';
    String month = '';
    String year = '';

    // เก็บตำแหน่งของเคอร์เซอร์ปัจจุบันก่อนจัดรูปแบบข้อความ
    int cursorPosition = newValue.selection.baseOffset;
    int additionalOffset = 0;

    // แยกค่า day, month, year
    if (text.length >= 2) {
      day = text.substring(0, 2);
    }

    if (text.length >= 4) {
      month = text.substring(2, 4);
    }

    if (text.length > 4) {
      year = text.substring(4);
    }

    dateColorCheck = false;
    monthColorCheck = false;

    // ตรวจสอบและตั้งค่า noDate ตามกรณีที่ต่างกัน
    if (text.length == 1) {
      noDate = true;
    } else if (text.length == 2) {
      noDate = true;
    } else if (text.length == 3) {
      noDate = true;
    } else if (text.length == 4) {
      noDate = true;
    } else if (text.length == 5) {
      noDate = true;
    } else if (text.length == 6) {
      noDate = true;
    } else if (text.length == 7) {
      noDate = true;
    } else if (text.length == 8) {
      noDate = false;
    } else {
      noDate = false;
    }

    // ตรวจสอบว่าค่าใน day ไม่เกิน 31
    if (day.isNotEmpty && !noDate) {
      int dayInt = int.parse(day);
      if (dayInt < 1 || dayInt > 31) {
        dateColorCheck = true;
        noDate = true;
      }
    }

    // ตรวจสอบว่าค่าใน month ไม่เกิน 12
    if (month.isNotEmpty && !noDate) {
      int monthInt = int.parse(month);
      if (monthInt < 1 || monthInt > 12) {
        monthColorCheck = true;
        noDate = true;
      }
    }

    // ตรวจสอบวันที่เฉพาะเมื่อพิมพ์ปีครบถ้วน
    if (day.isNotEmpty && month.isNotEmpty && year.length == 4 && !noDate) {
      if (!isValidDate(day, month, year)) {
        noDate = true;
      }
    }

    // จัดรูปแบบเป็น DD/MM/YYYY
    if (text.length > 2 && text.length <= 4) {
      text = text.substring(0, 2) + '/' + text.substring(2);
      if (cursorPosition > 2) {
        additionalOffset++;
      }
    } else if (text.length > 4 && text.length <= 8) {
      text = text.substring(0, 2) +
          '/' +
          text.substring(2, 4) +
          '/' +
          text.substring(4);
      if (cursorPosition > 2) {
        additionalOffset++;
      }
      if (cursorPosition > 4) {
        additionalOffset++;
      }
    }

    // จำกัดความยาวไม่เกิน 10 ตัว (รวม /)
    if (text.length > 10) {
      text = text.substring(0, 10);
    }

    // คำนวณตำแหน่งของเคอร์เซอร์หลังจากจัดรูปแบบ
    cursorPosition += additionalOffset;

    if (cursorPosition > text.length) {
      cursorPosition = text.length;
    }

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }

  // ฟังก์ชันตรวจสอบว่าวันที่ถูกต้องหรือไม่
  bool isValidDate(String day, String month, String year) {
    int dayInt = int.parse(day);
    int monthInt = int.parse(month);
    int yearInt = int.parse(year);

    // ตรวจสอบเดือนที่เกินขอบเขต
    if (monthInt < 1 || monthInt > 12) {
      monthColorCheck = false;
      return false;
    }

    // ตรวจสอบจำนวนวันในแต่ละเดือน
    List<int> daysInMonth = [
      31,
      isLeapYear(yearInt) ? 29 : 28, // ตรวจสอบปีอธิกสุรทินเมื่อปีครบถ้วน
      31,
      30,
      31,
      30,
      31,
      31,
      30,
      31,
      30,
      31
    ];
    int maxDays = daysInMonth[monthInt - 1];

    // ตรวจสอบว่าค่าวันไม่เกินจำนวนวันที่ในเดือนนั้น ๆ
    if (dayInt < 1 || dayInt > maxDays) {
      dateColorCheck = false;
      return false;
    }

    dateColorCheck = true;
    monthColorCheck = true;
    return true;
  }

  // ฟังก์ชันตรวจสอบปีอธิกสุรทิน (leap year)
  bool isLeapYear(int year) {
    if (year % 4 == 0) {
      if (year % 100 == 0) {
        if (year % 400 == 0) {
          return true; // ปีที่หาร 400 ลงตัวเป็นปีอธิกสุรทิน
        } else {
          return false; // ปีที่หาร 100 ลงตัวแต่หาร 400 ไม่ลงตัวไม่ใช่ปีอธิกสุรทิน
        }
      } else {
        return true; // ปีที่หาร 4 ลงตัวแต่หาร 100 ไม่ลงตัวเป็นปีอธิกสุรทิน
      }
    } else {
      return false; // ปีที่หาร 4 ไม่ลงตัวไม่ใช่ปีอธิกสุรทิน
    }
  }
}
