import 'package:flutter/material.dart';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/custom_appbar.dart';
import '../styles.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:wms_android/Global_Parameter.dart' as gb;

class SSFGPC04_LOCATION extends StatefulWidget {
  const SSFGPC04_LOCATION({super.key});

  @override
  _SSFGPC04_LOCATIONState createState() => _SSFGPC04_LOCATIONState();
}

class _SSFGPC04_LOCATIONState extends State<SSFGPC04_LOCATION> {
  List<Map<String, dynamic>> filteredLocItems = [];
  List<Map<String, dynamic>> locItems = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();

  void _selectAll(bool value) {
    if (mounted) {
      setState(() {
        for (var row in filteredLocItems) {
          row["selected"] = value;
        }
      });
    }
  }

  void _deselectAll() {
    if (mounted) {
      setState(() {
        for (var row in filteredLocItems) {
          row["selected"] = false;
        }
      });
    }
  }

  void _navigateBackWithSelectedData() async {
    List<Map<String, dynamic>> selectedItems =
        locItems.where((item) => item['selected'] == true).toList();
    gb.P_WARE_CODE = selectedItems.map((item) => item['ware_code']).join(',');
    if (mounted) {
      Navigator.pop(context, selectedItems);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    searchController.addListener(_filterItems);
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGPC04/Step_2_IN_LOCATION/${gb.P_ERP_OU_CODE}/${gb.APP_SESSION}'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $responseData');
        List<String> selectedWareCodes = gb.P_WARE_CODE.split(',');

        if (mounted) {
          setState(() {
            locItems =
                List<Map<String, dynamic>>.from(responseData['items'] ?? [])
                  ..forEach((row) {
                    row["selected"] =
                        selectedWareCodes.contains(row['ware_code']);
                  });
            filteredLocItems = locItems;
            isLoading = false;
          });
        }
        print('locItems: $locItems');
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

  void _filterItems() {
    String query = searchController.text.toLowerCase();
    if (mounted) {
      setState(() {
        filteredLocItems = locItems.where((item) {
          final wareCode = item['ware_code']?.toLowerCase() ?? '';
          final locCode = item['location_code']?.toLowerCase() ?? '';
          final locName = item['nb_location_name']?.toLowerCase() ?? '';
          return wareCode.contains(query) ||
              locCode.contains(query) ||
              locName.contains(query);
        }).toList();
      });
    }
  }

  Future<void> fetchCheck(String? loc) async {
    const url =
        'http://172.16.0.82:8888/apex/wms/SSFGPC04/Step_2_PU_INS_TMP_LOC_SEL';

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'APP_SESSION': gb.APP_SESSION,
      'WARE_CODE': gb.P_WARE_CODE, // ส่งรหัสคลังที่เลือกไปด้วย
      'LOCATION_CODE': loc, // ส่งค่า NB_SEL เป็น 'Y' หรือ 'N'
    });

    print('Request body: $body');

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          try {
            final Map<String, dynamic> responseData = jsonDecode(response.body);
            if (mounted) {
              setState(() {
                // Perform any additional UI updates here
              });
            }
            print('Success: $responseData');
          } catch (e) {
            print('Error decoding JSON: $e');
          }
        } else {
          print('Response body is empty');
        }
      } else {
        print('Failed to post data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error1 นะฮ๊าฟฟู๊วววว: $e');
    }
  }

  String message = '';
  Future<void> deleteData(String? wareCode) async {
    final String url =
        'http://172.16.0.82:8888/apex/wms/SSFGPC04/Step_2_PU_INS_TMP_LOC_SEL';

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json', // เปลี่ยนได้ตามต้องการ
          // 'Authorization': 'Bearer your_token', // ถ้าต้องการใช้ token
        },
        body: jsonEncode({
          'APP_SESSION': gb.APP_SESSION,
          'WARE_CODE': wareCode,
        }),
      );

      if (response.statusCode == 200) {
        // หากการลบสำเร็จ
        setState(() {
          message = 'Data deleted successfully.';
        });
      } else {
        // หากไม่สำเร็จ
        setState(() {
          message =
              'Failed to delete data. Status code: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        message = 'Error2 นะฮ๊าฟฟู๊วววว: $e';
      });
    }
  }

  

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          CustomAppBar(title: 'เลือกตำแหน่งที่จัดเก็บ', showExitWarning: false),
      backgroundColor: const Color.fromARGB(255, 17, 0, 56),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: const InputDecoration(
                hintText: 'ค้นหาตำแหน่งที่จัดเก็บ',
                suffixIcon:
                    Icon(Icons.search), // Place the search icon at the end
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white, // Set the background color to white
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _selectAll(true); // เลือกทั้งหมด (ติ๊กถูกทุกแถว)
                    for (var row in filteredLocItems) {
                      fetchCheck(row[
                          'ware_code']); // ส่งคำขอ POST สำหรับทุกแถวที่เลือก
                    }
                  },
                  child: const Text(
                    'Select All',
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: AppStyles.cancelButtonStyle(),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    _deselectAll(); // ยกเลิกการเลือกทั้งหมด (ติ๊กออกทุกแถว)
                    for (var row in filteredLocItems) {
                      deleteData(row[
                          'ware_code']); // ส่งคำขอ DELETE สำหรับทุกแถวที่ติ๊กออก
                    }
                  },
                  child: const Text(
                    'Deselect All',
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: AppStyles.cancelButtonStyle(),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: _buildDataTable(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _navigateBackWithSelectedData,
              child: const Text(
                'กลับสู่หน้าจอหลัก',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: AppStyles.cancelButtonStyle(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(currentPage: 'show'),
    );
  }

  Widget _buildDataTable() {
    if (locItems.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 100), // Adjust the top padding as needed
        child: const Center(
          child: Text(
            'No data found', // Show message when no data is available
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              // fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }
    return Container(
      color: Colors.white,
      child: Column(
        children: locItems.map((row) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      row["selected"] =
                          !(row["selected"] ?? false); // สลับสถานะ
                    });

                    if (row["selected"]!) {
                      fetchCheck(row['ware_code']);
                    } else {
                      deleteData(row['ware_code']);
                    }
                  },
                  child: Row(
                    children: [
                      Checkbox(
                        value: row["selected"] ?? false,
                        onChanged: (bool? value) {
                          setState(() {
                            row["selected"] = value!;
                          });

                          // ตรวจสอบสถานะของ Checkbox เพื่อเลือกว่าจะเรียก POST หรือ DELETE
                          if (value == true) {
                            // ถ้าเลือก (ติ๊กถูก) => รัน .post
                            fetchCheck(row['ware_code']);
                          } else {
                            // ถ้าไม่เลือก (ติ๊กออก) => รัน .delete
                            deleteData(row['ware_code']);
                          }
                        },
                      ),
                      // เพิ่มเนื้อหาที่เหลือของ Row ที่นี่
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    row['ware_code'] ?? '',
                    style: const TextStyle(fontSize: 14),
                    // textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Expanded(
                  child: Text(
                    row['location_code'] ?? '',
                    style: const TextStyle(fontSize: 14),
                    // textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Expanded(
                  child: Text(
                    row['location_name'] ?? '',
                    style: const TextStyle(fontSize: 14),
                    // textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
