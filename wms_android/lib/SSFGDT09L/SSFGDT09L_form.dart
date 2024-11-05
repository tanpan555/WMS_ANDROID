import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:wms_android/Global_Parameter.dart' as globals;
import 'package:wms_android/loading.dart';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/custom_appbar.dart';
import 'SSFGDT09L_grid.dart';
import 'package:wms_android/styles.dart';

class Ssfgdt09lForm extends StatefulWidget {
  final String pWareCode; // ware code ที่มาจากเลือ lov
  final String pAttr1;
  final String pDocNo;
  final String pDocType;
  final String pOuCode;
  final String pErpOuCode;
  Ssfgdt09lForm({
    Key? key,
    required this.pWareCode,
    required this.pAttr1,
    required this.pDocNo,
    required this.pDocType,
    required this.pOuCode,
    required this.pErpOuCode,
  }) : super(key: key);
  @override
  _Ssfgdt09lFormState createState() => _Ssfgdt09lFormState();
}

class _Ssfgdt09lFormState extends State<Ssfgdt09lForm> {
  List<dynamic> dataForm = [];
  List<dynamic> dataLovDocType = [];
  List<dynamic> dataLovMoDoNo = [];
  List<dynamic> dataLovRefNo = [];
  List<dynamic> dataLovCancel = [];
  String? selectLovDocType;
  String returnStatusLovDocType = '';
  // -----------------------------
  String? selectLovMoDoNo;
  String returnStatusLovMoDoNo = '';
  // -----------------------------
  String? selectLovRefNo;
  String returnStatusLovRefNo = '';
  // -----------------------------
  String? selectLovCancel;
  String returnStatusLovCancel = '';
  // -----------------------------
  String custName = ''; // cust_code + cust_name
  String ouCode = '';
  String docNo = '';
  String docType = '';
  String crDate = '';
  String refNo = '';
  String moDoNo = '';
  String staffCode = '';
  String note = '';
  String erpDocNo = '';
  String updBy = '';
  String updDate = '';
  String updProgID = '';
  String docDate = '';
  int testChk = 0; //

  //---------------------------------------\\
  String custNameForCheck = ''; // cust_code + cust_name
  String ouCodeForCheck = '';
  String docNoForCheck = '';
  String docTypeForCheck = '';
  String crDateForCheck = '';
  String refNoForCheck = '';
  String moDoNoForCheck = '';
  String staffCodeForCheck = '';
  String noteForCheck = '';
  String erpDocNoForCheck = '';
  String updByForCheck = '';
  String updDateForCheck = '';
  String updProgIDForCheck = '';
  String docDateForCheck = '';

  String returnStatusLovDocTypeForCheck = '';
  String returnStatusLovMoDoNoForCheck = '';
  String returnStatusLovRefNoForCheck = '';
  String returnStatusLovCancelForCheck = '';
  //---------------------------------------\\

  String soNoForChk = ''; // ref_no สำหรับ check
  String shidForChk = ''; // mo_do_no สำหรับ check
  String pMessageErr = ''; // message หลังจาก check    so_no == shid

  String statusSubmit = '';
  String messageSubmit = '';

  String deleteStatus = '';
  String deleteMessage = '';

  bool chkDate = false;
  bool dateColorCheck = false;
  bool monthColorCheck = false;
  bool noDate = false;

  bool isLoading = false;
  bool isFirstLoad = true;

  bool checkUpdateData = false;

  TextEditingController custNameController = TextEditingController();
  TextEditingController ouCodeController = TextEditingController();
  TextEditingController docNoController = TextEditingController();
  TextEditingController docTypeController = TextEditingController();
  TextEditingController crDateController = TextEditingController();
  TextEditingController refNoController = TextEditingController();
  TextEditingController moDoNoController = TextEditingController();
  TextEditingController staffCodeController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController erpDocNoController = TextEditingController();
  TextEditingController updByController = TextEditingController();
  TextEditingController updDateController = TextEditingController();
  TextEditingController updProgIDController = TextEditingController();
  TextEditingController docDateController = TextEditingController();

  TextEditingController _searchController1 = TextEditingController();
  TextEditingController _searchController2 = TextEditingController();
  TextEditingController _searchController3 = TextEditingController();
  TextEditingController _searchController4 = TextEditingController();
  TextEditingController cancelController = TextEditingController();

  @override
  void initState() {
    firstLoadData();
    super.initState();
  }

  @override
  void dispose() {
    _searchController1.dispose();
    _searchController2.dispose();
    _searchController3.dispose();
    _searchController4.dispose();
    custNameController.dispose();
    ouCodeController.dispose();
    docNoController.dispose();
    docTypeController.dispose();
    crDateController.dispose();
    refNoController.dispose();
    moDoNoController.dispose();
    staffCodeController.dispose();
    noteController.dispose();
    erpDocNoController.dispose();
    updByController.dispose();
    updDateController.dispose();
    updProgIDController.dispose();
    docDateController.dispose();
    super.dispose();
  }

