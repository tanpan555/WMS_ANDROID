import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/custom_appbar.dart';
import 'package:wms_android/Global_Parameter.dart' as gb;
import 'SSFGDT04_FORM.dart';
import 'package:url_launcher/url_launcher.dart';
import '../styles.dart';
import '../loading.dart';
import '../centered_message.dart';

class SSFGDT04_CARD extends StatefulWidget {
  final int pFlag;
  final String soNo;
  final String date;
  final String status;
  final String pWareCode;
  final String pErpOuCode;
  final String pAppUser;

  const SSFGDT04_CARD({
    super.key,
    required this.soNo,
    required this.date,
    required this.status,
    required this.pWareCode,
    required this.pErpOuCode,
    required this.pFlag,
    required this.pAppUser,
  });

  @override
  _SSFGDT04_CARDState createState() => _SSFGDT04_CARDState();
}

class _SSFGDT04_CARDState extends State<SSFGDT04_CARD> {
  int currentPage = 0;
  final int itemsPerPage = 15;
  bool isLoading = true;
  bool isNavigating = false;

  List<dynamic> dataCard = [];
  List<dynamic> displayedData = [];
  String data_null = 'null';
  String statusCard = '';
  String messageCard = '';
  String sessionID = gb.APP_SESSION;
  String pDocNoGetInHead = '';
  String pDocTypeGetInHead = '';
  String broeserLanguage = gb.BROWSER_LANGUAGE;
  String pDsPdf = gb.P_DS_PDF;
  final ScrollController _singleChildScrollController = ScrollController();
  final ScrollController _listViewScrollController = ScrollController();

  // PDF
  String? V_DS_PDF;
  String? LIN_ID;
  String? OU_CODE;
  String? USER_ID;
  String? PROGRAM_ID;
  String? PROGRAM_NAME;
  String? CURRENT_DATE;
  String? P_SESSION;

  String? S_DOC_TYPE;
  String? S_DOC_NO;
  String? E_DOC_TYPE;
  String? E_DOC_NO;
  String? FLAG;

  String? LH_PAGE;
  String? LH_DATE;
  String? LH_WARE;
  String? LH_DOC_NO;
  String? LH_DOC_DATE;
  String? LH_DOC_TYPE;
  String? LH_PROGRAM_NAME;
  String? LH_REF_NO1;
  String? LH_REF_NO2;

  String? LB_ITEM_CODE;
  String? LB_ITEM_NAME;
  String? LB_LOCATION;
  String? LB_UMS;
  String? LB_TRAN_QTY;
  String? LB_TRAN_UCOST;
  String? LB_TRAN_AMT;

  String? LT_NOTE;
  String? LT_TOTAL;
  String? LT_INPUT;
  String? LT_RECEIVE;
  String? LT_CHECK;

  String? LB_PALLET_NO;
  String? LB_PALLET_QTY;
  String? LH_MO_DO_NO;

  @override
  void initState() {
    print('status : ${widget.status} Type : ${widget.status.runtimeType}');
    print('date : ${widget.date} Type : ${widget.date.runtimeType}');
    print('sono : ${widget.soNo} Type : ${widget.soNo.runtimeType}');
    print(
        'pWareCode : ${widget.pWareCode} Type : ${widget.pWareCode.runtimeType}');
    print(
        'pErpOuCode : ${widget.pErpOuCode} Type : ${widget.pErpOuCode.runtimeType}');

    super.initState();
    fetchData();
  }

