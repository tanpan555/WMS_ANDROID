import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:wms_android/styles.dart';
import 'package:wms_android/loading.dart';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/custom_appbar.dart';
import 'package:wms_android/TextFormFieldCheckDate.dart';
import 'package:wms_android/Global_Parameter.dart' as globals;
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

  final dateInputFormatter = DateInputFormatter();
  bool isDateInvalid = false;
  bool isLoading = false;
  bool isCardDisabled = false;

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
          '${globals.IP_API}/apex/wms/SSFGDT12/SSFGDT12_Step_2_SelectDataForm/${globals.P_ERP_OU_CODE}/${widget.docNo}/${globals.BROWSER_LANGUAGE}'));

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
          '${globals.IP_API}/apex/wms/SSFGDT12/SSFGDT12_Step_2_Select_nbCountStaffName/${globals.P_ERP_OU_CODE}/${widget.docNo}/$nbStaffCountName'));

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
      String formattedDate = new DateFormat('dd/MM/yyyy').format(pickedDate);
      if (mounted) {
        setState(() {
          nbCountDateController.text = formattedDate;
          nbCountDate = nbCountDateController.text;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  onPressed: isCardDisabled
                      ? null
                      : () async {
                          setState(() {
                            isCardDisabled = true;
                          });
                          if (isDateInvalid != true) {
                            await Navigator.push(
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
                            ).then((value) async {
                              setState(() {
                                isCardDisabled = false;
                              });
                            });
                          }
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
                        ? Center(child: LoadingIndicator())
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

                    const SizedBox(height: 8),
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

                    const SizedBox(height: 8),
                    //////////////////////////////////////////////////////////////////////////////////////
                    TextFormField(
                      controller: nbCountDateController,
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
                        labelText: 'วันที่ตรวจนับ',
                        hintText: 'DD/MM/YYYY',
                        hintStyle: TextStyle(color: Colors.grey),
                        labelStyle: isDateInvalid == true
                            ? const TextStyle(color: Colors.red)
                            : const TextStyle(color: Colors.black87),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () async {
                            _selectDate(context);
                          },
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          nbCountDate = value;
                          isDateInvalid =
                              dateInputFormatter.noDateNotifier.value;
                          print('nbCountDate : $nbCountDate');
                          if (nbCountDate != nbCountDateForCheck) {
                            checkUpdateData = true;
                          }
                        });
                      },
                    ),
                    isDateInvalid == true
                        ? const Padding(
                            padding: EdgeInsets.only(top: 4.0),
                            child: Text(
                              'กรุณาระบุรูปแบบวันที่ให้ถูกต้อง เช่น 31/01/2024',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ))
                        : const SizedBox.shrink(),
                    const SizedBox(height: 8),
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

                    const SizedBox(height: 8),
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

                    const SizedBox(height: 8),
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
                    const SizedBox(height: 8),
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

                    const SizedBox(height: 8),
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

                    const SizedBox(height: 8),
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

                    const SizedBox(height: 8),
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

                    const SizedBox(height: 8),
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

                    const SizedBox(height: 8),
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
                  const SizedBox(height: 8),
                  Text(
                    messageAlert,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 8),
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
