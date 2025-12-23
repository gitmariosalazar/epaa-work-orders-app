import 'package:clean_architecture/shared_ui/ui/base/text/base_text.dart';
import 'package:flutter/material.dart';

class BaseTextButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final Color? textColor;
  final TextType textType;
  final FontWeight fontWeight;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final VisualDensity? visualDensity;
  final double? minimumWidth;

  const BaseTextButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.textColor,
    this.textType = TextType.bodyLarge,
    this.fontWeight = FontWeight.w500,
    this.backgroundColor,
    this.padding,
    this.visualDensity,
    this.minimumWidth,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDisabled = onPressed == null;

    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: textColor ?? theme.colorScheme.primary,
        backgroundColor: backgroundColor,
        disabledForegroundColor: theme.disabledColor,
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        visualDensity: visualDensity,
        minimumSize: minimumWidth != null
            ? Size(minimumWidth!, 44)
            : const Size(64, 44),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: BaseText(
        text,
        color: isDisabled
            ? theme.disabledColor
            : (textColor ?? theme.colorScheme.primary),
        textType: textType,
        fontWeight: fontWeight,
      ),
    );
  }
}
