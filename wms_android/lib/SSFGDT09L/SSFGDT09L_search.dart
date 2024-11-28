import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:wms_android/styles.dart';
import 'package:wms_android/loading.dart';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/custom_appbar.dart';
import 'package:wms_android/Global_Parameter.dart' as globals;
import 'package:wms_android/TextFormFieldCheckDate.dart';
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
  final ValueNotifier<bool> isDateInvalidNotifier = ValueNotifier<bool>(false);

  bool isLoading = false;

  @override
  void initState() {
    setData();
    super.initState();
  }

  @override
  void dispose() {
    dateController.dispose();
    pSoNoController.dispose();
    dataLovStatusController.dispose();
    super.dispose();
  }

  void setData() {
    isLoading = true;
    if (mounted) {
      setState(() {
        dataLovStatusController.text = 'ระหว่างบันทึก';
        isLoading = false;
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
      appBar: CustomAppBar(title: 'เบิกจ่าย', showExitWarning: false),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: LoadingIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      controller: dataLovStatusController,
                      readOnly: true,
                      onTap: () => showDialogSelectDataStatus(),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'ประเภทรายการ',
                        labelStyle: TextStyle(
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
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'เลขที่เอกสาร',
                        labelStyle: TextStyle(
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
                    CustomTextFormField(
                      controller: dateController,
                      labelText: 'วันที่เบิกจ่าย',
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        selectedDate = value;
                        print('วันที่ที่กรอก: $selectedDate');
                      },
                      isDateInvalidNotifier: isDateInvalidNotifier,
                    ),
                    //////////////////////////////////////////////////////////////
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
                              isDateInvalidNotifier.value = false;
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
                        //////////////////////////////////////////////////////
                        ElevatedButton(
                          onPressed: () {
                            if (isDateInvalidNotifier.value == false) {
                              if (selectedDate.isNotEmpty) {
                                if (selectedDate != '') {
                                  String modifiedDate =
                                      selectedDate.replaceAll('-', '/');
                                  DateTime parsedDate = DateFormat('dd/MM/yyyy')
                                      .parse(modifiedDate);
                                  String formattedDate =
                                      DateFormat('dd-MM-yyyy')
                                          .format(parsedDate);

                                  setState(() {
                                    selectedDate = formattedDate;
                                  });
                                  String pSoNoRP = pSoNo.replaceAll(' ', '');
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
                                          pSoNo:
                                              pSoNoRP == '' ? 'null' : pSoNoRP,
                                          pDocDate: formattedDate == ''
                                              ? 'null'
                                              : formattedDate),
                                    ),
                                  ).then((value) async {
                                    if (pSoNoRP == '') {
                                      if (mounted) {
                                        setState(() {
                                          pSoNo = '';
                                          pSoNoController.text = '';
                                        });
                                      }
                                    }
                                  });
                                }
                              } else {
                                String pSoNoRP = pSoNo.replaceAll(' ', '');
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
                                        pSoNo: pSoNoRP == '' ? 'null' : pSoNoRP,
                                        pDocDate: 'null'),
                                  ),
                                ).then((value) async {
                                  if (pSoNoRP == '') {
                                    if (mounted) {
                                      setState(() {
                                        pSoNo = '';
                                        pSoNoController.text = '';
                                      });
                                    }
                                  }
                                });
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
          headerText: 'ประเภทรายการ',
          data: dropdownItems,
          displayItem: (item) => '${item['d'] ?? ''}',
          onTap: (item) {
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
    );
  }
}
