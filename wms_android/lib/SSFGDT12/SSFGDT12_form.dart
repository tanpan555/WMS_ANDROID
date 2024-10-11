import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:wms_android/styles.dart';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/custom_appbar.dart';
import 'SSFGDT12_grid.dart';

class Ssfgdt12Form extends StatefulWidget {
  final String docNo;
  final String pErpOuCode;
  final String browser_language;
  final String wareCode; // ware code ที่มาจาก API แต่เป็น null
  final String pWareCode; // ware code ที่มาจากเลือ lov
  final String p_attr1;
  // final String status;
  Ssfgdt12Form({
    Key? key,
    required this.docNo,
    required this.pErpOuCode,
    required this.browser_language,
    required this.wareCode,
    required this.pWareCode,
    required this.p_attr1,
    // required this.status,
  }) : super(key: key);
  @override
  _Ssfgdt12FormState createState() => _Ssfgdt12FormState();
}

class _Ssfgdt12FormState extends State<Ssfgdt12Form> {
  //
  List<dynamic> dataForm = [];

  String staffCode = '';
  String docDate = '';
  String nbStaffName = '';
  String nbStaffCountName = '';
  String countStaff = '';
  String nbCountStaff = '';
  String updBy = '';
  String updDate = '';
  String remark = '';
  String status = '';
  String updBy1 = '';
  String nbCountDate = '';
  String docNo = '';
  String statuForCHK = '';
  bool chkDate = false;
  bool dateColorCheck = false;
  bool monthColorCheck = false;
  bool noDate = false;

  bool isLoading = false;

  // ------------------------------------\\
  String staffCodeForCheck = '';
  String docDateForCheck = '';
  String nbStaffNameForCheck = '';
  String nbStaffCountNameForCheck = '';
  String countStaffForCheck = '';
  String nbCountStaffForCheck = '';
  String updByForCheck = '';
  String updDateForCheck = '';
  String remarkForCheck = '';
  String statusForCheck = '';
  String updBy1ForCheck = '';
  String nbCountDateForCheck = '';
  String docNoForCheck = '';
  String statuForCHKForCheck = '';

  bool checkUpdateData = false;
  // ------------------------------------\\

