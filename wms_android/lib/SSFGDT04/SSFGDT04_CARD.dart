import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/custom_appbar.dart';
import 'package:wms_android/Global_Parameter.dart' as gb;
import 'SSFGDT04_FORM.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:intl/intl.dart';

class SSFGDT04_CARD extends StatefulWidget {
  final int pFlag;
  final String soNo;
  final String date;
  final String status;
  final String pWareCode;
  // final String pOuCode;
  final String pErpOuCode;
  final String pAppUser;

  SSFGDT04_CARD({
    Key? key,
    required this.soNo,
    required this.date,
    required this.status,
    required this.pWareCode,
    // required this.pOuCode,
    required this.pErpOuCode,
    required this.pFlag,
    required this.pAppUser,
  }) : super(key: key);

  @override
  _SSFGDT04_CARDState createState() => _SSFGDT04_CARDState();
}

class _SSFGDT04_CARDState extends State<SSFGDT04_CARD> {
  List<dynamic> dataCard = [];
  List<dynamic> displayedData = [];
  String data_null = 'null';
  String statusCard = '';
  String messageCard = '';
  String goToStep = '';
  String sessionID = gb.APP_SESSION;
  String pDocNoGetInHead = '';
  String pDocTypeGetInHead = '';
  // String pAppUser = gb.APP_USER;
  String broeserLanguage = gb.BROWSER_LANGUAGE;
  String pDsPdf = gb.P_DS_PDF;

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

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  Future<void> fetchData() async {
    final String endpoint = widget.soNo.isNotEmpty
        ? 'http://172.16.0.82:8888/apex/wms/SSFGDT04/Step_1_card1/${gb.P_ERP_OU_CODE}/${widget.soNo}/${widget.status}/${gb.ATTR1}/${widget.pWareCode}/${gb.APP_USER}/${widget.date}'
        : 'http://172.16.0.82:8888/apex/wms/SSFGDT12/selectCard/${gb.P_ERP_OU_CODE}/$data_null/${widget.status}/${gb.ATTR1}/${widget.pWareCode}/${gb.APP_USER}/${widget.date}';

    // print('Fetching data from: $endpoint');

    try {
      final response = await http.get(Uri.parse(endpoint));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $responseData');

        setState(() {
          dataCard =
              List<Map<String, dynamic>>.from(responseData['items'] ?? []);
          filterData();
        });
        print('dataCard: $dataCard');
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
        throw Exception(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // setState(() {});
      print('ERROR IN Fetch Data: $e');
    }
  }

  Future<void> checkStatusCard(
      String pReceiveNo, String po_doc_no, String po_doc_type) async {
    print('po_status $pReceiveNo Type: ${pReceiveNo.runtimeType}');
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGDT04/Step_1_check_RCVdirect_validate/${widget.pWareCode}/${widget.pErpOuCode}/$pReceiveNo'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> dataStatusCard =
            jsonDecode(utf8.decode(response.bodyBytes));
        print(
            'dataStatusCard : $dataStatusCard type : ${dataStatusCard.runtimeType}');

        checkGoTostep(
          dataStatusCard['po_status'] ?? '',
          dataStatusCard['po_message'] ?? '',
          dataStatusCard['po_goto_step'] ?? '',
          po_doc_no,
          po_doc_type,
        );
      } else {
        print(
            'checkStatusCard Failed to load data. Status code: ${response.statusCode}');
        // Log more detailed information
        // print('Response body: ${response.body}');
      }
    } catch (e) {
      setState(() {});
      print('checkStatusCard ERROR IN Fetch Data : $e');
    }
  }

  void checkGoTostep(String statusCard, String messageCard, String goToStep,
      String po_doc_no, String po_doc_type) {
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
        po_doc_no,
        po_doc_type,
      );
    }
  }

  // String? poStatus;
  // String? poMessage;
  // String? po_doc_no;
  // String? po_doc_type;

  Future<void> getInhead(
      String po_doc_no, String po_doc_type, String goToStep) async {
    print('po_doc_no $po_doc_no Type: ${po_doc_no.runtimeType}');
    print('po_doc_type $po_doc_type Type: ${po_doc_type.runtimeType}');
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGDT04/Step_1_get_INHead_WMS/${gb.P_OU_CODE}/${gb.P_ERP_OU_CODE}/${gb.APP_SESSION}/$po_doc_type/$po_doc_no/${gb.APP_USER}'));

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

  void filterData() {
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
              SSFGDT04_FORM(
                pWareCode: widget.pErpOuCode,
                // pAttr1: widget.pAttr1,
                po_doc_no: pDocNoGetInHead,
                po_doc_type: pDocTypeGetInHead,
              ));
        default:
          return null;
      }
    }
  }

  Future<void> getPDF(String po_doc_no, String po_doc_type) async {
    po_doc_no = '67020001';
    po_doc_type = 'FGI03';
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGDT04/Step_1_GET_PDF/$po_doc_type/$po_doc_no/${gb.P_DS_PDF}/${gb.BROWSER_LANGUAGE}/${gb.P_ERP_OU_CODE}/${gb.APP_USER}/${gb.APP_SESSION}/${widget.pFlag}'));

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

          _launchUrl(po_doc_no);
        });
      } else {
        // จัดการกรณีที่ response status code ไม่ใช่ 200
        print('โพสต์ข้อมูลล้มเหลว. รหัสสถานะ: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in submit Data: $e');
    }
  }

  Future<void> _launchUrl(String po_doc_no) async {
    final uri = Uri.parse('http://172.16.0.82:8888/jri/report?'
        '&_repName=/WMS/SSFGOD01'
        '&_repFormat=pdf'
        '&_dataSource=${gb.P_DS_PDF}'
        '&_outFilename=$po_doc_no.pdf'
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
    print('http://172.16.0.82:8888/jri/report?'
        '&_repName=/WMS/SSFGOD01'
        '&_repFormat=pdf'
        '&_dataSource=${gb.P_DS_PDF}'
        '&_outFilename=$po_doc_no.pdf'
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
      backgroundColor: const Color(0xFF17153B),
      // backgroundColor: Color.fromARGB(255, 165, 216, 103),
      appBar: CustomAppBar(title: 'รับตรง (ไม่อ้าง PO'),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        // child: Column(
        //   children: [
        //     Expanded(
        child: ListView.builder(
          itemCount: dataCard.length,
          itemBuilder: (context, index) {
            final item = dataCard[index];

            return Card(
              elevation: 8.0,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              color: Colors.lightBlue[100],
              child: InkWell(
                onTap: () {
                  checkStatusCard(item['po_no'] ?? '', item['p_doc_no'] ?? '',
                      item['p_doc_type'] ?? '');

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
                          Center(
                            child: Text(
                              item['ap_name'] ?? 'No Name',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Color.fromARGB(255, 0, 0, 0)),
                            ),
                          ),
                          const Divider(
                            color: Colors.black26, // สีเส้น Divider เบาลง
                            thickness: 1,
                          ),
                          // SizedBox(height: 8),
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .center, // Centers the items in the row
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0, vertical: 6.0),
                                  decoration: BoxDecoration(
                                    color: (() {
                                      switch (item['card_status_desc']) {
                                        case 'ระหว่างบันทึก':
                                          return Color.fromRGBO(
                                              246, 250, 112, 1);
                                        case 'ยืนยันการรับ':
                                          return Color.fromRGBO(
                                              146, 208, 80, 1);
                                        case 'ยกเลิก':
                                          return Color.fromRGBO(
                                              208, 206, 206, 1);
                                        case 'ทั้งหมด':
                                        default:
                                          return Color.fromARGB(
                                              255, 255, 255, 255);
                                      }
                                    })(),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    item['card_status_desc'],
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
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
                                    } else if (item['card_qc'] ==
                                        '#APP_IMAGES#rt_machine_off.png') {
                                      return Image.asset(
                                        'assets/images/rt_machine_off.png',
                                        width: 50,
                                        height: 50,
                                      );
                                    } else if (item['card_qc'] == '') {
                                      return SizedBox
                                          .shrink(); // No widget displayed
                                    } else {
                                      return Text(
                                          ''); // Empty text widget for other cases
                                    }
                                  })(),
                                ),

                                const SizedBox(
                                    width:
                                        8), // Adds space between the Container and the TextButton
                                Center(
                                  child: item['status'] != null
                                      ? Container(
                                          decoration: BoxDecoration(
                                            color: Color.fromARGB(
                                                72, 145, 144, 144),
                                            borderRadius: BorderRadius.circular(
                                                5), // Optional: Add rounded corners
                                          ),
                                          child: TextButton(
                                            onPressed: () {
                                              getPDF(
                                                item['doc_no'],
                                                item['doc_type'],
                                              );
                                              // });
                                              // Handle button press
                                              // Add your navigation or functionality here
                                            },
                                            child: item['status'] == 'พิมพ์'
                                                ? Image.asset(
                                                    'assets/images/printer.png', // Replace with your image path
                                                    width:
                                                        30, // Adjust the size as needed
                                                    height: 30,
                                                  )
                                                : Text(
                                                    item['status']!,
                                                    style: const TextStyle(
                                                      fontSize: 15,
                                                      color: Color.fromARGB(
                                                          137, 0, 0, 0),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                          ),
                                        )
                                      : SizedBox.shrink(),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 8),
                          Center(
                            child: Text(
                              '${item['po_date']} ${item['po_no']} ${item['item_stype_desc'] ?? ''}', //\n ${item['status']?? ''}
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.black54),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      //     ],
      //   ),
      // ),
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
          title: Text('คำเตือน'),
          content: Text(messageCard),
          actions: <Widget>[
            TextButton(
              child: Text('ตกลง'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return AlertDialog(
    //       title: Row(
    //         children: [
    //           // Icon(
    //           //   Icons.notification_important,
    //           //   color: Colors.red,
    //           // ),
    //           // SizedBox(width: 10),
    //           // Text(
    //           //   'Error',
    //           //   style: TextStyle(color: Colors.red),
    //           // ),
    //         ],
    //       ),
    //       content: SingleChildScrollView(
    //         child: Padding(
    //           padding: const EdgeInsets.all(16.0),
    //           child: Column(
    //             children: [
    //               const SizedBox(height: 10),
    //               Text(
    //                 messageCard,
    //                 style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
    //               ),
    //               const SizedBox(height: 10),
    //               Row(
    //                 // mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                 mainAxisAlignment: MainAxisAlignment.end,
    //                 children: [
    //                   ElevatedButton(
    //                     onPressed: () {
    //                       Navigator.of(context).pop();
    //                     },
    //                     // style: ElevatedButton.styleFrom(
    //                     //   backgroundColor: Colors.white,
    //                     //   side: BorderSide(color: Colors.grey),
    //                     // ),
    //                     child: const Text('OK'),
    //                   ),
    //                 ],
    //               )
    //             ],
    //           ),
    //         ),
    //       ),
    //     );
    //   },
    // );
  }
}
