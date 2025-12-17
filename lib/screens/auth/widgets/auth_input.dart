import 'package:flutter/material.dart';

import 'package:librium/core/constants/app_theme.dart';

class LoginField extends StatefulWidget {
  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final bool obscureText;
  final String? labelText;
  final String? hintText;
  final String? errorText;

  const LoginField({
    super.key,
    this.controller,
    this.textInputAction,
    this.validator,
    this.obscureText = false,
    this.labelText,
    this.hintText,
    this.errorText
  });

  @override
  State<LoginField> createState() => _LoginFieldState();
}
class _LoginFieldState extends State<LoginField> {
  final _fieldKey = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme().themeData;

    return TextFormField(
      key: _fieldKey,
      controller: widget.controller,
      textInputAction: widget.textInputAction,
      validator: widget.validator,
      onFieldSubmitted: (_) {
        _fieldKey.currentState?.validate();
      },
      onChanged: (value) {
        final currentState = _fieldKey.currentState;

        if (currentState != null && currentState.hasError) {
          final text = widget.controller?.text ?? "";

          currentState.reset();

          WidgetsBinding.instance.addPostFrameCallback((_) {
            widget.controller?.text = text;
            widget.controller?.selection = TextSelection.fromPosition(
              TextPosition(offset: text.length),
            );
          });
        }
      },
      obscureText: widget.obscureText,
      decoration: InputDecoration(
        labelStyle: TextStyle(
          fontSize: 17
        ),
        labelText: widget.labelText,
        hintStyle: TextStyle(
          fontSize: 17,
          color: theme.hintColor
        ),
        hintText: widget.hintText,
        errorStyle: const TextStyle(fontSize: 0),
        errorText: widget.errorText,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 17
        ),
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: theme.colorScheme.primary,
            width: 1.5
          )
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: theme.colorScheme.secondary,
            width: 2
          )
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: theme.colorScheme.error,
            width: 1.5
          )
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: theme.colorScheme.onError,
            width: 2
          )
        )
      )
    );
  }
}