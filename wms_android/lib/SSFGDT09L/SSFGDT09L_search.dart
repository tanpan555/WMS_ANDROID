import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:wms_android/styles.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/custom_appbar.dart';
import 'package:wms_android/Global_Parameter.dart' as globals;
import 'SSFGDT09L_card.dart';

class Ssfgdt09lSearch extends StatefulWidget {
  final String pWareCode;
  final String pWareName;
  final String pErpOuCode;
  final String pOuCode;
  final String pAttr1;
  Ssfgdt09lSearch({
    Key? key,
    required this.pWareCode,
    required this.pWareName,
    required this.pErpOuCode,
    required this.pOuCode,
    required this.pAttr1,
  }) : super(key: key);
  @override
  _Ssfgdt09lSearchState createState() => _Ssfgdt09lSearchState();
}

class _Ssfgdt09lSearchState extends State<Ssfgdt09lSearch> {
  int pFlag = 1;
  String pSoNo = '';
  String selectedItem = 'ระหว่างบันทึก';
  String statusDESC = 'ระหว่างบันทึก';
  String selectedDate = '';
  String appUser = globals.APP_USER;
  TextEditingController dateController = TextEditingController();
  final TextEditingController pSoNoController = TextEditingController();
  final String sDateFormat = "dd-MM-yyyy";
  final TextEditingController dataLovStatusController = TextEditingController();
  List<dynamic> dropdownItems = [
    {
      'd': 'ทั้งหมด',
      'r': 'ทั้งหมด',
    },
    {
      'd': 'ระหว่างบันทึก',
      'r': 'ระหว่างบันทึก',
    },
    {
      'd': 'ปกติ',
      'r': 'ปกติ',
    },
    {
      'd': 'ยืนยันการจ่าย',
      'r': 'ยืนยันการจ่าย',
    },
    {
      'd': 'อ้างอิงแล้ว',
      'r': 'อ้างอิงแล้ว',
    },
    {
      'd': 'ยกเลิก',
      'r': 'ยกเลิก',
    },
  ];
  bool chkDate = false;

  @override
  void initState() {
    setData();
    super.initState();
    print(
        'selectedItem in search page : $selectedItem Type : ${selectedItem.runtimeType}');
    print(
        'statusDESC in search page : $statusDESC Type : ${statusDESC.runtimeType}');
    print(
        'selectedDate in search page : $selectedDate Type : ${selectedDate.runtimeType}');
  }

  @override
  void dispose() {
    dateController.dispose();
    pSoNoController.dispose();
    dataLovStatusController.dispose();
    super.dispose();
  }

