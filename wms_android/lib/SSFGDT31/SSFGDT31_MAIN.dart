import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../custom_appbar.dart';
import '../bottombar.dart';
import 'SSFGDT31_SCREEN2.dart';

class SSFGDT31_MAIN extends StatefulWidget {
  @override
  _SSFGDT31_MAINState createState() => _SSFGDT31_MAINState();
}

class _SSFGDT31_MAINState extends State<SSFGDT31_MAIN> {
  List<dynamic> warehouseCodes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchWarehouseCodes();
  }

  Future<void> fetchWarehouseCodes() async {
    try {
      final response = await http
          .get(Uri.parse('http://172.16.0.82:8888/apex/wms/SSFGDT31/whcode'));
      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final data = jsonDecode(responseBody);
        print('Fetched data: $jsonDecode'); // Debug: Print the entire response

        setState(() {
          warehouseCodes = List<Map<String, dynamic>>.from(data['items'] ?? []);
          print('dataMenu: $warehouseCodes'); // Debug: Print parsed codes
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load warehouse codes');
      }
    } catch (e) {
      setState(() {});
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'รับคืนจากการเบิกผลิต'),
      backgroundColor: Color.fromARGB(255, 17, 0, 56),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    margin: const EdgeInsets.only(
                        bottom: 8.0), // Add some space below the container
                    color: Colors
                        .greenAccent, // Customize the background color of the container
                    child: Center(
                      child: Text(
                        'เลือกคลังปฏิบัติงาน',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: warehouseCodes.isNotEmpty
                        ? GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1 / 1,
                              crossAxisSpacing: 8.0,
                              mainAxisSpacing: 8.0,
                            ),
                            itemCount: warehouseCodes.length,
                            itemBuilder: (context, index) {
                              final item = warehouseCodes[index];
                              return Card(
                                elevation: 4,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SSFGDT31_SCREEN2()),
                                    );
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/images/warehouse_blue.png',
                                        width: 60,
                                        height: 60,
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        item['ware_code'] ?? 'ware_code = null',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        : Center(
                            child: Text(
                              'No warehouse codes available',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                  ),
                ],
              ),
      ),
      bottomNavigationBar: BottomBar(),
    );
  }
}
