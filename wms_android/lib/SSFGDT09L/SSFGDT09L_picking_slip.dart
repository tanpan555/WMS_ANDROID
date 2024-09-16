import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/custom_appbar.dart';

class Ssfgdt09lPickingSlip extends StatefulWidget {
  final String pErpOuCode;
  final String pOuCode;
  final String pMoDoNO;

  Ssfgdt09lPickingSlip({
    Key? key,
    required this.pErpOuCode,
    required this.pOuCode,
    required this.pMoDoNO,
  }) : super(key: key);
  @override
  _Ssfgdt09lPickingSlipState createState() => _Ssfgdt09lPickingSlipState();
}

class _Ssfgdt09lPickingSlipState extends State<Ssfgdt09lPickingSlip> {
  List<dynamic> dataCard = [];

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGDT09L/SSFGDT09L_Step_3_PickingSilp/${widget.pErpOuCode}/${widget.pOuCode}/${widget.pMoDoNO}'));

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF17153B),
      appBar: CustomAppBar(title: 'Picking Silp'),
      body: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(children: [
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {},
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
                    'พิมพ์',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView(
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
                        child: Stack(children: [
                          Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                              'Item :${item['material_code'] ?? ''}'),
                                        ),
                                        Expanded(
                                          child: Text(
                                              'Lot :${item['lot_no'] ?? ''}'),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 4.0),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                              'Comb :${item['comb'] ?? ''}'),
                                        ),
                                        Expanded(
                                          child: Text(
                                              'ความต้องการใช้ :${item['usage_qty'] ?? ''}'),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 4.0),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                              'Warehouse :${item['ware_code'] ?? ''}'),
                                        ),
                                        Expanded(
                                          child: Text(
                                              'Locator :${item['location_code'] ?? ''}'),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 4.0),
                                  ]))
                        ])),
                  );
                }).toList(),
              ),
            ),
          ])),
      bottomNavigationBar: BottomBar(),
    );
  }
}
