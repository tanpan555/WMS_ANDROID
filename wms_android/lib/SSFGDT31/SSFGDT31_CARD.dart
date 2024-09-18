import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wms_android/bottombar.dart';
import 'dart:convert';

import 'package:wms_android/custom_appbar.dart';
import 'package:wms_android/Global_Parameter.dart' as gb;

import 'package:url_launcher/url_launcher.dart';

class SSFGDT31_CARD extends StatefulWidget {
  final String soNo;
  final String statusDesc;
  final String wareCode;
  final String? receiveDate;

  SSFGDT31_CARD({required this.soNo, required this.statusDesc, required this.wareCode, this.receiveDate});

  @override
  _SSFGDT31_CARDPageState createState() => _SSFGDT31_CARDPageState();
}

class _SSFGDT31_CARDPageState extends State<SSFGDT31_CARD> {
  List<dynamic> data = [];
  bool isLoading = true;
  String errorMessage = '';
  String? DateSend;
  

  String? nextLink;
  String? prevLink;

  @override
  void initState() {
    super.initState();
    DateSend = widget.receiveDate;
    if (DateSend != null) {
      DateSend = DateSend!.replaceAll('/', '-');
    }
    fetchData();
  }

  String? doc_no;
String? doc_type;
String? erp_doc_no;
String? po_status;
String? po_message;


  Future<void> Inteface_receive_WMS2ERP(String v_erp_doc_type,String v_erp_doc_no) async {
    final url =
        'http://172.16.0.82:8888/apex/wms/SSFGDT31/get_INHead_WMS/$v_erp_doc_type/$v_erp_doc_no/${gb.P_OU_CODE}/${gb.P_ERP_OU_CODE}';
    print(url);
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        setState(() {
          doc_no = responseBody['doc_no'];
          doc_type = responseBody['doc_type'];
          erp_doc_no = responseBody['erp_doc_no'];
          po_status = responseBody['po_status'];
          po_message = responseBody['po_message'];

          print('p_doc_no: $doc_no');
          print('p_doc_type: $doc_type');
          print('erp_doc_no: $erp_doc_no');
          print('po_status: $po_status');
          print('po_message: $po_message');
        });

        fetchPDFData(v_erp_doc_type,v_erp_doc_type);
      } else {
        throw Exception('Failed to load PO status');
      }
    } catch (e) {
      setState(() {
        po_status = 'Error';
        po_message = e.toString();
      });
    }
  }

  String? V_DS_PDF;
