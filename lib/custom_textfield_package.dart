import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    this.fieldTitle = '',
    this.borderTitle = '',
    this.hintText = '',
    this.labelText = '',
    this.isOnlyTypeNumber = false,
    this.isPassword = false,
    this.isPasswordError = true,
    this.showBorder = false,
    this.isDisable = false,
    this.isActionDone = false,
    this.isActionNext = false,
    this.isActionSearch = false,
    this.isActionSend = false,
    this.isActionNewLine = false,
    this.textInputText = false,
    this.textInputNumber = false,
    this.textInputPhone = false,
    this.textInputDatetime = false,
    this.textInputEmailAddress = false,
    this.textInputNone = false,
    this.fillColor,
    this.borderColor,
    this.radius = 8,
    this.fieldMarginAll = 0,
    this.fieldMarginTop = 5,
    this.fieldMarginBottom = 5,
    this.fieldMarginLeft = 5,
    this.fieldMarginRight = 5,
    this.fieldPaddingAll = 0,
    this.fieldPaddingTop = 0,
    this.fieldPaddingBottom = 0,
    this.fieldPaddingLeft = 10,
    this.fieldPaddingRight = 10,
    this.fieldHeight,
    this.fieldWidth,
    this.fieldTitleFontSize,
    this.fieldTitleColor,
    this.onChanged,
  });

  final TextEditingController controller;
  final String fieldTitle;
  final String borderTitle;
  final String hintText;
  final String labelText;

  final bool isOnlyTypeNumber;
  final bool isPassword;
  final bool isPasswordError;
  final bool showBorder;
  final bool isDisable;

  final bool isActionDone;
  final bool isActionNext;
  final bool isActionSearch;
  final bool isActionSend;
  final bool isActionNewLine;

  final bool textInputText;
  final bool textInputNumber;
  final bool textInputPhone;
  final bool textInputDatetime;
  final bool textInputEmailAddress;
  final bool textInputNone;

  final double radius;

  final double fieldMarginAll;
  final double fieldMarginTop;
  final double fieldMarginBottom;
  final double fieldMarginLeft;
  final double fieldMarginRight;

  final double fieldPaddingAll;
  final double fieldPaddingTop;
  final double fieldPaddingBottom;
  final double fieldPaddingLeft;
  final double fieldPaddingRight;

  final double? fieldHeight;
  final double? fieldWidth;

  final Color? fillColor;
  final Color? borderColor;
  final Color? fieldTitleColor;

  final ValueChanged<String>? onChanged;

  final double? fieldTitleFontSize;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late TextEditingController _controller;

  bool _obscureText = true;

  double _strength = 0;

  String _strengthLabel = '';
  static Color green = Colors.green;
  static Color red = Colors.red;
  static Color orange = Colors.orange;
  static Color transparent = Colors.transparent;
  static Color black = Colors.black;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    if (!widget.isPassword) _obscureText = false;
    if (widget.isPassword) {
      _controller.addListener(_checkPasswordStrength);
    }
  }

  void _checkPasswordStrength() {
    final password = _controller.text.trim();
    final hasLetters = RegExp(r'[A-Za-z]').hasMatch(password);
    final hasNumbers = RegExp(r'\d').hasMatch(password);
    final hasSpecial =
        RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-\\/\[\]]').hasMatch(password);

    if (password.isEmpty) {
      _strength = 0;
      _strengthLabel = '';
    } else if (password.length < 8) {
      _strength = 0.25;
      _strengthLabel = 'Too short';
    } else if ((hasLetters && !hasNumbers && !hasSpecial) ||
        (!hasLetters && hasNumbers && !hasSpecial) ||
        (!hasLetters && !hasNumbers && hasSpecial)) {
      _strength = 0.25;
      _strengthLabel = 'Weak — type letters, numbers, and symbols';
    } else if ((hasLetters && hasNumbers && !hasSpecial) ||
        (hasLetters && !hasNumbers && hasSpecial) ||
        (!hasLetters && hasNumbers && hasSpecial)) {
      _strength = 0.5;
      _strengthLabel = 'Medium';
    } else if (hasLetters && hasNumbers && hasSpecial) {
      _strength = 1.0;
      _strengthLabel = 'Strong';
    } else {
      _strength = 0.25;
      _strengthLabel = 'Weak — type letters, numbers, and symbols';
    }

    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (widget.fieldTitle.isNotEmpty)
        Padding(
          padding: EdgeInsets.only(
            left: widget.fieldMarginAll != 0
                ? widget.fieldMarginAll
                : widget.fieldMarginLeft,
            top: widget.fieldMarginAll != 0 ? widget.fieldMarginAll : 0,
          ),
          child: Text(
            widget.fieldTitle,
            style: TextStyle(
                color: widget.fieldTitleColor,
                fontSize: widget.fieldTitleFontSize),
          ),
        ),
      Container(
        height: widget.fieldHeight ?? widget.fieldHeight,
        width: widget.fieldWidth ?? widget.fieldWidth,
        margin: widget.fieldMarginAll != 0
            ? (widget.fieldTitle.isNotEmpty
                ? EdgeInsets.only(
                    top: widget.fieldMarginTop,
                    bottom: widget.fieldMarginAll,
                    left: widget.fieldMarginAll,
                    right: widget.fieldMarginAll,
                  )
                : EdgeInsets.all(widget.fieldMarginAll))
            : EdgeInsets.only(
                top: widget.fieldMarginTop,
                bottom: widget.fieldMarginBottom,
                left: widget.fieldMarginLeft,
                right: widget.fieldMarginRight,
              ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.radius),
            color: widget.fillColor != null ? widget.fillColor : transparent,
            border: widget.showBorder ? Border.all() : null),
        child: TextField(
          controller: _controller,
          keyboardType: widget.isOnlyTypeNumber
              ? TextInputType.numberWithOptions(decimal: false, signed: false)
              : widget.textInputText
                  ? TextInputType.text
                  : widget.textInputNumber
                      ? TextInputType.number
                      : widget.textInputPhone
                          ? TextInputType.phone
                          : widget.textInputDatetime
                              ? TextInputType.datetime
                              : widget.textInputEmailAddress
                                  ? TextInputType.emailAddress
                                  : widget.textInputNone
                                      ? TextInputType.none
                                      : TextInputType.text,
          obscureText: _obscureText,
          onChanged: (value) {
            widget.onChanged?.call(value);
            if (widget.isPassword) _checkPasswordStrength();
          },
          inputFormatters: widget.isOnlyTypeNumber
              ? [FilteringTextInputFormatter.digitsOnly]
              : [],
          textInputAction: widget.isActionDone
              ? TextInputAction.done
              : widget.isActionNext
                  ? TextInputAction.next
                  : widget.isActionSearch
                      ? TextInputAction.search
                      : widget.isActionSend
                          ? TextInputAction.send
                          : widget.isActionNewLine
                              ? TextInputAction.newline
                              : TextInputAction.none,
          onSubmitted: (_) {
            if (widget.isActionDone) {
              FocusScope.of(context).unfocus();
            } else if (widget.isActionNext) {
              FocusScope.of(context).nextFocus();
            } else if (widget.isActionSearch) {
            } else if (widget.isActionSend) {}
          },
          readOnly: widget.isDisable,
          decoration: InputDecoration(
            contentPadding: widget.fieldPaddingAll != 0
                ? EdgeInsets.only(
                    top: widget.fieldPaddingAll,
                    bottom: widget.fieldPaddingAll,
                    left: widget.fieldPaddingAll,
                    right: widget.fieldPaddingAll,
                  )
                : EdgeInsets.only(
                    top: !widget.isPassword
                        ? widget.fieldPaddingTop
                        : (widget.fieldPaddingTop + 10),
                    bottom: widget.fieldPaddingBottom,
                    left: widget.fieldPaddingLeft,
                    right: widget.fieldPaddingRight,
                  ),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            suffixIcon: widget.isPassword
                ? GestureDetector(
                    child: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: black,
                    ),
                    onTap: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : null,
          ),
        ),
      ),
      if (widget.isPassword &&
          _strengthLabel.isNotEmpty &&
          widget.isPasswordError)
        Padding(
          padding: EdgeInsets.only(left: widget.fieldMarginLeft),
          child: Text(
            _strengthLabel,
            style: TextStyle(
              color: _strength >= 0.75
                  ? green
                  : _strength >= 0.5
                      ? orange
                      : red,
            ),
          ),
        ),
    ]);
  }
}
