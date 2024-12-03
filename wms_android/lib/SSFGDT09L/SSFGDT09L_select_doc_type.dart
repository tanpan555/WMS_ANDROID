import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:wms_android/custom_appbar.dart';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/Global_Parameter.dart' as globals;
import 'package:wms_android/styles.dart';
import 'package:wms_android/loading.dart';
import 'SSFGDT09L_form.dart';

class Ssfgdt09lSelectDocType extends StatefulWidget {
  final String pWareCode;
  final String pErpOuCode;
  final String pOuCode;
  final String pAttr1;

  const Ssfgdt09lSelectDocType({
    Key? key,
    required this.pWareCode,
    required this.pErpOuCode,
    required this.pOuCode,
    required this.pAttr1,
  }) : super(key: key);

  @override
  _Ssfgdt09lSelectDocTypeState createState() => _Ssfgdt09lSelectDocTypeState();
}

class _Ssfgdt09lSelectDocTypeState extends State<Ssfgdt09lSelectDocType> {
  List<dynamic> dataLovDocType = [];
  Map<String, dynamic>? selectedDocTypeItem;
  String docTypeLovD = '';
  String docTypeLovR = '';
  String chkCardName = '';
  String statusChkCreate = '';
  String messageChkCreate = '';
  String poDocType = '';
  String poDocNo = '';
  bool isNextDisabled = false;

  bool isLoading = false;

  final TextEditingController dataLovDocTypeController =
      TextEditingController();

  @override
  void initState() {
    selectLovDocType();
    super.initState();
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  Future<void> selectLovDocType() async {
    isLoading = true;
    try {
      final response = await http.get(Uri.parse(
          '${globals.IP_API}/apex/wms/SSFGDT09L/SSFGDT09L_Step_1_SelectLovDocType/${globals.ATTR1}'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $jsonDecode');
        if (mounted) {
          setState(() {
            dataLovDocType =
                List<Map<String, dynamic>>.from(responseData['items'] ?? []);

            selectedDocTypeItem = dataLovDocType[0];
            docTypeLovD = selectedDocTypeItem?['d'] ?? '';
            docTypeLovR = selectedDocTypeItem?['r'] ?? '';
            dataLovDocTypeController.text = docTypeLovD;

            isLoading = false;
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

  Future<void> chkCreateCard() async {
    final url =
        '${globals.IP_API}/apex/wms/SSFGDT09L/SSFGDT09L_Step_1_CreateNewINHead';

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'p_ou_code': globals.P_OU_CODE,
      'p_erp_ou_code': globals.P_ERP_OU_CODE,
      'p_app_session': globals.APP_SESSION,
      'p_ware_code': widget.pWareCode,
      'p_doc_type': docTypeLovR,
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
        final Map<String, dynamic> data =
            jsonDecode(utf8.decode(response.bodyBytes));
        print('data : $data type : ${data.runtimeType}');
        if (mounted) {
          setState(() {
            statusChkCreate = data['po_status'];
            messageChkCreate = data['po_message'];
            print(
                'statusChkCreate : $statusChkCreate Type : ${statusChkCreate.runtimeType}');
            print(
                'messageChkCreate : $messageChkCreate Type : ${messageChkCreate.runtimeType}');

            if (statusChkCreate == '1') {
              showDialogAlert(context, messageChkCreate);
            }
            if (statusChkCreate == '0') {
              poDocNo = data['po_doc_no'];
              poDocType = data['po_doc_type'];

              print('poDocNo : $poDocNo Type : ${poDocNo.runtimeType}');

              print('poDocType : $poDocType Type : ${poDocType.runtimeType}');

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Ssfgdt09lForm(
                    pWareCode: widget.pWareCode,
                    pAttr1: globals.ATTR1,
                    pDocNo: poDocNo,
                    pDocType: poDocType,
                    pOuCode: globals.P_OU_CODE,
                    pErpOuCode: globals.P_ERP_OU_CODE,
                  ),
                ),
              ).then((value) async {
                if (mounted) {
                  setState(() {
                    isNextDisabled = false;
                  });
                }
              });
            }
          });
        }
      } else {
        print('โพสต์ข้อมูลล้มเหลว. รหัสสถานะ: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'เบิกจ่าย', showExitWarning: false),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: LoadingIndicator())
            : Column(
                children: [
                  TextFormField(
                    controller: dataLovDocTypeController,
                    readOnly: true,
                    onTap: () => showDialogSelectDocType(),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.white,
                      labelText: 'ประเภทเอกสาร',
                      labelStyle: TextStyle(
                        color: Colors.black87,
                      ),
                      suffixIcon: Icon(
                        Icons.arrow_drop_down,
                        color: Color.fromARGB(255, 113, 113, 113),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: isNextDisabled
                            ? null
                            : () {
                                setState(() {
                                  isNextDisabled = true;
                                });
                                chkCreateCard();
                              },
                        style: AppStyles.ConfirmbuttonStyle(),
                        child: Text('ยืนยัน',
                            style: AppStyles.ConfirmbuttonTextStyle()),
                      ),
                    ],
                  ),
                ],
              ),
      ),
      bottomNavigationBar: const BottomBar(
        currentPage: 'not_show',
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
          onClose: () => Navigator.of(context).pop(),
          onConfirm: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  void showDialogSelectDocType() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return DialogStyles.customSelectLovDialog(
          context: context,
          headerText: 'ประเภทเอกสาร',
          data: dataLovDocType,
          displayItem: (item) => '${item['d'] ?? ''}',
          onTap: (item) {
            Navigator.of(context).pop();
            setState(() {
              docTypeLovD = item['d'];
              docTypeLovR = item['r'];
              dataLovDocTypeController.text = docTypeLovD;
              // -----------------------------------------
              print(
                  'dataLovDocTypeController New: $dataLovDocTypeController Type : ${dataLovDocTypeController.runtimeType}');
              print(
                  'docTypeLovD New: $docTypeLovD Type : ${docTypeLovD.runtimeType}');
              print(
                  'docTypeLovR New: $docTypeLovR Type : ${docTypeLovR.runtimeType}');
            });
          },
        );
      },
    );
  }
}