String? LIN_ID;
String? OU_CODE;
String? PROGRAM_NAME;
String? CURRENT_DATE;
String? USER_ID;
String? PROGRAM_ID;
String? P_WARE;
String? P_SESSION;
String? v_filename;
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
String? LB_WEIGHT;
String? LB_PD_LOCATION;
String? LB_USED_TOTAL;
String? LT_NOTE;
String? LT_TOTAL_QTY;
String? LT_ISSUE;
String? LT_APPROVE;
String? LT_OUT;
String? LT_RECEIVE;
String? LT_BILL;
String? LT_CHECK;



  void fetchPDFData(String doc_type,String print_doc_no) async {
    final url = Uri.parse(
        'http://172.16.0.82:8888/apex/wms/SSFGDT31/GET_PDF/${gb.APP_SESSION}/${widget.wareCode}/${gb.APP_USER}/${gb.P_ERP_OU_CODE}/TH/$doc_type/wms');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        print(url);
        final data = json.decode(response.body);

        V_DS_PDF = data['V_DS_PDF'];
        LIN_ID = data['LIN_ID'];
        OU_CODE = data['OU_CODE'];
        PROGRAM_NAME = data['PROGRAM_NAME'];

        CURRENT_DATE = data['CURRENT_DATE'];
        USER_ID = data['USER_ID'];
        PROGRAM_ID = data['PROGRAM_ID'];
        P_WARE = data['P_WARE'];
        P_SESSION = data['P_SESSION'];
        v_filename = data['v_filename'];
        S_DOC_TYPE = data['S_DOC_TYPE'];
        S_DOC_DATE = data['S_DOC_DATE'];
        S_DOC_NO = data['S_DOC_NO'];
        E_DOC_TYPE = data['E_DOC_TYPE'];
        E_DOC_DATE = data['E_DOC_DATE'];
        E_DOC_NO = data['E_DOC_NO'];

        FLAG = data['FLAG'];
        LH_PAGE = data['LH_PAGE'];
        LH_DATE = data['LH_DATE'];
        LH_AR_NAME = data['LH_AR_NAME'];
        LH_LOGISTIC_COMP = data['LH_LOGISTIC_COMP'];
        LH_DOC_TYPE = data['LH_DOC_TYPE'];
        LH_WARE = data['LH_WARE'];
        LH_CAR_ID = data['LH_CAR_ID'];
        LH_DOC_NO = data['LH_DOC_NO'];

        LH_DOC_DATE = data['LH_DOC_DATE'];
        LH_INVOICE_NO = data['LH_INVOICE_NO'];
        LB_SEQ = data['LB_SEQ'];
        LB_ITEM_CODE = data['LB_ITEM_CODE'];
        LB_ITEM_NAME = data['LB_ITEM_NAME'];
        LB_LOCATION = data['LB_LOCATION'];
        LB_UMS = data['LB_UMS'];
        LB_LOTS_PRODUCT = data['LB_LOTS_PRODUCT'];
        LB_MO_NO = data['LB_MO_NO'];
        LB_TRAN_QTY = data['LB_TRAN_QTY'];
        LB_WEIGHT = data['LB_WEIGHT'];
        LB_PD_LOCATION = data['LB_PD_LOCATION'];

        LB_USED_TOTAL = data['LB_USED_TOTAL'];
        LT_NOTE = data['LT_NOTE'];
        LT_TOTAL_QTY = data['LT_TOTAL_QTY'];
        LT_ISSUE = data['LT_ISSUE'];
        LT_APPROVE = data['LT_APPROVE'];
        LT_OUT = data['LT_OUT'];
        LT_RECEIVE = data['LT_RECEIVE'];
        LT_BILL = data['LT_BILL'];
        LT_CHECK = data['LT_CHECK'];
        _launchUrl(doc_type,print_doc_no);

      } else {
        print('Failed to load data, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  String? reportname = 'SSFGDT31_REPORT';
  Future<void> _launchUrl(String doc_type,String print_doc_no) async {
  final uri = Uri.parse('http://172.16.0.82:8888/jri/report?'
      '&_repName=/WMS/$reportname'
      '&_repFormat=pdf'
      '&_dataSource=wms'
      '&_outFilename=${doc_type}-${print_doc_no}'
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
      '&P_DOC_TYPE=$doc_type'
      '&P_ERP_DOC_NO=$print_doc_no'

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
      '&LB_WEIGHT=$LB_WEIGHT'
      '&LB_PD_LOCATION=$LB_PD_LOCATION'
      '&LB_USED_TOTAL=$LB_USED_TOTAL'
      '&LT_NOTE=$LT_NOTE'
      '&LT_TOTAL_QTY=$LT_TOTAL_QTY'
      '&LT_ISSUE=$LT_ISSUE'
      '&LT_APPROVE=$LT_APPROVE'
      '&LT_OUT=$LT_OUT'
      '&LT_RECEIVE=$LT_RECEIVE'
      '&LT_BILL=$LT_BILL'
      '&LT_CHECK=$LT_CHECK'
  );

  print(uri);


  if (!await launchUrl(uri)) {
    throw Exception('Could not launch $uri');
  }
}


  Future<void> fetchData([String? url]) async {
    final String apiUrl = url ?? "http://172.16.0.82:8888/apex/wms/SSFGDT31/Card_Test/${widget.soNo}/${widget.statusDesc}/${widget.wareCode}/$DateSend";
    
    try {
      final response = await http.get(Uri.parse(apiUrl));
      print(apiUrl);

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final parsedResponse = json.decode(responseBody);

        setState(() {
          if (parsedResponse is Map && parsedResponse.containsKey('items')) {
            data = parsedResponse['items']; 
          } else {
            data = [];
          }
          
      
          List<dynamic> links = parsedResponse['links'];
          nextLink = getLink(links, 'next');
          prevLink = getLink(links, 'prev');

          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load data: $apiUrl';
          isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        errorMessage = 'Error fetching data: $error';
        isLoading = false;
      });
    }
  }

  String? getLink(List<dynamic> links, String rel) {
    final link = links.firstWhere((item) => item['rel'] == rel, orElse: () => null);
    return link != null ? link['href'] : null;
  }

  void _loadNextPage() {
    if (nextLink != null) {
      setState(() {
        isLoading = true;
      });
      fetchData(nextLink);
    }
  }

  void _loadPrevPage() {
    if (prevLink != null) {
      setState(() {
        isLoading = true;
      });
      fetchData(prevLink); 
    }
  }

  Widget buildListTile(BuildContext context, Map<String, dynamic> item) {
 Map<String, Color> statusColors = {
  'ยืนยันการรับ': const Color.fromARGB(255, 146, 208, 80),
  'ระหว่างบันทึก': const Color.fromARGB(255, 246, 250, 112),
  'ยกเลิก': const Color.fromARGB(255, 208, 206, 206),
};

String iconImageYorN;

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

  Color statusColor = statusColors[item['card_status_desc']] ?? Colors.white;

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
    child:  Card(
  elevation: 8.0,
  margin: const EdgeInsets.symmetric(vertical: 8.0),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(15.0),
  ),
  color: const Color.fromRGBO(204, 235, 252, 1.0),
  child: InkWell(
    onTap: () {
      
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
                onTap: ()  {
                 print(item['doc_no']);
                print('${item['doc_type']}');
                Inteface_receive_WMS2ERP(item['doc_no'],item['doc_type']);
                
               
                },
                child: Container(
                  width: 100,
                  height: 40,
                  child: Image.asset(
                    'assets/images/printer.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Text(
                '${item['po_date']} ${item['po_no']} ${item['item_stype_desc'] } ',
                style: const TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
      
        Positioned(
          top: 8.0,
          right: 8.0,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                decoration: BoxDecoration(
                  color: statusColor, // Use the color from the map
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: statusColor, width: 2.0),
                ),
                child: Text(
                  item['card_status_desc'] ?? 'Unknown',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // const SizedBox(height: 1.0),
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
),
  );
}

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xFF17153B),
    appBar: const CustomAppBar(title: 'รับคืนจากการเบิกผลิต'),
    body: OrientationBuilder(
      builder: (context, orientation) {
        final isPortrait = orientation == Orientation.portrait;

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              if (isPortrait)
                const SizedBox(height: 4),
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : errorMessage.isNotEmpty
                        ? Center(
                            child: Text(
                              'Error: $errorMessage',
                              style: const TextStyle(color: Colors.white),
                            ),
                          )
                        : data.isEmpty
                            ? const Center(
                                child: Text(
                                  'No Data Available',
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                            : ListView(
                                children: [
                                  // Build the list items
                                  ...data.map((item) => buildListTile(context, item)).toList(),
                                  // Add spacing if needed
                                  const SizedBox(height: 10),
                                  // Previous and Next buttons
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      ElevatedButton(
                                        onPressed: prevLink != null ? _loadPrevPage : null,
                                        child: const Text('Previous'),
                                      ),
                                      ElevatedButton(
                                        onPressed: nextLink != null ? _loadNextPage : null,
                                        child: const Text('Next'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
              ),
            ],
          ),
        );
      },
    ),
    bottomNavigationBar: BottomBar(),
  );
}

}
