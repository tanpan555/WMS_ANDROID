import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:wms_android/custom_appbar.dart';

class TestSelectDateTime extends StatefulWidget {
  TestSelectDateTime({
    Key? key,
  }) : super(key: key);
  @override
  _TestSelectDateTimeState createState() => _TestSelectDateTimeState();
}

class _TestSelectDateTimeState extends State<TestSelectDateTime> {
  String selectedDate = '';
  bool chkDate = false;
  bool dateColorCheck = false;
  bool monthColorCheck = false;
  bool noDate = false;
  bool noTime = false;
  int _cursorPosition = 0;
  DateTime selectedDateTime = DateTime.now();

  TextEditingController dateController = TextEditingController();

  @override
  void dispose() {
    dateController.dispose();
    super.dispose();
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  Future<void> _selectDate(
      BuildContext context, String? initialDateString) async {
    DateTime? initialDate;

    if (initialDateString != null) {
      try {
        initialDate = DateFormat('dd/MM/yyyy').parseStrict(initialDateString);
      } catch (e) {
        initialDate = DateTime.now();
      }
    } else {
      initialDate = DateTime.now();
    }

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );

    if (pickedDate != null) {
      // ดึงเวลาปัจจุบันรวมถึงวินาที
      DateTime now = DateTime.now();

      // สร้าง DateTime ใหม่พร้อมกับเวลาปัจจุบันรวมถึงวินาที
      DateTime finalDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        now.hour,
        now.minute,
        now.second, // ใช้ค่าวินาทีจากเวลาปัจจุบัน
      );

      // ใช้รูปแบบ 'dd/MM/yyyy HH:mm:ss' เพื่อแสดงเวลาแบบ 24 ชั่วโมง
      String formattedDate =
          DateFormat('dd/MM/yyyy HH:mm:ss').format(finalDateTime);

      if (mounted) {
        setState(() {
          noDate = false;
          chkDate = false;
          dateController.text = formattedDate;
          selectedDate = dateController.text;
        });
      }
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'เบิกจ่าย', showExitWarning: false),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: dateController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(
                      14), // จำกัดความยาวไม่เกิน 14 ตัวอักษร
                  DateInputFormatter(), // ฟอร์แมตวันที่และเวลา
                ],
                decoration: InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'วันที่เบิกจ่าย',
                  hintText: 'DD/MM/YYYY HH:mm:ss',
                  hintStyle: TextStyle(color: Colors.grey),
                  labelStyle:
                      (chkDate == false && noDate == false && noTime == false)
                          ? const TextStyle(color: Colors.black87)
                          : const TextStyle(color: Colors.red),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today), // ไอคอนปฏิทิน
                    onPressed: () async {
                      // เปิด date picker
                      _selectDate(context, selectedDate);
                    },
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    selectedDate = value;
                    print('selectedDate : $selectedDate');

                    _cursorPosition = dateController.selection.baseOffset;
                    dateController.value = dateController.value.copyWith(
                      text: value,
                      selection: TextSelection.fromPosition(
                        TextPosition(offset: _cursorPosition),
                      ),
                    );

                    DateInputFormatter formatter = DateInputFormatter();
                    TextEditingValue oldValue =
                        TextEditingValue(text: dateController.text);
                    TextEditingValue newValue = TextEditingValue(text: value);

                    formatter.formatEditUpdate(oldValue, newValue);

                    dateColorCheck = formatter.dateColorCheck;
                    monthColorCheck = formatter.monthColorCheck;
                    noDate = formatter.noDate;
                    noTime = formatter.noTime;
                    print('noDate in setState : $noDate');
                    print('noTime in setState : $noTime');
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
                          fontSize: 12, // ปรับขนาดตัวอักษรตามที่ต้องการ
                        ),
                      ))
                  : const SizedBox.shrink(),
              noTime == true
                  ? const Padding(
                      padding: EdgeInsets.only(top: 4.0),
                      child: Text(
                        'กรุณาระบุรูปแบบเวลาให้ถูกต้อง เช่น 17:30:00',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 12, // ปรับขนาดตัวอักษรตามที่ต้องการ
                        ),
                      ))
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}

