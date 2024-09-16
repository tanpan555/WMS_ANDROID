import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:wms_android/SSFGDT17/SSFGD17_VERIFY.dart';
import 'package:wms_android/SSFGDT17/SSFGDT17_BARCODE.dart';
import 'package:wms_android/SSFGDT17/SSFGDT17_FORM.dart';
import 'package:wms_android/SSFGDT31/SSFGDT31_BARCODE.dart';
import 'package:wms_android/custom_appbar.dart';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/main.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:wms_android/Global_Parameter.dart' as gb;

class SSFGDT31_GRID extends StatefulWidget {
  final String po_doc_no;
  final String po_doc_type;
  final String pWareCode;
  final String v_ref_doc_no;
  final String v_ref_type;

  SSFGDT31_GRID({
    Key? key,
    required this.po_doc_no,
    required this.po_doc_type,
    required this.pWareCode,
    required this.v_ref_doc_no, 
    required this.v_ref_type,
  }) : super(key: key);

  @override
  _SSFGDT31_GRIDState createState() => _SSFGDT31_GRIDState();
}
class _SSFGDT31_GRIDState extends State<SSFGDT31_GRID> {
  List<dynamic> items = [];

  @override
  void initState() {
    super.initState();
    get_grid_data();
  }

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
            items = fetchedItems; // Update state with the fetched items
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
              ElevatedButton(
                onPressed: () async {
                   final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SSFGDT31_BARCODE(
          po_doc_no: widget.po_doc_no,
          po_doc_type: widget.po_doc_type,
          pWareCode: widget.pWareCode,
          v_ref_doc_no: widget.v_ref_doc_no,
          v_ref_type: widget.v_ref_type,
        ),
      ),
    );
    if (result == true) {
      await get_grid_data(); // Refresh the grid data
    }
                  print('+Create');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 103, 58, 183),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  minimumSize: const Size(10, 20),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                ),
                child: const Text(
                  '+Create',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  
                  print('Picking Slip');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 103, 58, 183),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  minimumSize: const Size(10, 20),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                ),
                child: const Text(
                  'Picking Slip',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                width: 40.0,
                height: 40.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: IconButton(
                  iconSize: 20.0,
                  icon: Image.asset(
                    'assets/images/right.png',
                    width: 20.0,
                    height: 20.0,
                  ),
                  onPressed: () {
                    print('Right button pressed');
                  },
                ),
              ),
            ],
          ),
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
          Expanded(
            child: items.isNotEmpty
                ? ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Card(
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
                              Text('Pack Qty: ${item['pack_qty'] ?? ''}'),

                              Text('Item Code: ${item['item_code'] ?? ''}'),

                              Text(
                                  'old pack qty: ${item['old_pack_qty'] ?? ''}'),
                           
                              Text('pack code: ${item['pack_code'] ?? ''}'),
                              Text('location code: ${item['location_code'] ?? ''}'),

                              Text('PD Location: ${item['attribute1'] ?? ''}'),
                              Text('Reason: ${item['attribute2'] ?? ''}'),
                              Text('ใช้แทนจุด: ${item['attribute3'] ?? ''}'),
                              Text('Replace Lot: ${item['attribute4'] ?? ''}'),
                           
                              // Add other fields as needed
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : const Center(
                    child: Text(
                      'No data available',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