  void firstLoadData() async {
    await fetchData();
    await lovDocType();
    await lovMoDoNo();
    await lovRefNo();
    await lovCancel();
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  Future<void> fetchData() async {
    if (isFirstLoad == true) {
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }
    }
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGDT09L/SSFGDT09L_Step_2_SelectDataForm/${widget.pErpOuCode}/${widget.pDocType}/${widget.pDocNo}/${widget.pAttr1}'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> items = data['items'];
        print(items);
        if (items.isNotEmpty) {
          final Map<String, dynamic> item = items[0];
          print('Fetched data: $jsonDecode');
          print('data $data');
          if (mounted) {
            setState(() {
              // -----------------------------
              ouCode = item['ou_code'] ?? '';
              ouCodeForCheck = item['ou_code'] ?? '';
              // -----------------------------
              docNo = item['doc_no'] ?? '';
              docNoForCheck = item['doc_no'] ?? '';
              // -----------------------------
              // docType = item['doc_type'] ?? '';
              // -----------------------------
              crDate = item['cr_date'] ?? '';
              crDateForCheck = item['cr_date'] ?? '';
              // -----------------------------
              staffCode = item['staff_code"'] ?? '';
              staffCodeForCheck = item['staff_code"'] ?? '';
              // -----------------------------
              note = item['note'] ?? '';
              noteForCheck = item['note'] ?? '';
              // -----------------------------
              erpDocNo = item['erp_doc_no'] ?? '';
              erpDocNoForCheck = item['erp_doc_no'] ?? '';
              // -----------------------------
              updBy = item['upd_by'] ?? '';
              updByForCheck = item['upd_by'] ?? '';
              // -----------------------------
              updDate = item['upd_date'] ?? '';
              updDateForCheck = item['upd_date'] ?? '';
              // -----------------------------
              updProgID = item['upd_prog_id'] ?? '';
              updProgIDForCheck = item['upd_prog_id'] ?? '';
              // -----------------------------
              docDate = item['doc_date'] ?? '';
              docDateForCheck = item['doc_date'] ?? '';
              // -----------------------------
              selectLovDocType = item['doc_type_d'] ?? '';
              returnStatusLovDocType = item['doc_type_r'] ?? '';
              returnStatusLovDocTypeForCheck = item['doc_type_r'] ?? '';
              // -----------------------------
              selectLovRefNo = item['ref_no'] ?? '';
              returnStatusLovRefNo = item['ref_no'] ?? '';
              returnStatusLovRefNoForCheck = item['ref_no'] ?? '';
              // -----------------------------
              selectLovMoDoNo = item['mo_do_no'] ?? '';
              returnStatusLovMoDoNo = item['mo_do_no'].toString();
              returnStatusLovMoDoNoForCheck = item['mo_do_no'].toString();
              // -----------------------------
              ouCodeController.text = ouCode;
              docNoController.text = docNo;
              crDateController.text = crDate;
              // refNoController.text = refNo;
              // moDoNoController.text = refNo;
              staffCodeController.text = staffCode;
              noteController.text = note;
              erpDocNoController.text = erpDocNo;
              updByController.text = updBy;
              updDateController.text = updDate;
              updProgIDController.text = updProgID;
              docDateController.text = docDate;

              docTypeController.text = selectLovDocType.toString();
              moDoNoController.text = selectLovMoDoNo.toString();
              refNoController.text = selectLovRefNo.toString();
            });
          }
        } else {
          print('No items found.');
        }
      } else {
        print(
            'fetchData     Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('1');
      print('Error: $e');
    }
  }

