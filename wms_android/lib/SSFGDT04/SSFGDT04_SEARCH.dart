import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/custom_appbar.dart';
import 'SSFGDT04_CARD.dart';
import 'dart:ui';
import 'package:wms_android/Global_Parameter.dart' as gb;
import '../styles.dart';
import 'package:flutter/services.dart';

class SSFGDT04_SEARCH extends StatefulWidget {
  final String pWareCode;
  final String pErpOuCode;

  const SSFGDT04_SEARCH({
    super.key,
    required this.pWareCode,
    required this.pErpOuCode,
  });

  @override
  _SSFGDT04_SEARCHState createState() => _SSFGDT04_SEARCHState();
}

class _SSFGDT04_SEARCHState extends State<SSFGDT04_SEARCH> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int pFlag = 1;
  String pSoNo = 'null';
  String selectedItem =
      'ระหว่างบันทึก'; // Ensure this value exists in dropdownItems
  String status = '1'; // Default status
  String selectedDate = 'null'; // Allow null for the date
  String appUser = gb.APP_USER;
  TextEditingController _dateController = TextEditingController();
  TextEditingController _controller = TextEditingController();
  TextEditingController _statusController = TextEditingController();
  final String sDateFormat = "dd-MM-yyyy";
  final List<dynamic> dropdownItems = [
    'ทั้งหมด',
    'ระหว่างบันทึก',
    'ยืนยันการรับ',
    'ยกเลิก',
  ];
  String? _dateError;
  final dateRegExp =
      RegExp(r"^(0[1-9]|[12][0-9]|3[01])/(0[1-9]|1[0-2])/\d{4}$");

  bool dateColorCheck = false;
  bool monthColorCheck = false;
  bool noDate = false;
  bool chkDate = false;
  bool isLoading = false;

  @override
  void initState() {
    setData();
    super.initState();
    print(
        'selectedItem in search page : $selectedItem Type : ${selectedItem.runtimeType}');
    print('statusDESC in search page : $status Type : ${status.runtimeType}');
    print(
        'selectedDate in search page : $selectedDate Type : ${selectedDate.runtimeType}');
  }

  @override
  void dispose() {
    _dateController.dispose();
    _controller.dispose();
    _statusController.dispose();
    super.dispose();
  }

  void setData() {
    isLoading = true;
    if (mounted) {
      setState(() {
        _statusController.text = 'ระหว่างบันทึก';
        isLoading = false;
      });
    }
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

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  void _showDropdownPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Container(
                padding: const EdgeInsets.all(16),
                height: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'ประเภทรายการ',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: dropdownItems.length,
                        itemBuilder: (context, index) {
                          var item = dropdownItems[index];
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              child: Text(
                                item,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                selectedItem = item;
                                _statusController.text = selectedItem;

                                switch (item) {
                                  case 'ทั้งหมด':
                                    status = '0';
                                    break;
                                  case 'ระหว่างบันทึก':
                                    status = '1';
                                    break;
                                  case 'ยืนยันการรับ':
                                    status = '2';
                                    break;
                                  case 'ยกเลิก':
                                    status = '3';
                                    break;
                                  default:
                                    status = '0';
                                }
                              });
                              Navigator.of(context).pop();
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF17153B),
      appBar: const CustomAppBar(title: 'รับตรง (ไม่อ้าง PO)'),
      body: SingleChildScrollView(
        // padding: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                TextFormField(
                  readOnly: true,
                  onTap: _showDropdownPopup,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: 'ประเภทรายการ',
                    labelStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                    filled: true,
                    fillColor: Colors.white,
                    suffixIcon: Icon(
                      Icons.arrow_drop_down,
                      color: Color.fromARGB(255, 113, 113, 113),
                    ),
                  ),
                  controller: _statusController,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    labelText: 'เลขที่เอกสาร',
                    labelStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                    hintStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: (value) {
                    setState(() {
                      pSoNo = value;
                    });
                  },
                ),
                const SizedBox(height: 8),
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
                    labelText: 'วันที่ส่งสินค้า',
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
                      RegExp dateRegExp = RegExp(r'^\d{2}/\d{2}/\d{4}$');
                      if (!dateRegExp.hasMatch(selectedDate)) {
                        chkDate =
                            true; // ถ้ารูปแบบไม่ถูกต้องให้ตั้งค่าเป็น true
                      } else {
                        chkDate = false; // ถ้ารูปแบบถูกต้องให้ตั้งค่าเป็น false
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
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _controller.clear();
                          _dateController.clear();
                          _statusController.text =
                              'ทั้งหมด'; // กำหนดค่าเริ่มต้นให้กับ DropdownButtonFormField
                          selectedDate = 'null'; // Set selectedDate to null
                          selectedItem = 'ทั้งหมด'; // Reset to a valid value
                          status = '0';
                          noDate = false;
                          chkDate = false; // Reset status to default
                        });
                      },
                      style: AppStyles.EraserButtonStyle(),
                      child: Image.asset('assets/images/eraser_red.png',
                          width: 50, height: 25),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
  onPressed: () {
    if (noDate != true && chkDate != true) {
      // ตรวจสอบว่าค่า selectedDate ว่างหรือเป็น null
      if (selectedDate.isNotEmpty && selectedDate != 'null') {
        RegExp dateRegExp = RegExp(r'^\d{2}/\d{2}/\d{4}$');
        if (!dateRegExp.hasMatch(selectedDate)) {
          setState(() {
            chkDate = true;
          });
        } else {
          DateTime parsedDate = DateFormat('dd/MM/yyyy').parse(selectedDate);
          String formattedDate = DateFormat('dd-MM-yyyy').format(parsedDate);

          setState(() {
            selectedDate = formattedDate;
          });

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SSFGDT04_CARD(
                pErpOuCode: widget.pErpOuCode,
                pWareCode: widget.pWareCode,
                pAppUser: appUser,
                pFlag: pFlag,
                soNo: pSoNo.isEmpty ? 'null' : pSoNo,
                date: formattedDate.isEmpty ? 'null' : formattedDate,  // เช็คค่าของ selectedDate
                status: status,
              ),
            ),
          );
        }
      } else {
        // ถ้าไม่มีการกรอกวันที่ ส่งค่า 'null'
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SSFGDT04_CARD(
              pErpOuCode: widget.pErpOuCode,
              pWareCode: widget.pWareCode,
              pAppUser: appUser,
              pFlag: pFlag,
              soNo: pSoNo.isEmpty ? 'null' : pSoNo,
              date: 'null',  // ส่งค่า 'null' เมื่อ selectedDate เป็นค่าว่างหรือ null
              status: status,
            ),
          ),
        );
      }
    }
  },
  style: AppStyles.SearchButtonStyle(),
  child: Image.asset(
    'assets/images/search_color.png',
    width: 50,
    height: 25,
  ),
),

                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomBar(currentPage: 'not_show'),
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
