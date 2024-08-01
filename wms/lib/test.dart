import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class test extends StatefulWidget {
  @override
  _testState createState() => _testState();
}

class _testState extends State<test> {
 
  @override
  void initState() {
    super.initState();
    fetchWareCodes();
  }

 List<dynamic> data = [];
  String? selectedWareCode;
  Future<void> fetchWareCodes() async {
    try {
      final response = await http.get(Uri.parse('http://172.16.0.82:8888/apex/wms/WH/WHCode'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final jsonData = json.decode(responseBody);

        print('Fetched data: $jsonData');

        setState(() {
          data = jsonData['items'];
          if (data.isNotEmpty) {
            selectedWareCode = data[0]['ware_code'];
          }
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {

    final wareCodes = data.map((item) => item['ware_code'] as String).toSet().toList();


    final filteredData = selectedWareCode == null
        ? []
        : data.where((item) => item['ware_code'] == selectedWareCode).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Warehouse Codes'),
      ),
      body: data.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                DropdownButton<String>(
                  value: selectedWareCode,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedWareCode = newValue;
                    });
                  },
                  items: wareCodes.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredData.length,
                    itemBuilder: (context, index) {
                      final item = filteredData[index];

                    
                      final wareName = item['ware_name'] ?? 'No Name';
                      final wareCode = item['ware_code'] ?? 'No Code';

                      return ListTile(
                        title: Text(wareName),
                        subtitle: Text(wareCode),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
