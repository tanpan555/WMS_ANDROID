import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/custom_appbar.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:wms_android/Global_Parameter.dart' as globals;
import 'package:wms_android/styles.dart';
import 'SSFGDT09L_grid.dart';
import 'SSFGDT09L_main.dart';

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
  // String docType = '';
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

  String soNoForChk = ''; // ref_no สำหรับ check
  String shidForChk = ''; // mo_do_no สำหรับ check
  String pMessageErr = ''; // message หลังจาก check    so_no == shid

  String statusSubmit = '';
  String messageSubmit = '';

  String deleteStatus = '';
  String deleteMessage = '';

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

  @override
  void initState() {
    super.initState();
    fetchData();
    lovDocType();
    lovMoDoNo();
    lovRefNo();
    lovCancel();
  }

  @override
  void dispose() {
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

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  Future<void> fetchData() async {
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

          setState(() {
            ouCode = item['ou_code'] ?? '';
            docNo = item['doc_no'] ?? '';
            crDate = item['cr_date'] ?? '';
            staffCode = item['staff_code"'] ?? '';
            note = item['note'] ?? '';
            erpDocNo = item['erp_doc_no'] ?? '';
            updBy = item['upd_by'] ?? '';
            updDate = item['upd_date'] ?? '';
            updProgID = item['upd_prog_id'] ?? '';
            docDate = item['doc_date'] ?? '';
            // -----------------------------
            selectLovDocType = item['doc_type_d'] ?? '';
            returnStatusLovDocType = item['doc_type_r'] ?? '';
            // -----------------------------
            selectLovRefNo = item['ref_no'] ?? '';
            returnStatusLovRefNo = item['ref_no'] ?? '';
            // -----------------------------
            selectLovMoDoNo = item['mo_do_no'] ?? '';
            returnStatusLovMoDoNo = item['mo_do_no'].toString();
            // -----------------------------
            ouCodeController.text = ouCode;
            docNoController.text = docNo;
            docTypeController.text = docNo;
            crDateController.text = crDate;
            refNoController.text = refNo;
            moDoNoController.text = refNo;
            staffCodeController.text = staffCode;
            noteController.text = note;
            erpDocNoController.text = erpDocNo;
            updByController.text = updBy;
            updDateController.text = updDate;
            updProgIDController.text = updProgID;
            docDateController.text = docDate;
          });
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

        setState(() {
          dataLovDocType =
              List<Map<String, dynamic>>.from(responseData['items'] ?? []);
        });
        print('dataLovDocType : $dataLovDocType');
      } else {
        throw Exception('dataLovDocType Failed to load fetchData');
      }
    } catch (e) {
      setState(() {});
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

        setState(() {
          dataLovMoDoNo =
              List<Map<String, dynamic>>.from(responseData['items'] ?? []);
        });
        print('dataLovMoDoNo : $dataLovMoDoNo');
      } else {
        throw Exception('dataLovMoDoNo Failed to load fetchData');
      }
    } catch (e) {
      setState(() {});
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

        setState(() {
          dataLovRefNo =
              List<Map<String, dynamic>>.from(responseData['items'] ?? []);
        });
        print('dataLovRefNo : $dataLovRefNo');
      } else {
        throw Exception('dataLovRefNo Failed to load fetchData');
      }
    } catch (e) {
      setState(() {});
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

        setState(() {
          dataLovCancel =
              List<Map<String, dynamic>>.from(responseData['items'] ?? []);
        });
        print('dataLovCancel : $dataLovCancel');
      } else {
        throw Exception('dataLovCancel Failed to load fetchData');
      }
    } catch (e) {
      setState(() {});
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

          setState(() {
            custName = item['cust'] ?? '';

            custNameController.text = custName;
          });
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
          'http://172.16.0.82:8888/apex/wms/SSFGDT09L/SSFGDT09L_Step_2_ChkCust/$arCode/${custCode ?? 'null'}'));

      print(
          'URL: http://172.16.0.82:8888/apex/wms/SSFGDT09L/SSFGDT09L_Step_2_ChkCust/$arCode/${custCode ?? 'null'}');
      if (response.statusCode == 200) {
        // ถอดรหัสข้อมูล JSON จาก response
        final Map<String, dynamic> dataMessage = jsonDecode(utf8
            .decode(response.bodyBytes)); // ถอดรหัส response body เป็น UTF-8
        print('dataMessage : $dataMessage type : ${dataMessage.runtimeType}');
        setState(() {
          pMessageErr = dataMessage['p_message_err'];
          print(
              'pMessageErr :: $pMessageErr  type :: ${pMessageErr.runtimeType}');
          if (pMessageErr.isNotEmpty) {
            showDialogErrorCHK(pMessageErr);
          }
          if (testChk == 1) {
            saveDataFoem();
          }
        });
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

          setState(() {
            custName = item['ar_code_name'] ?? '';

            custNameController.text = custName;
          });
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
        setState(() {
          submitData();
        });
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
        setState(() {
          statusSubmit = dataSubmit['po_status'];
          messageSubmit = dataSubmit['po_message'];

          if (statusSubmit == '1') {
            showDialogErrorCHK(messageSubmit);
          }
          if (statusSubmit == '0') {
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
            });
          }

          print(
              'statusSubmit in Function submitData : $statusSubmit type : ${statusSubmit.runtimeType}');
          print(
              'messageSubmit in Function submitData : $messageSubmit type : ${messageSubmit.runtimeType}');
        });
      } else {
        // จัดการกรณีที่ response status code ไม่ใช่ 200
        print('โพสต์ข้อมูลล้มเหลว. รหัสสถานะ: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in submit Data: $e');
    }
  }

  Future<void> deleteForm(String cancelCode) async {
    final url =
        'http://172.16.0.82:8888/apex/wms/SSFGDT09L/SSFGDT09L_Step_3_deleteCardGrid';

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'p_ou_code': globals.P_OU_CODE,
      'pErpOuCode': globals.P_ERP_OU_CODE,
      'pDocType': widget.pDocType,
      'pDocNo': widget.pDocNo,
      'p_cancel_code': cancelCode,
      'pAppUser': globals.APP_USER,
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
        setState(() {
          deleteStatus = dataDelete['po_status'];
          deleteMessage = dataDelete['po_message'];

          if (deleteStatus == '1') {
            showDialogErrorCHK(deleteMessage);
          }
          if (deleteStatus == '0') {
            setState(() async {
              _navigateToPage(
                  context,
                  SSFGDT09L_MAIN(
                    pOuCode: globals.P_OU_CODE,
                    pErpOuCode: globals.P_ERP_OU_CODE,
                    pAttr1: globals.ATTR1,
                  ));
            });
          }
        });
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
      setState(() {
        crDateController.text = formattedDate;
        crDate = crDateController.text;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF17153B),
      appBar: CustomAppBar(title: 'เบิกจ่าย'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    showDialogLovCancel();
                  },
                  style: AppStyles.cancelButtonStyle(),
                  child:
                      Text('ยกเลิก', style: AppStyles.CancelbuttonTextStyle()),
                ),

                // const Spacer(),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: IconButton(
                    iconSize: 20.0,
                    icon: Image.asset(
                      'assets/images/right.png',
                      width: 20.0,
                      height: 20.0,
                    ),
                    onPressed: () {
                      if (docNo.isNotEmpty &&
                          docNo != '' &&
                          docNo != null &&
                          docNo != 'null' &&
                          returnStatusLovDocType.isNotEmpty &&
                          returnStatusLovDocType != '' &&
                          returnStatusLovDocType != null &&
                          returnStatusLovDocType != 'null' &&
                          crDate.isNotEmpty &&
                          crDate != '' &&
                          crDate != null &&
                          crDate != 'null' &&
                          returnStatusLovMoDoNo.isNotEmpty &&
                          returnStatusLovMoDoNo != '' &&
                          returnStatusLovMoDoNo != null &&
                          returnStatusLovMoDoNo != 'null') {
                        chkCust(
                          shidForChk,
                          returnStatusLovRefNo.isNotEmpty ? soNoForChk : 'null',
                          testChk = 1,
                        );
                      } else {
                        showDialogErrorCHK('ต้องระบุเลขที่คำสั่งผลผลิต * !!!');
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // -----------------------------
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      style: const TextStyle(
                        color: Colors.black87,
                      ),
                      controller: docNoController,
                      readOnly: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.grey[300],
                        labelText: 'เลขที่ใบเบิก WMS *',
                        labelStyle: const TextStyle(
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // -----------------------------
                    DropdownSearch<String>(
                      popupProps: PopupProps.menu(
                        showSearchBox: true,
                        showSelectedItems: true,
                        itemBuilder: (context, item, isSelected) {
                          return ListTile(
                            title: Text(item),
                            selected: isSelected,
                          );
                        },
                        constraints: BoxConstraints(
                          maxHeight: 250,
                        ),
                      ),
                      items: dataLovDocType
                          // -----------------------------  แสดง 1 อย่าง
                          .map<String>((item) => '${item['doc_desc']}')
                          .toList(),
                      // -----------------------------  แสดง 2 อย่าง
                      // .map<String>((item) =>
                      //     '${item['doc_type']} ${item['doc_desc']}')
                      // .toList(),
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'ประเภทการจ่าย *',
                          labelStyle: const TextStyle(
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          selectLovDocType = value;

                          // Find the selected item
                          var selectedItem = dataLovDocType.firstWhere(
                            (item) => '${item['doc_desc']}' == value,
                            orElse: () => <String, dynamic>{}, // แก้ไข orElse
                          );

                          // var selectedItem = dataLovDocType.firstWhere(
                          //   (item) =>
                          //       '${item['doc_type']} ${item['doc_desc']}' ==
                          //       value,
                          //   orElse: () => <String, dynamic>{}, // แก้ไข orElse
                          // );
                          // Update variables based on selected item
                          if (selectedItem.isNotEmpty) {
                            returnStatusLovDocType =
                                selectedItem['doc_type'] ?? '';
                          }
                        });
                        print(
                            'dataLovDocType in body: $dataLovDocType type: ${dataLovDocType.runtimeType}');
                        // print(selectedItem);
                        print(
                            'returnStatusLovDocType in body: $returnStatusLovDocType type: ${returnStatusLovDocType.runtimeType}');
                      },
                      selectedItem: selectLovDocType,
                    ),

                    const SizedBox(height: 20),
                    // -----------------------------
                    TextFormField(
                      controller: crDateController,
                      readOnly: true,
                      onTap: () => _selectDate(context),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'วันที่บันทึก *',
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
                    // -----------------------------
                    DropdownSearch<String>(
                      popupProps: PopupProps.menu(
                        showSearchBox: true,
                        showSelectedItems: true,
                        itemBuilder: (context, item, isSelected) {
                          return ListTile(
                            title: Text(item),
                            selected: isSelected,
                          );
                        },
                        constraints: BoxConstraints(
                          maxHeight: 250,
                        ),
                      ),
                      items: dataLovRefNo
                          .map<String>((item) =>
                              '${item['so_no']} ${item['so_date']} ${item['so_remark']} ${item['ar_name']} ${item['ar_code']}')
                          .toList(),
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'เลขที่เอกสารอ้างอิง',
                          labelStyle: const TextStyle(
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          selectLovRefNo = value;

                          // Find the selected item
                          var selectedItem = dataLovRefNo.firstWhere(
                            (item) =>
                                '${item['so_no']} ${item['so_date']} ${item['so_remark']} ${item['ar_name']} ${item['ar_code']}' ==
                                value,
                            orElse: () => <String, dynamic>{}, // แก้ไข orElse
                          );
                          // Update variables based on selected item
                          if (selectedItem.isNotEmpty) {
                            returnStatusLovRefNo = selectedItem['so_no'] ?? '';
                            soNoForChk = selectedItem['so_no'].toString();
                          }
                        });
                        print(
                            'dataLovRefNo in body: $dataLovRefNo type: ${dataLovRefNo.runtimeType}');
                        // print(selectedItem);
                        print(
                            'returnStatusLovRefNo in body: $returnStatusLovRefNo type: ${returnStatusLovRefNo.runtimeType}');
                      },
                      selectedItem: selectLovRefNo,
                    ),

                    ///
                    const SizedBox(height: 20),
                    // ----------------------------------------------------------------------------------------------------------------------------------
                    DropdownSearch<String>(
                      popupProps: PopupProps.menu(
                        showSearchBox: true,
                        showSelectedItems: true,
                        itemBuilder: (context, item, isSelected) {
                          return ListTile(
                            title: Text(item),
                            selected: isSelected,
                          );
                        },
                        constraints: BoxConstraints(
                          maxHeight: 250,
                        ),
                      ),
                      items: dataLovMoDoNo
                          .map<String>((item) =>
                              '${item['schid']} ${item['fg_code']} ${item['cust_name']}')
                          .toList(),
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'เลขที่คำสั่งผลผลิต *',
                          labelStyle: const TextStyle(
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          // Find the selected item
                          var selectedItem = dataLovMoDoNo.firstWhere(
                            (item) =>
                                '${item['schid']} ${item['fg_code']} ${item['cust_name']}' ==
                                value,
                            orElse: () => <String, dynamic>{},
                          );

                          // Update variables based on selected item
                          if (selectedItem.isNotEmpty) {
                            returnStatusLovMoDoNo =
                                selectedItem['schid'].toString();
                            selectLovMoDoNo = selectedItem['schid'].toString();
                            selectCust(returnStatusLovMoDoNo);
                            //////-----------------------------------------------
                            shidForChk = selectedItem['schid'].toString();
                            print(selectedItem['schid'].toString());
                            chkCust(
                              shidForChk,
                              soNoForChk.isNotEmpty ? soNoForChk : 'null',
                              testChk = 0,
                            );
                          }
                        });
                        print(
                            'dataLovMoDoNo in body: $dataLovMoDoNo type: ${dataLovMoDoNo.runtimeType}');
                        print(
                            'returnStatusLovMoDoNo in body: $returnStatusLovMoDoNo type: ${returnStatusLovMoDoNo.runtimeType}');
                      },
                      selectedItem: selectLovMoDoNo,
                    ),
                    const SizedBox(height: 20),
                    // -----------------------------
                    TextFormField(
                      controller: custNameController,
                      readOnly: true,
                      minLines: 1,
                      maxLines: 3,
                      // overflow: TextOverflow.ellipsis,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.grey[300],
                        labelText: 'ลูกค้า',
                        labelStyle: const TextStyle(
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
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
                        }),
                      },
                    ),
                    const SizedBox(height: 20),
                    // -----------------------------
                    TextFormField(
                      controller: erpDocNoController,
                      readOnly: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.grey[300],
                        labelText: 'เลขที่เอกสาร ERP',
                        labelStyle: const TextStyle(
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(),
    );
  }

  void showDialogLovCancel() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              children: [
                // Icon(
                //   Icons.notification_important,
                //   color: Colors.red,
                // ),
                // SizedBox(width: 8),
                Text('สาเหตุการยกเลิก'),
              ],
            ),
            // content: Expanded(
            content: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text('ตรวจพบสินค้าที่ไม่ระบุจำนวนนับ'),
                    // const SizedBox(height: 8),
                    /////////////////////////////////////////////////
                    DropdownSearch<String>(
                      popupProps: PopupProps.menu(
                        showSearchBox: true,
                        showSelectedItems: true,
                        itemBuilder: (context, item, isSelected) {
                          return ListTile(
                            title: Text(item),
                            selected: isSelected,
                          );
                        },
                        constraints: BoxConstraints(
                          maxHeight: 250,
                        ),
                      ),
                      items: dataLovCancel
                          .map<String>((item) => '${item['d']}')
                          .toList(),
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'สาเหตุการยกเลิก',
                          labelStyle: const TextStyle(
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          selectLovCancel = value;

                          // Find the selected item
                          var selectedItem = dataLovCancel.firstWhere(
                            (item) => '${item['d']}' == value,
                            orElse: () => <String, dynamic>{}, // แก้ไข orElse
                          );
                          // Update variables based on selected item
                          if (selectedItem.isNotEmpty) {
                            returnStatusLovCancel = selectedItem['r'] ?? '';
                          }
                        });
                        print(
                            'dataLovCancel in body: $dataLovCancel type: ${dataLovCancel.runtimeType}');
                        // print(selectedItem);
                        print(
                            'returnStatusLovCancel in body: $returnStatusLovCancel type: ${returnStatusLovCancel.runtimeType}');
                      },
                      selectedItem: selectLovCancel,
                    ),
                    const SizedBox(height: 8),
                    //////////////////////////////////////////////////
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 103, 58, 183),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            minimumSize: const Size(10, 20),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                          ),
                          child: const Text(
                            'ย้อนกลับ',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              if (returnStatusLovCancel.isNotEmpty) {
                                deleteForm(returnStatusLovCancel);
                              }
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 103, 58, 183),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            minimumSize: const Size(10, 20),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                          ),
                          child: const Text(
                            'ยืนยัน',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            // ),
          );
        });
  }

  void showDialogErrorCHK(String pMessageErr) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              children: [
                Icon(
                  Icons.notification_important,
                  color: Colors.red,
                ),
                SizedBox(width: 8),
                Text('แจ้งเตือน'),
              ],
            ),
            // content: Expanded(
            content: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('$pMessageErr'),
                    const SizedBox(height: 8),
                    /////////////////////////////////////////////////

                    const SizedBox(height: 8),
                    //////////////////////////////////////////////////
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 103, 58, 183),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            minimumSize: const Size(10, 20),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                          ),
                          child: const Text(
                            'ย้อนกลับ',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // ElevatedButton(
                        //   onPressed: () {},
                        //   style: ElevatedButton.styleFrom(
                        //     backgroundColor:
                        //         const Color.fromARGB(255, 103, 58, 183),
                        //     shape: RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(12.0),
                        //     ),
                        //     minimumSize: const Size(10, 20),
                        //     padding: const EdgeInsets.symmetric(
                        //         horizontal: 10, vertical: 5),
                        //   ),
                        //   child: const Text(
                        //     'ยืนยัน',
                        //     style: TextStyle(
                        //       color: Colors.white,
                        //       fontWeight: FontWeight.bold,
                        //     ),
                        //   ),
                        // ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            // ),
          );
        });
  }
}
