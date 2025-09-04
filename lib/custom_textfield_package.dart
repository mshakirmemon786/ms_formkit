import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  CustomTextField({
    Key? key,
    required this.controller,
    this.title = '',
    this.hintText = '',
    this.labelText = '',
    this.onlyNumbers = false,
    this.isPassword = false,
    this.showPasswordStrength = true,
    this.isRequired = false,
    this.showBorder = false,
    this.isDisabled = false,
    this.actionDone = false,
    this.actionNext = false,
    this.actionSearch = false,
    this.actionSend = false,
    this.actionNewLine = false,
    this.textInputNumber = false,
    this.textInputPhone = false,
    this.textInputDatetime = false,
    this.textInputEmailAddress = false,
    this.textInputNone = false,
    this.fillColor,
    this.borderColor,
    this.borderRadius = 8,

    this.fieldMarginAll = 0,
    this.fieldMarginTop = 5,
    this.fieldMarginBottom = 5,
    this.fieldMarginLeft = 5,
    this.fieldMarginRight = 5
    ,
    this.fieldPaddingAll = 0,
    this.fieldPaddingTop = 0,
    this.fieldPaddingBottom = 0,
    this.fieldPaddingLeft = 10,
    this.fieldPaddingRight = 10,
    
    this.fieldHeight,
    this.fieldWidth,
    this.titleFontSize,
    this.titleColor,
    this.onChanged,
    this.onActionDone,
    this.onActionNext,
    this.onActionSearch,
    this.onActionSend,
    this.onActionNewLine,
    this.maxLines,
    this.minLines,
    this.maxLength,
    this.minLength,
    this.showLengthCounter = true,
    this.prefixIcon,
    this.prefixIconSize,
    this.prefixIconColor,
    this.prefixAssetPath,
    this.prefixAssetPathWidth,
    this.prefixAssetPathHeight,
    this.suffixAssetPath,
    this.suffixAssetPathHeight,
    this.suffixAssetPathWidth,
    this.suffixIcon,
    this.suffixIconSize,
    this.suffixIconColor,
  });

  final TextEditingController controller;
  final String title;
  final String hintText;
  final String labelText;

  final bool onlyNumbers;
  final bool isPassword;
  final bool showPasswordStrength;
  final bool showBorder;
  final bool isDisabled;
  final bool isRequired;

  final bool actionDone;
  final bool actionNext;
  final bool actionSearch;
  final bool actionSend;
  final bool actionNewLine;

  final bool textInputNumber;
  final bool textInputPhone;
  final bool textInputDatetime;
  final bool textInputEmailAddress;
  final bool textInputNone;

  final double borderRadius;

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
  final Color? titleColor;

  final ValueChanged<String>? onChanged;

  final double? titleFontSize;

  final VoidCallback? onActionDone;
  final VoidCallback? onActionNext;
  final VoidCallback? onActionSearch;
  final VoidCallback? onActionSend;
  final VoidCallback? onActionNewLine;

  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final int? minLength;
  final bool showLengthCounter;

  final IconData? prefixIcon;
  final double? prefixIconSize;
  final Color? prefixIconColor;

  final IconData? suffixIcon;
  final double? suffixIconSize;
  final Color? suffixIconColor;

  final String? prefixAssetPath;
  final double? prefixAssetPathHeight;
  final double? prefixAssetPathWidth;

  final String? suffixAssetPath;
  final double? suffixAssetPathHeight;
  final double? suffixAssetPathWidth;

  // CustomTextField.password({
  //   Key? key,
  //   required TextEditingController controller,
  //   String title = 'Password',
  //   String hintText = 'Enter password',
  //   bool showPasswordStrength = true,
  // }) : this(
  //         controller: controller,
  //         title: title,
  //         hintText: hintText,
  //         isPassword: true,
  //         showPasswordStrength: showPasswordStrength,
  //       );

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
  static Color grey = Colors.grey;

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
      if (widget.title.isNotEmpty)
        Padding(
          padding: EdgeInsets.only(
            left: widget.fieldMarginAll != 0
                ? widget.fieldMarginAll
                : widget.fieldMarginLeft,
            top: widget.fieldMarginAll != 0 ? widget.fieldMarginAll : 0,
          ),
          child: RichText(
            text: TextSpan(
              text: widget.title,
              style: TextStyle(
                color: widget.titleColor ?? black,
                fontSize: widget.titleFontSize,
              ),
              children: widget.isRequired
                  ? [
                      TextSpan(
                        text: ' *',
                        style: TextStyle(color: red),
                      ),
                    ]
                  : [],
            ),
          ),
        ),
      Container(
        height: widget.fieldHeight ?? widget.fieldHeight,
        width: widget.fieldWidth ?? widget.fieldWidth,
        margin: widget.fieldMarginAll != 0
            ? (widget.title.isNotEmpty
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
          borderRadius: BorderRadius.circular(widget.borderRadius),
          color: widget.fillColor != null ? widget.fillColor : transparent,
        ),
        child: TextField(
          controller: _controller,
          keyboardType: widget.onlyNumbers
              ? TextInputType.numberWithOptions(decimal: false, signed: false)
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
          inputFormatters: widget.onlyNumbers
              ? [FilteringTextInputFormatter.digitsOnly]
              : [],
          textInputAction: widget.actionDone
              ? TextInputAction.done
              : widget.actionNext
                  ? TextInputAction.next
                  : widget.actionSearch
                      ? TextInputAction.search
                      : widget.actionSend
                          ? TextInputAction.send
                          : widget.actionNewLine
                              ? TextInputAction.newline
                              : TextInputAction.none,
          onSubmitted: (_) {
            if (widget.onActionDone != null) {
              widget.onActionDone!();
            } else if (widget.onActionNext != null) {
              widget.onActionNext!();
            } else if (widget.onActionSearch != null) {
              widget.onActionSearch!();
            } else if (widget.onActionSend != null) {
              widget.onActionSend!();
            } else if (widget.onActionNewLine != null) {
              widget.onActionNewLine!();
            } else {
              FocusScope.of(context).unfocus();
            }
          },
          maxLines: widget.maxLines ?? 1,
          minLines: widget.minLines,
          maxLength: widget.maxLength,
          buildCounter: widget.showLengthCounter
              ? null
              : (_,
                      {required int currentLength,
                      required int? maxLength,
                      required bool isFocused}) =>
                  null,
          readOnly: widget.isDisabled,
          decoration: InputDecoration(
            floatingLabelBehavior: widget.labelText.isNotEmpty
                ? FloatingLabelBehavior.always
                : FloatingLabelBehavior.never,
            labelText: widget.labelText,
            hintText: widget.hintText,
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
            border: (!widget.showBorder && widget.fillColor == null)
                ? InputBorder.none
                : OutlineInputBorder(
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    borderSide: BorderSide(
                        color: (widget.showBorder && widget.isRequired)
                            ? red
                            : widget.fillColor ?? (widget.borderColor ?? grey)),
                  ),
            enabledBorder: (!widget.showBorder && widget.fillColor == null)
                ? InputBorder.none
                : OutlineInputBorder(
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    borderSide: BorderSide(
                        color: (widget.showBorder && widget.isRequired)
                            ? red
                            : widget.fillColor ?? (widget.borderColor ?? grey)),
                  ),
            focusedBorder: (!widget.showBorder && widget.fillColor == null)
                ? InputBorder.none
                : OutlineInputBorder(
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    borderSide: BorderSide(
                      color: (widget.showBorder && widget.isRequired)
                          ? red
                          : widget.fillColor ?? (widget.borderColor ?? grey),
                    ),
                  ),
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
                : (widget.suffixIcon != null
                    ? Icon(
                        widget.suffixIcon,
                        color: widget.suffixIconColor ?? black,
                        size: widget.suffixIconSize,
                      )
                    : (widget.suffixAssetPath != null
                        ? Image.asset(
                            widget.suffixAssetPath!,
                            width: widget.suffixAssetPathWidth,
                            height: widget.suffixAssetPathHeight,
                          )
                        : null)),
            prefixIcon: widget.prefixIcon != null
                ? Icon(
                    widget.prefixIcon,
                    color: widget.prefixIconColor ?? black,
                    size: widget.prefixIconSize,
                  )
                : (widget.prefixAssetPath != null
                    ? Image.asset(
                        widget.prefixAssetPath!,
                        width: widget.prefixAssetPathWidth,
                        height: widget.prefixAssetPathHeight,
                      )
                    : null),

            // suffixIcon: widget.isPassword
            //     ? GestureDetector(
            //         child: Icon(
            //           _obscureText ? Icons.visibility_off : Icons.visibility,
            //           color: black,
            //         ),
            //         onTap: () {
            //           setState(() {
            //             _obscureText = !_obscureText;
            //           });
            //         },
            //       )
            //     : widget.suffixIcon != null
            //         ? GestureDetector(
            //             child: Icon(
            //               widget.suffixIcon,
            //               color: black,
            //             ),
            //             onTap: () {
            //               setState(() {
            //                 _obscureText = !_obscureText;
            //               });
            //             },
            //           )
            //         : widget.suffixAssetPath != null
            //             ? Image.asset(widget.suffixAssetPath!)
            //             : null,
          ),
        ),
      ),
      if (widget.isPassword &&
          _strengthLabel.isNotEmpty &&
          widget.showPasswordStrength)
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
      if (widget.isRequired &&
          !widget.showBorder &&
          widget.title.isEmpty &&
          !(widget.isPassword &&
              _strengthLabel.isNotEmpty &&
              widget.showPasswordStrength))
        Padding(
          padding: EdgeInsets.only(left: widget.fieldMarginLeft),
          child: Text(
            "This feild is required",
            style: TextStyle(
              color: red,
            ),
          ),
        )
    ]);
  }
}
