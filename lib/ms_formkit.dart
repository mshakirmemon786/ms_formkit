import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A reusable custom text field widget with support for:
/// - password visibility toggle
/// - password strength indicator
/// - required field validation message
/// - prefix/suffix icons or asset images
/// - dynamic padding, margin, borders and colors
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
    this.keyboardType = TextInputType.text,
    this.fillColor,
    this.borderColor,
    this.borderRadius = 8,
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
    this.requiredMessage = "This feild is required",
  });

  // Core text editing controller
  final TextEditingController controller;

  // Labels and hints
  final String title;
  final String hintText;
  final String labelText;

  // Behavior flags
  final bool onlyNumbers;
  final bool isPassword;
  final bool showPasswordStrength;
  final bool showBorder;
  final bool isDisabled;
  final bool isRequired;

  // Keyboard action buttons
  final bool actionDone;
  final bool actionNext;
  final bool actionSearch;
  final bool actionSend;
  final bool actionNewLine;

  // Input configuration
  final TextInputType keyboardType;

  // Border and radius
  final double borderRadius;

  // Margins
  final double fieldMarginAll;
  final double fieldMarginTop;
  final double fieldMarginBottom;
  final double fieldMarginLeft;
  final double fieldMarginRight;

  // Padding
  final double fieldPaddingAll;
  final double fieldPaddingTop;
  final double fieldPaddingBottom;
  final double fieldPaddingLeft;
  final double fieldPaddingRight;

  // Field dimensions
  final double? fieldHeight;
  final double? fieldWidth;

  // Colors
  final Color? fillColor;
  final Color? borderColor;
  final Color? titleColor;

  final double? titleFontSize;

  // Callbacks
  final ValueChanged<String>? onChanged;

  final VoidCallback? onActionDone;
  final VoidCallback? onActionNext;
  final VoidCallback? onActionSearch;
  final VoidCallback? onActionSend;
  final VoidCallback? onActionNewLine;

  // Text field limits
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final int? minLength;
  final bool showLengthCounter;

  // Prefix icon settings
  final IconData? prefixIcon;
  final double? prefixIconSize;
  final Color? prefixIconColor;

  // Suffix icon settings
  final IconData? suffixIcon;
  final double? suffixIconSize;
  final Color? suffixIconColor;

  // Prefix asset image settings
  final String? prefixAssetPath;
  final double? prefixAssetPathHeight;
  final double? prefixAssetPathWidth;

  // Suffix asset image settings
  final String? suffixAssetPath;
  final double? suffixAssetPathHeight;
  final double? suffixAssetPathWidth;

  // Error message when field is required
  final String requiredMessage;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late TextEditingController _controller;
  bool _obscureText = true;

  double _strength = 0;
  String _strengthLabel = '';

  // Commonly used colors
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

    // Only password fields should start obscured
    if (!widget.isPassword) _obscureText = false;

    // Listen for password strength updates
    if (widget.isPassword) {
      _controller.addListener(_checkPasswordStrength);
    }
  }

  @override
  void dispose() {
    // Controller is not disposed here since it's passed from outside
    // Whoever owns the controller should dispose it.
    super.dispose();
  }

  /// Returns margin for the text field container or title.
  EdgeInsets getFieldMargin({bool forTitle = false}) {
    if (widget.fieldMarginAll != 0) {
      if (forTitle) {
        return EdgeInsets.only(
          left: widget.fieldMarginAll,
          top: widget.fieldMarginAll,
        );
      }
      return EdgeInsets.all(widget.fieldMarginAll);
    } else {
      return EdgeInsets.only(
        top: widget.fieldMarginTop,
        bottom: widget.fieldMarginBottom,
        left: widget.fieldMarginLeft,
        right: widget.fieldMarginRight,
      );
    }
  }

  /// Returns padding inside the text field.
  EdgeInsets getFieldPadding() {
    if (widget.fieldPaddingAll != 0) {
      return EdgeInsets.all(widget.fieldPaddingAll);
    } else {
      return EdgeInsets.only(
        top: !widget.isPassword
            ? widget.fieldPaddingTop
            : (widget.fieldPaddingTop + 10), // extra space for password toggle
        bottom: widget.fieldPaddingBottom,
        left: widget.fieldPaddingLeft,
        right: widget.fieldPaddingRight,
      );
    }
  }

  /// Evaluates and sets the password strength label and color.
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

  /// Builds border style depending on showBorder and colors.
  InputBorder _getBorder(Color color) {
    if (!widget.showBorder && widget.fillColor == null) {
      return InputBorder.none;
    }
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      borderSide: BorderSide(color: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // Show title if provided
      if (widget.title.isNotEmpty)
        Padding(
          padding: getFieldMargin(forTitle: true),
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

      // Main text field container
      Container(
        height: widget.fieldHeight,
        width: widget.fieldWidth,
        margin: getFieldMargin(),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          color: widget.fillColor ?? transparent,
        ),
        child: TextField(
          controller: _controller,
          keyboardType:
              widget.onlyNumbers ? TextInputType.number : widget.keyboardType,
          obscureText: _obscureText,
          onChanged: (value) {
            widget.onChanged?.call(value);
            if (widget.isPassword) _checkPasswordStrength();
          },
          inputFormatters: widget.onlyNumbers
              ? [FilteringTextInputFormatter.digitsOnly]
              : [],
          // Keyboard action mapping
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
            // Fire provided callbacks or just unfocus
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
            contentPadding: getFieldPadding(),
            border: _getBorder(widget.showBorder && widget.isRequired
                ? red
                : (widget.borderColor ?? grey)),
            enabledBorder: _getBorder(widget.showBorder && widget.isRequired
                ? red
                : (widget.borderColor ?? grey)),
            focusedBorder: _getBorder(widget.showBorder && widget.isRequired
                ? red
                : (widget.borderColor ?? grey)),

            // Suffix: password toggle, suffix icon or asset
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

            // Prefix: icon or asset
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
          ),
        ),
      ),

      // Show password strength message
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

      // Show required field message (if no border/title/password strength)
      if (widget.isRequired &&
          !widget.showBorder &&
          widget.title.isEmpty &&
          !(widget.isPassword &&
              _strengthLabel.isNotEmpty &&
              widget.showPasswordStrength))
        Padding(
          padding: EdgeInsets.only(left: widget.fieldMarginLeft),
          child: Text(
            widget.requiredMessage,
            style: TextStyle(color: red),
          ),
        )
    ]);
  }
}
