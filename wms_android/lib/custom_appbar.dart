import 'package:flutter/material.dart';


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({
    super.key,
    this.title = 'WMS',
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      backgroundColor: const Color.fromARGB(255, 17, 0, 56),
      iconTheme: const IconThemeData(
        color: Colors.white,
        size: 18, // Set the back icon color to white
      ),
    // final isHomePage = ModalRoute.of(context)?.settings.name == '/home';
    // return AppBar(
    //   automaticallyImplyLeading: false,
    //   centerTitle: false,

    //   backgroundColor: const Color.fromARGB(255, 17, 0, 56),
    //   leading: isHomePage
    //     // padding: const EdgeInsets.symmetric(horizontal: 0),
    //       ? null//SizedBox()
    //       : IconButton(
    //     icon: Icon(
    //       Icons.arrow_back_outlined,
    //       color: Colors.white,
    //     ),
    //     onPressed: () {
    //       Navigator.pop(context);
    //     },
    //   ),
      title: GestureDetector(
        onTap: () {
          // Navigate back to the main page
          Navigator.popUntil(context, (route) => route.isFirst);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Image.asset(
              'assets/images/app-logo.png',
              height: 40.0, // Adjust the height as needed
            ),
            const SizedBox(width: 5),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
