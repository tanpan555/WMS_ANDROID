import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({super.key, this.title = 'WMS'});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      backgroundColor: const Color.fromARGB(255, 103, 58, 183),
      // leading: Builder(
      //   builder: (BuildContext context) {
      //     return IconButton(
      //       icon: const Icon(Icons.menu, color: Colors.white),
      //       onPressed: () {
      //         Scaffold.of(context).openDrawer();
      //       },
      //     );
      //   },
      // ),
      title: GestureDetector(
        onTap: () {
          // Navigate back to the main page
          Navigator.popUntil(context, (route) => route.isFirst);
        },
        child: Row(
          children: [
            Image.asset(
              'assets/images/app-logo.png',
              height: 40.0, // Adjust the height as needed
            ),
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
