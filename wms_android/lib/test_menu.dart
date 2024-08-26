// import 'package:flutter/material.dart';
// import 'custom_appbar.dart';
// import 'custom_drawer.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'test_menu_lv2.dart';
// import 'package:wms_android/Global_Parameter.dart' as globals;
// // import 'package:intl/intl.dart';

// class TestMenu_LV_1 extends StatefulWidget {
//   @override
//   _TestMenu_LV_1State createState() => _TestMenu_LV_1State();
// }

// class _TestMenu_LV_1State extends State<TestMenu_LV_1> {
//   List<dynamic> dataMenu = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }

//   Future<void> fetchData() async {
//     try {
//       final response = await http
//           .get(Uri.parse('http://172.16.0.82:8888/apex/wms/c/menu_level_1'));

//       if (response.statusCode == 200) {
//         final responseBody = utf8.decode(response.bodyBytes);
//         final responseData = jsonDecode(responseBody);
//         print('Fetched data: $jsonDecode');

//         setState(() {
//           dataMenu =
//               List<Map<String, dynamic>>.from(responseData['items'] ?? []);
//           print(globals.APP_USER);
//         });
//         print('dataMenu : $dataMenu');
//       } else {
//         throw Exception('Failed to load fetchData');
//       }
//     } catch (e) {
//       setState(() {});
//       print('ERROR IN Fetch Data : $e');
//     }
//   }

//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const CustomAppBar(),
//       drawer: const CustomDrawer(),
//       body: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: Column(
//           children: [
//             Text(globals.APP_USER),
//             const SizedBox(height: 20), // Spacing above the grid
//             Expanded(
//             child: SingleChildScrollView(
//               child: GridView.builder(
//                 shrinkWrap: true,
//                 physics: NeverScrollableScrollPhysics(),
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2, // Number of columns
//                   crossAxisSpacing: 5, // Horizontal spacing between cards
//                   mainAxisSpacing: 5, // Vertical spacing between cards
//                   childAspectRatio: 1.0, // Aspect ratio for each card
//                 ),
//                 itemCount: dataMenu.length,
//                 itemBuilder: (context, index) {
//                   final item = dataMenu[index];

//                   // เช็คค่า card_value และกำหนดไอคอนและสีของ Card ตามที่ต้องการ
//                   IconData iconData;
//                   Color cardColor;

//                   switch (item['card_value']) {
//                     case 'WMS คลังวัตถุดิบ':
//                       iconData = Icons.inventory_2_outlined;
//                       cardColor = Colors.blueAccent;
//                       break;
//                     case 'WMS คลังสำเร็จรูป':
//                       iconData = Icons.shopping_bag_outlined;
//                       cardColor = Colors.orangeAccent;
//                       break;
//                     case 'พิมพ์ Tag':
//                       iconData = Icons.discount_outlined;
//                       cardColor = Colors.greenAccent;
//                       break;
//                     case 'ตรวจนับประจำงวด':
//                       iconData = Icons.folder_outlined;
//                       cardColor = Colors.greenAccent;
//                       break;
//                     // เพิ่มกรณีอื่นๆ ตามที่ต้องการ
//                     default:
//                       iconData = Icons.help; // ไอคอนและสีเริ่มต้น
//                       cardColor = Colors.grey;
//                   }

//                   return GestureDetector(
//                     onTap: () {
//                       // ทำงานเมื่อการ์ดถูกกด
//                       // ตัวอย่าง: แสดงข้อความ
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content: Text('Clicked on ${item['card_value']}'),
//                         ),
//                       );

//                       // หรือคุณสามารถนำทางไปยังหน้าอื่น
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) =>
//                               TestMenuLv2(menu_id: item['menu_id']),
//                         ),
//                       );
//                     },
//                     child: Card(
//                       elevation: 4.0,
//                       margin: const EdgeInsets.symmetric(vertical: 8.0),
//                       color: cardColor, // กำหนดสีของ Card
//                       shape: RoundedRectangleBorder(
//                         borderRadius:
//                             BorderRadius.circular(5), // ปรับความโค้งมนของขอบ
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(15.0), // เพิ่ม padding
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(
//                               iconData,
//                               size: 50, // ขนาดของไอคอน
//                               color: Colors.black,
//                             ),
//                             const SizedBox(
//                                 height:
//                                     20), // เพิ่มช่องว่างระหว่างไอคอนกับข้อความ
//                             Text(
//                               item['card_value'] ?? 'No Name',
//                               style: const TextStyle(
//                                 fontSize: 12,
//                                 color: Colors.black,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             const SizedBox(
//                                 height: 8), // เพิ่มช่องว่างระหว่างข้อความ
//                             Text(
//                               item['menu_id'] ?? '',
//                               style: const TextStyle(
//                                 fontSize: 10,
//                                 color: Colors.black54,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
