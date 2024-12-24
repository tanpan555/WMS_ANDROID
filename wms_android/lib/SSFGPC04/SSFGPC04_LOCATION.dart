import 'package:flutter/material.dart';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/custom_appbar.dart';
import '../styles.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:wms_android/Global_Parameter.dart' as gb;
import 'SSFGPC04_LOC.dart';
import '../loading.dart';

class SSFGPC04_LOCATION extends StatefulWidget {
  final String date;
  final String note;
  final String docNo;
  const SSFGPC04_LOCATION({
    Key? key,
    // required this.selectedItems,
    required this.date,
    required this.note,
    required this.docNo,
  }) : super(key: key);

  @override
  _SSFGPC04_LOCATIONState createState() => _SSFGPC04_LOCATIONState();
}

class _SSFGPC04_LOCATIONState extends State<SSFGPC04_LOCATION> {
  List<Map<String, dynamic>> filteredLocItems = [];
  List<Map<String, dynamic>> locItems = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();
  // bool _isAllSelected = false;

  void _selectAll(bool value) {
    if (mounted) {
      setState(() {
        for (var row in filteredLocItems) {
          row['nb_sel'] = value;
        }
      });
    }
  }

  void _deselectAll() {
    if (mounted) {
      setState(() {
        for (var row in filteredLocItems) {
          row['nb_sel'] = false;
        }
      });
    }
  }
  bool get _isAllSelected {
    return filteredLocItems.every((row) => row['nb_sel'] == true);
  }

