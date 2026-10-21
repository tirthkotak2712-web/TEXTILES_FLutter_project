import 'package:flutter/material.dart';
import 'package:textiles/resources/app_styles.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.color = AppColors.green,
    this.foreground = Colors.white,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color color;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: AppStyles.buttonHeight,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: color,
          foregroundColor: foreground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppStyles.radius),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}

class OutlineAction extends StatelessWidget {
  const OutlineAction({
    super.key,
    required this.label,
    required this.onPressed,
    this.color = AppColors.green,
  });

  final String label;
  final VoidCallback onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: AppStyles.buttonHeight,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          side: BorderSide(color: color.withValues(alpha: 0.45)),
          backgroundColor: color.withValues(alpha: 0.04),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppStyles.radius),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}

Color statusColor(String label) {
  switch (label.toLowerCase()) {
    case 'pending':
      return AppColors.orange;
    case 'cancelled':
    case 'canceled':
    case 'refunded':
    case 'rejected':
      return AppColors.danger;
    case 'shipped':
      return AppColors.blue;
    default:
      return AppColors.green;
  }
}

class QtyStepper extends StatelessWidget {
  const QtyStepper({
    super.key,
    required this.quantity,
    required this.onChanged,
  });

  final int quantity;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _btn(Icons.remove, () => onChanged(quantity - 1)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text('$quantity', style: const TextStyle(fontWeight: FontWeight.w700)),
          ),
          _btn(Icons.add, () => onChanged(quantity + 1)),
        ],
      ),
    );
  }

  Widget _btn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Padding(padding: const EdgeInsets.all(8), child: Icon(icon, size: 18)),
    );
  }
}

void showAppMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
