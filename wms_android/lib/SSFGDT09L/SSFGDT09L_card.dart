import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/custom_appbar.dart';
import 'package:wms_android/Global_Parameter.dart' as globals;
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'SSFGDT09L_form.dart';
import 'SSFGDT09L_grid.dart';

class Ssfgdt09lCard extends StatefulWidget {
  final String pErpOuCode;
  final String pOuCode;
  final String pAttr1;
  final String pAppUser;
  final int pFlag;
  final String pStatusDESC; // สถานะที่เลือก
  final String pSoNo; // เลขที่ใบตรวจนับ
  final String pDocDate; // date format dd-MM-yyyy
  final String pWareCode;

  Ssfgdt09lCard({
    Key? key,
    required this.pErpOuCode,
    required this.pOuCode,
    required this.pAttr1,
    required this.pAppUser,
    required this.pFlag,
    required this.pStatusDESC,
    required this.pSoNo,
    required this.pDocDate,
    required this.pWareCode,
  }) : super(key: key);
  @override
  _Ssfgdt09lCardState createState() => _Ssfgdt09lCardState();
}

class _Ssfgdt09lCardState extends State<Ssfgdt09lCard> {
  List<dynamic> dataCard = [];
  String statusCard = '';
  String messageCard = '';
  String goToStep = '';
  String pDocNoGetInHead = '';
  String pDocTypeGetInHead = '';
  String formattedDateDocDate = '';

  String broeserLanguage = globals.BROWSER_LANGUAGE;
  String sessionID = globals.APP_SESSION;
  String pDsPdf = globals.P_DS_PDF;

  // PDF
  String? V_DS_PDF;
  String? LIN_ID;
  String? OU_CODE;
  String? PROGRAM_NAME;
  String? CURRENT_DATE;
  String? USER_ID;
  String? PROGRAM_ID;
  String? P_WARE;
  String? P_SESSION;

  String? S_DOC_TYPE;
  String? S_DOC_DATE;
  String? S_DOC_NO;
  String? E_DOC_TYPE;
  String? E_DOC_DATE;
  String? E_DOC_NO;
  String? FLAG;

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

