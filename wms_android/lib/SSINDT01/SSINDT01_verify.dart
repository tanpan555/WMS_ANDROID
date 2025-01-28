import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:wms_android/custom_appbar.dart';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/Global_Parameter.dart' as gb;
import 'package:wms_android/styles.dart';

import 'package:url_launcher/url_launcher.dart';

class Ssindt01Verify extends StatefulWidget {
  final String poReceiveNo;
  final String? poPONO;

  final String pWareCode;
  final String pWareName;
  final String p_ou_code;

  Ssindt01Verify({
    required this.poReceiveNo,
    this.poPONO,
    required this.pWareCode,
    required this.pWareName,
    required this.p_ou_code,
  });

  @override
  _Ssindt01VerifyState createState() => _Ssindt01VerifyState();
}

class _Ssindt01VerifyState extends State<Ssindt01Verify> {
  List<Map<String, dynamic>> dataList = [];
  List<dynamic> data = [];
  String? poStatus;
  String? poMessage;
  String? erp_doc_no;
  final BROWSER_LANGUAGE = gb.BROWSER_LANGUAGE;
  final P_OU_CODE = gb.P_OU_CODE;
  final P_ERP_OU_CODE = gb.P_ERP_OU_CODE;
  String? revNo;

  String? reportServer;
  String? reportname = 'WMS_SSINDT01_GETJOB';
  String P_RECEIVE_NO = '';
  String? report;
  String? allreport;
  bool isDialogShowing = false;