  final FocusNode _focusNode = FocusNode();
  final TextEditingController staffCodeController = TextEditingController();
  final TextEditingController docDateController = TextEditingController();
  final TextEditingController nbStaffNameController = TextEditingController();
  final TextEditingController nbStaffCountNameController =
      TextEditingController();
  final TextEditingController countStaffController = TextEditingController();
  final TextEditingController nbCountStaffController = TextEditingController();
  final TextEditingController updByController = TextEditingController();
  final TextEditingController updDateController = TextEditingController();
  final TextEditingController remarkController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  final TextEditingController updBy1Controller = TextEditingController();
  final TextEditingController nbCountDateController = TextEditingController();
  final TextEditingController docNoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        selectNbCountStaff(
          nbCountStaff,
        );
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    staffCodeController.dispose();
    docDateController.dispose();
    nbStaffNameController.dispose();
    nbStaffCountNameController.dispose();
    countStaffController.dispose();
    nbCountStaffController.dispose();
    updByController.dispose();
    updDateController.dispose();
    remarkController.dispose();
    statusController.dispose();
    updBy1Controller.dispose();
    nbCountDateController.dispose();
    docNoController.dispose();
    super.dispose();
  }

  Future<void> fetchData() async {
    isLoading = true;
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGDT12/SSFGDT12_Step_2_SelectDataForm/${widget.pErpOuCode}/${widget.docNo}/${widget.browser_language}'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> items = data['items'];
        print(items);
        if (items.isNotEmpty) {
          final Map<String, dynamic> item = items[0];
          //

          //
          print('Fetched data: $jsonDecode');
          if (mounted) {
            setState(() {
              staffCode = item['staff_code'] ?? '';
              docDate = item['doc_date'] ?? '';
              nbStaffName = item['nb_staff_name'] ?? '';
              nbStaffCountName = item['nb_staff_count_name'] ?? '';
              countStaff = item['count_staff'] ?? '';
              nbCountStaff = item['nb_count_staff'] ?? '';
              updBy = item['upd_by'] ?? '';
              updDate = item['upd_date'] ?? '';
              remark = item['remark'] ?? '';
              status = item['status'] ?? '';
              updBy1 = item['upd_by1'] ?? '';
              nbCountDate = item['nb_count_date'] ?? '';
              docNo = widget.docNo;
              statuForCHK = item['statusforchk'];

              staffCodeController.text = staffCode;
              docDateController.text = docDate;
              nbStaffNameController.text = nbStaffName;
              nbStaffCountNameController.text = nbStaffCountName;
              countStaffController.text = countStaff;
              nbCountStaffController.text = nbCountStaff;
              updByController.text = updBy;
              updDateController.text = updDate;
              remarkController.text = remark;
              statusController.text = status;
              updBy1Controller.text = updBy1;
              nbCountDateController.text = nbCountDate;
              docNoController.text = docNo;

              isLoading = false;

              print('statuForCHK : $statuForCHK');
            });
          }
        } else {
          print('No items found.');
        }
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> selectNbCountStaff(String nbStaffCountName) async {
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGDT12/SSFGDT12_Step_2_Select_nbCountStaffName/${widget.pErpOuCode}/${widget.docNo}/$nbStaffCountName'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> items = data['items'];
        print(items);
        if (items.isNotEmpty) {
          final Map<String, dynamic> item = items[0];
          //

          //
          print('Fetched data: $jsonDecode');
          if (mounted) {
            setState(() {
              nbStaffCountName = item['nb_staff_count_name'] ?? '';

              nbStaffCountNameController.text = nbStaffCountName;
            });
          }
        } else {
          print('No items found.');
        }
      } else {
        print(
            '999999 Failed to load data. Status code: ${response.statusCode}');
        print(
            'nbStaffCountName : $nbStaffCountName type : ${nbStaffCountName.runtimeType}');
      }
    } catch (e) {
      print('Error: $e');
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
      // Format the date as dd/MM/yyyy
      String formattedDate = new DateFormat('dd/MM/yyyy').format(pickedDate);
      if (mounted) {
        setState(() {
          noDate = false;
          chkDate = false;
          nbCountDateController.text = formattedDate;
          nbCountDate = nbCountDateController.text;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF17153B),
      appBar: CustomAppBar(
        title: 'ผลการตรวจนับ',
        showExitWarning: checkUpdateData,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // if (nbCountDate.isNotEmpty) {
                    setState(() {
                      if (noDate != true && chkDate != true) {
                        RegExp dateRegExp = RegExp(r'^\d{2}/\d{2}/\d{4}$');
                        // String messageAlertValueDate =
                        //     'กรุณากรองวันที่ให้ถูกต้อง';
                        if (!dateRegExp.hasMatch(nbCountDate)) {
                          setState(() {
                            chkDate = true;
                          });
                          // showDialogAlert(context, messageAlertValueDate);
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Ssfgdt12Grid(
                                nbCountStaff: nbCountStaff,
                                nbCountDate: nbCountDate,
                                docNo: docNo,
                                status: status,
                                wareCode: widget.wareCode,
                                pErpOuCode: widget.pErpOuCode,
                                pWareCode: widget.pWareCode,
                                docDate: docDate,
                                countStaff: countStaff,
                                p_attr1: widget.p_attr1,
                                statuForCHK: statuForCHK,
                              ),
                            ),
                          );
                        }
                      }
                    });
                    // }
                  },
                  style: AppStyles.NextButtonStyle(),
                  child: Image.asset(
                    'assets/images/right.png', // ใส่ภาพจากไฟล์ asset
                    width: 25, // กำหนดขนาดภาพ
                    height: 25,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    isLoading
                        ? Center(child: CircularProgressIndicator())
                        : GestureDetector(
                            child: AbsorbPointer(
                              child: TextFormField(
                                style: const TextStyle(
                                  color: Colors.black87,
                                ),
                                controller: docNoController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  filled: true,
                                  fillColor: Colors.grey[300],
                                  labelText: 'เลขที่เอกสาร',
                                  labelStyle: const TextStyle(
                                    color: Colors.black87,
                                  ),
                                ),
                                readOnly: true,
                              ),
                            ),
                          ),

                    const SizedBox(height: 10),
                    //////////////////////////////////////////////////////////////////////////////////////
                    GestureDetector(
                      child: AbsorbPointer(
                        child: TextFormField(
                          style: const TextStyle(
                            color: Colors.black87,
                          ),
                          controller: docDateController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            filled: true,
                            fillColor: Colors.grey[300],
                            labelText: 'วันที่เตรียมการตรวจนับ',
                            labelStyle: const TextStyle(
                              color: Colors.black87,
                            ),
                          ),
                          readOnly: true,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),
                    //////////////////////////////////////////////////////////////////////////////////////
                    TextFormField(
                      controller: nbCountDateController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter
                            .digitsOnly, // ยอมรับเฉพาะตัวเลข
                        LengthLimitingTextInputFormatter(
                            8), // จำกัดจำนวนตัวอักษรไม่เกิน 10 ตัว
                        DateInputFormatter(), // กำหนดรูปแบบ __/__/____
                      ],
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'วันที่ตรวจนับ',
                        hintText: 'DD/MM/YYYY',
                        hintStyle: TextStyle(color: Colors.grey),
                        labelStyle: chkDate == false && noDate == false
                            ? const TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                              )
                            : const TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                              ),
                        suffixIcon: IconButton(
                          icon:
                              Icon(Icons.calendar_today), // ไอคอนที่อยู่ขวาสุด
                          onPressed: () async {
                            // กดไอคอนเพื่อเปิด date picker
                            _selectDate(context);
                          },
                        ),
                      ),
                      onChanged: (value) {
                        nbCountDate = value;
                        print('nbCountDate : $nbCountDate');
                        if (nbCountDate != nbCountDateForCheck) {
                          checkUpdateData = true;
                        }
                        setState(() {
                          // สร้าง instance ของ DateInputFormatter
                          DateInputFormatter formatter = DateInputFormatter();

                          // ตรวจสอบการเปลี่ยนแปลงของข้อความ
                          TextEditingValue oldValue = TextEditingValue(
                              text: nbCountDateController.text);
                          TextEditingValue newValue =
                              TextEditingValue(text: value);

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
                          if (!dateRegExp.hasMatch(nbCountDate)) {
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
                    const SizedBox(height: 10),
                    //////////////////////////////////////////////////////////////////////////////////////
                    GestureDetector(
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: staffCodeController,
                          readOnly: true,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            filled: true,
                            fillColor: Colors.grey[300],
                            labelText: 'ผู้เตรียมข้อมูลตรวจนับ',
                            labelStyle: const TextStyle(
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),
                    //////////////////////////////////////////////////////////////////////////////////////
                    GestureDetector(
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: nbStaffNameController,
                          readOnly: true,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            filled: true,
                            fillColor: Colors.grey[300],
                            labelText: '',
                            labelStyle: const TextStyle(
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),
                    //////////////////////////////////////////////////////////////////////////////////////
                    TextFormField(
                      controller: nbCountStaffController,
                      focusNode: _focusNode,
                      // readOnly: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'ผู้ทำการตรวจนับ',
                        labelStyle: const TextStyle(
                          color: Colors.black87,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          nbCountStaff = value;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    //////////////////////////////////////////////////////////////////////////////////////
                    GestureDetector(
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: nbStaffCountNameController,
                          readOnly: true,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            filled: true,
                            fillColor: Colors.grey[300],
                            labelText: '',
                            labelStyle: const TextStyle(
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),
                    //////////////////////////////////////////////////////////////////////////////////////
                    GestureDetector(
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: remarkController,
                          readOnly: true,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            filled: true,
                            fillColor: Colors.grey[300],
                            labelText: 'คำอธิบาย',
                            labelStyle: const TextStyle(
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),
                    //////////////////////////////////////////////////////////////////////////////////////
                    GestureDetector(
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: statusController,
                          readOnly: true,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            filled: true,
                            fillColor: Colors.grey[300],
                            labelText: 'สถานะเอกสาร',
                            labelStyle: const TextStyle(
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),
                    //////////////////////////////////////////////////////////////////////////////////////
                    GestureDetector(
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: updBy1Controller,
                          readOnly: true,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            filled: true,
                            fillColor: Colors.grey[300],
                            labelText: 'ผู้ปรับปรุงล่าสุด',
                            labelStyle: const TextStyle(
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),
                    //////////////////////////////////////////////////////////////////////////////////////
                    GestureDetector(
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: updDateController,
                          readOnly: true,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            filled: true,
                            fillColor: Colors.grey[300],
                            labelText: 'วันที่ปรับปรุงล่าสุด',
                            labelStyle: const TextStyle(
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),
                    //////////////////////////////////////////////////////////////////////////////////////
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(
        currentPage: checkUpdateData == true ? 'show' : 'not_show',
      ),
    );
  }

  void showDialogAlert(
    BuildContext context,
    String messageAlert,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.notification_important,
                    color: Colors.red,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'แจ้งเตือน',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(children: [
                  const SizedBox(height: 10),
                  Text(
                    messageAlert,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: Colors.grey),
                        ),
                        child: const Text('ตกลง'),
                      ),
                    ],
                  )
                ])),
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
      noDate = true;
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
