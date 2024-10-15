import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:wms_android/styles.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/custom_appbar.dart';
import 'package:wms_android/Global_Parameter.dart' as globals;
import 'SSFGDT09L_main.dart';

class Ssfgdt09lVerify extends StatefulWidget {
  final String pErpOuCode;
  final String pOuCode;
  final String docNo;
  final String docType;
  final String docDate;
  final String moDoNo;
  final String pWareCode;
  // final String pAttr1;
  // // final String refNo;
  // final String pAppUser;
  // final String statusCase;
  Ssfgdt09lVerify({
    Key? key,
    required this.pErpOuCode,
    required this.pOuCode,
    required this.docNo,
    required this.docType,
    required this.docDate,
    required this.moDoNo,
    required this.pWareCode,
    // required this.pAttr1,
    // // required this.refNo,
    // required this.pAppUser,
    // required this.statusCase,
  }) : super(key: key);
  @override
  _Ssfgdt09lVerifyState createState() => _Ssfgdt09lVerifyState();
}

class _Ssfgdt09lVerifyState extends State<Ssfgdt09lVerify> {
  List<dynamic> dataCard = [];

  String poTypeComplete = '';
  String poErpDocNo = '';
  String poStatusSubmit = '';
  String poMessageSubmit = '';
  String flag = '1';

