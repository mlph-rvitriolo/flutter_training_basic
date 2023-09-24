import 'package:flutter/material.dart';

/// Creates a TextFormField with obscureText enabled.
/// This also includes validation to ensure password is
///     * at least 8 characters long
///     * with at least one upper case character
///     * with at least one number

class PasswordTextField extends StatefulWidget {
  ///
  const PasswordTextField(this.controller,
      {this.labelText = 'Password',
      this.validator,
      Key? key,
      this.icon,
      this.requireSpecialChar = false,
      this.passwordValue})
      : super(key: key);

  final TextEditingController controller;
  final String labelText;
  final FormFieldValidator<String>? validator;
  final String? passwordValue;
  final bool requireSpecialChar;
  final Widget? icon;

  @override
  State<StatefulWidget> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        style: const TextStyle(
          color: Colors.black87,
        ),
        obscureText: _obscurePassword,
        autofocus: false,
        decoration: InputDecoration(
          errorMaxLines: 2,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
                  BorderSide(color: Colors.black.withOpacity(0.38), width: 2)),
          errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red, width: 2),
              borderRadius: BorderRadius.circular(8)),
          focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red, width: 2),
              borderRadius: BorderRadius.circular(8)),
          errorStyle: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(fontSize: 12, color: Colors.red),
          labelText: '${widget.labelText} *',
          hintText: widget.labelText,
          contentPadding: const EdgeInsets.all(19),
          icon: widget.icon,
          suffixIcon: IconButton(
            icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: _obscurePassword
                    ? Colors.black54
                    : Theme.of(context).colorScheme.secondary),
            onPressed: () => setState(() {
              _obscurePassword = !_obscurePassword;
            }),
          ),
        ),
        validator: (value) {
          if (widget.validator != null) {
            return widget.validator!(value);
          }
          if (value!.isEmpty) {
            return 'Please enter a password.';
          } else if (value.length < 8) {
            return 'Password must be at least 8 characters.';
          } else if (!value.contains(RegExp('[A-Z]'))) {
            return 'Password must have at least one uppercase.';
          } else if (!value.contains(RegExp('[0-9]'))) {
            return 'Password must have at least one number.';
          } else if (widget.requireSpecialChar &&
              !value.contains(RegExp(r'[~!@#$%^&*()_+<>:"{}_+|<>;?=-]'))) {
            return 'Password must have at least one special character.';
          } else if (widget.passwordValue != null) {
            if (value != widget.passwordValue) {
              return 'Password is not the same';
            }
          } else {
            return null;
          }
          return null;
        },
        controller: widget.controller,
      ),
    );
  }
}