class DateInputFormatter extends TextInputFormatter {
  bool dateColorCheck = false;
  bool monthColorCheck = false;
  bool noDate = false;
  bool noTime = false;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text;

    // กรองเฉพาะตัวเลขและสัญลักษณ์ที่เกี่ยวข้อง
    text = text.replaceAll(RegExp(r'[^0-9]'), '');

    StringBuffer buffer = StringBuffer();
    int selectionIndex = newValue.selection.end;
    print(text.length);
    // ตรวจสอบค่าความยาวของข้อความ
    if (text.length < 8 && text.length > 0) {
      noDate = true;
    } else if (text.length == 8) {
      String day = text.substring(0, 2);
      String month = text.substring(2, 4);
      String year = text.substring(4, 8);

      noDate = !isValidDate(day, month, year);
    } else if (text.length > 8 && text.length <= 13) {
      noTime = true;
    } else if (text.length == 14) {
      String hour = text.substring(8, 10);
      String minute = text.substring(10, 12);
      String second = text.substring(12, 14);

      print(hour);
      print(minute);
      print(second);
      print(!isValidTime(hour, minute, second));

      noTime = !isValidTime(hour, minute, second);
    } else {
      noDate = false;
      noTime = false;
    }

    // เพิ่มสัญลักษณ์ต่าง ๆ
    if (text.length > 2) {
      buffer.write(text.substring(0, 2) + '/');
      if (selectionIndex >= 2) selectionIndex++;
    } else {
      buffer.write(text);
    }

    if (text.length > 4) {
      buffer.write(text.substring(2, 4) + '/');
      if (selectionIndex >= 4) selectionIndex++;
    } else if (text.length > 2) {
      buffer.write(text.substring(2));
    }

    if (text.length > 8) {
      buffer.write(text.substring(4, 8) + ' ');
      if (selectionIndex >= 8) selectionIndex++;
    } else if (text.length > 4) {
      buffer.write(text.substring(4));
    }

    if (text.length > 10) {
      buffer.write(text.substring(8, 10) + ':');
      if (selectionIndex >= 10) selectionIndex++;
    } else if (text.length > 8) {
      buffer.write(text.substring(8));
    }

    if (text.length > 12) {
      buffer.write(text.substring(10, 12) + ':');
      if (selectionIndex >= 12) selectionIndex++;
    } else if (text.length > 10) {
      buffer.write(text.substring(10));
    }

    if (text.length > 14) {
      buffer.write(text.substring(12, 14));
    } else if (text.length > 12) {
      buffer.write(text.substring(12));
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }

  // ฟังก์ชันตรวจสอบวันที่ถูกต้องหรือไม่
  bool isValidDate(String day, String month, String year) {
    try {
      int dayInt = int.parse(day);
      int monthInt = int.parse(month);
      int yearInt = int.parse(year);

      // ตรวจสอบจำนวนวันในแต่ละเดือน
      List<int> daysInMonth = [
        31,
        isLeapYear(yearInt) ? 29 : 28,
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
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  // ฟังก์ชันตรวจสอบเวลาถูกต้องหรือไม่
  bool isValidTime(String hour, String minute, String second) {
    try {
      int hourInt = int.parse(hour);
      int minuteInt = int.parse(minute);
      int secondInt = int.parse(second);
      print('hourInt in isValidTime: $hourInt type : ${hourInt.runtimeType}');
      print(
          'minuteInt in isValidTime: $minuteInt type : ${minuteInt.runtimeType}');
      print(
          'secondInt in isValidTime: $secondInt type : ${secondInt.runtimeType}');

      // เช็คค่าของชั่วโมง นาที และวินาที
      if (hourInt < 0 ||
          hourInt > 23 ||
          minuteInt < 0 ||
          minuteInt > 59 ||
          secondInt < 0 ||
          secondInt > 59) {
        return false;
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  // ฟังก์ชันตรวจสอบปีอธิกสุรทิน (leap year)
  bool isLeapYear(int year) {
    if (year % 4 == 0) {
      if (year % 100 == 0) {
        if (year % 400 == 0) {
          return true;
        } else {
          return false;
        }
      } else {
        return true;
      }
    } else {
      return false;
    }
  }
}
