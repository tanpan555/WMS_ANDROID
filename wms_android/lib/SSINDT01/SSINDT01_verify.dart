import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:wms_android/custom_appbar.dart';

import 'package:wms_android/bottombar.dart';
import 'package:wms_android/Global_Parameter.dart' as gb;
import 'dart:developer';

import 'package:url_launcher/url_launcher.dart';


class Ssindt01Verify extends StatefulWidget {
  final String poReceiveNo;
  final String? poPONO;

  Ssindt01Verify({required this.poReceiveNo, this.poPONO});

  @override
  _Ssindt01VerifyState createState() => _Ssindt01VerifyState();
}

class _Ssindt01VerifyState extends State<Ssindt01Verify> {
  List<Map<String, dynamic>> dataList = [];
  List<dynamic> data = [];
  String? poStatus;
  String? poMessage;
  String? erp_doc_no;
  final BROWSER_LANGUAGE =gb.BROWSER_LANGUAGE;
  final P_OU_CODE = gb.P_OU_CODE;
  final P_ERP_OU_CODE = gb.P_ERP_OU_CODE;
  String? revNo;

 String?  reportServer;
  String? reportname = 'WMS_SSINDT01_GETJOB';
  String P_RECEIVE_NO = '';
  String? report;
  String? allreport;
 String? report1;
  String? report2;

  @override
  void initState() {
    super.initState();
    sendGetRequestlineWMS();
    // chk_sub();
    fetchPDFData();

    reportServer = 
        'http://172.16.0.82:8888/jri/report?&_repName=/$reportname'
        '&_repFormat=pdf&_dataSource=wms'
        '&_outFilename=${widget.poReceiveNo}.pdf'
        '&_repLocale=en_US';

        P_RECEIVE_NO = "&P_RECEIVE_NO=${revNo ?? ''}";

        report = '$reportServer'+P_RECEIVE_NO;
      
  }

