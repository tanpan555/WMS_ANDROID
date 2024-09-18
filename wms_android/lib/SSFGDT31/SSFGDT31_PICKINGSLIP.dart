import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:wms_android/Global_Parameter.dart' as gb;
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/custom_appbar.dart';
import 'package:url_launcher/url_launcher.dart';

class SSFGDT31_PICKINGSLIP extends StatefulWidget {
  final String po_doc_no;
  final String po_doc_type;
  final String pWareCode;
  final String v_ref_doc_no;
  final String v_ref_type;
  final String SCHID;

  SSFGDT31_PICKINGSLIP({
    Key? key,
    required this.po_doc_no,
    required this.po_doc_type,
    required this.pWareCode,
    required this.v_ref_doc_no,
    required this.v_ref_type, 
    required this.SCHID,
  }) : super(key: key);

  @override
  _SSFGDT31_PICKINGSLIPState createState() => _SSFGDT31_PICKINGSLIPState();
}

class _SSFGDT31_PICKINGSLIPState extends State<SSFGDT31_PICKINGSLIP> {

  @override
  void initState() {
    super.initState();
    get_slip_data();
  }
  List<dynamic> items = [];

   Future<void> get_slip_data() async {
    final url = Uri.parse(
        'http://172.16.0.82:8888/apex/wms/SSFGDT31/picking_slip_data/${gb.P_ERP_OU_CODE}/${gb.P_OU_CODE}/${widget.SCHID}');
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

  String? reportname = 'WMS_SSFGDT09L_Picking_Slip';

  Future<void> _launchUrl() async {
    final uri = Uri.parse('http://172.16.0.82:8888/jri/report?'
        '&_repName=/$reportname'
        '&_repFormat=pdf'
        '&_dataSource=wms'
        '&_outFilename=${widget.po_doc_no}'
        '&_repLocale=en_US'
        '&P_MO_DO_NO=${widget.SCHID}}'
        '&P_OU_CODE=${gb.P_OU_CODE}}'
        '&P_ERP_OU_CODE=${gb.P_ERP_OU_CODE}}');

    print(uri);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
  }



 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: CustomAppBar(title: 'Picking Slip'),
    backgroundColor: const Color.fromARGB(255, 17, 0, 56),
    body: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ElevatedButton(
                onPressed: () async {
                  await _launchUrl();
                  print('พิมพ์');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 103, 58, 183),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  minimumSize: const Size(10, 20),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                ),
                child: const Text(
                  'พิมพ์',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: items.isEmpty
              ? Center(
                  child: Text(
                    'No Data',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Item: ${item['material_code']}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'LOT: ${item['lot_no']}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Comb: ${item['comb']}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'ความต้องการใช้: ${item['usage_qty']}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Warehouse: ${item['ware_code']}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Locator: ${item['location_code']}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    ),
    bottomNavigationBar: BottomBar(),
  );
}


}
