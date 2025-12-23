import 'package:flutter/material.dart';
import 'package:clean_architecture/core/utils/responsive/responsive_utils.dart'; // Tu ResponsiveExtension

enum ActionButtonStyle { elevated, outlined, text }

enum ActionButtonSize { verySmall, small, medium, large }

class ActionButton extends StatelessWidget {
  final IconData icon;
  final String? label;
  final String? tooltip;
  final String? semanticLabel;

  final VoidCallback? onPressed;
  final bool disabled;
  final bool loading;

  final bool circular;
  final Color? color;
  final ActionButtonStyle style;
  final ActionButtonSize size;

  final Widget? trailing;
  final double? iconSizeOverride;

  const ActionButton({
    super.key,
    required this.icon,
    this.label,
    this.tooltip,
    this.semanticLabel,
    this.onPressed,
    this.disabled = false,
    this.loading = false,
    this.circular = false,
    this.color,
    this.style = ActionButtonStyle.elevated,
    this.size = ActionButtonSize.medium,
    this.trailing,
    this.iconSizeOverride,
  });

  bool get _isDisabled => disabled || onPressed == null || loading;
  bool get _hasLabel => label != null && label!.isNotEmpty;

  double _getIconSize(BuildContext context) {
    if (iconSizeOverride != null) return iconSizeOverride!;
    return switch (size) {
      ActionButtonSize.verySmall => context.iconExtraSmall,
      ActionButtonSize.small => context.iconSmall,
      ActionButtonSize.medium => context.iconMedium,
      ActionButtonSize.large => context.iconLarge,
    };
  }

  double _getVerticalPadding(BuildContext context) {
    return switch (size) {
      ActionButtonSize.verySmall => context.extraSmallSpacing,
      ActionButtonSize.small => context.smallSpacing,
      ActionButtonSize.medium => context.mediumSpacing,
      ActionButtonSize.large => context.largeSpacing,
    };
  }

  double _getHorizontalPadding(BuildContext context) {
    return switch (size) {
      ActionButtonSize.verySmall => context.extraSmallSpacing,
      ActionButtonSize.small => context.mediumSpacing * 1.5,
      ActionButtonSize.medium => context.largeSpacing,
      ActionButtonSize.large => context.extraSmallSpacing,
    };
  }

  double _getFontSize(BuildContext context) {
    return switch (size) {
      ActionButtonSize.verySmall => 10.0,
      ActionButtonSize.small => 12.0,
      ActionButtonSize.medium => 14.0,
      ActionButtonSize.large => 16.0,
    };
  }

  double _getBorderRadius(BuildContext context) {
    return circular ? 999 : context.largeBorderRadiusValue;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final effectiveColor = color ?? colorScheme.primary;
    final isDisabled = _isDisabled;
    final isLoading = loading && !disabled;

    // === Colores según estilo ===
    final ButtonStyle buttonStyle =
        switch (style) {
          ActionButtonStyle.elevated => ElevatedButton.styleFrom(
            backgroundColor: isDisabled ? theme.disabledColor : effectiveColor,
            foregroundColor: Colors.white,
            elevation: isDisabled ? 0 : context.cardElevation,
            shadowColor: effectiveColor.withOpacity(0.3),
          ),
          ActionButtonStyle.outlined => OutlinedButton.styleFrom(
            foregroundColor: isDisabled ? theme.disabledColor : effectiveColor,
            side: BorderSide(
              color: isDisabled ? theme.disabledColor : effectiveColor,
              width: 1.5,
            ),
          ),
          ActionButtonStyle.text => TextButton.styleFrom(
            foregroundColor: isDisabled ? theme.disabledColor : effectiveColor,
          ),
        }.copyWith(
          padding: WidgetStateProperty.all(
            EdgeInsets.symmetric(
              horizontal: _getHorizontalPadding(context),
              vertical: _getVerticalPadding(context),
            ),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(_getBorderRadius(context)),
            ),
          ),
          minimumSize: WidgetStateProperty.all(
            Size(
              size == ActionButtonSize.verySmall ? 60 : 80,
              context.buttonHeight,
            ),
          ),
        );

    // === Widget del ícono (con loading) ===
    final Widget iconWidget = isLoading
        ? SizedBox(
            width: _getIconSize(context) * 0.6,
            height: _getIconSize(context) * 0.6,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation(
                style == ActionButtonStyle.elevated
                    ? Colors.white
                    : effectiveColor,
              ),
            ),
          )
        : Icon(
            icon,
            size: _getIconSize(context),
            color: style == ActionButtonStyle.elevated
                ? Colors.white
                : effectiveColor,
          );

    // === Botón base ===
    Widget button;

    if (circular) {
      button = IconButton(
        onPressed: isDisabled ? null : onPressed,
        icon: iconWidget,
        tooltip: tooltip,
        style: IconButton.styleFrom(
          backgroundColor: isDisabled ? theme.disabledColor : effectiveColor,
          foregroundColor: Colors.white,
          fixedSize: Size.square(_getIconSize(context) * 2.2),
        ),
      );
    } else {
      final Widget content = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          iconWidget,
          if (_hasLabel) ...[
            SizedBox(width: context.smallSpacing),
            Flexible(
              child: Text(
                label!,
                style: context.buttonText.copyWith(
                  fontSize: _getFontSize(context),
                  fontWeight: FontWeight.bold,
                  color: style == ActionButtonStyle.elevated
                      ? Colors.white
                      : effectiveColor,
                ),
              ),
            ),
          ],
          if (trailing != null) ...[
            SizedBox(width: context.smallSpacing),
            trailing!,
          ],
        ],
      );

      button = switch (style) {
        ActionButtonStyle.elevated => ElevatedButton(
          onPressed: isDisabled ? null : onPressed,
          style: buttonStyle,
          child: content,
        ),
        ActionButtonStyle.outlined => OutlinedButton(
          onPressed: isDisabled ? null : onPressed,
          style: buttonStyle,
          child: content,
        ),
        ActionButtonStyle.text => TextButton(
          onPressed: isDisabled ? null : onPressed,
          style: buttonStyle,
          child: content,
        ),
      };
    }

    // === Tooltip y accesibilidad ===
    Widget finalButton = button;

    if (tooltip != null) {
      finalButton = Tooltip(message: tooltip!, child: finalButton);
    }

    return Semantics(
      button: true,
      enabled: !isDisabled,
      label: semanticLabel ?? label ?? tooltip,
      child: finalButton,
    );
  }
}