  String? LB_SEQ;
  String? LB_ITEM_CODE;
  String? LB_ITEM_NAME;
  String? LB_LOCATION;
  String? LB_UMS;
  String? LB_LOTS_PRODUCT;
  String? LB_MO_NO;
  String? LB_TRAN_QTY;
  String? LB_ATTRIBUTE1;
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
    print(
        'pErpOuCode : ${widget.pErpOuCode} Type : ${widget.pErpOuCode.runtimeType}');
    print('pAttr1 : ${widget.pAttr1} Type : ${widget.pAttr1.runtimeType}');
    print(
        'pAppUser : ${widget.pAppUser} Type : ${widget.pAppUser.runtimeType}');
    print('pFlag : ${widget.pFlag} Type : ${widget.pFlag.runtimeType}');
    print(
        'pStatusDESC : ${widget.pStatusDESC} Type : ${widget.pStatusDESC.runtimeType}');
    print('pSoNo : ${widget.pSoNo} Type : ${widget.pSoNo.runtimeType}');
    print(
        'pDocDate : ${widget.pDocDate} Type : ${widget.pDocDate.runtimeType}');
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
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGDT09L/SSFGDT09L_Step_1_SearchCard/${widget.pErpOuCode}/${widget.pAttr1}/${widget.pAppUser}/${widget.pStatusDESC}/${widget.pSoNo}/${widget.pDocDate}'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $jsonDecode');

        setState(() {
          dataCard =
              List<Map<String, dynamic>>.from(responseData['items'] ?? []);
        });
        print('dataCard : $dataCard');
      } else {
        throw Exception('Failed to load fetchData');
      }
    } catch (e) {
      setState(() {});
      print('ERROR IN Fetch Data : $e');
    }
  }

  Future<void> checkStatusCard(
      String pReceiveNo, String pDocNo, String pDocType) async {
    print('po_status $pReceiveNo Type: ${pReceiveNo.runtimeType}');
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGDT09L/SSFGDT09L_Step_1_check_ISSDirect_validate/${widget.pOuCode}/${widget.pErpOuCode}/$pReceiveNo'));

      if (response.statusCode == 200) {
        // ถอดรหัสข้อมูล JSON จาก response
        final Map<String, dynamic> dataStatusCard = jsonDecode(utf8
            .decode(response.bodyBytes)); // ถอดรหัส response body เป็น UTF-8
        print(
            'dataStatusCard : $dataStatusCard type : ${dataStatusCard.runtimeType}');

        //
        print('Fetched data: $jsonDecode');

        setState(() {
          // statusCard = dataStatusCard['po_status'] ?? '';
          // messageCard = dataStatusCard['po_message'] ?? '';
          // goToStep = dataStatusCard['po_goto_step'] ?? '';
          checkGoTostep(
            dataStatusCard['po_status'] ?? '',
            dataStatusCard['po_message'] ?? '',
            dataStatusCard['po_goto_step'] ?? '',
            pDocNo,
            pDocType,
          );

          print(
              'po_status : ${dataStatusCard['po_status']} Type: ${dataStatusCard['po_status'.runtimeType]}');
          print(
              'po_message : ${dataStatusCard['po_message']} Type: ${dataStatusCard['po_message'.runtimeType]}');
          print(
              'po_goto_step : ${dataStatusCard['po_goto_step']} Type: ${dataStatusCard['po_goto_step'.runtimeType]}');
        });
        // } else {
        //   print('No items found.');
        // }
      } else {
        print(
            'checkStatusCard Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {});
      print('checkStatusCard ERROR IN Fetch Data : $e');
    }
  }

  void checkGoTostep(String statusCard, String messageCard, String goToStep,
      String pDocNo, String pDocType) {
    //
    print('statusCard : $statusCard Type : ${statusCard.runtimeType}');
    print('messageCard : $messageCard Type : ${messageCard.runtimeType}');
    print('goToStep : $goToStep Type : ${goToStep.runtimeType}');
    if (statusCard == '1') {
      showMessageStatusCard(context, messageCard);
    }
    if (statusCard == '0') {
      getInhead(
        goToStep,
        pDocNo,
        pDocType,
      );
    }
  }

  Future<void> getInhead(
      String goToStep, String pDocNo, String pDocType) async {
    print('pDocNo $pDocNo Type: ${pDocNo.runtimeType}');
    print('pDocType $pDocType Type: ${pDocType.runtimeType}');
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGDT09L/SSFGDT09L_Step_1_GET_INHEAD/${widget.pOuCode}/${widget.pErpOuCode}/$sessionID/$pDocNo/$pDocType/${widget.pAppUser}'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> dataGetInHead =
            jsonDecode(utf8.decode(response.bodyBytes));
        print(
            'dataGetInHead : $dataGetInHead type : ${dataGetInHead.runtimeType}');

        //
        print('Fetched data: $jsonDecode');

        setState(() {
          pDocNoGetInHead = dataGetInHead['po_doc_no'] ?? '';
          pDocTypeGetInHead = dataGetInHead['po_doc_type'] ?? '';
          getInheadStpe(
            dataGetInHead['po_doc_no'] ?? '',
            dataGetInHead['po_doc_type'] ?? '',
            dataGetInHead['po_status'],
            dataGetInHead['po_message'],
            goToStep,
          );

          print(
              'po_doc_type : ${dataGetInHead['po_doc_type']} Type: ${dataGetInHead['po_doc_type'.runtimeType]}');
          print(
              'po_doc_no : ${dataGetInHead['po_doc_no']} Type: ${dataGetInHead['po_doc_no'.runtimeType]}');
          print(
              'po_status : ${dataGetInHead['po_status']} Type: ${dataGetInHead['po_status'.runtimeType]}');
          print(
              'po_message : ${dataGetInHead['po_message']} Type: ${dataGetInHead['po_message'.runtimeType]}');
        });
        // } else {
        //   print('No items found.');
        // }
      } else {
        print(
            'getInhead Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {});
      print('getInhead ERROR IN Fetch Data : $e');
    }
  }

  void getInheadStpe(String pDocNoGetInHead, String pDocTypeGetInHead,
      String poStatus, String poMessage, String goToStep) {
    if (poStatus == '1') {
      showMessageStatusCard(context, poMessage);
    }
    if (poStatus == '0') {
      switch (goToStep) {
        case '2':
          return _navigateToPage(
              context,
              Ssfgdt09lForm(
                  pWareCode: widget.pErpOuCode,
                  pAttr1: widget.pAttr1,
                  // pDocNo: 'RMO1-WMS-24090028',
                  // pDocType: 'RMO1',
                  pDocNo: pDocNoGetInHead,
                  pDocType: pDocTypeGetInHead,
                  pOuCode: widget.pOuCode,
                  pErpOuCode: widget.pErpOuCode));
        case '3':
          return _navigateToPage(
              context,
              Ssfgdt09lGrid(
                pWareCode: widget.pErpOuCode,
                pAttr1: widget.pAttr1,
                // docNo: 'RMO1-WMS-24090028',
                // docType: 'RMO1',
                docNo: pDocNoGetInHead,
                docType: pDocTypeGetInHead,
                docDate: formattedDateDocDate,
                pErpOuCode: widget.pErpOuCode,
                pOuCode: widget.pOuCode,
                pAppUser: globals.APP_USER,
                moDoNo: '230303001',
                // test
                statusCase: 'test3',
              ));
        case '4':
          return _navigateToPage(
              context,
              Ssfgdt09lGrid(
                pWareCode: widget.pErpOuCode,
                pAttr1: widget.pAttr1,
                // docNo: 'RMO1-WMS-24090028',
                // docType: 'RMO1',
                docNo: pDocNoGetInHead,
                docType: pDocTypeGetInHead,
                docDate: formattedDateDocDate,
                pErpOuCode: widget.pErpOuCode,
                pOuCode: widget.pOuCode,
                pAppUser: globals.APP_USER,
                moDoNo: '230303001',
                // test
                statusCase: 'test4',
              ));
        default:
          return null;
      }
    }
  }

  // Future<void> getPDF(String docNo, String docType, String docDate) async {
  //   try {
  //     final response = await http.get(Uri.parse(
  //         'http://172.16.0.82:8888/apex/wms/SSFGDT09L/SSFGDT09L_Step_1_GET_PDF/$broeserLanguage/${widget.pErpOuCode}/${widget.pAppUser}/${widget.pWareCode}/$sessionID/$docType/$docDate/$docNo/${widget.pFlag}/$pDsPdf'));

  //     print(
  //         'http://172.16.0.82:8888/apex/wms/SSFGDT09L/SSFGDT09L_Step_1_GET_PDF/$broeserLanguage/${widget.pErpOuCode}/${widget.pAppUser}/${widget.pWareCode}/$sessionID/$docType/$docDate/$docNo/${widget.pFlag}/$pDsPdf');
  //     if (response.statusCode == 200) {
  //       final Map<String, dynamic> data =
  //           jsonDecode(utf8.decode(response.bodyBytes));
  //       final List<dynamic> items = data['items'];
  //       print(items);
  //       if (items.isNotEmpty) {
  //         final Map<String, dynamic> item = items[0];
  //         print('Fetched data: $jsonDecode');
  //         print('data $data');

  //         setState(() {
  // V_DS_PDF = item['V_DS_PDF'] ?? '';
  // LIN_ID = item['LIN_ID'] ?? '';
  // OU_CODE = item['OU_CODE'] ?? '';
  // PROGRAM_NAME = item['PROGRAM_NAME'] ?? '';
  // CURRENT_DATE = item['CURRENT_DATE'] ?? '';
  // USER_ID = item['USER_ID'] ?? '';
  // PROGRAM_ID = item['PROGRAM_ID'] ?? '';
  // P_WARE = item['P_WARE'] ?? '';
  // P_SESSION = item['P_SESSION'] ?? '';

  // S_DOC_TYPE = item['S_DOC_TYPE'] ?? '';
  // S_DOC_DATE = item['S_DOC_DATE'] ?? '';
  // S_DOC_NO = item['S_DOC_NO'] ?? '';
  // E_DOC_TYPE = item['E_DOC_TYPE'] ?? '';
  // E_DOC_DATE = item['E_DOC_DATE'] ?? '';
  // E_DOC_NO = item['E_DOC_NO'] ?? '';
  // FLAG = item['FLAG'] ?? '';

  // LH_PAGE = item['LH_PAGE'] ?? '';
  // LH_DATE = item['LH_DATE'] ?? '';
  // LH_AR_NAME = item['LH_AR_NAME'] ?? '';
  // LH_LOGISTIC_COMP = item['LH_LOGISTIC_COMP'] ?? '';
  // LH_DOC_TYPE = item['LH_DOC_TYPE'] ?? '';
  // LH_WARE = item['LH_WARE'] ?? '';
  // LH_CAR_ID = item['LH_CAR_ID'] ?? '';
  // LH_DOC_NO = item['LH_DOC_NO'] ?? '';
  // LH_DOC_DATE = item['LH_DOC_DATE'] ?? '';
  // LH_INVOICE_NO = item['LH_INVOICE_NO'] ?? '';

  // LB_SEQ = item['LB_SEQ'] ?? '';
  // LB_ITEM_CODE = item['LB_ITEM_CODE'] ?? '';
  // LB_ITEM_NAME = item['LB_ITEM_NAME'] ?? '';
  // LB_LOCATION = item['LB_LOCATION'] ?? '';
  // LB_UMS = item['LB_UMS'] ?? '';
  // // LB_LOTS_PRODUCT = item['LB_LOTS_PRODUCT'] ?? '';
  // // LB_MO_NO = item['LB_MO_NO'] ?? '';          ////-------////
  // LB_TRAN_QTY = item['LB_TRAN_QTY'] ?? '';
  // // LB_ATTRIBUTE1 = item['LB_ATTRIBUTE1'] ?? '';
  // LT_NOTE = item['LT_NOTE'] ?? '';
  // LT_TOTAL_QTY = item['LT_TOTAL_QTY'] ?? '';
  // LT_ISSUE = item['LT_ISSUE'] ?? '';
  // LT_APPROVE = item['LT_APPROVE'] ?? '';
  // LT_OUT = item['LT_OUT'] ?? '';
  // LT_RECEIVE = item['LT_RECEIVE'] ?? '';
  // LT_BILL = item['LT_BILL'] ?? '';
  // LT_CHECK = item['LT_CHECK'] ?? '';

  //           _launchUrl(docNo);
  //         });
  //       } else {
  //         print('No items found.');
  //       }
  //     } else {
  //       print(
  //           'fetchData 555555555    Failed to load data. Status code: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('1');
  //     print('Error Get PDF: $e');
  //   }
  // }

  Future<void> getPDF(String docNo, String docType, String docDate) async {
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGDT09L/SSFGDT09L_Step_1_GET_PDF/$broeserLanguage/${widget.pErpOuCode}/${widget.pAppUser}/${widget.pWareCode}/$sessionID/$docType/$docDate/$docNo/${widget.pFlag}/$pDsPdf'));

      print('Response body: ${response.body}'); // แสดงข้อมูลที่ได้รับจาก API

      if (response.statusCode == 200) {
        // ถอดรหัสข้อมูล JSON จาก response
        final Map<String, dynamic> dataPDF = jsonDecode(utf8
            .decode(response.bodyBytes)); // ถอดรหัส response body เป็น UTF-8
        print('dataPDF : $dataPDF type : ${dataPDF.runtimeType}');
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
          LH_CAR_ID = dataPDF['LH_CAR_ID'] ?? '';
          LH_DOC_NO = dataPDF['LH_DOC_NO'] ?? '';
          LH_DOC_DATE = dataPDF['LH_DOC_DATE'] ?? '';
          LH_INVOICE_NO = dataPDF['LH_INVOICE_NO'] ?? '';

          LB_SEQ = dataPDF['LB_SEQ'] ?? '';
          LB_ITEM_CODE = dataPDF['LB_ITEM_CODE'] ?? '';
          LB_ITEM_NAME = dataPDF['LB_ITEM_NAME'] ?? '';
          LB_LOCATION = dataPDF['LB_LOCATION'] ?? '';
          LB_UMS = dataPDF['LB_UMS'] ?? '';
          // LB_LOTS_PRODUCT = item['LB_LOTS_PRODUCT'] ?? '';
          // LB_MO_NO = item['LB_MO_NO'] ?? '';          ////-------////
          LB_TRAN_QTY = dataPDF['LB_TRAN_QTY'] ?? '';
          // LB_ATTRIBUTE1 = item['LB_ATTRIBUTE1'] ?? '';
          LT_NOTE = dataPDF['LT_NOTE'] ?? '';
          LT_TOTAL_QTY = dataPDF['LT_TOTAL_QTY'] ?? '';
          LT_ISSUE = dataPDF['LT_ISSUE'] ?? '';
          LT_APPROVE = dataPDF['LT_APPROVE'] ?? '';
          LT_OUT = dataPDF['LT_OUT'] ?? '';
          LT_RECEIVE = dataPDF['LT_RECEIVE'] ?? '';
          LT_BILL = dataPDF['LT_BILL'] ?? '';
          LT_CHECK = dataPDF['LT_CHECK'] ?? '';

          _launchUrl(docNo);
        });
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
        '&_dataSource=$pDsPdf'
        '&_outFilename=$pDocNo.pdf'
        '&_repLocale=en_US'
        '&V_DS_PDF=$V_DS_PDF'
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
        '&E_DOC_TYPE=$E_DOC_TYPE'
        '&E_DOC_DATE=$E_DOC_DATE'
        '&E_DOC_NO=$E_DOC_NO'
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
        '&LB_TRAN_QTY=$LB_TRAN_QTY'
        '&LB_ATTRIBUTE1=$LB_ATTRIBUTE1'
        '&LT_NOTE=$LT_NOTE'
        '&LT_TOTAL_QTY=$LT_TOTAL_QTY'
        '&LT_ISSUE=$LT_ISSUE'
        '&LT_APPROVE=$LT_APPROVE'
        '&LT_OUT=$LT_OUT'
        '&LT_RECEIVE=$LT_RECEIVE'
        '&LT_BILL=$LT_BILL'
        '&LT_CHECK=$LT_CHECK');

    print(uri);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
    print('http://172.16.0.82:8888/jri/report?'
        '&_repName=/WMS/SSFGOD02A5'
        '&_repFormat=pdf'
        '&_dataSource=$pDsPdf'
        '&_outFilename=$pDocNo.pdf'
        '&_repLocale=en_US'
        '&V_DS_PDF=$V_DS_PDF'
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
        '&E_DOC_TYPE=$E_DOC_TYPE'
        '&E_DOC_DATE=$E_DOC_DATE'
        '&E_DOC_NO=$E_DOC_NO'
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
        '&LB_TRAN_QTY=$LB_TRAN_QTY'
        '&LB_ATTRIBUTE1=$LB_ATTRIBUTE1'
        '&LT_NOTE=$LT_NOTE'
        '&LT_TOTAL_QTY=$LT_TOTAL_QTY'
        '&LT_ISSUE=$LT_ISSUE'
        '&LT_APPROVE=$LT_APPROVE'
        '&LT_OUT=$LT_OUT'
        '&LT_RECEIVE=$LT_RECEIVE'
        '&LT_BILL=$LT_BILL'
        '&LT_CHECK=$LT_CHECK');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF17153B),
      appBar: CustomAppBar(title: 'เบิกจ่าย'),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: dataCard.map((item) {
                  Color cardColor;
                  String statusText;
                  String iconImageYorN;
                  print(item['card_status_desc']);
                  switch (item['card_status_desc']) {
                    case 'ระหว่างบันทึก':
                      cardColor = Color.fromRGBO(246, 250, 112, 1.0);
                      statusText = 'ระหว่างบันทึก';
                      break;
                    case 'ยืนยันการรับ':
                      cardColor = Color.fromRGBO(146, 208, 80, 1.0);
                      statusText = 'ยืนยันการรับ';
                      break;
                    case 'ยกเลิก':
                      cardColor = Color.fromRGBO(208, 206, 206, 1.0);
                      statusText = 'ยกเลิก';
                      break;
                    case 'ยืนยันการจ่าย':
                      cardColor = Color.fromRGBO(255, 255, 255, 1.0);
                      statusText = 'ยืนยันการจ่าย';
                      break;
                    case 'ปกติ':
                      cardColor = Color.fromRGBO(255, 255, 255, 1.0);
                      statusText = 'ยืนยันการจ่าย';
                      break;
                    case 'อ้างอิงแล้ว':
                      cardColor = Color.fromRGBO(255, 255, 255, 1.0);
                      statusText = 'อ้างอิงแล้ว';
                      break;
                    default:
                      cardColor = Color.fromRGBO(255, 255, 255, 1.0);
                      statusText = 'Unknown';
                  }

                  switch (item['qc_yn']) {
                    case 'Y':
                      iconImageYorN = 'assets/images/rt_machine_on.png';
                      break;
                    case 'N':
                      iconImageYorN = 'assets/images/rt_machine_off.png';
                      break;
                    default:
                      iconImageYorN = 'assets/images/rt_machine_off.png';
                  }

                  return Card(
                    elevation: 8.0,
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    color: Color.fromRGBO(204, 235, 252, 1.0),
                    child: InkWell(
                      onTap: () {
                        checkStatusCard(item['po_no'] ?? '',
                            item['p_doc_no'] ?? '', item['p_doc_type'] ?? '');

                        print(
                            'po_no in Card : ${item['po_no']} Type : ${item['po_no'].runtimeType}');
                        print(
                            'p_doc_no in Card : ${item['p_doc_no']} Type : ${item['p_doc_no'].runtimeType}');
                        print(
                            'p_doc_type in Card : ${item['p_doc_type']} Type : ${item['p_doc_type'].runtimeType}');
                      },
                      borderRadius: BorderRadius.circular(15.0),
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      DateTime parsedDate =
                                          DateFormat('dd/MM/yyyy')
                                              .parse(item['po_date']);
                                      String formattedDate =
                                          DateFormat('dd-MM-yyyy')
                                              .format(parsedDate);

                                      formattedDateDocDate = formattedDate;
                                      getPDF(
                                        item['p_doc_no'],
                                        item['p_doc_type'],
                                        formattedDate,
                                      );
                                    });
                                  },
                                  child: Container(
                                    width: 100,
                                    height: 40,
                                    // color: cardColor, // เปลี่ยนสีพื้นหลังที่นี่
                                    child: Image.asset(
                                      'assets/images/printer.png',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20.0),
                                Text(
                                  '${item['po_date']} ${item['po_no']} ${item['item_stype_desc']}',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                          // Positioned สำหรับสถานะ
                          if (statusText != 'Unknown')
                            Positioned(
                              top: 8.0,
                              right: 8.0,
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12.0, vertical: 6.0),
                                    decoration: BoxDecoration(
                                      color: cardColor,
                                      borderRadius: BorderRadius.circular(12.0),
                                      border: Border.all(
                                          color: cardColor, width: 2.0),
                                    ),
                                    child: Text(
                                      statusText,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  // SizedBox(height: 5.0),
                                  SizedBox(
                                    width: 100,
                                    height: 40,
                                    child: Image.asset(
                                      iconImageYorN,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
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
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(),
    );
  }

  void showMessageStatusCard(
    BuildContext context,
    String messageCard,
  ) {
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
              SizedBox(width: 10),
              Text(
                'Error',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Text(
                    messageCard,
                    style: TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: BorderSide(color: Colors.grey),
                        ),
                        child: const Text('ย้อนกลับ'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
