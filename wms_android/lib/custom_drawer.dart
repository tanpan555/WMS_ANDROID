// import 'package:flutter/material.dart';
// import '../login.dart';

// class CustomDrawer extends StatelessWidget {
//   const CustomDrawer({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: MediaQuery.of(context).size.width * 0.6, // กำหนดความกว้างของ Drawer เป็นครึ่งหนึ่งของความกว้างของหน้าจอ
//       // color: Colors.grey[300],
//       child: Drawer(
//         backgroundColor: Colors.grey[300],
//         child: Column(
//           children: [
//             // DrawerHeader(
//             //       child: Container(
//             //     // color: Colors.blue,
//             //   )),
//             Expanded(
//               child: ListView(
//                 children: [
//                   ListTile(
//                     leading: Image.asset(
//                       'assets/images/exit.png',
//                       width: 25,
//                       height: 25,
//                     ),
//                     title: Text(
//                       'Sign Out',
//                       style: TextStyle(fontSize: 16),
//                     ),
//                     onTap: () {
//                       Navigator.of(context).pop();
//                       Navigator.of(context).push(
//                         MaterialPageRoute(
//                           builder: (context) => LoginPage(),
//                         ),
//                       );
//                     },
//                   ),
//                   const Divider(color: Colors.black26, thickness: 1),
//                   ListTile(
//                     leading: Image.asset(
//                       'assets/images/reset-password.png',
//                       width: 25,
//                       height: 25,
//                     ),
//                     title: Text(
//                       'Change Password',
//                       style: TextStyle(fontSize: 16),
//                     ),
//                     onTap: () {
//                       print('Change Password');
//                     },
//                   ),
//                   const Divider(color: Colors.black26, thickness: 1),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
