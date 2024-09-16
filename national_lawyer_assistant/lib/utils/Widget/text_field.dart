import 'package:flutter/material.dart';

class TextFieldInput extends StatefulWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final String hintText;
  final IconData? icon;
  final String? Function(String?)? validator;
  final double left;

  const TextFieldInput({
    Key? key,
    required this.textEditingController,
    this.isPass = false,
    required this.hintText,
    this.left = 40,
    this.icon,
    this.validator,
  }) : super(key: key);

  @override
  State<TextFieldInput> createState() => _TextFieldInputState();
}

class _TextFieldInputState extends State<TextFieldInput> {
  // Variable to toggle password visibility
  bool _isObscured = true;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.isPass;
  }

  @override
  Widget build(BuildContext context) {
    final double leftPadding = widget.left;
    return Padding(
      padding: EdgeInsets.fromLTRB(leftPadding, 10, 40, 10),
      child: TextFormField(
        obscureText: widget.isPass ? _isObscured : false,
        controller: widget.textEditingController,
        cursorColor: Theme.of(context).colorScheme.secondary,
        decoration: InputDecoration(
          errorStyle: const TextStyle(
            color: Colors.red,
            fontSize: 16,
          ),
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: Colors.black.withOpacity(0.5),
            fontSize: 18,
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 10,
          ),
          prefixIcon: widget.icon == null
              ? null
              : Icon(
                  widget.icon,
                  color: Colors.black,
                ),
          suffixIcon: widget.isPass
              ? IconButton(
                  icon: Icon(
                    _isObscured ? Icons.visibility : Icons.visibility_off,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscured = !_isObscured;
                    });
                  },
                )
              : null,
          filled: true,
          fillColor: Colors.transparent,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: Colors.black,
            ),
            borderRadius: BorderRadius.circular(6),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 3, color: Colors.purple[900]!),
            borderRadius: BorderRadius.circular(6),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 2, color: Colors.red),
            borderRadius: BorderRadius.circular(6),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 3, color: Colors.red),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        validator: widget.validator, // Add validator logic
      ),
    );
  }
}
