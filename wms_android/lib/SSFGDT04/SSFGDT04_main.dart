import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../custom_appbar.dart';
import '../bottombar.dart';
import 'SSFGDT04_MENU.dart';
import 'package:wms_android/Global_Parameter.dart' as gb;

class SSFGDT04_MAIN extends StatefulWidget {
  final String p_attr1;
  final String p_ou_code;

  const SSFGDT04_MAIN({
    Key? key,
    required this.p_attr1,
    required this.p_ou_code,
  }) : super(key: key);

  @override
  _SSFGDT04_MAINState createState() => _SSFGDT04_MAINState();
}

class _SSFGDT04_MAINState extends State<SSFGDT04_MAIN> {
  List<dynamic> data = [];
  final ScrollController _scrollController = ScrollController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
    print(widget.p_attr1);
    print(gb.P_ERP_OU_CODE);
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGDT04/Step_1_ware_code/${gb.P_ERP_OU_CODE}/${gb.ATTR1}'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $responseData');

        setState(() {
          data = List<Map<String, dynamic>>.from(responseData['items'] ?? []);
          isLoading = false;
        });
        print('dataMenu : $data');
      } else {
        throw Exception('Failed to load fetchData');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('ERROR IN Fetch Data : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'รับตรง (ไม่อ้าง PO)'),
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
                    color: Colors.grey[
                        300], // Customize the background color of the container
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
                    child: data.isNotEmpty
                        ? GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1 / 1,
                              crossAxisSpacing: 8.0,
                              mainAxisSpacing: 8.0,
                            ),
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              final item = data[index];
                              return Card(
                                elevation: 4,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SSFGDT04_MENU(
                                          pWareCode: gb.P_WARE_CODE,
                                          pErpOuCode: gb.P_ERP_OU_CODE,
                                        ),
                                      ),
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
