import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
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
  final TextEditingController dataLovStatusController = TextEditingController();
  final String sDateFormat = "dd/MM/yyyy";
  List<dynamic> dropdownItems = [
    {
      'd': 'ทั้งหมด',
      'r': '1',
    },
    {
      'd': 'รอตรวจนับ',
      'r': 'N',
    },
    {
      'd': 'กำลังตรวจนับ',
      'r': 'T',
    },
    {
      'd': 'ยืนยันตรวจนับแล้ว',
      'r': 'X',
    },
    {
      'd': 'กำลังปรับปรุงจำนวน/มูลค่า',
      'r': 'A',
    },
    {
      'd': 'ยืนยันปรับปรุงจำนวน/มูลค่าแล้ว',
      'r': 'B',
    },
  ];
  bool chkDate = false;
  bool dateColorCheck = false;
  bool monthColorCheck = false;
  bool noDate = false;

  @override
  void initState() {
    setData();
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

    // if (pickedDate != null) {
    //   // Format the date as dd/MM/yyyy
    //   String formattedDate = new DateFormat('dd/MM/yyyy').format(pickedDate);
    //   if (mounted) {
    //     setState(() {
    //       noDate = false;
    //       chkDate = false;
    //       _dateController.text = formattedDate;
    //       selectedDate = _dateController.text;
    //     });
    //   }
    // }
    if (pickedDate != null) {
      String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
      if (mounted) {
        setState(() {
          noDate = false;
          chkDate = false;
          _dateController.text = formattedDate;
          selectedDate = _dateController.text;
        });
      }
    }
  }

  void setData() {
    if (mounted) {
      setState(() {
        dataLovStatusController.text = 'รอตรวจนับ';
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
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly, // ยอมรับเฉพาะตัวเลข
                LengthLimitingTextInputFormatter(
                    8), // จำกัดจำนวนตัวอักษรไม่เกิน 10 ตัว
                DateInputFormatter(), // กำหนดรูปแบบ __/__/____
              ],
              decoration: InputDecoration(
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.white,
                labelText: 'วันที่เตรียมข้อมูลตรวจนับ',
                hintText: 'DD/MM/YYYY',
                hintStyle: TextStyle(color: Colors.grey),
                labelStyle: chkDate == false && noDate == false
                    ? const TextStyle(
                        color: Colors.black87,
                      )
                    : const TextStyle(
                        color: Colors.red,
                      ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today), // ไอคอนที่อยู่ขวาสุด
                  onPressed: () async {
                    _selectDate(context);
                  },
                ),
              ),
              onChanged: (value) {
                selectedDate = value;
                print('selectedDate : $selectedDate');
                setState(() {
                  // สร้าง instance ของ DateInputFormatter
                  DateInputFormatter formatter = DateInputFormatter();

                  // ตรวจสอบการเปลี่ยนแปลงของข้อความ
                  TextEditingValue oldValue =
                      TextEditingValue(text: _dateController.text);
                  TextEditingValue newValue = TextEditingValue(text: value);

                  // ใช้ formatEditUpdate เพื่อตรวจสอบและอัปเดตค่าสีของวันที่และเดือน
                  formatter.formatEditUpdate(oldValue, newValue);

                  // ตรวจสอบค่าที่ส่งกลับมาจาก DateInputFormatter
                  dateColorCheck = formatter.dateColorCheck;
                  monthColorCheck = formatter.monthColorCheck;
                  noDate = formatter.noDate; // เพิ่มการตรวจสอบ noDate
                });
                setState(() {
                  RegExp dateRegExp = RegExp(r'^\d{2}/\d{2}/\d{4}$');
                  // String messageAlertValueDate =
                  //     'กรุณากรองวันที่ให้ถูกต้อง';
                  if (!dateRegExp.hasMatch(selectedDate)) {
                    // setState(() {
                    //   chkDate == true;
                    // });
                    // showDialogAlert(context, messageAlertValueDate);
                  } else {
                    setState(() {
                      chkDate = false;
                    });
                  }
                });

                // setState(() {
                //   RegExp dateRegExp = RegExp(r'^\d{2}/\d{2}/\d{4}$');
                //   // String messageAlertValueDate =
                //   //     'กรุณากรองวันที่ให้ถูกต้อง';
                //   if (!dateRegExp.hasMatch(selectedDate)) {
                //     // setState(() {
                //     //   chkDate == true;
                //     // });
                //     // showDialogAlert(context, messageAlertValueDate);
                //   }
                // });
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
            const SizedBox(height: 8),
            TextFormField(
              controller: dataLovStatusController,
              readOnly: true,
              onTap: () => showDialogSelectDataStatus(),
              decoration: InputDecoration(
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.white,
                labelText: 'สถานะ',
                labelStyle: const TextStyle(
                  color: Colors.black87,
                ),
                suffixIcon: Icon(
                  Icons.arrow_drop_down,
                  color: Color.fromARGB(255, 113, 113, 113),
                ),
              ),
            ),

            const SizedBox(height: 20),
            //////////////////////////////////////////////////////////////////////////////////////
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _controller.clear();
                    _dateController.clear();
                    setState(() {
                      noDate = false;
                      chkDate = false;
                      pDocNo = '';
                      selectedDate = '';
                      selectedItem = 'รอตรวจนับ';
                      status = 'N';
                      dataLovStatusController.text = 'รอตรวจนับ';
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
                    if (noDate == false && chkDate == false) {
                      if (selectedDate.isNotEmpty &&
                          noDate != true &&
                          chkDate != true) {
                        RegExp dateRegExp = RegExp(r'^\d{2}/\d{2}/\d{4}$');
                        if (!dateRegExp.hasMatch(selectedDate)) {
                          setState(() {
                            chkDate = true;
                          });
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Ssfgdt12Card(
                                      docNo: pDocNo,
                                      date: selectedDate,
                                      status: status,
                                      pWareCode: widget.pWareCode,
                                      p_flag: p_flag,
                                      browser_language:
                                          globals.BROWSER_LANGUAGE,
                                      pErpOuCode: widget.pErpOuCode,
                                      p_attr1: widget.p_attr1,
                                    )),
                          ).then((value) async {
                            // เมื่อกลับมาหน้าเดิม เรียก fetchData
                            setState(() {
                              // pDocNo = '';
                              // selectedDate = '';
                              // selectedItem = 'รอตรวจนับ';
                              // status = 'N';
                              // _controller.clear();
                              // _dateController.clear();
                            });
                          });
                        }
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Ssfgdt12Card(
                                    docNo: pDocNo,
                                    date: selectedDate,
                                    status: status,
                                    pWareCode: widget.pWareCode,
                                    p_flag: p_flag,
                                    browser_language: globals.BROWSER_LANGUAGE,
                                    pErpOuCode: widget.pErpOuCode,
                                    p_attr1: widget.p_attr1,
                                  )),
                        ).then((value) async {
                          // เมื่อกลับมาหน้าเดิม เรียก fetchData
                          setState(() {
                            // pDocNo = '';
                            // selectedDate = '';
                            // selectedItem = 'รอตรวจนับ';
                            // status = 'N';
                            // _controller.clear();
                            // _dateController.clear();
                          });
                        });
                      }
                    }
                    // _navigateToPage(
                    //     context,
                    //     Ssfgdt12Card(
                    //       docNo: pDocNo,
                    //       date: selectedDate,
                    //       status: status,
                    //       pWareCode: widget.pWareCode,
                    //       p_flag: p_flag,
                    //       browser_language: globals.BROWSER_LANGUAGE,
                    //       pErpOuCode: widget.pErpOuCode,
                    //       p_attr1: widget.p_attr1,
                    //     )
                    //     //
                    //     );
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

  void showDialogSelectDataStatus() {
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
                height: 300, // ปรับความสูงของ Popup ตามต้องการ
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey, // สีของเส้น
                            width: 1.0, // ความหนาของเส้น
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'สถานะ',
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
                      child: ListView(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics:
                                const NeverScrollableScrollPhysics(), // เพื่อให้ทำงานร่วมกับ ListView ด้านนอกได้
                            itemCount: dropdownItems.length,
                            itemBuilder: (context, index) {
                              // ดึงข้อมูลรายการจาก dataCard
                              var item = dropdownItems[index];

                              // return GestureDetector(
                              //   onTap: () {
                              //     setState(() {
                              //       dataLocator = item['location_code'];
                              //     });
                              //   },
                              //   child: SizedBox(
                              //     child: Text('${item['location_code']}'),
                              //   ),
                              // );
                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey, // สีของขอบทั้ง 4 ด้าน
                                      width: 2.0, // ความหนาของขอบ
                                    ),
                                    borderRadius: BorderRadius.circular(
                                        10.0), // ทำให้ขอบมีความโค้ง
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                      vertical:
                                          8.0), // เพิ่ม padding ด้านซ้าย-ขวา และ ด้านบน-ล่าง
                                  child: Text(
                                    item['d'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  setState(() {
                                    selectedItem = item['d'];
                                    status = item['r'];
                                    dataLovStatusController.text = selectedItem;
                                    // -----------------------------------------
                                    print(
                                        'dataLovStatusController New: $dataLovStatusController Type : ${dataLovStatusController.runtimeType}');
                                    print(
                                        'selectedItem New: $selectedItem Type : ${selectedItem.runtimeType}');
                                    print(
                                        'status New: $status Type : ${status.runtimeType}');
                                  });
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    )

                    // ช่องค้นหา
                  ],
                ),
              );
            },
          ),
        );
      },
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
