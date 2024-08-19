import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      backgroundColor: Color(0xFF17153B),
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        },
      ),
      title: GestureDetector(
        // onTap: () {
        // Navigate back to the main page
        // Navigator.popUntil(context, (route) => route.isFirst);
        // },
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(
                Icons.arrow_back_outlined,
                color: Colors.white, // ปรับสีไอคอนตามที่ต้องการ
              ),
              onPressed: () {
                Navigator.pop(context); // ทำการย้อนกลับไปยังหน้าก่อนหน้า
              },
            ),
            // Image.asset(
            //   'assets/images/app-logo.png',
            //   height: 40.0, // Adjust the height as needed
            // ),
            const SizedBox(width: 8.0),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
          ],
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              // IconButton(
              //   icon: const FaIcon(
              //     FontAwesomeIcons.user,
              //     size: 18.0,
              //     color: Colors.white,
              //   ),
              //   onPressed: () {
              //     // Define your onPressed action here
              //   },
              // ),
              // IconButton(
              //   icon: const FaIcon(
              //     FontAwesomeIcons.angleDown,
              //     size: 15.0,
              //     color: Colors.white,
              //   ),
              //   onPressed: () {
              //     // Define your onPressed action here
              //   },
              // ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