  void setData() {
    if (mounted) {
      setState(() {
        dataLovStatusController.text = 'ระหว่างบันทึก';
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
      String formattedDate = new DateFormat('dd/MM/yyyy').format(pickedDate);
      if (mounted) {
        setState(() {
          dateController.text = formattedDate;
          selectedDate = dateController.text;
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
      appBar: CustomAppBar(title: 'เบิกจ่าย'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              //////////////////////////////////////////////////////////////
              // TextFormField(
              //   readOnly: true,
              //   decoration: InputDecoration(
              //     border: InputBorder.none,
              //     filled: true,
              //     fillColor: Colors.grey[300],
              //     labelText: '${widget.pWareCode}  ${widget.pWareName}',
              //     labelStyle: const TextStyle(
              //       color: Colors.black87,
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 20),
              //////////////////////////////////////////////////////////////
              TextFormField(
                controller: dataLovStatusController,
                readOnly: true,
                onTap: () => showDialogSelectDataStatus(),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'ประเภทรายการ',
                  labelStyle: const TextStyle(
                    color: Colors.black87,
                  ),
                  suffixIcon: Icon(
                    Icons.arrow_drop_down,
                    color: Color.fromARGB(255, 113, 113, 113),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              //////////////////////////////////////////////////////////////
              TextFormField(
                controller: pSoNoController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'เลขที่เอกสาร',
                  labelStyle: const TextStyle(
                    color: Colors.black87,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    pSoNo = value;
                  });
                },
              ),
              //////////////////////////////////////////////////////////////
              const SizedBox(height: 8),
              TextFormField(
                controller: dateController,
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
                  labelText: 'วันที่เบิกจ่าย',
                  labelStyle: chkDate == false
                      ? const TextStyle(
                          color: Colors.black87,
                        )
                      : const TextStyle(
                          color: Colors.red,
                        ),
                  suffixIcon: IconButton(
                    icon:
                        const Icon(Icons.calendar_today), // ไอคอนที่อยู่ขวาสุด
                    onPressed: () async {
                      // กดไอคอนเพื่อเปิด date picker
                      _selectDate(context);
                    },
                  ),
                ),
                onChanged: (value) {
                  selectedDate = value;
                  print('selectedDate : $selectedDate');
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
                },
              ),
              chkDate == true
                  ? const Padding(
                      padding: EdgeInsets.only(top: 4.0),
                      child: Text(
                        'กรุณากรอกวันที่ให้ถูกต้องตามรูปแบบ DD/MM/YYYY',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 14, // ปรับขนาดตัวอักษรตามที่ต้องการ
                        ),
                      ))
                  : const SizedBox.shrink(),
              // TextFormField(
              //   controller: dateController,
              //   readOnly: true,
              //   onTap: () => _selectDate(context),
              //   decoration: InputDecoration(
              //     border: InputBorder.none,
              //     filled: true,
              //     fillColor: Colors.white,
              //     labelText: 'วันที่เบิกจ่าย',
              //     labelStyle: const TextStyle(
              //       color: Colors.black87,
              //     ),
              //     suffixIcon: Icon(
              //       Icons.calendar_today,
              //       color: Colors.black87,
              //     ),
              //   ),
              // ),
              const SizedBox(height: 20),
              //////////////////////////////////////////////////////////////
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
                  //       setState(() {
                  //         pSoNo = '';
                  //         selectedDate = '';
                  //         selectedItem = 'ทั้งหมด';
                  //         statusDESC = 'ทั้งหมด';
                  //         dateController.clear();
                  //         pSoNoController.clear();
                  //       });
                  //     },
                  //   ),
                  // ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        pSoNo = '';
                        selectedDate = '';
                        selectedItem = 'ทั้งหมด';
                        statusDESC = 'ทั้งหมด';
                        dataLovStatusController.text = 'ทั้งหมด';
                        dateController.clear();
                        pSoNoController.clear();

                        print('selectedItem : $selectedItem');
                        print('statusDESC : $statusDESC');
                        print(
                            'dataLovStatusController : $dataLovStatusController');
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
                  //////////////////////////////////////////////////////
                  ElevatedButton(
                    onPressed: () {
                      if (selectedDate.isNotEmpty) {
                        RegExp dateRegExp = RegExp(r'^\d{2}/\d{2}/\d{4}$');
                        if (!dateRegExp.hasMatch(selectedDate)) {
                          setState(() {
                            chkDate = true;
                          });
                        } else if (selectedDate != '') {
                          DateTime parsedDate =
                              DateFormat('dd/MM/yyyy').parse(selectedDate);
                          String formattedDate =
                              DateFormat('dd-MM-yyyy').format(parsedDate);

                          setState(() {
                            selectedDate = formattedDate;
                          });

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Ssfgdt09lCard(
                                    pErpOuCode: widget.pErpOuCode,
                                    pWareCode: widget.pWareCode,
                                    pOuCode: widget.pOuCode,
                                    pAttr1: widget.pAttr1,
                                    pAppUser: appUser,
                                    pFlag: pFlag,
                                    pStatusDESC: statusDESC,
                                    pSoNo: pSoNo == '' ? 'null' : pSoNo,
                                    pDocDate: formattedDate == ''
                                        ? 'null'
                                        : formattedDate)),
                          ).then((value) async {});
                        }
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Ssfgdt09lCard(
                                  pErpOuCode: widget.pErpOuCode,
                                  pWareCode: widget.pWareCode,
                                  pOuCode: widget.pOuCode,
                                  pAttr1: widget.pAttr1,
                                  pAppUser: appUser,
                                  pFlag: pFlag,
                                  pStatusDESC: statusDESC,
                                  pSoNo: pSoNo == '' ? 'null' : pSoNo,
                                  pDocDate: 'null')),
                        ).then((value) async {});
                      }
                    },
                    style: AppStyles.SearchButtonStyle(),
                    child: Image.asset(
                      'assets/images/search_color.png', // ใส่ภาพจากไฟล์ asset
                      width: 50, // กำหนดขนาดภาพ
                      height: 25,
                    ),
                  ),
                ],
              ),
            ],
          ),
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
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  setState(() {
                                    selectedItem = item['d'];
                                    statusDESC = item['r'];
                                    dataLovStatusController.text = selectedItem;
                                    // -----------------------------------------
                                    print(
                                        'dataLovStatusController New: $dataLovStatusController Type : ${dataLovStatusController.runtimeType}');
                                    print(
                                        'selectedItem New: $selectedItem Type : ${selectedItem.runtimeType}');
                                    print(
                                        'statusDESC New: $statusDESC Type : ${statusDESC.runtimeType}');
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
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text;

    // กรองเฉพาะตัวเลข
    text = text.replaceAll(RegExp(r'[^0-9]'), '');

    // จัดรูปแบบเป็น DD/MM/YYYY
    if (text.length > 2 && text.length <= 4) {
      text = text.substring(0, 2) + '/' + text.substring(2);
    } else if (text.length > 4 && text.length <= 8) {
      text = text.substring(0, 2) +
          '/' +
          text.substring(2, 4) +
          '/' +
          text.substring(4);
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
