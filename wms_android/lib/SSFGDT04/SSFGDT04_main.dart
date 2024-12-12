import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../custom_appbar.dart';
import '../bottombar.dart';
import 'SSFGDT04_MENU.dart';
import 'package:wms_android/Global_Parameter.dart' as gb;
import '../loading.dart';

class SSFGDT04_MAIN extends StatefulWidget {
  final String p_attr1;
  final String p_ou_code;

  const SSFGDT04_MAIN({
    super.key,
    required this.p_attr1,
    required this.p_ou_code,
  });

  @override
  _SSFGDT04_MAINState createState() => _SSFGDT04_MAINState();
}

class _SSFGDT04_MAINState extends State<SSFGDT04_MAIN> {
  List<dynamic> datawarehouse = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
    print(gb.ATTR1);
    print(gb.P_ERP_OU_CODE);
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(
          '${gb.IP_API}/apex/wms/SSFGDT04/Step_1_ware_code/${gb.P_ERP_OU_CODE}/${gb.ATTR1}'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $responseData');

        if (mounted) {
          setState(() {
            datawarehouse =
                List<Map<String, dynamic>>.from(responseData['items'] ?? []);
            isLoading = false;
          });
        }
        print('dataMenu : $datawarehouse');
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
      appBar:
          CustomAppBar(title: 'รับตรง (ไม่อ้าง PO)', showExitWarning: false),
      // backgroundColor: const Color.fromARGB(255, 17, 0, 56),
      // endDrawer:CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: isLoading
            ? Center(child: LoadingIndicator())
            // ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    margin: const EdgeInsets.only(bottom: 8.0),
                    color: Colors.grey[300],
                    child: const Center(
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
                    child: datawarehouse.isNotEmpty
                        ? GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 5,
                              childAspectRatio: 1.0,
                            ),
                            itemCount: datawarehouse.length,
                            itemBuilder: (context, index) {
                              final item = datawarehouse[index];
                              return Card(
                                // elevation: 4,
                                child: InkWell(
                                  onTap: () {
                                    gb.P_WARE_CODE = item['ware_code'];
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
                        : const Center(
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
