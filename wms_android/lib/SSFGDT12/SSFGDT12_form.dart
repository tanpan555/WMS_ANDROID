import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
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
  List<dynamic> dataEMP = [];

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

  final ValueNotifier<bool> isDateInvalidNotifier = ValueNotifier<bool>(false);
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

  String displayNBCountStaff = '';
  String returnNBCountStaff = '';

  bool checkUpdateData = false;
  // ------------------------------------\\

  // final FocusNode _focusNode = FocusNode();
  final TextEditingController searchEMPController = TextEditingController();
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
    selectLovEMP();
    // _focusNode.addListener(() {
    //   if (!_focusNode.hasFocus) {
    //     selectNbCountStaff(
    //       nbCountStaff,
    //     );
    //   }
    // });
  }

  @override
  void dispose() {
    // _focusNode.dispose();
    searchEMPController.dispose();
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
    print(
        '${globals.IP_API}/apex/wms/SSFGDT12/SSFGDT12_Step_2_SelectDataForm/${globals.P_ERP_OU_CODE}/${widget.docNo}/${globals.BROWSER_LANGUAGE}/${globals.P_EMP_ID}');
    isLoading = true;
    try {
      final response = await http.get(Uri.parse(
          '${globals.IP_API}/apex/wms/SSFGDT12/SSFGDT12_Step_2_SelectDataForm/${globals.P_ERP_OU_CODE}/${widget.docNo}/${globals.BROWSER_LANGUAGE}/${globals.P_EMP_ID}'));

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
              displayNBCountStaff = item['nb_count_staff'] ?? '';
              returnNBCountStaff = item['nb_count_staff'] ?? '';
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
              nbCountStaffController.text = displayNBCountStaff;
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

  Future<void> selectLovEMP() async {
    try {
      final response = await http.get(Uri.parse(
          '${globals.IP_API}/apex/wms/SSFGDT12/SSFGDT12_Step_2_SelectLovEMP/${globals.P_ERP_OU_CODE}/${globals.BROWSER_LANGUAGE}'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $jsonDecode');
        if (mounted) {
          setState(() {
            dataEMP =
                List<Map<String, dynamic>>.from(responseData['items'] ?? []);
          });
        }
        print('dataEMP : $dataEMP');
      } else {
        throw Exception('dataEMP Failed to load fetchData');
      }
    } catch (e) {
      print('dataEMP ERROR IN Fetch Data : $e');
    }
  }

  // Future<void> selectNbCountStaff(String nbStaffCountName) async {
  //   try {
  //     final response = await http.get(Uri.parse(
  //         '${globals.IP_API}/apex/wms/SSFGDT12/SSFGDT12_Step_2_Select_nbCountStaffName/${globals.P_ERP_OU_CODE}/${widget.docNo}/$nbStaffCountName'));

  //     if (response.statusCode == 200) {
  //       final Map<String, dynamic> data =
  //           jsonDecode(utf8.decode(response.bodyBytes));
  //       final List<dynamic> items = data['items'];
  //       print(items);
  //       if (items.isNotEmpty) {
  //         final Map<String, dynamic> item = items[0];
  //         //

  //         //
  //         print('Fetched data: $jsonDecode');
  //         if (mounted) {
  //           setState(() {
  //             nbStaffCountName = item['nb_staff_count_name'] ?? '';

  //             nbStaffCountNameController.text = nbStaffCountName;
  //           });
  //         }
  //       } else {
  //         print('No items found.');
  //       }
  //     } else {
  //       print(
  //           '999999 Failed to load data. Status code: ${response.statusCode}');
  //       print(
  //           'nbStaffCountName : $nbStaffCountName type : ${nbStaffCountName.runtimeType}');
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //   }
  // }

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
                          if (isDateInvalidNotifier.value != true &&
                              nbCountDate.isNotEmpty) {
                            if (returnNBCountStaff.isNotEmpty) {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Ssfgdt12Grid(
                                    nbCountStaff: returnNBCountStaff,
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
                            } else {
                              setState(() {
                                isCardDisabled = false;
                              });
                              String meaaage = 'ต้องระบุผู้ทำการตรวจนับ * !!!';
                              showDialogAlert(context, meaaage);
                            }
                          } else {
                            setState(() {
                              isCardDisabled = false;
                              isDateInvalidNotifier.value = true;
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
                    CustomTextFormField(
                      controller: docDateController,
                      labelText: 'วันที่บันทึก',
                      keyboardType: TextInputType.number,
                      showAsterisk: true,
                      onChanged: (value) {
                        nbCountDate = value;
                        print('วันที่ที่กรอก: $docDate');
                        if (nbCountDate != nbCountDateForCheck) {
                          checkUpdateData = true;
                        }
                      },
                      isDateInvalidNotifier: isDateInvalidNotifier,
                    ),
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
                      readOnly: true,
                      onTap: () => showDialogDropdownSearchEMP(),
                      minLines: 1,
                      maxLines: 3,
                      // overflow: TextOverflow.ellipsis,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.white,
                        label: RichText(
                          text: const TextSpan(
                            text: 'ผู้ทำการตรวจนับ',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                            ),
                            children: [
                              TextSpan(
                                text: ' *',
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                        suffixIcon: const Icon(
                          Icons.arrow_drop_down,
                          color: Color.fromARGB(255, 113, 113, 113),
                        ),
                      ),
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
        return DialogStyles.alertMessageDialog(
          context: context,
          content: Text(messageAlert),
          onClose: () {
            Navigator.of(context).pop();
          },
          onConfirm: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  void showDialogDropdownSearchEMP() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return DialogStyles.customRequiredLovSearchDialog(
          context: context,
          headerText: 'ผู้ทำการตรวจนับ',
          searchController: searchEMPController,
          data: dataEMP,
          docString: (item) =>
              '${item['emp_id'] ?? ''} ${item['emp_name'] ?? '--No Value Set--'}',
          titleText: (item) => '${item['emp_id'] ?? '--No Value Set--'}',
          subtitleText: (item) {
            // final empNo = item['emp_name'] ?? '';
            // return empNo.isNotEmpty ? empNo : null;
            final empNo = item['emp_name']?.toString() ?? '';
            return empNo.isNotEmpty ? empNo : '';
          },
          onTap: (item) {
            isLoading = true;
            Navigator.of(context).pop();
            setState(() {
              returnNBCountStaff = '${item['emp_id'] ?? ''}';
              displayNBCountStaff = '${item['emp_id'] ?? '--No Value Set--'}';
              nbCountStaffController.text = displayNBCountStaff;
              nbStaffCountNameController.text = '${item['emp_name'] ?? ''}';
              nbStaffCountName = '${item['emp_name'] ?? ''}';
              isLoading = false;
              // -----------------------------------------
            });
          },
        );
      },
    );
  }
}
