import 'package:flutter/material.dart';

class ActionButtonRow extends StatelessWidget {
  final VoidCallback? onCopy;
  final VoidCallback? onShare;
  final VoidCallback? onScanAgain;

  const ActionButtonRow({
    super.key,
    this.onCopy,
    this.onShare,
    this.onScanAgain,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: [
        _ActionButton(
          icon: Icons.copy_rounded,
          label: "Copy",
          onPressed: onCopy,
        ),
        _ActionButton(
          icon: Icons.share_rounded,
          label: "Share",
          onPressed: onShare,
        ),
        _ActionButton(
          icon: Icons.restart_alt_rounded,
          label: "Scan Again",
          onPressed: onScanAgain,
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: FilledButton.styleFrom(
        minimumSize: const Size(150, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}