  Future<void> lovDocType() async {
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGDT09L/SSFGDT09L_Step_2_SelectLovDocTypeFormPage/${widget.pAttr1}'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $jsonDecode');
        if (mounted) {
          setState(() {
            dataLovDocType =
                List<Map<String, dynamic>>.from(responseData['items'] ?? []);
          });
        }
        print('dataLovDocType : $dataLovDocType');
      } else {
        throw Exception('dataLovDocType Failed to load fetchData');
      }
    } catch (e) {
      if (mounted) {
        setState(() {});
      }
      print('dataLovDocType ERROR IN Fetch Data : $e');
    }
  }

  Future<void> lovMoDoNo() async {
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGDT09L/SSFGDT09L_Step_2_SelectLovMoDoNo'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $jsonDecode');
        if (mounted) {
          setState(() {
            dataLovMoDoNo =
                List<Map<String, dynamic>>.from(responseData['items'] ?? []);
          });
        }
        print('dataLovMoDoNo : $dataLovMoDoNo');
      } else {
        throw Exception('dataLovMoDoNo Failed to load fetchData');
      }
    } catch (e) {
      if (mounted) {
        setState(() {});
      }
      print('dataLovMoDoNo ERROR IN Fetch Data : $e');
    }
  }

  Future<void> lovRefNo() async {
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGDT09L/SSFGDT09L_Step_2_SelectLovRefNo'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $jsonDecode');
        if (mounted) {
          setState(() {
            dataLovRefNo =
                List<Map<String, dynamic>>.from(responseData['items'] ?? []);
          });
        }
        print('dataLovRefNo : $dataLovRefNo');
      } else {
        throw Exception('dataLovRefNo Failed to load fetchData');
      }
    } catch (e) {
      if (mounted) {
        setState(() {});
      }
      print('dataLovRefNo ERROR IN Fetch Data : $e');
    }
  }

  Future<void> lovCancel() async {
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGDT09L/SSFGDT09L_Step_2_SelectLovCancel'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $jsonDecode');
        if (mounted) {
          setState(() {
            dataLovCancel =
                List<Map<String, dynamic>>.from(responseData['items'] ?? []);

            if (isFirstLoad == true) {
              isFirstLoad = false;
              isLoading = false;
            }
          });
        }
        print('dataLovCancel : $dataLovCancel');
      } else {
        throw Exception('dataLovCancel Failed to load fetchData');
      }
    } catch (e) {
      if (mounted) {
        setState(() {});
      }
      print('dataLovCancel ERROR IN Fetch Data : $e');
    }
  }

  Future<void> selectCust(String pMoDoNo) async {
    print('pMoDoNo in selectCust   : $pMoDoNo type : ${pMoDoNo.runtimeType}');
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGDT09L/SSFGDT09L_Step_2_SelectCust/$pMoDoNo'));

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
              custName = item['cust'] ?? '';

              custNameController.text = custName;
            });
          }
        } else {
          print('No items found.');
        }
      } else {
        print(
            'pMoDoNo in selectCust   else: $pMoDoNo type : ${pMoDoNo.runtimeType}');
        print(
            'selectCust   Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('2');
      print('Error: $e');
    }
  }

  Future<void> chkCust(String custCode, String arCode, int testChk) async {
    // cutuCode ---------------- mo do no
    // acCode ---------------------- ref no
    print('custCode  in chkCust  : $custCode');
    print('arCode  in chkCust  : $arCode');
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGDT09L/SSFGDT09L_Step_2_ChkCust/$arCode/${custCode}'));
      if (response.statusCode == 200) {
        // ถอดรหัสข้อมูล JSON จาก response
        final Map<String, dynamic> dataMessage = jsonDecode(utf8
            .decode(response.bodyBytes)); // ถอดรหัส response body เป็น UTF-8
        print('dataMessage : $dataMessage type : ${dataMessage.runtimeType}');
        if (mounted) {
          setState(() {
            pMessageErr = dataMessage['p_message_err'];
            print(
                'pMessageErr :: $pMessageErr  type :: ${pMessageErr.runtimeType}');
            if (pMessageErr.isNotEmpty) {
              showDialogErrorCHK(context, pMessageErr);
            }
            if (testChk == 1) {
              saveDataFoem();
            }
          });
        }
      } else {
        // จัดการกรณีที่ response status code ไม่ใช่ 200
        print('รหัสสถานะ: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> changeRefNo(String soNoForChk) async {
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGDT09L/SSFGDT09L_Step_2_ChangeRefNo/$soNoForChk'));

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
              custName = item['ar_code_name'] ?? '';

              custNameController.text = custName;
            });
          }
        } else {
          print('No items found.');
        }
      } else {
        print(
            'selectCust   Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('2');
      print('Error: $e');
    }
  }

  Future<void> saveDataFoem() async {
    final url =
        'http://172.16.0.82:8888/apex/wms/SSFGDT09L/SSFGDT09L_Step_2_SaveDataForm';

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'p_ou_code': widget.pErpOuCode, // 000
      'p_doc_no': widget.pDocNo,
      'p_doc_type': widget.pDocType,
      'p_ref_no': returnStatusLovRefNo,
      'p_mo_do_no': returnStatusLovMoDoNo,
      'p_note': note,
      'p_app_user': globals.APP_USER,
      'p_cr_date': crDate,
    });
    print('Request body: $body');
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> dataSaveForm = jsonDecode(utf8
            .decode(response.bodyBytes)); // ถอดรหัส response body เป็น UTF-8
        print(
            'dataSaveForm : $dataSaveForm type : ${dataSaveForm.runtimeType}');
        if (mounted) {
          setState(() {
            submitData();
          });
        }
      } else {
        // จัดการกรณีที่ response status code ไม่ใช่ 200
        print(
            'โพสต์ข้อมูลล้มเหลว(save data form). รหัสสถานะ: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in SaveDataForm: $e');
    }
  }

  Future<void> submitData() async {
    final url =
        'http://172.16.0.82:8888/apex/wms/SSFGDT09L/SSFGDT09L_Step_2_UpdateForm';

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'pOuCode': widget.pOuCode,
      'pErpOuCode': widget.pErpOuCode,
      'pDocNo': docNo,
      'pAppUser': globals.APP_USER,
    });
    print('Request body: $body');
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        // ถอดรหัสข้อมูล JSON จาก response
        final Map<String, dynamic> dataSubmit = jsonDecode(utf8
            .decode(response.bodyBytes)); // ถอดรหัส response body เป็น UTF-8
        print('dataSubmit : $dataSubmit type : ${dataSubmit.runtimeType}');
        if (mounted) {
          setState(() {
            statusSubmit = dataSubmit['po_status'];
            messageSubmit = dataSubmit['po_message'];

            if (statusSubmit == '1') {
              showDialogErrorCHK(context, messageSubmit);
            }
            if (statusSubmit == '0') {
              checkUpdateData = false;
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Ssfgdt09lGrid(
                          pWareCode: widget.pWareCode,
                          pAttr1: widget.pAttr1,
                          docNo: widget.pDocNo,
                          docType: widget.pDocType,
                          docDate: docDate,
                          pErpOuCode: widget.pErpOuCode,
                          pOuCode: widget.pOuCode,
                          pAppUser: globals.APP_USER,
                          moDoNo: returnStatusLovMoDoNo,
                          // test
                          statusCase: 'test1',
                        )),
              ).then((value) async {
                // Navigator.of(context).pop();
                await fetchData();
                await lovDocType();
                await lovMoDoNo();
                await lovRefNo();
                await lovCancel();
                checkUpdateData = false;
              });
            }

            print(
                'statusSubmit in Function submitData : $statusSubmit type : ${statusSubmit.runtimeType}');
            print(
                'messageSubmit in Function submitData : $messageSubmit type : ${messageSubmit.runtimeType}');
          });
        }
      } else {
        // จัดการกรณีที่ response status code ไม่ใช่ 200
        print('โพสต์ข้อมูลล้มเหลว. รหัสสถานะ: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in submit Data: $e');
    }
  }

  Future<void> deleteForm(String cancelCode) async {
    print('cancelCode : $cancelCode');
    final url =
        'http://172.16.0.82:8888/apex/wms/SSFGDT09L/SSFGDT09L_Step_2_DeleteForm';

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'p_ou_code': globals.P_OU_CODE,
      'p_erp_ou_code': globals.P_ERP_OU_CODE,
      'p_doc_type': widget.pDocType,
      'p_doc_no': widget.pDocNo,
      'p_cancel_code': cancelCode,
      'p_app_user': globals.APP_USER,
    });
    print('Request body: $body');

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        // ถอดรหัสข้อมูล JSON จาก response
        final Map<String, dynamic> dataDelete = jsonDecode(utf8
            .decode(response.bodyBytes)); // ถอดรหัส response body เป็น UTF-8
        print('dataDelete : $dataDelete type : ${dataDelete.runtimeType}');
        if (mounted) {
          setState(() {
            deleteStatus = dataDelete['po_status'];
            deleteMessage = dataDelete['po_message'];

            if (deleteStatus == '1') {
              showDialogErrorCHK(context, deleteMessage);
            }
            if (deleteStatus == '0') {
              if (mounted) {
                setState(() async {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  // Navigator.of(context).pushAndRemoveUntil(
                  //   MaterialPageRoute(
                  //       builder: (context) => SSFGDT09L_MAIN(
                  //           pOuCode: globals.P_OU_CODE,
                  //           pErpOuCode: globals.P_ERP_OU_CODE,
                  //           pAttr1: globals.ATTR1)),
                  //   (Route<dynamic> route) => false,
                  // );

                  // _navigateToPage(
                  //     context,
                  //     SSFGDT09L_MAIN(
                  //       pOuCode: globals.P_OU_CODE,
                  //       pErpOuCode: globals.P_ERP_OU_CODE,
                  //       pAttr1: globals.ATTR1,
                  //     ));
                });
              }
            }
          });
        }
      } else {
        // จัดการกรณีที่ response status code ไม่ใช่ 200
        print('ลบข้อมูลล้มเหลว. รหัสสถานะ: ${response.statusCode}');
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
          noDate = false;
          chkDate = false;
          crDateController.text = formattedDate;
          crDate = crDateController.text;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'เบิกจ่าย',
        showExitWarning: checkUpdateData,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            isLoading
                ? const SizedBox.shrink()
                // : dataForm.isEmpty
                //     ? const SizedBox.shrink()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          showDialogLovCancel();
                        },
                        style: AppStyles.NextButtonStyle(),
                        child: Text('ยกเลิก',
                            style: AppStyles.CancelbuttonTextStyle()),
                      ),

                      // const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            if (noDate != true && chkDate != true) {
                              RegExp dateRegExp =
                                  RegExp(r'^\d{2}/\d{2}/\d{4}$');
                              // String messageAlertValueDate =
                              //     'กรุณากรองวันที่ให้ถูกต้อง';
                              if (!dateRegExp.hasMatch(crDate)) {
                                setState(() {
                                  chkDate = true;
                                });
                              } else {
                                if (docNo.isNotEmpty &&
                                    docNo != '' &&
                                    docNo != 'null' &&
                                    returnStatusLovDocType.isNotEmpty &&
                                    returnStatusLovDocType != '' &&
                                    returnStatusLovDocType != 'null' &&
                                    crDate.isNotEmpty &&
                                    crDate != '' &&
                                    crDate != 'null' &&
                                    returnStatusLovMoDoNo.isNotEmpty &&
                                    returnStatusLovMoDoNo != '' &&
                                    returnStatusLovMoDoNo != 'null') {
                                  chkCust(
                                    shidForChk,
                                    returnStatusLovRefNo.isNotEmpty
                                        ? soNoForChk
                                        : 'null',
                                    testChk = 1,
                                  );
                                } else {
                                  showDialogErrorCHK(context,
                                      'ต้องระบุเลขที่คำสั่งผลผลิต * !!!');
                                }
                              }
                            }
                          });
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
            // -----------------------------
            Expanded(
              child: isLoading
                  ? Center(child: LoadingIndicator())
                  // :
                  //  dataForm.isEmpty
                  //     ? const Center(
                  //         child: Text(
                  //           'No data found',
                  //           style: TextStyle(color: Colors.white),
                  //         ),
                  //       )
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          GestureDetector(
                            child: AbsorbPointer(
                              child: TextFormField(
                                style: const TextStyle(
                                  color: Colors.black87,
                                ),
                                controller: docNoController,
                                readOnly: true,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  filled: true,
                                  fillColor: Colors.grey[300],
                                  label: RichText(
                                    text: const TextSpan(
                                      text: 'เลขที่ใบเบิก WMS', // ชื่อ label
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 16,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: ' *', // เพิ่มเครื่องหมาย *
                                          style: TextStyle(
                                            color: Colors.red, // สีแดงสำหรับ *
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),
                          // -----------------------------

                          TextFormField(
                            controller: docTypeController,
                            readOnly: true,
                            onTap: () => showDialogDropdownSearchDocType(),
                            minLines: 1,
                            maxLines: 3,
                            // overflow: TextOverflow.ellipsis,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Colors.white,
                              label: RichText(
                                text: const TextSpan(
                                  text: 'ประเภทการจ่าย', // ชื่อ label
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 16,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: ' *', // เพิ่มเครื่องหมาย *
                                      style: TextStyle(
                                        color: Colors.red, // สีแดงสำหรับ *
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // labelText: 'ประเภทการจ่าย *',
                              // labelStyle: TextStyle(
                              //   color: Colors.black87,
                              // ),
                              suffixIcon: const Icon(
                                Icons.arrow_drop_down,
                                color: Color.fromARGB(255, 113, 113, 113),
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),
                          // -----------------------------
                          TextFormField(
                            controller: crDateController,
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
                              label: RichText(
                                text: TextSpan(
                                  text: 'วันที่บันทึก', // ชื่อ label
                                  style: chkDate == false && noDate == false
                                      ? const TextStyle(
                                          color: Colors.black87,
                                          fontSize: 16,
                                        )
                                      : const TextStyle(
                                          color: Colors.red,
                                          fontSize: 16,
                                        ),
                                  children: [
                                    TextSpan(
                                      text: ' *', // เพิ่มเครื่องหมาย *
                                      style: TextStyle(
                                        color: Colors.red, // สีแดงสำหรับ *
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              hintText: 'DD/MM/YYYY',
                              hintStyle: TextStyle(color: Colors.grey),
                              // labelText: 'วันที่บันทึก *',
                              // labelStyle: const TextStyle(
                              //   color: Colors.black87,
                              // ),
                              suffixIcon: IconButton(
                                icon: const Icon(
                                    Icons.calendar_today), // ไอคอนที่อยู่ขวาสุด
                                onPressed: () async {
                                  // กดไอคอนเพื่อเปิด date picker
                                  _selectDate(context);
                                },
                              ),
                            ),
                            onChanged: (value) {
                              crDate = value;
                              print('crDate : $crDate');
                              if (crDate != crDateForCheck) {
                                checkUpdateData = true;
                              }
                              setState(() {
                                //----------------------------------------------\\
                                // สร้าง instance ของ DateInputFormatter
                                DateInputFormatter formatter =
                                    DateInputFormatter();

                                // ตรวจสอบการเปลี่ยนแปลงของข้อความ
                                TextEditingValue oldValue = TextEditingValue(
                                    text: crDateController.text);
                                TextEditingValue newValue =
                                    TextEditingValue(text: value);

                                // ใช้ formatEditUpdate เพื่อตรวจสอบและอัปเดตค่าสีของวันที่และเดือน
                                formatter.formatEditUpdate(oldValue, newValue);

                                // ตรวจสอบค่าที่ส่งกลับมาจาก DateInputFormatter
                                dateColorCheck = formatter.dateColorCheck;
                                monthColorCheck = formatter.monthColorCheck;
                                noDate =
                                    formatter.noDate; // เพิ่มการตรวจสอบ noDate
                                //--------------------------------------------------\\
                                RegExp dateRegExp =
                                    RegExp(r'^\d{2}/\d{2}/\d{4}$');
                                // String messageAlertValueDate =
                                //     'กรุณากรองวันที่ให้ถูกต้อง';
                                if (!dateRegExp.hasMatch(crDate)) {
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
                          // noDate
                          //     ? const Text(
                          //         'กรุณาระบุรูปแบบวันที่ให้ถูกต้อง เช่น 31/01/2024',
                          //         style: TextStyle(color: Colors.red),
                          //       )
                          //     : const SizedBox.shrink(),
                          chkDate == true || noDate == true
                              ? const Padding(
                                  padding: EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    'กรุณาระบุรูปแบบวันที่ให้ถูกต้อง เช่น 31/01/2024',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          12, // ปรับขนาดตัวอักษรตามที่ต้องการ
                                    ),
                                  ))
                              : const SizedBox.shrink(),
                          const SizedBox(height: 8),
                          // -----------------------------
                          // DropdownSearch<String>(
                          //   popupProps: PopupProps.menu(
                          //     showSearchBox: true,
                          //     showSelectedItems: true,
                          //     itemBuilder: (context, item, isSelected) {
                          //       return ListTile(
                          //         title: Text(item),
                          //         selected: isSelected,
                          //       );
                          //     },
                          //     constraints: BoxConstraints(
                          //       maxHeight: 250,
                          //     ),
                          //   ),
                          //   items: dataLovRefNo
                          //       .map<String>((item) =>
                          //           '${item['so_no']} ${item['so_date']} ${item['so_remark']} ${item['ar_name']} ${item['ar_code']}')
                          //       .toList(),
                          //   dropdownDecoratorProps: DropDownDecoratorProps(
                          //     dropdownSearchDecoration: InputDecoration(
                          //       border: InputBorder.none,
                          //       filled: true,
                          //       fillColor: Colors.white,
                          //       labelText: 'เลขที่เอกสารอ้างอิง',
                          //       labelStyle: const TextStyle(
                          //         color: Colors.black87,
                          //       ),
                          //     ),
                          //   ),
                          //   onChanged: (String? value) {
                          //     setState(() {
                          //       selectLovRefNo = value;

                          //       // Find the selected item
                          //       var selectedItem = dataLovRefNo.firstWhere(
                          //         (item) =>
                          //             '${item['so_no']} ${item['so_date']} ${item['so_remark']} ${item['ar_name']} ${item['ar_code']}' ==
                          //             value,
                          //         orElse: () => <String, dynamic>{}, // แก้ไข orElse
                          //       );
                          //       // Update variables based on selected item
                          //       if (selectedItem.isNotEmpty) {
                          //         returnStatusLovRefNo = selectedItem['so_no'] ?? '';
                          //         soNoForChk = selectedItem['so_no'].toString();
                          //       }
                          //     });
                          //     print(
                          //         'dataLovRefNo in body: $dataLovRefNo type: ${dataLovRefNo.runtimeType}');
                          //     // print(selectedItem);
                          //     print(
                          //         'returnStatusLovRefNo in body: $returnStatusLovRefNo type: ${returnStatusLovRefNo.runtimeType}');
                          //   },
                          //   selectedItem: selectLovRefNo,
                          // ),

                          ///
                          TextFormField(
                            controller: refNoController,
                            readOnly: true,
                            onTap: () => showDialogDropdownSearchRefNo(),
                            minLines: 1,
                            maxLines: 3,
                            // overflow: TextOverflow.ellipsis,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Colors.white,
                              labelText: 'เลขที่เอกสารอ้างอิง',
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

                          // ----------------------------------------------------------------------------------------------------------------------------------
                          // DropdownSearch<String>(
                          //   popupProps: PopupProps.menu(
                          //     showSearchBox: true,
                          //     showSelectedItems: true,
                          //     itemBuilder: (context, item, isSelected) {
                          //       return ListTile(
                          //         title: Text(item),
                          //         selected: isSelected,
                          //       );
                          //     },
                          //     constraints: BoxConstraints(
                          //       maxHeight: 250,
                          //     ),
                          //   ),
                          //   items: dataLovMoDoNo
                          //       .map<String>((item) =>
                          //           '${item['schid']} ${item['fg_code']} ${item['cust_name']}')
                          //       .toList(),
                          //   dropdownDecoratorProps: DropDownDecoratorProps(
                          //     dropdownSearchDecoration: InputDecoration(
                          //       border: InputBorder.none,
                          //       filled: true,
                          //       fillColor: Colors.white,
                          //       labelText: 'เลขที่คำสั่งผลผลิต *',
                          //       labelStyle: const TextStyle(
                          //         color: Colors.black87,
                          //       ),
                          //     ),
                          //   ),
                          //   onChanged: (String? value) {
                          //     setState(() {
                          //       // Find the selected item
                          //       var selectedItem = dataLovMoDoNo.firstWhere(
                          //         (item) =>
                          //             '${item['schid']} ${item['fg_code']} ${item['cust_name']}' ==
                          //             value,
                          //         orElse: () => <String, dynamic>{},
                          //       );

                          //       // Update variables based on selected item
                          //       if (selectedItem.isNotEmpty) {
                          //         returnStatusLovMoDoNo =
                          //             selectedItem['schid'].toString();
                          //         selectLovMoDoNo = selectedItem['schid'].toString();
                          //         selectCust(returnStatusLovMoDoNo);
                          //         //////-----------------------------------------------
                          //         shidForChk = selectedItem['schid'].toString();
                          //         print(selectedItem['schid'].toString());
                          //         chkCust(
                          //           shidForChk,
                          //           soNoForChk.isNotEmpty ? soNoForChk : 'null',
                          //           testChk = 0,
                          //         );
                          //       }
                          //     });
                          //     print(
                          //         'dataLovMoDoNo in body: $dataLovMoDoNo type: ${dataLovMoDoNo.runtimeType}');
                          //     print(
                          //         'returnStatusLovMoDoNo in body: $returnStatusLovMoDoNo type: ${returnStatusLovMoDoNo.runtimeType}');
                          //   },
                          //   selectedItem: selectLovMoDoNo,
                          // ),
                          TextFormField(
                            controller: moDoNoController,
                            readOnly: true,
                            onTap: () => showDialogDropdownSearchMoDoNo(),
                            minLines: 1,
                            maxLines: 3,
                            // overflow: TextOverflow.ellipsis,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Colors.white,
                              label: RichText(
                                text: const TextSpan(
                                  text: 'เลขที่คำสั่งผลผลิต', // ชื่อ label
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 16,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: ' *', // เพิ่มเครื่องหมาย *
                                      style: TextStyle(
                                        color: Colors.red, // สีแดงสำหรับ *
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // labelText: 'เลขที่คำสั่งผลผลิต *',
                              // labelStyle: TextStyle(
                              //   color: Colors.black87,
                              // ),
                              suffixIcon: Icon(
                                Icons.arrow_drop_down,
                                color: Color.fromARGB(255, 113, 113, 113),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          // -----------------------------
                          GestureDetector(
                            child: AbsorbPointer(
                              child: TextFormField(
                                controller: custNameController,
                                readOnly: true,
                                minLines: 1,
                                maxLines: 3,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  filled: true,
                                  fillColor: Colors.grey[300],
                                  labelText: 'ลูกค้า',
                                  labelStyle: const TextStyle(
                                    color: Colors.black87,
                                  ),
                                ),
                                onChanged: (value) {
                                  if (custName != custNameForCheck) {
                                    checkUpdateData = true;
                                  }
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          // -----------------------------
                          TextFormField(
                            controller: noteController,
                            minLines: 1,
                            maxLines: 5,
                            // readOnly: true,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Colors.white,
                              labelText: 'หมายเหตุ',
                              labelStyle: const TextStyle(
                                color: Colors.black87,
                              ),
                            ),
                            onChanged: (value) => {
                              setState(() {
                                note = value;
                                if (note != noteForCheck) {
                                  checkUpdateData = true;
                                }
                              }),
                            },
                          ),
                          const SizedBox(height: 8),
                          // -----------------------------
                          GestureDetector(
                            child: AbsorbPointer(
                              child: TextFormField(
                                controller: erpDocNoController,
                                readOnly: true,
                                minLines: 1,
                                maxLines: 3,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  filled: true,
                                  fillColor: Colors.grey[300],
                                  labelText: 'เลขที่เอกสาร ERP',
                                  labelStyle: const TextStyle(
                                    color: Colors.black87,
                                  ),
                                ),
                                onChanged: (value) {
                                  if (erpDocNo != erpDocNoForCheck) {
                                    checkUpdateData = true;
                                  }
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
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

  void showDialogLovCancel() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogStyles.cancelDialog(
          context: context,
          onCloseDialog: () {
            Navigator.of(context).pop();
            setState(() {
              selectLovCancel = '';
              returnStatusLovCancel = '';
              cancelController.text = '';
            });
          },
          onConfirmDialog: () {
            setState(() {
              deleteForm(returnStatusLovCancel);
            });
          },
          onTap: () => showDialogDropdownSearchCancel(),
          controller: cancelController,
        );
      },
    );
  }

  void showDialogErrorCHK(
    BuildContext context,
    String messageAlert,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogStyles.alertMessageDialog(
          context: context,
          content: Text(messageAlert),
          onClose: () => Navigator.of(context).pop(),
          onConfirm: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  void showDialogDropdownSearchMoDoNo() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return DialogStyles.customRequiredLovSearchDialog(
          context: context,
          headerText: 'เลขที่คำสั่งผลผลิต',
          searchController: _searchController1,
          data: dataLovMoDoNo,
          docString: (item) =>
              '${item['schid'] ?? ''} ${item['fg_code'] ?? ''} ${item['cust_name'] ?? ''}',
          titleText: (item) =>
              '${item['schid'] ?? ''} ${item['fg_code'] ?? ''}',
          subtitleText: (item) => '${item['cust_name'] ?? ''}',
          onTap: (item) {
            Navigator.of(context).pop();
            setState(() {
              String dataCHK = '${item['schid']}';
              selectLovMoDoNo = '${item['schid']}';
              returnStatusLovMoDoNo = '${item['schid']}';
              moDoNoController.text = selectLovMoDoNo.toString();

              if (dataCHK != returnStatusLovRefNoForCheck) {
                checkUpdateData = true;
              } else {
                print('returnStatusLovRefNo : '
                    '$returnStatusLovRefNo'
                    'returnStatusLovRefNoForCheck'
                    '$returnStatusLovRefNoForCheck');
              }

              print(
                  'returnStatusLovMoDoNo New: $returnStatusLovMoDoNo Type : ${returnStatusLovMoDoNo.runtimeType}');
              print(
                  'selectLovMoDoNo New: $selectLovMoDoNo Type : ${selectLovMoDoNo.runtimeType}');
              print(
                  'moDoNoController New: $moDoNoController Type : ${moDoNoController.runtimeType}');
              shidForChk = '${item['schid']}';
              selectCust(returnStatusLovMoDoNo);
              print('shidForChk : $shidForChk');
              print(
                  'returnStatusLovRefNoForCheck : $returnStatusLovRefNoForCheck');
              print(' checkUpdateData : $checkUpdateData');
              chkCust(
                shidForChk,
                soNoForChk.isNotEmpty ? soNoForChk : 'null',
                testChk = 0,
              );
            });
          },
        );
      },
    );
  }

  void showDialogDropdownSearchRefNo() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return DialogStyles.customLovSearchDialog(
          context: context,
          headerText: 'เลขที่เอกสารอ้างอิง',
          searchController: _searchController2,
          data: dataLovRefNo,
          docString: (item) =>
              '${item['so_no']} ${item['so_date']} ${item['so_remark']} ${item['ar_name']} ${item['ar_code']}',
          titleText: (item) =>
              '${item['so_no']} ${item['so_date']} ${item['so_remark']} ${item['ar_name']} ${item['ar_code']}',
          subtitleText: (item) => '',
          onTap: (item) {
            Navigator.of(context).pop();
            setState(() {
              String dataCHK =
                  '${item['so_no']} ${item['so_date']} ${item['so_remark']} ${item['ar_name']} ${item['ar_code']}';
              selectLovRefNo =
                  '${item['so_no']} ${item['so_date']} ${item['so_remark']} ${item['ar_name']} ${item['ar_code']}';
              returnStatusLovRefNo = '${item['so_no']}';
              refNoController.text = selectLovRefNo.toString();

              if (dataCHK != returnStatusLovRefNoForCheck) {
                checkUpdateData = true;
              }
              print(
                  'returnStatusLovRefNo New: $returnStatusLovRefNo Type : ${returnStatusLovRefNo.runtimeType}');
              print(
                  'selectLovRefNo New: $selectLovRefNo Type : ${selectLovRefNo.runtimeType}');
              print(
                  'refNoController New: $refNoController Type : ${refNoController.runtimeType}');
              soNoForChk = '${item['so_no']}';
            });
          },
        );
      },
    );
  }

  void showDialogDropdownSearchDocType() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return DialogStyles.customRequiredLovSearchDialog(
          context: context,
          headerText: 'ประเภทการจ่าย',
          searchController: _searchController3,
          data: dataLovDocType,
          docString: (item) => '${item['doc_type']} ${item['doc_desc']}',
          titleText: (item) => '${item['doc_type']}',
          subtitleText: (item) => '${item['doc_desc'] ?? ''}',
          onTap: (item) {
            Navigator.of(context).pop();
            setState(() {
              String dataCHK = '${item['doc_desc']}';
              selectLovDocType = '${item['doc_desc']}';
              docTypeController.text = '${item['doc_desc']}';
              returnStatusLovDocType = '${item['doc_type']}';

              if (dataCHK != returnStatusLovDocTypeForCheck) {
                checkUpdateData = true;
              }
            });
            print(
                'dataLovDocType in body: $dataLovDocType type: ${dataLovDocType.runtimeType}');
            // print(selectedItem);
            print(
                'returnStatusLovDocType in body: $returnStatusLovDocType type: ${returnStatusLovDocType.runtimeType}');
          },
        );
      },
    );
  }

  void showDialogDropdownSearchCancel() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return DialogStyles.customLovSearchDialog(
          context: context,
          headerText: 'สาเหตุการยกเลิก',
          searchController: _searchController4,
          data: dataLovCancel,
          docString: (item) => '${item['d']}',
          titleText: (item) => '${item['r']}',
          subtitleText: (item) => '${item['cancel_desc']}',
          onTap: (item) {
            Navigator.of(context).pop();
            setState(() {
              selectLovCancel = '${item['d']}';
              cancelController.text = selectLovCancel.toString();
              returnStatusLovCancel = '${item['r']}';

              //  if(returnStatusLovCancel != returnStatusLovCancelForCheck) {
              // checkUpdateData = true;
              // }
            });
            print(
                'dataLovCancel in body: $dataLovCancel type: ${dataLovCancel.runtimeType}');
            // print(selectedItem);
            print(
                'returnStatusLovCancel in body: $returnStatusLovCancel type: ${returnStatusLovCancel.runtimeType}');
          },
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
