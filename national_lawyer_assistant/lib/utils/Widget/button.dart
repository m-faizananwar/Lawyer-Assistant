import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final VoidCallback onTab;
  final String text;

  const AppButton({
    super.key,
    required this.onTab,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10),
      child: InkWell(
        onTap: onTab,
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 12),
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            color: Colors.black,
          ),
          child: Text(
            text,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
