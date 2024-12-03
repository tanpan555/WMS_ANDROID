import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:ui';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/custom_appbar.dart';
import 'package:wms_android/Global_Parameter.dart' as globals;
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:wms_android/styles.dart';
import 'package:wms_android/loading.dart';
import 'package:wms_android/centered_message.dart';
import 'SSFGDT09L_form.dart';
import 'SSFGDT09L_grid.dart';
import 'SSFGDT09L_verify.dart';

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

  bool isLoading = true;
  bool isCardDisabled = false;
  bool isPrintDisabled = false;
  int currentPage = 0;
  final int itemsPerPage = 15;

  ScrollController _scrollController = ScrollController();

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
  String? LH_Doc_Type;
  String? LH_Ware;
  String? LH_CAR_ID;
  // String? LH_Doc_No;
  String? LH_Doc_Date;
  String? LH_INVOICE_NO;
  String? LH_DOC_TYPE;
  String? LH_WARE;
  String? LH_DOC_NO;
  String? LH_DOC_DATE;
  String? LB_ITEM_CODE;
  String? LB_ITEM_NAME;
  String? LB_LOCATION;
  String? LB_UMS;

  String? LB_SEQ;
  String? LB_Item_Code;
  String? LB_Item_Name;
  String? LB_Location;
  String? LB_Ums;
  String? LB_LOTS_PRODUCT;
  String? LB_MO_NO;
  String? LB_TRAN_Qty;
  String? LB_ATTRIBUTE1;
  String? LB_TRAN_QTY;

  String? LT_NOTE;
  String? lt_total_qty;
  String? LT_ISSUE;
  String? LT_APPROVE;
  String? LT_OUT;
  String? LT_RECEIVE;
  String? LT_BILL;
  String? LT_CHECK;
  String? LT_TOTAL_QTY;

  @override
  void initState() {
    super.initState();
    fetchData();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  Future<void> fetchData([String? url]) async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    print(
        '${globals.IP_API}/apex/wms/SSFGDT09L/SSFGDT09L_Step_1_SearchCard/${globals.P_ERP_OU_CODE}/${globals.ATTR1}/${globals.APP_USER}/${widget.pStatusDESC}/${widget.pSoNo}/${widget.pDocDate}/${globals.BROWSER_LANGUAGE}');
    final String requestUrl = url ??
        '${globals.IP_API}/apex/wms/SSFGDT09L/SSFGDT09L_Step_1_SearchCard/${globals.P_ERP_OU_CODE}/${globals.ATTR1}/${globals.APP_USER}/${widget.pStatusDESC}/${widget.pSoNo}/${widget.pDocDate}/${globals.BROWSER_LANGUAGE}';

    try {
      final response = await http.get(Uri.parse(requestUrl));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final parsedResponse = json.decode(responseBody);

        if (mounted) {
          setState(() {
            if (parsedResponse is Map && parsedResponse.containsKey('items')) {
              dataCard = parsedResponse['items'];
            } else {
              dataCard = [];
            }
            isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            print('Failed to load data: ${response.statusCode}');
          });
        }
        print('HTTP Error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      if (mounted) {
        isLoading = false;
        setState(() {
          print('Error occurred: $e');
        });
      }
      print('Exception: $e');
    }
  }

  Future<void> checkStatusCard(
      String pReceiveNo, String pDocNo, String pDocType) async {
    print('po_status $pReceiveNo Type: ${pReceiveNo.runtimeType}');
    try {
      final response = await http.get(Uri.parse(
          '${globals.IP_API}/apex/wms/SSFGDT09L/SSFGDT09L_Step_1_check_ISSDirect_validate/${globals.P_OU_CODE}/${globals.P_ERP_OU_CODE}/$pReceiveNo'));

      if (response.statusCode == 200) {
        // ถอดรหัสข้อมูล JSON จาก response
        final Map<String, dynamic> dataStatusCard = jsonDecode(utf8
            .decode(response.bodyBytes)); // ถอดรหัส response body เป็น UTF-8
        print(
            'dataStatusCard : $dataStatusCard type : ${dataStatusCard.runtimeType}');

        //
        print('Fetched data: $jsonDecode');
        if (mounted) {
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
        }
        // } else {
        //   print('No items found.');
        // }
      } else {
        print(
            'checkStatusCard Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      if (mounted) {
        setState(() {});
      }
      print('checkStatusCard ERROR IN Fetch Data : $e');
    }
  }

  int totalPages() {
    return (dataCard.length / itemsPerPage).ceil(); // คำนวณจำนวนหน้าทั้งหมด
  }

  void loadNextPage() {
    if (currentPage < totalPages() - 1) {
      if (mounted) {
        setState(() {
          currentPage++;
          scrollToTop();
        });
      }
    }
  }

  void loadPrevPage() {
    if (currentPage > 0) {
      if (mounted) {
        setState(() {
          currentPage--;
          scrollToTop();
        });
      }
    }
  }

  List<dynamic> getCurrentData() {
    final start = currentPage * itemsPerPage;
    final end = start + itemsPerPage;

    return dataCard.sublist(start, end.clamp(0, dataCard.length));
  }

  void scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0); // เลื่อนไปยังตำแหน่งเริ่มต้น (index 0)
    }
  }

  void checkGoTostep(String statusCard, String messageCard, String goToStep,
      String pDocNo, String pDocType) {
    //
    print('statusCard : $statusCard Type : ${statusCard.runtimeType}');
    print('messageCard : $messageCard Type : ${messageCard.runtimeType}');
    print('goToStep : $goToStep Type : ${goToStep.runtimeType}');
    if (statusCard == '1') {
      if (mounted) {
        setState(() {
          isCardDisabled = false;
        });
      }
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
          '${globals.IP_API}/apex/wms/SSFGDT09L/SSFGDT09L_Step_1_GET_INHEAD/${globals.P_OU_CODE}/${globals.P_ERP_OU_CODE}/${globals.APP_SESSION}/$pDocNo/$pDocType/${globals.APP_USER}'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> dataGetInHead =
            jsonDecode(utf8.decode(response.bodyBytes));
        print(
            'dataGetInHead : $dataGetInHead type : ${dataGetInHead.runtimeType}');

        //
        print('Fetched data: $jsonDecode');
        if (mounted) {
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
        }
        // } else {
        //   print('No items found.');
        // }
      } else {
        print(
            'getInhead Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      if (mounted) {
        setState(() {});
      }
      print('getInhead ERROR IN Fetch Data : $e');
    }
  }

  Future<void> getInheadStpe(String pDocNoGetInHead, String pDocTypeGetInHead,
      String poStatus, String poMessage, String goToStep) async {
    if (poStatus == '1') {
      if (mounted) {
        setState(() {
          isCardDisabled = false;
        });
      }
      showMessageStatusCard(context, poMessage);
    }
    if (poStatus == '0') {
      switch (goToStep) {
        case '2':
          return await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Ssfgdt09lForm(
                  pWareCode: globals.P_ERP_OU_CODE,
                  pAttr1: widget.pAttr1,
                  // pDocNo: 'RMO1-WMS-24090028',
                  // pDocType: 'RMO1',
                  pDocNo: pDocNoGetInHead,
                  pDocType: pDocTypeGetInHead,
                  pOuCode: globals.P_OU_CODE,
                  pErpOuCode: globals.P_ERP_OU_CODE),
            ),
          ).then((value) async {
            if (mounted) {
              setState(() {
                isCardDisabled = false;
              });
            }
          });
        case '3':
          return await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Ssfgdt09lGrid(
                pWareCode: widget.pWareCode,
                pAttr1: widget.pAttr1,
                // docNo: 'RMO1-WMS-24090028',
                // docType: 'RMO1',
                docNo: pDocNoGetInHead,
                docType: pDocTypeGetInHead,
                docDate: formattedDateDocDate,
                pErpOuCode: globals.P_ERP_OU_CODE,
                pOuCode: globals.P_OU_CODE,
                pAppUser: globals.APP_USER,
                moDoNo: '230303001',
                // test
                statusCase: 'test3',
              ),
            ),
          ).then((value) async {
            if (mounted) {
              setState(() {
                isCardDisabled = false;
              });
            }
          });
        case '4':
          return await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Ssfgdt09lVerify(
                pOuCode: globals.P_OU_CODE,
                pErpOuCode: globals.P_ERP_OU_CODE,
                docNo: pDocNoGetInHead,
                docType: pDocTypeGetInHead,
                docDate: formattedDateDocDate,
                moDoNo: '230303001',
                pWareCode: widget.pWareCode,
                // docNo: 'RMO1-WMS-24090028',
                // docType: 'RMO1',
              ),
            ),
          ).then((value) async {
            if (mounted) {
              setState(() {
                isCardDisabled = false;
              });
            }
          });
        default:
          return null;
      }
    }
  }

  Future<void> getPDF(String docNo, String docType, String docDate) async {
    try {
      final response = await http.get(Uri.parse(
          '${globals.IP_API}/apex/wms/SSFGDT09L/SSFGDT09L_Step_1_GET_PDF/${globals.BROWSER_LANGUAGE}/${globals.P_ERP_OU_CODE}/${globals.APP_USER}/${widget.pWareCode}/${globals.APP_SESSION}/$docType/$docDate/$docNo/${widget.pFlag}/${globals.P_DS_PDF}'));

      debugPrint('Response body: ${response.body}');
      print('docNo in get pdf : $docNo');
      print('docType in get pdf : $docType');
      print('docDate in get pdf : $docDate');

      if (response.statusCode == 200) {
        final Map<String, dynamic> dataPDF =
            jsonDecode(utf8.decode(response.bodyBytes));
        print('dataPDF : $dataPDF type : ${dataPDF.runtimeType}');
        if (mounted) {
          setState(() {
            // V_DS_PDF = dataPDF['V_DS_PDF'] ?? '';
            // LIN_ID = dataPDF['LIN_ID'] ?? '';
            // OU_CODE = dataPDF['OU_CODE'] ?? '';
            // PROGRAM_NAME = dataPDF['PROGRAM_NAME'] ?? '';
            // CURRENT_DATE = dataPDF['CURRENT_DATE'] ?? '';
            // USER_ID = dataPDF['USER_ID'] ?? '';
            // PROGRAM_ID = dataPDF['PROGRAM_ID'] ?? '';
            // P_WARE = dataPDF['P_WARE'] ?? '';
            // P_SESSION = dataPDF['P_SESSION'] ?? '';

            // S_DOC_TYPE = dataPDF['S_DOC_TYPE'] ?? '';
            // S_DOC_DATE = dataPDF['S_DOC_DATE'] ?? '';
            // S_DOC_NO = dataPDF['S_DOC_NO'] ?? '';
            // E_DOC_TYPE = dataPDF['E_DOC_TYPE'] ?? '';
            // E_DOC_DATE = dataPDF['E_DOC_DATE'] ?? '';
            // E_DOC_NO = dataPDF['E_DOC_NO'] ?? '';
            // FLAG = dataPDF['FLAG'] ?? '';

            // LH_PAGE = dataPDF['LH_PAGE'] ?? '';
            // LH_DATE = dataPDF['LH_DATE'] ?? '';
            // LH_AR_NAME = dataPDF['LH_AR_NAME'] ?? '';
            // LH_LOGISTIC_COMP = dataPDF['LH_LOGISTIC_COMP'] ?? '';
            // // LH_DOC_TYPE = dataPDF['LH_DOC_TYPE'] ?? '';
            // // LH_WARE = dataPDF['LH_WARE'] ?? '';
            // LH_CAR_ID = dataPDF['LH_CAR_ID'] ?? '';
            // // LH_DOC_NO = dataPDF['LH_DOC_NO'] ?? '';
            // // LH_DOC_DATE = dataPDF['LH_DOC_DATE'] ?? '';
            // LH_INVOICE_NO = dataPDF['LH_INVOICE_NO'] ?? '';

            // LB_SEQ = dataPDF['LB_SEQ'] ?? '';
            // // LB_ITEM_CODE = dataPDF['LB_ITEM_CODE'] ?? '';
            // // LB_ITEM_NAME = dataPDF['LB_ITEM_NAME'] ?? '';
            // // LB_LOCATION = dataPDF['LB_LOCATION'] ?? '';
            // // LB_UMS = dataPDF['LB_UMS'] ?? '';
            // // LB_LOTS_PRODUCT = item['LB_LOTS_PRODUCT'] ?? '';
            // // LB_MO_NO = item['LB_MO_NO'] ?? '';          ////-------////
            // // LB_TRAN_QTY = dataPDF['LB_TRAN_QTY'] ?? '';
            // // LB_ATTRIBUTE1 = item['LB_ATTRIBUTE1'] ?? '';
            // LT_NOTE = dataPDF['LT_NOTE'] ?? '';
            // // LT_TOTAL_QTY = dataPDF['LT_TOTAL_QTY'] ?? '';
            // LT_ISSUE = dataPDF['LT_ISSUE'] ?? '';
            // LT_APPROVE = dataPDF['LT_APPROVE'] ?? '';
            // LT_OUT = dataPDF['LT_OUT'] ?? '';
            // LT_RECEIVE = dataPDF['LT_RECEIVE'] ?? '';
            // LT_BILL = dataPDF['LT_BILL'] ?? '';
            // LT_CHECK = dataPDF['LT_CHECK'] ?? '';

            V_DS_PDF = dataPDF['V_DS_PDF'] ?? '';
            LIN_ID = dataPDF['LIN_ID'] ?? '';
            OU_CODE = dataPDF['OU_CODE'] ?? '';
            PROGRAM_NAME = dataPDF['PROGRAM_NAME'] ?? '';
            CURRENT_DATE = dataPDF['CURRENT_DATE'] ?? '';
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
            LB_LOTS_PRODUCT = dataPDF['LB_LOTS_PRODUCT'] ?? '';
            LB_MO_NO = dataPDF['LB_MO_NO'] ?? '';
            LB_TRAN_QTY = dataPDF['LB_TRAN_QTY'] ?? '';
            LB_ATTRIBUTE1 = dataPDF['LB_ATTRIBUTE1'] ?? '';
            LT_NOTE = dataPDF['LT_NOTE'] ?? '';
            LT_TOTAL_QTY = dataPDF['LT_TOTAL_QTY'] ?? '';
            LT_ISSUE = dataPDF['LT_ISSUE'] ?? '';
            LT_APPROVE = dataPDF['LT_APPROVE'] ?? '';
            LT_OUT = dataPDF['LT_OUT'] ?? '';
            LT_RECEIVE = dataPDF['LT_RECEIVE'] ?? '';
            LT_BILL = dataPDF['LT_BILL'] ?? '';
            LT_CHECK = dataPDF['LT_CHECK'] ?? '';

            isPrintDisabled = false;
            _launchUrl(docNo, docType);
          });
        }
      } else {
        print('โพสต์ข้อมูลล้มเหลว. รหัสสถานะ: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in submit Data: $e');
    }
  }

  Future<void> _launchUrl(String pErpDocNo, String pDocType) async {
    final uri = Uri.parse('${globals.IP_API}/jri/report?'
        '&_repName=/WMS/SSFGOD02A5'
        '&_repFormat=pdf'
        '&_dataSource=${globals.P_DS_PDF}'
        '&_outFilename=$pErpDocNo.pdf'
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
        '&P_DOC_TYPE=$pDocType'
        '&P_ERP_DOC_NO=$pErpDocNo'
        '&S_DOC_TYPE=$S_DOC_TYPE'
        '&S_DOC_DATE=$S_DOC_DATE'
        '&S_DOC_NO=$S_DOC_NO'
        '&E_DOC_TYPE=$E_DOC_TYPE'
        '&E_DOC_DATE=$E_DOC_DATE'
        '&E_DOC_NO=$E_DOC_NO'
        '&FLAG=$FLAG'
        '&LH_PAGE=$LH_PAGE'
        '&LH_DATE=$LH_DATE'
        '&LH_AR_NAME=$LH_AR_NAME'
        '&LH_LOGISTIC_COMP=$LH_LOGISTIC_COMP'
        '&LH_Doc_Type=$LH_DOC_TYPE'
        '&LH_Ware=$LH_WARE'
        '&LH_CAR_ID=$LH_CAR_ID'
        '&LH_Doc_No=$LH_DOC_NO'
        '&LH_Doc_Date=$LH_DOC_DATE'
        '&LH_INVOICE_NO=$LH_INVOICE_NO'
        '&LB_SEQ=$LB_SEQ'
        '&LB_Item_Code=$LB_ITEM_CODE'
        '&LB_Item_Name=$LB_ITEM_NAME'
        '&LB_Location=$LB_LOCATION'
        '&LB_Ums=$LB_UMS'
        '&LB_LOTS_PRODUCT=$LB_LOTS_PRODUCT'
        '&LB_MO_NO=$LB_MO_NO'
        '&LB_TRAN_Qty=$LB_TRAN_QTY'
        '&LB_ATTRIBUTE1=$LB_ATTRIBUTE1'
        '&LT_NOTE=$LT_NOTE'
        '&lt_total_qty=$LT_TOTAL_QTY'
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
    print('pErpDocNo : $pErpDocNo');
    print('pDocType : $pDocType');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'เบิกจ่าย', showExitWarning: false),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: isLoading
                  ? Center(child: LoadingIndicator())
                  : dataCard.isEmpty
                      ? const Center(child: CenteredMessage())
                      : SingleChildScrollView(
                          controller: _scrollController,
                          child: ListView.builder(
                              controller: _scrollController,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: getCurrentData().length + 1,
                              itemBuilder: (context, index) {
                                if (index < getCurrentData().length) {
                                  var item = getCurrentData()[index];
                                  Color cardColor;
                                  String statusText;
                                  // String iconImageYorN;
                                  print(item['card_status_desc']);
                                  switch (item['card_status_desc']) {
                                    case 'ระหว่างบันทึก':
                                      cardColor =
                                          Color.fromRGBO(246, 250, 112, 1.0);
                                      statusText = 'ระหว่างบันทึก';
                                      break;
                                    case 'ยืนยันการรับ':
                                      cardColor =
                                          Color.fromRGBO(146, 208, 80, 1.0);
                                      statusText = 'ยืนยันการรับ';
                                      break;
                                    case 'ยกเลิก':
                                      cardColor =
                                          Color.fromRGBO(208, 206, 206, 1.0);
                                      statusText = 'ยกเลิก';
                                      break;
                                    case 'ยืนยันการจ่าย':
                                      cardColor =
                                          Color.fromRGBO(255, 255, 255, 1.0);
                                      statusText = 'ยืนยันการจ่าย';
                                      break;
                                    case 'ปกติ':
                                      cardColor =
                                          Color.fromRGBO(255, 255, 255, 1.0);
                                      statusText = 'ยืนยันการจ่าย';
                                      break;
                                    case 'อ้างอิงแล้ว':
                                      cardColor =
                                          Color.fromRGBO(255, 255, 255, 1.0);
                                      statusText = 'อ้างอิงแล้ว';
                                      break;
                                    default:
                                      cardColor =
                                          Color.fromRGBO(255, 255, 255, 1.0);
                                      statusText = 'Unknown';
                                  }

                                  // switch (item['qc_yn']) {
                                  //   case 'Y':
                                  //     iconImageYorN =
                                  //         'assets/images/rt_machine_on.png';
                                  //     break;
                                  //   case 'N':
                                  //     iconImageYorN =
                                  //         'assets/images/rt_machine_off.png';
                                  //     break;
                                  //   default:
                                  //     iconImageYorN =
                                  //         'assets/images/rt_machine_off.png';
                                  // }
                                  // return Padding(
                                  //     padding: const EdgeInsets.only(
                                  //         top: 10.0, bottom: 20.0),
                                  //     child:
                                  return CardStyles.cardPage(
                                    showON: item['qc_yn'] == 'Y'
                                        ? true
                                        : item['qc_yn'] == 'N'
                                            ? false
                                            : false,
                                    headerText: '',
                                    isShowPrint: true,
                                    colorStatus: cardColor,
                                    statusCard: statusText,
                                    onCard: isCardDisabled
                                        ? null
                                        : () async {
                                            setState(() {
                                              isCardDisabled = true;
                                            });
                                            checkStatusCard(
                                                item['po_no'] ?? '',
                                                item['p_doc_no'] ?? '',
                                                item['p_doc_type'] ?? '');

                                            print(
                                                'po_no in Card : ${item['po_no']} Type : ${item['po_no'].runtimeType}');
                                            print(
                                                'p_doc_no in Card : ${item['p_doc_no']} Type : ${item['p_doc_no'].runtimeType}');
                                            print(
                                                'p_doc_type in Card : ${item['p_doc_type']} Type : ${item['p_doc_type'].runtimeType}');
                                          },
                                    onPrint: isPrintDisabled
                                        ? null
                                        : () {
                                            setState(() {
                                              isPrintDisabled = true;
                                              DateTime parsedDate =
                                                  DateFormat('dd/MM/yyyy')
                                                      .parse(item['po_date']);
                                              String formattedDate =
                                                  DateFormat('dd-MM-yyyy')
                                                      .format(parsedDate);

                                              formattedDateDocDate =
                                                  formattedDate;
                                              getPDF(
                                                item['p_doc_no'],
                                                item['p_doc_type'],
                                                formattedDate,
                                              );
                                            });
                                          },
                                    titleText:
                                        '${item['po_date'] ?? ''} ${item['po_no'] ?? ''} ${item['item_stype_desc'] ?? ''}',
                                  );
                                  // );
                                } else {
                                  // displayedData.length <= 3
                                  // ?
                                  return getCurrentData().length > 3
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                currentPage > 0
                                                    ? ElevatedButton(
                                                        onPressed:
                                                            currentPage > 0
                                                                ? () {
                                                                    loadPrevPage();
                                                                  }
                                                                : null,
                                                        style: ButtonStyles
                                                            .previousButtonStyle,
                                                        child: ButtonStyles
                                                            .previousButtonContent,
                                                      )
                                                    : ElevatedButton(
                                                        onPressed: null,
                                                        style: DisableButtonStyles
                                                            .disablePreviousButtonStyle,
                                                        child: DisableButtonStyles
                                                            .disablePreviousButtonContent,
                                                      )
                                              ],
                                            ),
                                            // const SizedBox(width: 30),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Center(
                                                  child: Text(
                                                    '${(currentPage * itemsPerPage) + 1} - ${dataCard.isNotEmpty ? ((currentPage + 1) * itemsPerPage).clamp(1, dataCard.length) : 0}',
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            // const SizedBox(width: 30),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                currentPage < totalPages() - 1
                                                    ? ElevatedButton(
                                                        onPressed: currentPage <
                                                                totalPages() - 1
                                                            ? () {
                                                                loadNextPage();
                                                              }
                                                            : null,
                                                        style: ButtonStyles
                                                            .nextButtonStyle,
                                                        child: ButtonStyles
                                                            .nextButtonContent(),
                                                      )
                                                    : ElevatedButton(
                                                        onPressed: null,
                                                        style: DisableButtonStyles
                                                            .disableNextButtonStyle,
                                                        child: DisableButtonStyles
                                                            .disablePreviousButtonContent,
                                                      ),
                                              ],
                                            ),
                                          ],
                                        )
                                      : const SizedBox.shrink();
                                }
                              })),
            ),
            !isLoading && getCurrentData().length > 0
                ? getCurrentData().length <= 3
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              currentPage > 0
                                  ? ElevatedButton(
                                      onPressed: currentPage > 0
                                          ? () {
                                              loadPrevPage();
                                            }
                                          : null,
                                      style: ButtonStyles.previousButtonStyle,
                                      child: ButtonStyles.previousButtonContent,
                                    )
                                  : ElevatedButton(
                                      onPressed: null,
                                      style: DisableButtonStyles
                                          .disablePreviousButtonStyle,
                                      child: DisableButtonStyles
                                          .disablePreviousButtonContent,
                                    )
                            ],
                          ),
                          // const SizedBox(width: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Text(
                                  '${(currentPage * itemsPerPage) + 1} - ${dataCard.isNotEmpty ? ((currentPage + 1) * itemsPerPage).clamp(1, dataCard.length) : 0}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            ],
                          ),
                          // const SizedBox(width: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              currentPage < totalPages() - 1
                                  ? ElevatedButton(
                                      onPressed: currentPage < totalPages() - 1
                                          ? () {
                                              loadNextPage();
                                            }
                                          : null,
                                      style: ButtonStyles.nextButtonStyle,
                                      child: ButtonStyles.nextButtonContent(),
                                    )
                                  : ElevatedButton(
                                      onPressed: null,
                                      style: DisableButtonStyles
                                          .disableNextButtonStyle,
                                      child: DisableButtonStyles
                                          .disablePreviousButtonContent,
                                    ),
                            ],
                          ),
                        ],
                      )
                    : const SizedBox.shrink()
                : const SizedBox.shrink(),
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(
        currentPage: 'show',
      ),
    );
  }

  void showMessageStatusCard(
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
}
