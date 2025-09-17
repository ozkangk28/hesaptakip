import 'package:flutter/material.dart';
import 'package:hesaptakip/core/theme/app_theme.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool filledGold;
  final double fontSize;
  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.filledGold = true,
    this.fontSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: filledGold ? AppColors.gold : AppColors.greenDark,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: filledGold ? Colors.black : AppColors.gold,
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