  @override
  void dispose() {
    _singleChildScrollController.dispose();
    _listViewScrollController.dispose();
    super.dispose();
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  Future<void> fetchData([String? url]) async {
    if (!mounted) return;
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    print('URL : $url ');
    final String requestUrl = url ??
        '${gb.IP_API}/apex/wms/SSFGDT04/Step_1_card1/${gb.P_ERP_OU_CODE}/${widget.soNo}/${widget.status}/${gb.ATTR1}/${widget.pWareCode}/${gb.APP_USER}/${widget.date}/${gb.BROWSER_LANGUAGE}';
print('URL : $requestUrl ');
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

  int totalPages() {
    return (dataCard.length / itemsPerPage).ceil(); // คำนวณจำนวนหน้าทั้งหมด
  }

  void _loadPrevPage() {
    if (currentPage > 0) {
      setState(() {
        currentPage--;
      });
      _scrollToTop();
    }
  }

  void _loadNextPage() {
    if ((currentPage + 1) * itemsPerPage < dataCard.length) {
      setState(() {
        currentPage++;
      });
      _scrollToTop();
    }
  }

  List<dynamic> getCurrentData() {
    final start = currentPage * itemsPerPage;
    final end = start + itemsPerPage;

    return dataCard.sublist(start, end.clamp(0, dataCard.length));
  }

  void _scrollToTop() {
    if (_singleChildScrollController.hasClients) {
      _singleChildScrollController.jumpTo(0); // Scroll to the top
    }
  }

  Future<void> checkRCV(
      String pReceiveNo, String poDocNo, String poDocType) async {
    print('pReceiveNo $pReceiveNo Type: ${pReceiveNo.runtimeType}');
    try {
      final response = await http.get(Uri.parse(
          '${gb.IP_API}/apex/wms/SSFGDT04/Step_1_check_RCVdirect_validate/${widget.pWareCode}/${widget.pErpOuCode}/$pReceiveNo'));
      print(Uri.parse(
          '${gb.IP_API}/apex/wms/SSFGDT04/Step_1_check_RCVdirect_validate/${widget.pWareCode}/${widget.pErpOuCode}/$pReceiveNo'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> dataStatusCard =
            jsonDecode(utf8.decode(response.bodyBytes));
        print(
            'dataStatusCard : $dataStatusCard type : ${dataStatusCard.runtimeType}');

        checkGoTostep(
          dataStatusCard['po_status'] ?? '',
          dataStatusCard['po_message'] ?? '',
          dataStatusCard['po_goto_step'] ?? '',
          poDocNo,
          poDocType,
        );
      } else {
        print(
            'checkRCV Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      if (mounted) {
        setState(() {});
      }
      print('checkRCV ERROR IN Fetch Data : $e');
    }
  }

  void checkGoTostep(String statusCard, String messageCard, String goToStep,
      String poDocNo, String poDocType) {
    //
    // print(
    //     'checkGoTostep pReceiveNo : $pReceiveNo Type : ${pReceiveNo.runtimeType}');
    print('checkGoTostep poDocNo : $poDocNo Type : ${poDocNo.runtimeType}');
    print(
        'checkGoTostep poDocType : $poDocType Type : ${poDocType.runtimeType}');
    print(
        'checkGoTostep statusCard : $statusCard Type : ${statusCard.runtimeType}');
    print(
        'checkGoTostep messageCard : $messageCard Type : ${messageCard.runtimeType}');
    print('checkGoTostep goToStep : $goToStep Type : ${goToStep.runtimeType}');
    if (statusCard == '1') {
      showMessageStatusCard(context, messageCard);
    }
    if (statusCard == '0') {
      getInhead(
        poDocNo,
        poDocType,
        goToStep,
      );
    }
  }

  Future<void> getInhead(
      String vErpDocNo, String vErpDocType, String goToStep) async {
    print('getInhead p_doc_no: $vErpDocNo, Type: ${vErpDocNo.runtimeType}');
    print(
        'getInhead p_doc_type: $vErpDocType, Type: ${vErpDocType.runtimeType}');
    var getErpDocType = vErpDocType.isEmpty ? 'null' : vErpDocType;
    print('get_po_type: $getErpDocType');
    try {
      final uri = Uri.parse(
          '${gb.IP_API}/apex/wms/SSFGDT04/Step_1_get_INHead_WMS/'
          '${gb.APP_USER}/${gb.P_OU_CODE}/${gb.P_ERP_OU_CODE}/${gb.APP_SESSION}/'
          '$getErpDocType/$vErpDocNo');
      final response = await http.get(uri);
      print('Request URL: $uri');
      if (response.statusCode == 200) {
        final Map<String, dynamic> dataGetInHead =
            jsonDecode(utf8.decode(response.bodyBytes));
        print(
            'Fetched data: $dataGetInHead, Type: ${dataGetInHead.runtimeType}');

        if (mounted) {
          setState(() {
            pDocTypeGetInHead = dataGetInHead['po_doc_type'] ?? '';
            pDocNoGetInHead = dataGetInHead['po_doc_no'] ?? '';
            print('pDocNoGetInHead: $pDocNoGetInHead');
            print('pDocTypeGetInHead: $pDocTypeGetInHead');
            getInheadStep(
              dataGetInHead['po_doc_type'] ?? '',
              dataGetInHead['po_doc_no'] ?? '',
              dataGetInHead['po_status'],
              dataGetInHead['po_message'],
              goToStep,
            );
            print('getInheadStep po_doc_type: ${dataGetInHead['po_doc_type']} '
                'Type: ${dataGetInHead['po_doc_type'].runtimeType}');
            print('getInheadStep po_doc_no: ${dataGetInHead['po_doc_no']} '
                'Type: ${dataGetInHead['po_doc_no'].runtimeType}');
            print('getInheadStep po_status: ${dataGetInHead['po_status']} '
                'Type: ${dataGetInHead['po_status'].runtimeType}');
            print('getInheadStep po_message: ${dataGetInHead['po_message']} '
                'Type: ${dataGetInHead['po_message'].runtimeType}');
          });
        }
      } else {
        print('getInhead error: ${response.statusCode}');
      }
    } catch (e) {
      if (mounted) {
        setState(() {});
      }
      print('getInhead ERROR: $e');
    }
  }

  void filterData() {
    if (mounted) {
      setState(() {
        displayedData = dataCard.where((item) {
          final date = item['po_date'] ?? '';
          if (widget.date.isEmpty) {
            final matchesSearchQuery = date == date;
            return matchesSearchQuery;
          } else {
            final matchesSearchQuery = date == widget.date;
            return matchesSearchQuery;
          }
        }).toList();
        print(
            'displayedData : $displayedData Type : ${displayedData.runtimeType}');
      });
    }
  }

  void getInheadStep(String pDocTypeGetInHead, String pDocNoGetInHead,
      String poStatus, String poMessage, String goToStep) {
    print('getInheadStep -> pDocNoGetInHead: $pDocNoGetInHead');
    print('getInheadStep -> pDocTypeGetInHead: $pDocTypeGetInHead');
    if (poStatus == '1') {
      showMessageStatusCard(context, poMessage);
    }
    if (poStatus == '0') {
      switch (goToStep) {
        case '2':
          return _navigateToPage(
            context,
            SSFGDT04_FORM(
              pWareCode: widget.pErpOuCode,
              po_doc_no: pDocNoGetInHead,
              po_doc_type: pDocTypeGetInHead,
            ),
          );
        default:
          return;
      }
    }
  }

  Future<void> getPDF(String poDocNo, String poDocType) async {
    // poDocNo = '67020001';
    // poDocType = 'FGI03';
    try {
      final response = await http.get(Uri.parse(
          '${gb.IP_API}/apex/wms/SSFGDT04/Step_1_GET_PDF/$poDocType/$poDocNo/${gb.P_DS_PDF}/${gb.BROWSER_LANGUAGE}/${gb.P_ERP_OU_CODE}/${gb.APP_USER}/${gb.APP_SESSION}/${widget.pFlag}'));

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
            USER_ID = dataPDF['USER_ID'] ?? '';
            PROGRAM_ID = dataPDF['PROGRAM_ID'] ?? '';
            PROGRAM_NAME = dataPDF['PROGRAM_NAME'] ?? '';
            CURRENT_DATE = dataPDF['CURRENT_DATE'] ?? '';
            P_SESSION = dataPDF['P_SESSION'] ?? '';

            S_DOC_TYPE = dataPDF['S_DOC_TYPE'] ?? '';
            S_DOC_NO = dataPDF['S_DOC_NO'] ?? '';
            E_DOC_TYPE = dataPDF['E_DOC_TYPE'] ?? '';
            E_DOC_NO = dataPDF['E_DOC_NO'] ?? '';
            FLAG = dataPDF['FLAG'] ?? '';

            LH_PAGE = dataPDF['LH_PAGE'] ?? '';
            LH_DATE = dataPDF['LH_DATE'] ?? '';
            LH_WARE = dataPDF['LH_WARE'] ?? '';
            LH_DOC_NO = dataPDF['LH_DOC_NO'] ?? '';
            LH_DOC_NO = dataPDF['LH_DOC_NO'] ?? '';
            LH_DOC_DATE = dataPDF['LH_DOC_DATE'] ?? '';
            LH_DOC_TYPE = dataPDF['LH_DOC_TYPE'] ?? '';
            LH_PROGRAM_NAME = dataPDF['LH_PROGRAM_NAME'] ?? '';
            LH_REF_NO1 = dataPDF['LH_REF_NO1'] ?? '';
            LH_REF_NO2 = dataPDF['LH_REF_NO2'] ?? '';

            LB_ITEM_CODE = dataPDF['LB_ITEM_CODE'] ?? '';
            LB_ITEM_NAME = dataPDF['LB_ITEM_NAME'] ?? '';
            LB_LOCATION = dataPDF['LB_LOCATION'] ?? '';
            LB_UMS = dataPDF['LB_UMS'] ?? '';
            LB_TRAN_QTY = dataPDF['LB_TRAN_QTY'] ?? '';
            LB_TRAN_UCOST = dataPDF['LB_TRAN_UCOST'] ?? '';
            LB_TRAN_AMT = dataPDF['LB_TRAN_AMT'] ?? '';

            LT_NOTE = dataPDF['LT_NOTE'] ?? '';
            LT_TOTAL = dataPDF['LT_TOTAL'] ?? '';
            LT_INPUT = dataPDF['LT_INPUT'] ?? '';
            LT_RECEIVE = dataPDF['LT_RECEIVE'] ?? '';
            LT_CHECK = dataPDF['LT_CHECK'] ?? '';

            LB_PALLET_NO = dataPDF['LB_PALLET_NO'] ?? '';
            LB_PALLET_QTY = dataPDF['LB_PALLET_QTY'] ?? '';
            LH_MO_DO_NO = dataPDF['LH_MO_DO_NO'] ?? '';

            _launchUrl('$poDocType' '-' '$poDocNo');
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

  Future<void> _launchUrl(String poDocNo) async {
    final uri = Uri.parse('${gb.IP_API}/jri/report?'
        '&_repName=/WMS/SSFGOD01'
        '&_repFormat=pdf'
        '&_dataSource=${gb.P_DS_PDF}'
        '&_outFilename=$poDocNo.pdf'
        '&_repLocale=en_US'
        '&V_DS_PDF=$V_DS_PDF'
        '&LIN_ID=$LIN_ID'
        '&OU_CODE=$OU_CODE'
        '&USER_ID=$USER_ID'
        '&PROGRAM_ID=$PROGRAM_ID'
        '&PROGRAM_NAME=$PROGRAM_NAME'
        '&CURRENT_DATE=$CURRENT_DATE'
        '&P_SESSION=$P_SESSION'
        '&S_DOC_TYPE=$S_DOC_TYPE'
        '&S_DOC_NO=$S_DOC_NO'
        '&E_DOC_TYPE=$E_DOC_TYPE'
        '&E_DOC_NO=$E_DOC_NO'
        '&FLAG=$FLAG'
        '&LH_PAGE=$LH_PAGE'
        '&LH_DATE=$LH_DATE'
        '&LH_WARE=$LH_WARE'
        '&LH_DOC_NO=$LH_DOC_NO'
        '&LH_DOC_DATE=$LH_DOC_DATE'
        '&LH_DOC_TYPE=$LH_DOC_TYPE'
        '&LH_PROGRAM_NAME=$LH_PROGRAM_NAME'
        '&LH_REF_NO1=$LH_REF_NO1'
        '&LH_REF_NO2=$LH_REF_NO2'
        '&LB_ITEM_CODE=$LB_ITEM_CODE'
        '&LB_ITEM_NAME=$LB_ITEM_NAME'
        '&LB_LOCATION=$LB_LOCATION'
        '&LB_UMS=$LB_UMS'
        '&LB_TRAN_QTY=$LB_TRAN_QTY'
        '&LB_TRAN_UCOST=$LB_TRAN_UCOST'
        '&LB_TRAN_AMT=$LB_TRAN_AMT'
        '&LT_NOTE=$LT_NOTE'
        '&LT_TOTAL=$LT_TOTAL'
        '&LT_INPUT=$LT_INPUT'
        '&LT_RECEIVE=$LT_RECEIVE'
        '&LT_CHECK=$LT_CHECK'
        '&LB_PALLET_NO=$LB_PALLET_NO'
        '&LB_PALLET_QTY=$LB_PALLET_QTY'
        '&LH_MO_DO_NO=$LH_MO_DO_NO');

    print(uri);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
    print('${gb.IP_API}/jri/report?'
        '&_repName=/WMS/SSFGOD01'
        '&_repFormat=pdf'
        '&_dataSource=${gb.P_DS_PDF}'
        '&_outFilename=$poDocNo.pdf'
        '&_repLocale=en_US'
        '&V_DS_PDF=$V_DS_PDF'
        '&LIN_ID=$LIN_ID'
        '&OU_CODE=$OU_CODE'
        '&USER_ID=$USER_ID'
        '&PROGRAM_ID=$PROGRAM_ID'
        '&PROGRAM_NAME=$PROGRAM_NAME'
        '&CURRENT_DATE=$CURRENT_DATE'
        '&P_SESSION=$P_SESSION'
        '&S_DOC_TYPE=$S_DOC_TYPE'
        '&S_DOC_NO=$S_DOC_NO'
        '&E_DOC_TYPE=$E_DOC_TYPE'
        '&E_DOC_NO=$E_DOC_NO'
        '&FLAG=$FLAG'
        '&LH_PAGE=$LH_PAGE'
        '&LH_DATE=$LH_DATE'
        '&LH_WARE=$LH_WARE'
        '&LH_DOC_NO=$LH_DOC_NO'
        '&LH_DOC_DATE=$LH_DOC_DATE'
        '&LH_DOC_TYPE=$LH_DOC_TYPE'
        '&LH_PROGRAM_NAME=$LH_PROGRAM_NAME'
        '&LH_REF_NO1=$LH_REF_NO1'
        '&LH_REF_NO2=$LH_REF_NO2'
        '&LB_ITEM_CODE=$LB_ITEM_CODE'
        '&LB_ITEM_NAME=$LB_ITEM_NAME'
        '&LB_LOCATION=$LB_LOCATION'
        '&LB_UMS=$LB_UMS'
        '&LB_TRAN_QTY=$LB_TRAN_QTY'
        '&LB_TRAN_UCOST=$LB_TRAN_UCOST'
        '&LB_TRAN_AMT=$LB_TRAN_AMT'
        '&LT_NOTE=$LT_NOTE'
        '&LT_TOTAL=$LT_TOTAL'
        '&LT_INPUT=$LT_INPUT'
        '&LT_RECEIVE=$LT_RECEIVE'
        '&LT_CHECK=$LT_CHECK'
        '&LB_PALLET_NO=$LB_PALLET_NO'
        '&LB_PALLET_QTY=$LB_PALLET_QTY'
        '&LH_MO_DO_NO=$LH_MO_DO_NO');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          CustomAppBar(title: 'รับตรง (ไม่อ้าง PO)', showExitWarning: false),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
                child: isLoading
                    ? Center(child: LoadingIndicator())
                    : dataCard.isEmpty
                        ? const Center(child: CenteredMessage())
                        : SingleChildScrollView(
                            controller: _singleChildScrollController,
                            child: ListView.builder(
                              controller: _listViewScrollController,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: getCurrentData().length + 1,
                              itemBuilder: (context, index) {
                                if (index < getCurrentData().length) {
                                  var item = getCurrentData()[index];
                                  return Card(
                                    elevation: 8.0,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    color: Colors.lightBlue[100],
                                    child: InkWell(
                                      onTap: isNavigating
                                          ? null // Disable tap if navigating
                                          : () {
                                              setState(() {
                                                isNavigating =
                                                    true; // Set to true to block further taps
                                              });
                                              checkRCV(
                                                  item['po_no'] ?? '',
                                                  item['doc_no'] ?? '',
                                                  item['doc_type'] ?? '');
                                              print(
                                                  'po_no in Card : ${item['po_no']} Type : ${item['po_no'].runtimeType}');
                                              print(
                                                  'p_doc_no in Card : ${item['doc_no']} Type : ${item['doc_no'].runtimeType}');
                                              print(
                                                  'p_doc_type in Card : ${item['doc_type']} Type : ${item['doc_type'].runtimeType}');
                                              Future.delayed(
                                                  const Duration(seconds: 1),
                                                  () {
                                                setState(() {
                                                  isNavigating =
                                                      false; // Re-enable tap after some time (e.g., after navigation completes)
                                                });
                                              });
                                            },
                                      borderRadius: BorderRadius.circular(15.0),
                                      child: Stack(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  item['ap_name'] ?? 'No Name',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 17,
                                                    color: Color.fromARGB(
                                                        255, 0, 0, 0),
                                                  ),
                                                ),
                                                const Divider(
                                                    color: Colors.black26,
                                                    thickness: 1),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 12.0,
                                                          vertical: 6.0),
                                                      decoration: BoxDecoration(
                                                        color: (() {
                                                          switch (item[
                                                              'card_status_desc']) {
                                                            case 'ระหว่างบันทึก':
                                                              return const Color
                                                                  .fromRGBO(246,
                                                                  250, 112, 1);
                                                            case 'ยืนยันการรับ':
                                                              return const Color
                                                                  .fromRGBO(146,
                                                                  208, 80, 1);
                                                            case 'ยกเลิก':
                                                              return const Color
                                                                  .fromRGBO(208,
                                                                  206, 206, 1);
                                                            case 'ทั้งหมด':
                                                            default:
                                                              return const Color
                                                                  .fromARGB(
                                                                  255,
                                                                  255,
                                                                  255,
                                                                  255);
                                                          }
                                                        })(),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      child: Text(
                                                        item[
                                                            'card_status_desc'],
                                                        style: const TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Center(
                                                      child: (() {
                                                        if (item['card_qc'] ==
                                                            '#APP_IMAGES#rt_machine_on.png') {
                                                          return Image.asset(
                                                            'assets/images/rt_machine_on.png',
                                                            width: 50,
                                                            height: 50,
                                                          );
                                                        } else if (item[
                                                                'card_qc'] ==
                                                            '#APP_IMAGES#rt_machine_off.png') {
                                                          return Image.asset(
                                                            'assets/images/rt_machine_off.png',
                                                            width: 50,
                                                            height: 50,
                                                          );
                                                        } else if (item[
                                                                'card_qc'] ==
                                                            '') {
                                                          return const SizedBox
                                                              .shrink();
                                                        } else {
                                                          return const Text('');
                                                        }
                                                      })(),
                                                    ),
                                                    const Spacer(),
                                                    Center(
                                                      child:
                                                          item['status'] != null
                                                              ? Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: const Color
                                                                        .fromARGB(
                                                                        72,
                                                                        145,
                                                                        144,
                                                                        144),
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(5),
                                                                  ),
                                                                  child:
                                                                      TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      getPDF(
                                                                          item[
                                                                              'doc_no'],
                                                                          item[
                                                                              'doc_type']);
                                                                    },
                                                                    child: item['status'] ==
                                                                            'พิมพ์'
                                                                        ? Image
                                                                            .asset(
                                                                            'assets/images/printer.png',
                                                                            width:
                                                                                30,
                                                                            height:
                                                                                30,
                                                                          )
                                                                        : Text(
                                                                            item['status']!,
                                                                            style:
                                                                                const TextStyle(
                                                                              fontSize: 15,
                                                                              color: Color.fromARGB(137, 0, 0, 0),
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                          ),
                                                                  ),
                                                                )
                                                              : const SizedBox
                                                                  .shrink(),
                                                    ),
                                                  ],
                                                ),
                                                // const Spacer(),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        horizontal: 12.0,
                                                        vertical: 6.0,
                                                      ),
                                                      child: Text(
                                                        '${item['po_date']} ${item['po_no']} ${item['item_stype_desc'] ?? ''}',
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.black87,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                } else {
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
                                                                    _loadPrevPage();
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
                                                                _loadNextPage();
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
                              },
                            ))),
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
                                              _loadPrevPage();
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
                                              _loadNextPage();
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
      bottomNavigationBar: BottomBar(currentPage: 'not_show'),
    );
  }

  void showMessageStatusCard(BuildContext context, String messageCard) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogStyles.alertMessageDialog(
          context: context,
          content: Text(messageCard),
          onClose: () {
            Navigator.of(context).pop();
          },
          onConfirm: () async {
            // await fetchPoStatusconform(vReceiveNo);
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}
