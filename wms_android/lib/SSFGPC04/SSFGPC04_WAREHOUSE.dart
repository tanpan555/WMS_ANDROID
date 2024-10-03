import 'package:flutter/material.dart';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/custom_appbar.dart';
import '../styles.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:wms_android/Global_Parameter.dart' as gb;

class SSFGPC04_WAREHOUSE extends StatefulWidget {
  const SSFGPC04_WAREHOUSE({super.key});

  @override
  _SSFGPC04_WAREHOUSEState createState() => _SSFGPC04_WAREHOUSEState();
}

class _SSFGPC04_WAREHOUSEState extends State<SSFGPC04_WAREHOUSE> {
  List<Map<String, dynamic>> whItems = [];
  bool isLoading = true;

  void _selectAll(bool value) {
    setState(() {
      for (var row in whItems) {
        row["selected"] = value;
      }
    });
  }

  void _deselectAll() {
    setState(() {
      for (var row in whItems) {
        row["selected"] = false;
      }
    });
  }

  void _navigateBackWithSelectedData() {
  List<Map<String, dynamic>> selectedItems = whItems
      .where((item) => item['selected'] == true)
      .toList();

  // ส่งข้อมูลที่เลือกกลับไปยังหน้าจอหลัก โดยไม่ยกเลิกการเลือก
  Navigator.pop(context, selectedItems);
}



  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGPC04/Step_1_IN_WAREHOUSE/${gb.APP_SESSION}/${gb.P_ERP_OU_CODE}'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $responseData');

        setState(() {
          whItems = List<Map<String, dynamic>>.from(responseData['items'] ?? []);
          isLoading = false;
        });
        print('dataTable : $whItems');
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
      appBar: const CustomAppBar(title: 'เลือกคลังสินค้า'),
      backgroundColor: const Color.fromARGB(255, 17, 0, 56),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: () => _selectAll(true),
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
                  onPressed: _deselectAll,
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
      bottomNavigationBar: BottomBar(),
    );
  }

  Widget _buildDataTable() {
  return Container(
    color: Colors.white, // Set the background color of the table to white
    child: Column(
      children: whItems.map((row) {
        print('Row data: $row');
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Checkbox(
                value: row["selected"] ?? false, // Ensure 'selected' has a default value
                onChanged: (bool? value) {
                  setState(() {
                    row["selected"] = value!;
                  });
                },
              ),
              const SizedBox(width: 10),
              Text(
                row['ware_code'] ?? 'NULL', // Display the 'WAREHOUSE_CODE' field
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(width: 10),
              Text(
                row['ware_name'] ?? 'NULL', // Display the 'WAREHOUSE_NAME' field
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      }).toList(),
    ),
  );
}
}
