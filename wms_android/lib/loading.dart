import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final Color color;

  LoadingIndicator({Key? key})
      : color = Colors.white,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}