  bool isLoading = false;

// ---------------------------- P ---------------------------- \\
  String? V_DS_PDF;
  String? LIN_ID;
  String? OU_CODE;
  String? PROGRAM_NAME;
  String? CURRENT_DATE;
  String? USER_ID;
  String? PROGRAM_ID;
  String? P_WARE;
  String? P_SESSION;
  String? P_DOC_TYPE;
  String? P_ERP_DOC_NO;
// ---------------------------- S ---------------------------- \\
  String? S_DOC_TYPE;
  String? S_DOC_DATE;
  String? S_DOC_NO;
  String? E_DOC_TYPE;
  String? E_DOC_DATE;
  String? E_DOC_NO;
  String? FLAG;
// ---------------------------- LH ---------------------------- \\
  String? LH_PAGE;
  String? LH_DATE;
  String? LH_AR_NAME;
  String? LH_LOGISTIC_COMP;
  String? LH_DOC_TYPE;
  String? LH_WARE;
  String? LH_CAR_ID;
  String? LH_DOC_NO;
  String? LH_DOC_DATE;
  String? LH_INVOICE_NO;
// ---------------------------- LB ---------------------------- \\
  String? LB_SEQ;
  String? LB_ITEM_CODE;
  String? LB_ITEM_NAME;
  String? LB_LOCATION;
  String? LB_UMS;
  String? LB_LOTS_PRODUCT;
  String? LB_MO_NO;
  String? LB_TRAN_Qty;
  String? LB_ATTRIBUTE1;
// ---------------------------- LT ---------------------------- \\
  String? LT_NOTE;
  String? LT_TOTAL_QTY;
  String? LT_ISSUE;
  String? LT_APPROVE;
  String? LT_OUT;
  String? LT_RECEIVE;
  String? LT_BILL;
  String? LT_CHECK;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  Future<void> fetchData() async {
    isLoading = true;
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGDT09L/SSFGDT09L_Step_5_SelectDetailCard/${widget.pOuCode}/${widget.pErpOuCode}/${widget.docNo}/${widget.docType}'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $responseData');
        if (mounted) {
          setState(() {
            dataCard =
                List<Map<String, dynamic>>.from(responseData['items'] ?? []);

            isLoading = false;
          });
        }
        print('dataCard : $dataCard');
      } else {
        throw Exception('Failed to load fetchData');
      }
    } catch (e) {
      if (mounted) {
        setState(() {});
      }
      print('ERROR IN Fetch Data : $e');
    }
  }

  Future<void> submitData() async {
    final url =
        'http://172.16.0.82:8888/apex/wms/SSFGDT09L/SSFGDT09L_Step_5_Submit';

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'p_erp_ou_code': widget.pErpOuCode,
      'p_doc_no': widget.docNo,
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
            poTypeComplete = data['po_type_complete'];
            poErpDocNo = data['po_erp_doc_no'];
            poStatusSubmit = data['po_status'];
            poMessageSubmit = data['po_message'];

            print(
                'poTypeComplete : $poTypeComplete Type : ${poTypeComplete.runtimeType}');
            print('poErpDocNo : $poErpDocNo Type : ${poErpDocNo.runtimeType}');
            print(
                'poStatusSubmit : $poStatusSubmit Type : ${poStatusSubmit.runtimeType}');
            print(
                'poMessageSubmit : $poMessageSubmit Type : ${poMessageSubmit.runtimeType}');

            if (poStatusSubmit == '1') {
              showDialogAlert(context, poMessageSubmit);
            }
            if (poStatusSubmit == '0') {
              showDialogPoDocNo(context, poTypeComplete, poErpDocNo);
            }
          });
        }
      } else {
        // จัดการกรณีที่ response status code ไม่ใช่ 200
        print('โพสต์ข้อมูลล้มเหลว. รหัสสถานะ: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> getPDF(String poErpDocNo, String poTypeComplete) async {
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGDT09L/SSFGDT09L_Step_5_GET_PDF/${widget.docType}/${widget.docDate}/$poErpDocNo/$flag/${widget.pWareCode}/${globals.APP_SESSION}/${globals.APP_USER}/${globals.P_DS_PDF}'));

      print('Response body: ${response.body}'); // แสดงข้อมูลที่ได้รับจาก API

      if (response.statusCode == 200) {
        // ถอดรหัสข้อมูล JSON จาก response
        final Map<String, dynamic> dataPDF = jsonDecode(utf8
            .decode(response.bodyBytes)); // ถอดรหัส response body เป็น UTF-8
        print('dataPDF : $dataPDF type : ${dataPDF.runtimeType}');
        if (mounted) {
          setState(() {
            V_DS_PDF = dataPDF['V_DS_PDF'] ?? '';
            LIN_ID = dataPDF['LIN_ID'] ?? '';
            OU_CODE = dataPDF['OU_CODE'] ?? '';
            PROGRAM_NAME = dataPDF['PROGRAM_NAME'] ?? '';
            CURRENT_DATE = dataPDF['CURRENT_DATE'] ?? '';
            USER_ID = dataPDF['USER_ID'] ?? '';
            PROGRAM_ID = dataPDF['PROGRAM_ID'] ?? '';
            P_WARE = dataPDF['P_WARE'] ?? '';
            P_SESSION = dataPDF['P_SESSION'] ?? '';

            S_DOC_TYPE = dataPDF['S_DOC_TYPE'] ?? '';
            S_DOC_DATE = dataPDF['S_DOC_DATE'] ?? '';
            S_DOC_NO = dataPDF['S_DOC_NO'] ?? '';
            E_DOC_TYPE = dataPDF['E_DOC_TYPE'] ?? '';
            E_DOC_DATE = dataPDF['E_DOC_DATE'] ?? '';
            E_DOC_NO = dataPDF['E_DOC_NO'] ?? '';
            FLAG = dataPDF['FLAG'] ?? '';

            LH_PAGE = dataPDF['LH_PAGE'] ?? '';
            LH_DATE = dataPDF['LH_DATE'] ?? '';
            LH_AR_NAME = dataPDF['LH_AR_NAME'] ?? '';
            LH_LOGISTIC_COMP = dataPDF['LH_LOGISTIC_COMP'] ?? '';
            LH_DOC_TYPE = dataPDF['LH_DOC_TYPE'] ?? '';
            LH_WARE = dataPDF['LH_WARE'] ?? '';
            LH_DOC_NO = dataPDF['LH_DOC_NO'] ?? '';
            LH_DOC_DATE = dataPDF['LH_DOC_DATE'] ?? '';
            LH_INVOICE_NO = dataPDF['LH_INVOICE_NO'] ?? '';

            LB_SEQ = dataPDF['LB_SEQ'] ?? '';
            LB_ITEM_CODE = dataPDF['LB_ITEM_CODE'] ?? '';
            LB_ITEM_NAME = dataPDF['LB_ITEM_NAME'] ?? '';
            LB_LOCATION = dataPDF['LB_LOCATION'] ?? '';
            LB_UMS = dataPDF['LB_UMS'] ?? '';
            LB_MO_NO = dataPDF['LB_MO_NO'] ?? '';
            LB_TRAN_Qty = dataPDF['LB_TRAN_Qty'] ?? '';
            // LB_ATTRIBUTE1 = dataPDF['LB_ATTRIBUTE1'] ?? '';

            LT_NOTE = dataPDF['LT_NOTE'] ?? '';
            LT_TOTAL_QTY = dataPDF['LT_TOTAL_QTY'] ?? '';
            LT_ISSUE = dataPDF['LT_ISSUE'] ?? '';
            LT_APPROVE = dataPDF['LT_APPROVE'] ?? '';
            LT_OUT = dataPDF['LT_OUT'] ?? '';
            LT_RECEIVE = dataPDF['LT_RECEIVE'] ?? '';
            LT_BILL = dataPDF['LT_BILL'] ?? '';
            LT_CHECK = dataPDF['LT_CHECK'] ?? '';

            _launchUrl(poErpDocNo);
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

  Future<void> _launchUrl(String pDocNo) async {
    final uri = Uri.parse('http://172.16.0.82:8888/jri/report?'
        '&_repName=/WMS/SSFGOD02A5'
        '&_repFormat=pdf'
        '&_dataSource=${globals.P_DS_PDF}'
        '&_outFilename=$pDocNo.pdf'
        '&_repLocale=en_US'
        '&LIN_ID=$LIN_ID'
        '&OU_CODE=$OU_CODE'
        '&PROGRAM_NAME=$PROGRAM_NAME'
        '&CURRENT_DATE=$CURRENT_DATE'
        '&USER_ID=$USER_ID'
        '&PROGRAM_ID=$PROGRAM_ID'
        '&P_WARE=$P_WARE'
        '&P_SESSION=$P_SESSION'
        '&S_DOC_TYPE=$S_DOC_TYPE'
        '&S_DOC_DATE=$S_DOC_DATE'
        '&S_DOC_NO=$S_DOC_NO'
        '&E_DOC_TYPE=$E_DOC_TYPE'
        '&E_DOC_DATE=$E_DOC_DATE'
        '&FLAG=$FLAG'
        '&LH_PAGE=$LH_PAGE'
        '&LH_DATE=$LH_DATE'
        '&LH_AR_NAME=$LH_AR_NAME'
        '&LH_LOGISTIC_COMP=$LH_LOGISTIC_COMP'
        '&LH_DOC_TYPE=$LH_DOC_TYPE'
        '&LH_WARE=$LH_WARE'
        '&LH_CAR_ID=$LH_CAR_ID'
        '&LH_DOC_NO=$LH_DOC_NO'
        '&LH_DOC_DATE=$LH_DOC_DATE'
        '&LH_INVOICE_NO=$LH_INVOICE_NO'
        '&LB_SEQ=$LB_SEQ'
        '&LB_ITEM_CODE=$LB_ITEM_CODE'
        '&LB_ITEM_NAME=$LB_ITEM_NAME'
        '&LB_LOCATION=$LB_LOCATION'
        '&LB_UMS=$LB_UMS'
        '&LB_LOTS_PRODUCT=$LB_LOTS_PRODUCT'
        '&LB_MO_NO=$LB_MO_NO'
        '&LB_TRAN_Qty=$LB_TRAN_Qty'
        // '&LB_ATTRIBUTE1=$LB_ATTRIBUTE1'
        '&LT_NOTE=$LT_NOTE'
        '&LT_TOTAL_QTY=$LT_TOTAL_QTY'
        '&LT_ISSUE=$LT_ISSUE'
        '&LT_APPROVE=$LT_APPROVE'
        '&LT_OUT=$LT_OUT'
        '&LT_RECEIVE=$LT_RECEIVE'
        '&LT_BILL=$LT_BILL');

    print(uri);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
    print('http://172.16.0.82:8888/jri/report?'
        '&_repName=/WMS/SSFGOD02A5'
        '&_repFormat=pdf'
        '&_dataSource=${globals.P_DS_PDF}'
        '&_outFilename=$pDocNo.pdf'
        '&_repLocale=en_US'
        '&LIN_ID=$LIN_ID'
        '&OU_CODE=$OU_CODE'
        '&PROGRAM_NAME=$PROGRAM_NAME'
        '&CURRENT_DATE=$CURRENT_DATE'
        '&USER_ID=$USER_ID'
        '&PROGRAM_ID=$PROGRAM_ID'
        '&P_WARE=$P_WARE'
        '&P_SESSION=$P_SESSION'
        '&S_DOC_TYPE=$S_DOC_TYPE'
        '&S_DOC_DATE=$S_DOC_DATE'
        '&S_DOC_NO=$S_DOC_NO'
        '&E_DOC_TYPE=$E_DOC_TYPE'
        '&E_DOC_DATE=$E_DOC_DATE'
        '&FLAG=$FLAG'
        '&LH_PAGE=$LH_PAGE'
        '&LH_DATE=$LH_DATE'
        '&LH_AR_NAME=$LH_AR_NAME'
        '&LH_LOGISTIC_COMP=$LH_LOGISTIC_COMP'
        '&LH_DOC_TYPE=$LH_DOC_TYPE'
        '&LH_WARE=$LH_WARE'
        '&LH_CAR_ID=$LH_CAR_ID'
        '&LH_DOC_NO=$LH_DOC_NO'
        '&LH_DOC_DATE=$LH_DOC_DATE'
        '&LH_INVOICE_NO=$LH_INVOICE_NO'
        '&LB_SEQ=$LB_SEQ'
        '&LB_ITEM_CODE=$LB_ITEM_CODE'
        '&LB_ITEM_NAME=$LB_ITEM_NAME'
        '&LB_LOCATION=$LB_LOCATION'
        '&LB_UMS=$LB_UMS'
        '&LB_LOTS_PRODUCT=$LB_LOTS_PRODUCT'
        '&LB_MO_NO=$LB_MO_NO'
        '&LB_TRAN_Qty=$LB_TRAN_Qty'
        // '&LB_ATTRIBUTE1=$LB_ATTRIBUTE1'
        '&LT_NOTE=$LT_NOTE'
        '&LT_TOTAL_QTY=$LT_TOTAL_QTY'
        '&LT_ISSUE=$LT_ISSUE'
        '&LT_APPROVE=$LT_APPROVE'
        '&LT_OUT=$LT_OUT'
        '&LT_RECEIVE=$LT_RECEIVE'
        '&LT_BILL=$LT_BILL');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF17153B),
      appBar: CustomAppBar(title: 'เบิกจ่าย'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  submitData(); // รอ check จาก rujxyho ก่อน **************************************************
                },
                style: AppStyles.ConfirmbuttonStyle(),
                child: Text(
                  'CONFIRM',
                  style: AppStyles.ConfirmbuttonTextStyle(),
                ),
              ),
              // --------------------------------------------------------------------
            ],
          ),
          const SizedBox(height: 10),
          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 5,
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.yellow[200], // พื้นหลังสีเหลืองอ่อน
                    border: Border.all(
                      color: Colors.black, // ขอบสีดำ
                      width: 2.0, // ความกว้างของขอบ 2.0
                    ),
                    borderRadius: BorderRadius.circular(
                        8.0), // เพิ่มมุมโค้งให้กับ Container
                  ),
                  child: Center(
                    child: Text(
                      widget.docNo,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14, // ปรับขนาดตัวอักษรตามที่ต้องการ
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.yellow[200], // พื้นหลังสีเหลืองอ่อน
                    border: Border.all(
                      color: Colors.black, // ขอบสีดำ
                      width: 2.0, // ความกว้างของขอบ 2.0
                    ),
                    borderRadius: BorderRadius.circular(
                        8.0), // เพิ่มมุมโค้งให้กับ Container
                  ),
                  child: Center(
                    child: Text(
                      widget.moDoNo,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14, // ปรับขนาดตัวอักษรตามที่ต้องการ
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),
          // --------------------------------------------------------------------
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : dataCard.isEmpty
                    ? const Center(
                        child: Text(
                          'No data found',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : ListView(
                        children: dataCard.map((item) {
                          return Card(
                            elevation: 8.0,
                            margin: EdgeInsets.symmetric(vertical: 8.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            color: Color.fromRGBO(204, 235, 252, 1.0),
                            child: InkWell(
                              onTap: () {},
                              borderRadius: BorderRadius.circular(15.0),
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          child: Row(
                                            // mainAxisAlignment:
                                            // MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                'Item : ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14.0),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  padding: EdgeInsets.all(5.0),
                                                  color: Colors.white,
                                                  child: Text(
                                                    '${item['item_code'] ?? ''}',
                                                    style: const TextStyle(
                                                        fontSize: 14.0),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        // ------------------------------------------------------------------------\\
                                        const SizedBox(height: 4.0),
                                        // ------------------------------------------------------------------------\\
                                        SizedBox(
                                          child: Row(
                                            // mainAxisAlignment:
                                            // MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                'Lot No. : ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14.0),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  padding: EdgeInsets.all(5.0),
                                                  color: Colors.white,
                                                  child: Text(
                                                    '${item['lots_no'] ?? ''}',
                                                    style: const TextStyle(
                                                        fontSize: 14.0),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        // ------------------------------------------------------------------------\\
                                        const SizedBox(height: 4.0),
                                        // ------------------------------------------------------------------------\\
                                        Row(
                                          children: [
                                            Expanded(
                                              child: SizedBox(
                                                child: Row(
                                                  // mainAxisAlignment:
                                                  // MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    const Text(
                                                      'Locator : ',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14.0),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.all(5.0),
                                                        color: Colors.white,
                                                        child: Text(
                                                          '${item['location_code'] ?? ''}',
                                                          style:
                                                              const TextStyle(
                                                                  fontSize:
                                                                      14.0),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            // ------------------------------------------------------------------------\\
                                            const SizedBox(width: 4.0),
                                            // ------------------------------------------------------------------------\\
                                            Expanded(
                                              child: SizedBox(
                                                child: Row(
                                                  // mainAxisAlignment:
                                                  // MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    const Text(
                                                      'จำนวนที่จ่าย : ',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14.0),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.all(5.0),
                                                        color: Colors.white,
                                                        child: Text(
                                                          '${NumberFormat('#,###,###,###,###,###').format(item['pack_qty'] ?? '')}',
                                                          style:
                                                              const TextStyle(
                                                                  fontSize:
                                                                      14.0),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        // ------------------------------------------------------------------------\\
                                        const SizedBox(height: 4.0),
                                        // ------------------------------------------------------------------------\\
                                        SizedBox(
                                          child: Row(
                                            // mainAxisAlignment:
                                            // MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                'PD Location : ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14.0),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  padding: EdgeInsets.all(5.0),
                                                  color: Colors.white,
                                                  child: Text(
                                                    '${item['pd_location'] ?? ''}',
                                                    style: const TextStyle(
                                                        fontSize: 14.0),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        // ------------------------------------------------------------------------\\
                                        const SizedBox(height: 4.0),
                                        // ------------------------------------------------------------------------\\
                                        SizedBox(
                                          child: Row(
                                            // mainAxisAlignment:
                                            // MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                'Reason : ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14.0),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  padding: EdgeInsets.all(5.0),
                                                  color: Colors.white,
                                                  child: Text(
                                                    '${item['reason_mismatch'] ?? ''}',
                                                    style: const TextStyle(
                                                        fontSize: 14.0),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        // ------------------------------------------------------------------------\\
                                        const SizedBox(height: 4.0),
                                        // ------------------------------------------------------------------------\\
                                        Row(
                                          children: [
                                            Expanded(
                                              child: SizedBox(
                                                child: Row(
                                                  // mainAxisAlignment:
                                                  // MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    const Text(
                                                      'ใช้แทนจุด : ',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14.0),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.all(5.0),
                                                        color: Colors.white,
                                                        child: Text(
                                                          '${item['attribute3'] ?? ''}',
                                                          style:
                                                              const TextStyle(
                                                                  fontSize:
                                                                      14.0),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            // ------------------------------------------------------------------------\\
                                            const SizedBox(width: 4.0),
                                            // ------------------------------------------------------------------------\\
                                            Expanded(
                                              child: SizedBox(
                                                child: Row(
                                                  // mainAxisAlignment:
                                                  // MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    const Text(
                                                      'Replace Lot# ',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14.0),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.all(5.0),
                                                        color: Colors.white,
                                                        child: Text(
                                                          '${item['attribute4'] ?? ''}',
                                                          style:
                                                              const TextStyle(
                                                                  fontSize:
                                                                      14.0),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        // ------------------------------------------------------------------------\\
                                        const SizedBox(height: 4.0),
                                        // ------------------------------------------------------------------------\\
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
          ),
        ]),
      ),
      bottomNavigationBar: BottomBar(
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
                padding: const EdgeInsets.all(3.0),
                child: Column(children: [
                  const SizedBox(height: 10),
                  Text(
                    messageAlert,
                    style: const TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 10),
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

  void showDialogPoDocNo(
    BuildContext context,
    String poTypeComplete,
    String poErpDocNo,
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
                  // Icon(
                  //   Icons.notification_important,
                  //   color: Colors.red,
                  // ),
                  // SizedBox(width: 10),
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
                  const SizedBox(height: 10),
                  Text(
                    poErpDocNo,
                    style: const TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Navigator.of(context).pop();
                          setState(() {
                            String messageText = 'ต้องการพิมพ์เอกสารหรือไม่ ?';
                            showDialogCheckPrint(context, poTypeComplete,
                                poErpDocNo, messageText);
                          });
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

  void showDialogCheckPrint(BuildContext context, String poTypeComplete,
      String poErpDocNo, String messageText) {
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
                  // Icon(
                  //   Icons.notification_important,
                  //   color: Colors.red,
                  // ),
                  // SizedBox(width: 10),
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
                      // Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SSFGDT09L_MAIN(
                                  pAttr1: globals.ATTR1,
                                  pErpOuCode: widget.pErpOuCode,
                                  pOuCode: widget.pOuCode,
                                )),
                      ).then((value) {
                        fetchData();
                      });
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
                  const SizedBox(height: 10),
                  Text(
                    messageText,
                    style: const TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Navigator.of(context).pop();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SSFGDT09L_MAIN(
                                      pAttr1: globals.ATTR1,
                                      pErpOuCode: widget.pErpOuCode,
                                      pOuCode: widget.pOuCode,
                                    )),
                          ).then((value) {
                            fetchData();
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: Colors.grey),
                        ),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Navigator.of(context).pop();
                          getPDF(poErpDocNo, poTypeComplete);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: Colors.grey),
                        ),
                        child: const Text('OK'),
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
