import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final isHomePage = ModalRoute.of(context)?.settings.name == '/home';
    return AppBar(
      centerTitle: false,
      backgroundColor: Color(0xFF17153B),
      leading: isHomePage
          ? null
          : IconButton(
              icon: Icon(
                Icons.arrow_back_outlined,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
      title: GestureDetector(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(),
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
      // actions: [
      //   Padding(
      //     padding: const EdgeInsets.symmetric(horizontal: 8.0),
      //     child: Row(
      //       children: [
      //         IconButton(
      //           icon: const FaIcon(
      //             FontAwesomeIcons.user,
      //             size: 18.0,
      //             color: Colors.white,
      //           ),
      //           onPressed: () {
      //             // Define your onPressed action here
      //           },
      //         ),
      //         IconButton(
      //           icon: const FaIcon(
      //             FontAwesomeIcons.angleDown,
      //             size: 15.0,
      //             color: Colors.white,
      //           ),
      //           onPressed: () {
      //             // Define your onPressed action here
      //           },
      //         ),
      //       ],
      //     ),
      //   ),
      // ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
