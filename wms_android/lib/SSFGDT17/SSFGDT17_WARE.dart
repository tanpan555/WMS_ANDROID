import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/custom_appbar.dart';
import 'SSFGDT17_MENU.dart';
import 'package:wms_android/Global_Parameter.dart' as gb;
import '../loading.dart';

class SSFGDT17_WARE extends StatefulWidget {
  final String p_attr1;
  final String p_ou_code;

  const SSFGDT17_WARE({
    Key? key,
    required this.p_attr1,
    required this.p_ou_code,
  }) : super(key: key);

  @override
  _SSFGDT17_WAREState createState() => _SSFGDT17_WAREState();
}

class _SSFGDT17_WAREState extends State<SSFGDT17_WARE> {
  List<dynamic> data = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    print('=================================');
    print(gb.ATTR1);
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(
          '${gb.IP_API}/apex/wms/SSFGDT17/Step_1_whcode/${gb.ATTR1}/${gb.P_ERP_OU_CODE}'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $responseData');
        if (mounted) {
          setState(() {
            data = List<Map<String, dynamic>>.from(responseData['items'] ?? []);
            isLoading = false;
          });
        }
        print('dataMenu : $data');
      } else {
        throw Exception('Failed to load fetchData');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      print('ERROR IN Fetch Data : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Move Locator', showExitWarning: false),
      // backgroundColor: Color(0xFF17153B),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: isLoading
            // ? Center(child: CircularProgressIndicator())
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
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SSFGDT17_MENU(
                                          pWareCode: item['ware_code'],
                                          pWareName: item['ware_name'],
                                          p_ou_code: gb.P_ERP_OU_CODE,
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
