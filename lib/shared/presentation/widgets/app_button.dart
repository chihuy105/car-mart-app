import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    this.child,
    this.text,
    this.onPressed,
    this.isExpand = false,
    this.leading,
    this.trailing,
  });

  final Widget? child;
  final String? text;
  final VoidCallback? onPressed;
  final bool isExpand;
  final Widget? leading;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final button = ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: theme.colorScheme.onPrimary,
        backgroundColor: theme.colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      ),
      child: _buildChild(),
    );

    if (isExpand) {
      return SizedBox(width: double.infinity, child: button);
    }
    return button;
  }

  Widget _buildChild() {
    if (leading != null || trailing != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ?leading,
          if (leading != null) const SizedBox(width: 8),
          Flexible(child: child ?? Text(text ?? '')),
          ?trailing,
        ],
      );
    }
    return child ?? Text(text ?? '');
  }
}
