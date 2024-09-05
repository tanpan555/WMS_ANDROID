import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:intl/intl.dart';
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
  final List<String> dropdownItems = [
    'ทั้งหมด',
    'ระหว่างบันทึก',
    'ปกติ',
    'ยืนยันการจ่าย',
    'อ้างอิงแล้ว',
    'ยกเลิก',
  ]; // รายการใน dropdown

  @override
  void initState() {
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
    super.dispose();
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
      setState(() {
        dateController.text = formattedDate;
        selectedDate = dateController.text;
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
      appBar: CustomAppBar(title: 'เบิกจ่าย'),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
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
              DropdownButtonFormField<String>(
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
                  labelText: 'ประเภทรายการ',
                  labelStyle: const TextStyle(
                    color: Colors.black87,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    selectedItem = value ?? '';
                    switch (selectedItem) {
                      case 'ทั้งหมด':
                        statusDESC = 'ทั้งหมด';
                        break;
                      case 'ระหว่างบันทึก':
                        statusDESC = 'ระหว่างบันทึก';
                        break;
                      case 'ปกติ':
                        statusDESC = 'ปกติ';
                        break;
                      case 'ยืนยันการจ่าย':
                        statusDESC = 'ยืนยันการจ่าย';
                        break;
                      case 'อ้างอิงแล้ว':
                        statusDESC = 'อ้างอิงแล้ว';
                        break;
                      case 'ยกเลิก':
                        statusDESC = 'ยกเลิก';
                        break;
                      default:
                        statusDESC = 'Unknown';
                    }
                  });
                },
              ),
              const SizedBox(height: 20),
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
              const SizedBox(height: 20),
              TextFormField(
                controller: dateController,
                readOnly: true,
                onTap: () => _selectDate(context),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'วันที่เบิกจ่าย',
                  labelStyle: const TextStyle(
                    color: Colors.black87,
                  ),
                  suffixIcon: Icon(
                    Icons.calendar_today,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              //////////////////////////////////////////////////////////////
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: IconButton(
                      iconSize: 20.0,
                      icon: Image.asset(
                        'assets/images/eraser_red.png',
                        width: 20.0,
                        height: 20.0,
                      ),
                      onPressed: () {
                        setState(() {
                          pSoNo = '';
                          selectedDate = '';
                          selectedItem = 'ระหว่างบันทึก';
                          statusDESC = 'ระหว่างบันทึก';
                          dateController.clear();
                          pSoNoController.clear();
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 20),
                  //////////////////////////////////////////////////////
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: IconButton(
                      iconSize: 20.0,
                      icon: Image.asset(
                        'assets/images/search_color.png',
                        width: 20.0,
                        height: 20.0,
                      ),
                      onPressed: selectedItem.isNotEmpty
                          ? () {
                              if (selectedDate != '') {
                                DateTime parsedDate = DateFormat('dd/MM/yyyy')
                                    .parse(selectedDate);
                                String formattedDate =
                                    DateFormat('dd-MM-yyyy').format(parsedDate);

                                setState(() {
                                  selectedDate = formattedDate;
                                });

                                _navigateToPage(
                                  context,
                                  Ssfgdt09lCard(
                                      pErpOuCode: widget.pErpOuCode,
                                      pOuCode: widget.pOuCode,
                                      pAttr1: widget.pAttr1,
                                      pAppUser: appUser,
                                      pFlag: pFlag,
                                      pStatusDESC: statusDESC,
                                      pSoNo: pSoNo == '' ? 'null' : pSoNo,
                                      pDocDate: formattedDate == ''
                                          ? 'null'
                                          : formattedDate),
                                );
                              } else {
                                _navigateToPage(
                                    context,
                                    Ssfgdt09lCard(
                                        pErpOuCode: widget.pErpOuCode,
                                        pOuCode: widget.pOuCode,
                                        pAttr1: widget.pAttr1,
                                        pAppUser: appUser,
                                        pFlag: pFlag,
                                        pStatusDESC: statusDESC,
                                        pSoNo: pSoNo == '' ? 'null' : pSoNo,
                                        pDocDate: 'null'));
                              }
                            }
                          : null,
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
}
