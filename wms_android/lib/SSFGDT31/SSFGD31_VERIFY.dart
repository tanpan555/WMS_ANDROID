import 'dart:convert';
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
                        padding: const EdgeInsets.all(12.0),
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
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          border: Border.all(
                            color: Colors.black,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Center(
                          child: Text(
                            'Item Desc: $selectedItemDescName',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(12.0),
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
                              fontSize: 16,
                            ),
                            border:
                                InputBorder.none, 
                            contentPadding:
                                EdgeInsets.zero,
                          ),
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(12.0),
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
                              fontSize: 16,
                            ),
                            border:
                                InputBorder.none,
                            contentPadding:
                                EdgeInsets.zero,
                          ),
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
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
