import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wms_android/SSINDT01/SSINDT01_search.dart';
import 'dart:convert';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/custom_appbar.dart';
import 'package:wms_android/Global_Parameter.dart' as gb;
import '../loading.dart';

class SSFGDT01_WARE extends StatefulWidget {
  final String p_attr1;
  final String p_ou_code;

  const SSFGDT01_WARE({
    Key? key,
    required this.p_attr1,
    required this.p_ou_code,
  }) : super(key: key);

  @override
  _SSFGDT01_WAREState createState() => _SSFGDT01_WAREState();
}

class _SSFGDT01_WAREState extends State<SSFGDT01_WARE> {
  List<dynamic> data = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(
          '${gb.IP_API}/apex/wms/SSINDT01/Step_1_ware_code/${gb.P_ERP_OU_CODE}/${gb.ATTR1}'));

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
      appBar: CustomAppBar(title: 'รับจากการสั่งซื้อ', showExitWarning: false),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: isLoading
            ? Center(child: LoadingIndicator())
            : Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    margin: const EdgeInsets.only(bottom: 8.0),
                    color: Colors.grey[300],
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
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 5,
                              childAspectRatio: 1.0,
                            ),
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              final item = data[index];
                              return Card(
                                elevation: 4,
                                child: InkWell(
                                  onTap: () {
                                    gb.P_WARE_CODE = item['ware_code'];
                                    print(
                                        'Selected Global Ware Code: ${gb.P_WARE_CODE}');
                                    log('Selected Global Ware Code: ${gb.P_WARE_CODE}');

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SSINDT01_SEARCH(
                                          pWareCode: item['ware_code'],
                                          pWareName: item['ware_name'],
                                          p_ou_code: widget.p_ou_code,
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
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
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
      bottomNavigationBar: BottomBar(currentPage: 'not_show'),
    );
  }
}