  @override
  void dispose() {
    super.dispose();
  }

Future<void> _launchUrl() async {
    print(widget.poReceiveNo);
   final uri = Uri.parse('http://172.16.0.82:8888/jri/report?'
   '&_repName=/$reportname'
   '&_repFormat=pdf'
   '&_dataSource=wms'
   '&_outFilename=${widget.poReceiveNo}'
   '&_repLocale=en_US'
   '&LH_AP_CODE=$LH_AP_CODE'
   '&LH_AP_NAME=$LH_AP_NAME'
   '&LH_CUR_CODE=$LH_CUR_CODE'
   '&LH_RATE=$LH_RATE'
   '&P_RECEIVE_NO=RS-D02-6011001' //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
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
    'http://172.16.0.82:8888/apex/wms/c/GET_PDF/${widget.poPONO}/wms/$BROWSER_LANGUAGE/$P_ERP_OU_CODE/$P_OU_CODE'
  );

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      revNo = data['P_RECEIVE_NO'];

      reportServer = 'http://172.16.0.82:8888/jri/report?&_repName=/$reportname'
          '&_repFormat=pdf&_dataSource=wms'
          '&_outFilename=${widget.poReceiveNo}.pdf'
          '&_repLocale=en_US';

      final queryParams1 = {
        'LH_AP_CODE': data['LH_AP_CODE'],
        'LH_AP_NAME': data['LH_AP_NAME'],
        'LH_CUR_CODE': data['LH_CUR_CODE'],
        'LH_RATE': data['LH_RATE'],
        'P_RECEIVE_NO': data['P_RECEIVE_NO'],
        'P_ERP_OU_CODE': data['P_ERP_OU_CODE'],
        'P_OU_CODE': data['P_OU_CODE'],
        'P_LIN_ID': data['P_LIN_ID'],
        'V_DS_PDF': data['V_DS_PDF'],
        'LH_PONO': data['LH_PONO'],
        'LH_REF_DOC_NO': data['LH_REF_DOC_NO'],
        'LH_INV_NO': data['LH_INV_NO'],
        'LH_CONF_DATE': data['LH_CONF_DATE'],
        'LH_RECEIVE_DATE': data['LH_RECEIVE_DATE'],
        'LH_REF_DOC_DATE': data['LH_REF_DOC_DATE'],
        'LH_INV_DATE': data['LH_INV_DATE'],
        'LB_NO': data['LB_NO'],
        'LB_ITEM_CODE': data['LB_ITEM_CODE'],
        'LB_ITEM_NAME': data['LB_ITEM_NAME'],
        'LB_WH': data['LB_WH'],
        'LB_QTY': data['LB_QTY'],
        'LB_UNIT': data['LB_UNIT'],
        'LB_REMARK': data['LB_REMARK'],
        'LT_REMARK': data['LT_REMARK'],
        'LT_DATE': data['LT_DATE'],
        'LT_SIGN1': data['LT_SIGN1'],
        'LT_SIGN2': data['LT_SIGN2'],
        'LT_SIGN3': data['LT_SIGN3'],
      };

     LH_AP_CODE =  data['LH_AP_CODE'];
     LH_AP_NAME = data['LH_AP_NAME'];
    LH_CUR_CODE =  data['LH_CUR_CODE'];
    LH_RATE=  data['LH_RATE'];
    P_RECEIVE_NO =  data['P_RECEIVE_NO'];
    // P_ERP_OU_CODE =  data['P_ERP_OU_CODE'];
    //  P_OU_CODE = data['P_OU_CODE'];
    P_LIN_ID =  data['P_LIN_ID'];
    V_DS_PDF =  data['V_DS_PDF'];
    LH_PONO =  data['LH_PONO'];
     LH_REF_DOC_NO =  data['LH_REF_DOC_NO'];
    LH_INV_NO =  data['LH_INV_NO'];
    LH_CONF_DATE =  data['LH_CONF_DATE'];
     LH_RECEIVE_DATE = data['LH_RECEIVE_DATE'];
    LH_REF_DOC_DATE =  data['LH_REF_DOC_DATE'];
    LH_INV_DATE =  data['LH_INV_DATE'];
    LB_NO = data['LB_NO'];
    LB_ITEM_CODE =   data['LB_ITEM_CODE'];
     LB_ITEM_NAME =  data['LB_ITEM_NAME'];
    LB_WH =   data['LB_WH'];
    LB_QTY = data['LB_QTY'];
    LB_UNIT = data['LB_UNIT'];
    LB_REMARK =  data['LB_REMARK'];
    LT_REMARK =  data['LT_REMARK'];
     LT_DATE = data['LT_DATE'];
    LT_SIGN1 = data['LT_SIGN1'];
    LT_SIGN2 = data['LT_SIGN2'];
    LT_SIGN3 = data['LT_SIGN3'];

    } else {
      print('Failed to load data, status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}

  Future<void> sendGetRequestlineWMS() async {
    final url =
        'http://172.16.0.82:8888/apex/wms/c/pull_po/${widget.poReceiveNo}';

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

        setState(() {
          dataList =
              List<Map<String, dynamic>>.from(responseData['items'] ?? []);
        });
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
          'http://172.16.0.82:8888/apex/wms/c/Submit_ver/${widget.poReceiveNo}'));
      print(widget.poReceiveNo);
      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final jsonData = json.decode(responseBody);
        setState(() {
          poStatus = jsonData['po_status'];
          poMessage = jsonData['po_message'];
          erp_doc_no = jsonData['v_erp_doc_no'];
          print(response.statusCode);
          print(jsonData);
          print(poStatus);
          print(poMessage);
        });
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
      backgroundColor: Color(0xFF17153B),
      appBar: CustomAppBar(title: 'รับจากการสั่งซื้อ'),
      // drawer: const CustomDrawer(),
      body: Column(
        children: [
          Expanded(
            child: dataList.isEmpty
                ? Center(
                    child: Text('No data available',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)))
                : SingleChildScrollView(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: dataList.map((data) {
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          elevation: 6.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Item: ${data['item'] ?? 'N/A'}',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepPurple,
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Row(
                                  children: [
                                    Icon(Icons.assignment,
                                        color: Colors.grey[700]),
                                    SizedBox(width: 8.0),
                                    Expanded(
                                      child: Text(
                                        'จำนวนรับ: ${data['receive_qty']?.toString() ?? 'N/A'}',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4.0),
                                Row(
                                  children: [
                                    Icon(Icons.pending,
                                        color: Colors.orange[700]),
                                    SizedBox(width: 8.0),
                                    Expanded(
                                      child: Text(
                                        'Pending Quantity: ${data['pending_qty']?.toString() ?? 'N/A'}',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4.0),
                                Row(
                                  children: [
                                    Icon(Icons.location_on,
                                        color: Colors.blue[700]),
                                    SizedBox(width: 8.0),
                                    Expanded(
                                      child: Text(
                                        'Locator: ${data['locator_det']?.toString() ?? 'N/A'}',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4.0),
                                Row(
                                  children: [
                                    Icon(Icons.check, color: Colors.blue[700]),
                                    SizedBox(width: 8.0),
                                    Expanded(
                                      child: Text(
                                        'Product No: ${data['lot_product_no']?.toString() ?? 'N/A'}',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4.0),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child:ElevatedButton(
  onPressed: _launchUrl,
  child: Text('Open PDF Report'),
)
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                chk_sub();
                if (poStatus == '0') {

                  showCustomDialog(context);
                  
                } else if (poStatus == '1') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(poMessage!)),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: EdgeInsets.symmetric(vertical: 15.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: Text(
                'ยืนยัน',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomBar(),
    );
  }

  void showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ยืนยัน'),
          content: Text('ยืนยันหรือไม่?'),
          actions: [
            TextButton(
              child: Text('ยกเลิก'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('ยืนยัน'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