  @override
  void initState() {
    super.initState();
    sendGetRequestlineWMS();

    reportServer = '${gb.IP_API}/jri/report?&_repName=/$reportname'
        '&_repFormat=pdf&_dataSource=wms'
        '&_outFilename=$erp_doc_no.pdf'
        '&_repLocale=en_US';

    P_RECEIVE_NO = "&P_RECEIVE_NO=${revNo ?? ''}";

    report = '$reportServer' + P_RECEIVE_NO;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _launchUrl() async {
    print(widget.poReceiveNo);
    final uri = Uri.parse('${gb.IP_API}/jri/report?'
        '&_repName=/WMS/$reportname'
        '&_repFormat=pdf'
        '&_dataSource=wms'
        '&_outFilename=${widget.poReceiveNo}'
        '&_repLocale=en_US'
        '&LH_AP_CODE=$LH_AP_CODE'
        '&LH_AP_NAME=$LH_AP_NAME'
        '&LH_CUR_CODE=$LH_CUR_CODE'
        '&LH_RATE=$LH_RATE'
        '&P_RECEIVE_NO=$erp_doc_no'
        '&P_ERP_OU_CODE=$P_ERP_OU_CODE'
        '&P_OU_CODE=$P_OU_CODE'
        '&P_LIN_ID=$P_LIN_ID'
        '&V_DS_PDF=$V_DS_PDF'
        '&LH_PONO=$LH_PONO'
        '&LH_REF_DOC_NO=$LH_REF_DOC_NO'
        '&LH_INV_NO=$LH_INV_NO'
        '&LH_CONF_DATE=$LH_CONF_DATE'
        '&LH_RECEIVE_DATE=$LH_RECEIVE_DATE'
        '&LH_REF_DOC_DATE=$LH_REF_DOC_DATE'
        '&LH_INV_DATE=$LH_INV_DATE'
        '&LB_NO=$LB_NO'
        '&LB_ITEM_CODE=$LB_ITEM_CODE'
        '&LB_ITEM_NAME=$LB_ITEM_NAME'
        '&LB_WH=$LB_WH'
        '&LB_QTY=$LB_QTY'
        '&LB_UNIT=$LB_UNIT'
        '&LB_REMARK=$LB_REMARK'
        '&LT_REMARK=$LT_REMARK'
        '&LT_DATE=$LT_DATE'
        '&LT_SIGN1=$LT_SIGN1'
        '&LT_SIGN2=$LT_SIGN2'
        '&LT_SIGN3=$LT_SIGN3');
    print(uri);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
  }

  String? LH_AP_CODE;
  String? LH_AP_NAME;
  String? LH_CUR_CODE;
  String? LH_RATE;
  String? P_LIN_ID;
  String? V_DS_PDF;
  String? LH_PONO;
  String? LH_REF_DOC_NO;
  String? LH_INV_NO;
  String? LH_CONF_DATE;
  String? LH_RECEIVE_DATE;
  String? LH_REF_DOC_DATE;
  String? LH_INV_DATE;
  String? LB_NO;
  String? LB_ITEM_CODE;
  String? LB_ITEM_NAME;
  String? LB_WH;
  String? LB_QTY;
  String? LB_UNIT;
  String? LB_REMARK;
  String? LT_REMARK;
  String? LT_DATE;
  String? LT_SIGN1;
  String? LT_SIGN2;
  String? LT_SIGN3;

  void fetchPDFData() async {
    final url = Uri.parse(
        '${gb.IP_API}/apex/wms/SSINDT01/Step_4_GET_PDF/${widget.poPONO}/wms/$BROWSER_LANGUAGE/$P_ERP_OU_CODE/$P_OU_CODE');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        revNo = data['P_RECEIVE_NO'];

        reportServer = '${gb.IP_API}/jri/report?&_repName=/$reportname'
            '&_repFormat=pdf&_dataSource=wms'
            '&_outFilename=${widget.poReceiveNo}.pdf'
            '&_repLocale=en_US';

        // final queryParams1 = {
        //   'LH_AP_CODE': data['LH_AP_CODE'],
        //   'LH_AP_NAME': data['LH_AP_NAME'],
        //   'LH_CUR_CODE': data['LH_CUR_CODE'],
        //   'LH_RATE': data['LH_RATE'],
        //   'P_RECEIVE_NO': data['P_RECEIVE_NO'],
        //   'P_ERP_OU_CODE': data['P_ERP_OU_CODE'],
        //   'P_OU_CODE': data['P_OU_CODE'],
        //   'P_LIN_ID': data['P_LIN_ID'],
        //   'V_DS_PDF': data['V_DS_PDF'],
        //   'LH_PONO': data['LH_PONO'],
        //   'LH_REF_DOC_NO': data['LH_REF_DOC_NO'],
        //   'LH_INV_NO': data['LH_INV_NO'],
        //   'LH_CONF_DATE': data['LH_CONF_DATE'],
        //   'LH_RECEIVE_DATE': data['LH_RECEIVE_DATE'],
        //   'LH_REF_DOC_DATE': data['LH_REF_DOC_DATE'],
        //   'LH_INV_DATE': data['LH_INV_DATE'],
        //   'LB_NO': data['LB_NO'],
        //   'LB_ITEM_CODE': data['LB_ITEM_CODE'],
        //   'LB_ITEM_NAME': data['LB_ITEM_NAME'],
        //   'LB_WH': data['LB_WH'],
        //   'LB_QTY': data['LB_QTY'],
        //   'LB_UNIT': data['LB_UNIT'],
        //   'LB_REMARK': data['LB_REMARK'],
        //   'LT_REMARK': data['LT_REMARK'],
        //   'LT_DATE': data['LT_DATE'],
        //   'LT_SIGN1': data['LT_SIGN1'],
        //   'LT_SIGN2': data['LT_SIGN2'],
        //   'LT_SIGN3': data['LT_SIGN3'],
        // };

        LH_AP_CODE = data['LH_AP_CODE'];
        LH_AP_NAME = data['LH_AP_NAME'];
        LH_CUR_CODE = data['LH_CUR_CODE'];
        LH_RATE = data['LH_RATE'];
        P_RECEIVE_NO = data['P_RECEIVE_NO'];
        P_LIN_ID = data['P_LIN_ID'];
        V_DS_PDF = data['V_DS_PDF'];
        LH_PONO = data['LH_PONO'];
        LH_REF_DOC_NO = data['LH_REF_DOC_NO'];
        LH_INV_NO = data['LH_INV_NO'];
        LH_CONF_DATE = data['LH_CONF_DATE'];
        LH_RECEIVE_DATE = data['LH_RECEIVE_DATE'];
        LH_REF_DOC_DATE = data['LH_REF_DOC_DATE'];
        LH_INV_DATE = data['LH_INV_DATE'];
        LB_NO = data['LB_NO'];
        LB_ITEM_CODE = data['LB_ITEM_CODE'];
        LB_ITEM_NAME = data['LB_ITEM_NAME'];
        LB_WH = data['LB_WH'];
        LB_QTY = data['LB_QTY'];
        LB_UNIT = data['LB_UNIT'];
        LB_REMARK = data['LB_REMARK'];
        LT_REMARK = data['LT_REMARK'];
        LT_DATE = data['LT_DATE'];
        LT_SIGN1 = data['LT_SIGN1'];
        LT_SIGN2 = data['LT_SIGN2'];
        LT_SIGN3 = data['LT_SIGN3'];
        _launchUrl();
      } else {
        print('Failed to load data, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> sendGetRequestlineWMS() async {
    final url =
        '${gb.IP_API}/apex/wms/SSINDT01/Step_4_pull_po/${widget.poReceiveNo}/${gb.P_ERP_OU_CODE}';

    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    print('Request URL: $url');

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        if (mounted) {
          setState(() {
            dataList =
                List<Map<String, dynamic>>.from(responseData['items'] ?? []);
          });
        }
        print('Success: $dataList');
      } else {
        print('Failed to get data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> chk_sub() async {
    try {
      final response = await http.get(Uri.parse(
          '${gb.IP_API}/apex/wms/SSINDT01/Step_4_Submit_ver/${widget.poReceiveNo}/${gb.P_ERP_OU_CODE}/${gb.APP_USER}'));
      print(widget.poReceiveNo);
      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final jsonData = json.decode(responseBody);
        if (mounted) {
          setState(() {
            poStatus = jsonData['po_status'];
            poMessage = jsonData['po_message'];
            erp_doc_no = jsonData['v_erp_doc_no'];
            print(response.statusCode);
            print(jsonData);
            print(poStatus);
            print(poMessage);
          });
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'รับจากการสั่งซื้อ', showExitWarning: false),
      body:
          // Column(
          //   children: [
          Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: IconButton(
                      icon: Image.asset(
                        'assets/images/printer.png',
                        width: 25.0,
                        height: 25.0,
                      ),
                      onPressed: () async {
                        _launchUrl();
                        // fetchPDFData();
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () async {
                      if (isDialogShowing) return;

                      setState(() {
                        isDialogShowing =
                            true; // Set flag to true when a dialog is about to be shown
                      });
                      await chk_sub();
                      if (poStatus == '1') {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return DialogStyles.alertMessageDialog(
                              context: context,
                              content: Text(poMessage ?? ''),
                              onClose: () {
                                Navigator.of(context).pop();
                                setState(() {
                                  isDialogShowing =
                                      false; // Reset the flag when the first dialog is closed
                                });
                              },
                              onConfirm: () async {
                                Navigator.of(context).pop();
                                setState(() {
                                  isDialogShowing =
                                      false; // Reset the flag when the first dialog is closed
                                });
                              },
                            );
                          },
                        );
                        setState(() {
                          isDialogShowing =
                              false; // รีเซ็ตสถานะหลังจากปิด dialog
                        });
                      } else if (poStatus == '0') {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Center(child: Text('$erp_doc_no')),
                              actions: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextButton(
                                      child: Text('ยืนยัน'),
                                      onPressed: () async {
                                        showCustomDialog(context);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        );
                        setState(() {
                          isDialogShowing =
                              false; // รีเซ็ตสถานะหลังจากปิด dialog
                        });
                      }
                    },
                    style: AppStyles.ConfirmbuttonStyle(),
                    child: Text(
                      'ยืนยัน',
                      style: AppStyles.CancelbuttonTextStyle(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: ListView(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    margin: const EdgeInsets.only(bottom: 10.0),
                    color: const Color.fromARGB(255, 255, 242, 204),
                    child: Center(
                      child: Text(
                        '${widget.poPONO}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    margin: const EdgeInsets.only(bottom: 10.0),
                    color: const Color.fromARGB(255, 244, 244, 244),
                    child: Center(
                      child: Text(
                        '${widget.poReceiveNo}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                    ),
                  ),
                  dataList.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 150),
                            child: Text(
                              'No data found',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                      : SingleChildScrollView(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            children: dataList.map((data) {
                              Map<String, String> info1 = {
                                'จำนวนรับ :':
                                    data['receive_qty']?.toString() ?? '-',
                                'ค้างรับ :':
                                    data['pending_qty']?.toString() ?? '-',
                              };
                              Map<String, String> info2 = {
                                'Locator :':
                                    data['locator_det']?.toString() ?? '-',
                                'Lot No :':
                                    data['lot_product_no']?.toString() ?? '-',
                              };
                              return Card(
                                margin: EdgeInsets.symmetric(vertical: 8.0),
                                elevation: 6.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                color: Color.fromRGBO(204, 235, 252, 1.0),
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: Text(
                                          ' ${data['item'] ?? ''}',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: const Color.fromARGB(
                                                255, 0, 0, 0),
                                          ),
                                        ),
                                      ),
                                      Divider(
                                          color: const Color.fromARGB(
                                              255, 0, 0, 0)),
                                      _buildInfoRow2(info1),
                                      _buildInfoRow2(info2),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(currentPage: 'show'),
    );
  }

  Widget _buildInfoRow2(Map<String, String> info) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: info.entries.map((entry) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        height: 30,
                        alignment: Alignment.center,
                        child: Text(
                          entry.key,
                          style: TextStyle(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            fontSize: 12,
                          ),
                          softWrap: false,
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 1),
                  Flexible(
                    flex: 1,
                    child: Container(
                      height: 30,
                      alignment: Alignment.center,
                      child: TextField(
                        controller: TextEditingController(text: entry.value),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color.fromARGB(255, 254, 247, 230),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 0,
                          ),
                        ),
                        style: TextStyle(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.right,
                        readOnly: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  void showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ต้องการพิมพ์เอกสารใบรับหรือไม่'),
          content: Text('$erp_doc_no'),
          actions: [
            TextButton(
              child: Text('ยกเลิก'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('ยืนยัน'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                fetchPDFData();
              },
            ),
          ],
        );
      },
    );
  }
}
