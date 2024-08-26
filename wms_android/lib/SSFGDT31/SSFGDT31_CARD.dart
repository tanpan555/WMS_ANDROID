// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class SSFGDT31_CARD extends StatefulWidget {
//   final String soNo;
//   final String statusDesc;
//   final String wareCode;

//   SSFGDT31_CARD({required this.soNo, required this.statusDesc, required this.wareCode});

//   @override
//   _SSFGDT31_CARDPageState createState() => _SSFGDT31_CARDPageState();
// }

// class _SSFGDT31_CARDPageState extends State<SSFGDT31_CARD> {
//   List<dynamic> data = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }

//   Future<void> fetchData() async {
//     final String apiUrl = "http://172.16.0.82:8888/apex/wms/SSFGDT31/Card/${widget.soNo}/${widget.statusDesc}/${widget.wareCode}";
//     try {
//       final response = await http.get(Uri.parse(apiUrl));

//       if (response.statusCode == 200) {
//         setState(() {
//           data = json.decode(response.body);
//         });
//       } else {
//         // Handle server errors
//         throw Exception('Failed to load data');
//       }
//     } catch (error) {
//       // Handle network errors
//       print('Error fetching data: $error');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('SSFGDT31 Card'),
//       ),
//       body: data.isEmpty
//           ? Center(child: CircularProgressIndicator())
//           : ListView.builder(
//               itemCount: data.length,
//               itemBuilder: (context, index) {
//                 final item = data[index];
//                 return Card(
//                   child: ListTile(
//                     title: Text('Item ${item['name']}'), // Customize as per API response
//                     subtitle: Text('Detail: ${item['detail']}'), // Customize as per API response
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class SSFGDT31_CARD extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Card Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: 1, // จำนวนการ์ดที่ต้องการแสดง
          itemBuilder: (context, index) {
            return Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Card Title $index',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Card Description $index',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: SSFGDT31_CARD(),
  ));
}

