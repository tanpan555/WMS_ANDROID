import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:wms_android/styles.dart';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/custom_appbar.dart';
import 'package:wms_android/Global_Parameter.dart' as globals;
import 'package:wms_android/TextFormFieldCheckDate.dart';
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
  TextEditingController dateController = TextEditingController();
  final TextEditingController controller = TextEditingController();
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
  final dateInputFormatter = DateInputFormatter();
  bool isDateInvalid = false;

  @override
  void initState() {
    setData();
    super.initState();
    print(
        'pWareCode in search page : ${widget.pWareCode} Type : ${widget.pWareCode.runtimeType}');
    print(
        'pWareName in search page : ${widget.pWareName} Type : ${widget.pWareName.runtimeType}');
  }

  Future<void> _selectDate(
    BuildContext context,
  ) async {
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
          isDateInvalid = false;
          dateController.text = formattedDate;
          selectedDate = dateController.text;
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
      appBar: CustomAppBar(title: 'ผลการตรวจนับ', showExitWarning: false),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: controller,
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
              controller: dateController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(8),
                dateInputFormatter,
              ],
              decoration: InputDecoration(
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.white,
                labelText: 'วันที่เบิกจ่าย',
                hintText: 'DD/MM/YYYY',
                hintStyle: const TextStyle(color: Colors.grey),
                labelStyle: isDateInvalid
                    ? const TextStyle(color: Colors.red)
                    : const TextStyle(color: Colors.black87),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () {
                    _selectDate(context);
                  },
                ),
              ),
              onChanged: (value) {
                setState(() {
                  selectedDate = value;
                  isDateInvalid = dateInputFormatter.noDateNotifier.value;
                });
                print('isDateInvalid : $isDateInvalid');
              },
            ),
            if (isDateInvalid == true)
              const Padding(
                padding: EdgeInsets.only(top: 4.0),
                child: Text(
                  'กรุณาระบุรูปแบบวันที่ให้ถูกต้อง เช่น 31/01/2024',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            // ------------------------------------------
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
                    controller.clear();
                    dateController.clear();
                    setState(() {
                      pDocNo = '';
                      selectedDate = '';
                      selectedItem = 'รอตรวจนับ';
                      status = 'N';
                      dataLovStatusController.text = 'รอตรวจนับ';
                      isDateInvalid = false;
                    });
                  },
                  style: AppStyles.EraserButtonStyle(),
                  child: Image.asset(
                    'assets/images/eraser_red.png',
                    width: 50,
                    height: 25,
                  ),
                ),
                const SizedBox(width: 20),

                /// //////////////////////////////////////////////////////
                ElevatedButton(
                  onPressed: () {
                    if (isDateInvalid == false) {
                      if (selectedDate.isNotEmpty) {
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
                            ),
                          ),
                        ).then((value) async {});
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
                            ),
                          ),
                        ).then((value) async {});
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
      bottomNavigationBar: BottomBar(
        currentPage: 'not_show',
      ),
    );
  }

  void showDialogSelectDataStatus() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return DialogStyles.customSelectLovDialog(
          context: context,
          headerText: 'สถานะ',
          data: dropdownItems,
          displayItem: (item) => '${item['d'] ?? ''}',
          onTap: (item) {
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
              print('status New: $status Type : ${status.runtimeType}');
            });
          },
        );
      },
    );
  }
}
