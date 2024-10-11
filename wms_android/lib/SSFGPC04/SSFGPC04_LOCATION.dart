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
  List<Map<String, dynamic>> locItems = [];
  bool isLoading = true;

  void _selectAll(bool value) {
    if (mounted) {setState(() {
      for (var row in locItems) {
        row["selected"] = value;
      }
    });}
  }

  void _deselectAll() {
    if (mounted) {setState(() {
      for (var row in locItems) {
        row["selected"] = false;
      }
    });}
  }


  void _navigateBackWithSelectedData() async {
  List<Map<String, dynamic>> selectedItems =
      locItems.where((item) => item['selected'] == true).toList();

  // ส่งค่า WARE_CODE ที่เลือกไปที่ API
  String nbSelValue = selectedItems.isNotEmpty ? 'Y' : 'N';
  gb.P_WARE_CODE = selectedItems.map((item) => item['ware_code']).join(',');

  // เรียกใช้ API เพื่อเช็คข้อมูลตามค่า NB_SEL ที่ได้
  await fetchCheck(nbSelValue);

  // เช็คว่า widget ยังอยู่หรือไม่ก่อนทำการ pop
  if (mounted) {
    Navigator.pop(context, selectedItems);
  }
}


  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
  try {
    final response = await http.get(Uri.parse(
        'http://172.16.0.82:8888/apex/wms/SSFGPC04/Step_2_IN_LOCATION/${gb.P_ERP_OU_CODE}/${gb.APP_SESSION}'));

    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes);
      final responseData = jsonDecode(responseBody);
      print('Fetched data: $responseData');

      // เก็บรหัสคลังที่เลือกไว้ใน Global Parameter
      List<String> selectedWareCodes = gb.P_WARE_CODE.split(',');

      if (mounted) {setState(() {
        locItems = List<Map<String, dynamic>>.from(responseData['items'] ?? [])
          ..forEach((row) {
            // ตรวจสอบว่า ware_code ในรายการอยู่ใน selectedWareCodes หรือไม่
            row["selected"] = selectedWareCodes.contains(row['ware_code']);
          });
        isLoading = false;
      });}
      print('dataTable : $locItems');
    } else {
      throw Exception('Failed to load fetchData');
    }
  } catch (e) {
    if (mounted) {setState(() {
      isLoading = false;
    });}
    print('ERROR IN Fetch Data : $e');
  }
}


  Future<void> fetchCheck(String? nbSel) async {
    const url =
        'http://172.16.0.82:8888/apex/wms/SSFGPC04/Step_2_PU_DEL_TMP_LOC';

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'APP_SESSION': gb.APP_SESSION,
      // 'WARE_CODE': gb.P_WARE_CODE, // ส่งรหัสคลังที่เลือกไปด้วย
      // 'P_ERP_OU_CODE': gb.P_ERP_OU_CODE,
      // 'NB_SEL': nbSel, // ส่งค่า NB_SEL เป็น 'Y' หรือ 'N'
    });

    print('Request body: $body');

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (mounted) {setState(() {
          // ดำเนินการอื่นๆ เมื่อเช็คสำเร็จ เช่นการอัปเดตตารางหรือแสดงข้อความ
        });}
        print('Success: $responseData');
      } else {
        print('Failed to post data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
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
      bottomNavigationBar: BottomBar(currentPage: 'show'),
    );
  }

  Widget _buildDataTable() {
  return Container(
    color: Colors.white, // Set the background color of the table to white
    child: Column(
      children: locItems.map((row) {
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
                row['ware_code'] ?? '', // Display the 'WAREHOUSE_CODE' field
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(width: 10),Text(
                row['location_code'] ?? '', // Display the 'WAREHOUSE_CODE' field
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(width: 10),
              Text(
                row['location_name'] ?? '', // Display the 'WAREHOUSE_NAME' field
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
