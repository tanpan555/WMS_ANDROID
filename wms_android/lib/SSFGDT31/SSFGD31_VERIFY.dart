import 'dart:convert';
import 'dart:developer';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:wms_android/Global_Parameter.dart' as gb;
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/custom_appbar.dart';
import 'package:url_launcher/url_launcher.dart';

class SSFGDT31_VERIFY extends StatefulWidget {
  final String po_doc_no;
  final String po_doc_type;
  final String pWareCode;
  final String v_ref_doc_no;
  final String v_ref_type;
  final String SCHID;
  final String DOC_DATE;

  SSFGDT31_VERIFY({
    Key? key,
    required this.po_doc_no,
    required this.po_doc_type,
    required this.pWareCode,
    required this.v_ref_doc_no,
    required this.v_ref_type,
    required this.SCHID,
    required this.DOC_DATE,
  }) : super(key: key);

  @override
  _SSFGDT31_VERIFYState createState() => _SSFGDT31_VERIFYState();
}

class _SSFGDT31_VERIFYState extends State<SSFGDT31_VERIFY> {
  @override
  void initState() {
    super.initState();
    get_grid_data();
    
    
  }

  List<dynamic> items = [];
  String selectedItemDescName = '';
  String selectedPackDescName = '';

  final NumberFormat numberFormat = NumberFormat("#,##0");

  Future<void> get_grid_data() async {
    final url = Uri.parse(
        'http://172.16.0.82:8888/apex/wms/SSFGDT31/get_grid_data/${gb.P_OU_CODE}/${gb.P_ERP_OU_CODE}/${widget.po_doc_no}/${widget.po_doc_type}');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> fetchedItems = data['items'] ?? [];
        print(fetchedItems);

        if (fetchedItems.isNotEmpty) {
          setState(() {
            items = fetchedItems;
          });
        } else {
          print('No items found.');
        }
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

String? p_doc_no;
String? p_doc_type;
String? erp_doc_no;
String? po_status;
String? po_message;

  Future<void> Inteface_receive_WMS2ERP() async {
    final url =
        'http://172.16.0.82:8888/apex/wms/SSFGDT31/Inteface_receive_WMS2ERP/${widget.po_doc_no}/${widget.po_doc_type}/${gb.P_ERP_OU_CODE}/${gb.APP_USER}';
    print(url);
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        setState(() {
          p_doc_no = responseBody['p_doc_no'];
          p_doc_type = responseBody['p_doc_type'];
          erp_doc_no = responseBody['erp_doc_no'];
          po_status = responseBody['po_status'];
          po_message = responseBody['po_message'];

          print('p_doc_no: $p_doc_no');
          print('p_doc_type: $p_doc_type');
          print('erp_doc_no: $erp_doc_no');
          print('po_status: $po_status');
          print('po_message: $po_message');
        });
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



  void fetchPDFData() async {
    final url = Uri.parse(
        'http://172.16.0.82:8888/apex/wms/SSFGDT31/GET_PDF/${gb.APP_SESSION}/${widget.pWareCode}/${gb.APP_USER}/${gb.P_ERP_OU_CODE}/TH/${widget.po_doc_type}/wms');

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
        _launchUrl();

      } else {
        print('Failed to load data, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

String? reportname = 'SSFGDT31_REPORT';
  Future<void> _launchUrl() async {
  final uri = Uri.parse('http://172.16.0.82:8888/jri/report?'
      '&_repName=/$reportname'
      '&_repFormat=pdf'
      '&_dataSource=wms'

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
      '&P_DOC_TYPE=$p_doc_type'
      '&P_ERP_DOC_NO=$erp_doc_no'

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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'รับคืนจากการเบิกผลิต'),
      backgroundColor: const Color.fromARGB(255, 17, 0, 56),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Spacer(),
              ElevatedButton(
                onPressed: () async {
                  await Inteface_receive_WMS2ERP();
                  if(po_status == '1'){
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('คำเตือน'),
                            content: Text(po_message ?? ''),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('ตกลง'),
                              ),
                            ],
                          );
                        },
                      );
                  }
                  else{
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('คำเตือน'),
                            content: const Text(
                                'ต้องการพิมพ์เอกสารการรับคืนหรือไม่ ?'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('ยกเลิก'),
                              ),
                              Spacer(),
                              TextButton(
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                  fetchPDFData();
                                },
                                child: const Text('ตกลง'),
                              ),
                            ],
                          );
                        },
                      );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 212, 245, 212),
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: Text(
                  'Confirm',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          color: Colors.yellow[200],
                          border: Border.all(
                            color: Colors.black,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Center(
                          child: Text(
                            '${widget.po_doc_no}',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          border: Border.all(
                            color: Colors.black,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: TextField(
                          controller: TextEditingController(
                              text: selectedItemDescName),
                          decoration: InputDecoration(
                            labelText: 'Item Desc',
                            labelStyle: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            border:
                                InputBorder.none, 
                            contentPadding:
                                EdgeInsets.zero,
                          ),
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          readOnly: true,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          border: Border.all(
                            color: Colors.black,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: TextField(
                          controller: TextEditingController(
                              text: widget
                                  .SCHID),
                          decoration: InputDecoration(
                            labelText: 'เลขที่คำสั่งผลิต',
                            labelStyle: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            border:
                                InputBorder.none, 
                            contentPadding:
                                EdgeInsets.zero,
                          ),
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          readOnly: true,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          border: Border.all(
                            color: Colors.black,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: TextField(
                          controller: TextEditingController(
                              text: widget
                                  .DOC_DATE),
                          decoration: InputDecoration(
                            labelText: 'วันที่บันทึก',
                            labelStyle: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            border:
                                InputBorder.none,
                            contentPadding:
                                EdgeInsets.zero,
                          ),
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          readOnly: true,
                        ),
                      )
                    ],
                  );
                } else {
                  final item = items[index - 1];
                  return InkWell(
                    onTap: () {
                      setState(() {
                        selectedItemDescName = item['nb_item_name'] ?? '';
                        selectedPackDescName = item['nb_pack_name'] ?? '';
                      });
                    },
                    child: Card(
                      margin: const EdgeInsets.all(10),
                      color: const Color.fromRGBO(204, 235, 252, 1.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Lots No: ${item['lots_no'] ?? ''}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                )),
                            Text(
                                'Pack Qty: ${item['pack_qty'] != null ? numberFormat.format(item['pack_qty']) : ''}'),
                            Text('Item Code: ${item['item_code'] ?? ''}'),
                            Text('Old Pack Qty: ${item['old_pack_qty'] ?? ''}'),
                            Text('Pack Code: ${item['pack_code'] ?? ''}'),
                            Text(
                                'Location Code: ${item['location_code'] ?? ''}'),
                            Text('PD Location: ${item['attribute1'] ?? ''}'),
                            Text('Reason: ${item['attribute2'] ?? ''}'),
                            Text('ใช้แทนจุด: ${item['attribute3'] ?? ''}'),
                            Text('Replace Lot: ${item['attribute4'] ?? ''}'),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomBar(),
    );
  }
}