  // void _navigateBackWithSelectedData() async {
  //   if (mounted) {
  //     Navigator.pop(context);
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => SSFGPC04_LOC(
  //           date: widget.date,
  //           note: widget.note,
  //           docNo: widget.docNo,
  //         ),
  //       ),
  //     );
  //   }
  // }

  @override
  void initState() {
    super.initState();
    fetchData();
    searchController.addListener(_filterItems);
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(
          '${gb.IP_API}/apex/wms/SSFGPC04/Step_2_IN_LOCATION/${gb.P_ERP_OU_CODE}/${gb.APP_SESSION}'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $responseData');

        if (mounted) {
          setState(() {
            locItems =
                List<Map<String, dynamic>>.from(responseData['items'] ?? [])
                  ..forEach((row) {
                    row['nb_sel'] = (row['nb_sel'] == 'Y') ? true : false;
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

  Future<void> fetchCheck(String? loc, String? wareCode) async {
    final url = '${gb.IP_API}/apex/wms/SSFGPC04/Step_2_PU_INS_TMP_LOC_SEL';
    print('post loc : $url');
    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'APP_SESSION': gb.APP_SESSION,
      'WARE_CODE': wareCode, // ส่งรหัสคลังที่เลือกไปด้วย
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
        '${gb.IP_API}/apex/wms/SSFGPC04/Step_2_PU_INS_TMP_LOC_SEL';
    print('delete loc : $url');

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
      body: Padding(
        padding: const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 8),
        child: isLoading
            ? Center(child: LoadingIndicator())
            : Column(
          children: [
            // TextField(
            //   controller: searchController,
            //   decoration: InputDecoration(
            //     hintText: 'ค้นหาตำแหน่งที่จัดเก็บ',
            //     border: const OutlineInputBorder(),
            //     filled: true,
            //     fillColor: Colors.white,
            //     suffixIcon: searchController.text.isNotEmpty
            //         ? GestureDetector(
            //             onTap: () {
            //               searchController.clear();
            //               setState(() {});
            //             },
            //             child: Container(
            //               width: 3,
            //               height: 3,
            //               margin: const EdgeInsets.all(10),
            //               decoration: BoxDecoration(
            //                 color: Colors.grey.withOpacity(0.2),
            //                 borderRadius: BorderRadius.circular(20.0),
            //               ),
            //               child: const Icon(
            //                 MyIcons.close,
            //                 size: 15,
            //                 color: Color(0xFF676767),
            //               ),
            //             ),
            //           )
            //         : null,
            //   ),
            //   onChanged: (query) {
            //     setState(() {});
            //   },
            // ),
            // const SizedBox(height: 20),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   children: [
            //     ElevatedButton(
            //       onPressed: () {
            //         _selectAll(true); // เลือกทั้งหมด (ติ๊กถูกทุกแถว)
            //         for (var row in filteredLocItems) {
            //           fetchCheck(row['location_code'],
            //               row['ware_code']); // ส่งคำขอ POST สำหรับทุกแถวที่เลือก
            //         }
            //       },
            //       child: const Text(
            //         'Select All',
            //         style: TextStyle(
            //           color: Color.fromARGB(255, 0, 0, 0),
            //           fontWeight: FontWeight.bold,
            //         ),
            //       ),
            //       style: AppStyles.cancelButtonStyle(),
            //     ),
            //     const SizedBox(width: 10),
            //     ElevatedButton(
            //       onPressed: () {
            //         _deselectAll(); // ยกเลิกการเลือกทั้งหมด (ติ๊กออกทุกแถว)
            //         for (var row in filteredLocItems) {
            //           deleteData(row[
            //               'ware_code']); // ส่งคำขอ DELETE สำหรับทุกแถวที่ติ๊กออก
            //         }
            //       },
            //       child: const Text(
            //         'Deselect All',
            //         style: TextStyle(
            //           color: Color.fromARGB(255, 0, 0, 0),
            //           fontWeight: FontWeight.bold,
            //         ),
            //       ),
            //       style: AppStyles.cancelButtonStyle(),
            //     ),
            //   ],
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(
                  value: _isAllSelected,
                  onChanged: (bool? value) {
                    setState(() {
                      final newValue = value ?? false;
                      if (newValue) {
                        _selectAll(true);
                        for (var row in filteredLocItems) {
                          fetchCheck(row['location_code'],
                          row['ware_code']);
                        }
                      } else {
                        _deselectAll();
                        for (var row in filteredLocItems) {
                          deleteData(row['ware_code']);
                        }
                      }
                    });
                  },
                  fillColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
                      return Colors.deepPurple[400];
                    }
                    return Colors.white;
                  }),
                  // activeColor: Colors.deepPurple[300], // สีของ Checkbox เมื่อถูกเลือก
                  // checkColor: Colors.white, // สีของเครื่องหมายถูก
                ),
                const Text(
                  'All',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                child: _buildDataTable(),
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              // onPressed: _navigateBackWithSelectedData,
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SSFGPC04_LOC(
                      date: widget.date,
                      note: widget.note,
                      docNo: widget.docNo,
                    ),
                  ),
                );
              },
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
        padding:
            const EdgeInsets.only(top: 100), // Adjust the top padding as needed
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
          return Column(
              children: [
                Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      row['nb_sel'] = !(row['nb_sel'] ?? false); // สลับสถานะ
                    });

                    if (row['nb_sel']!) {
                      fetchCheck(row['location_code'], row['ware_code']);
                    } else {
                      deleteData(row['ware_code']);
                    }
                  },
                  child: Row(
                    children: [
                      Checkbox(
                        value: row['nb_sel'] ?? false,
                        onChanged: (bool? value) {
                          setState(() {
                            row['nb_sel'] = value!;
                          });
                          // ตรวจสอบสถานะของ Checkbox เพื่อเลือกว่าจะเรียก POST หรือ DELETE
                          if (value == true) {
                            // ถ้าเลือก (ติ๊กถูก) => รัน .post
                            fetchCheck(row['location_code'], row['ware_code']);
                          } else {
                            // ถ้าไม่เลือก (ติ๊กออก) => รัน .delete
                            deleteData(row['ware_code']);
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '${row['location_code'] ?? ''}\n',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold, // ทำให้ตัวหนา
                          ),
                        ),
                        TextSpan(
                          text: '${row['ware_code'] ?? ''}  ',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal, // ตัวปกติ
                          ),
                        ),
                        TextSpan(
                          text: '${row['location_name'] ?? ''}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal, // ตัวปกติ
                          ),
                        ),
                      ],
                    ),
                    overflow: TextOverflow.visible,
                    softWrap: true,
                  ),
                ),
              ],
            ),
          ),
          const Divider(
                color: Colors.black54,
                thickness: 1,
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
