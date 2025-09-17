import 'package:flutter/material.dart';
import 'package:hesaptakip/core/theme/app_theme.dart';

class BottomPillNav extends StatefulWidget {
  const BottomPillNav({super.key, required this.onTap});
  final ValueChanged<int> onTap;

  @override
  State<BottomPillNav> createState() => _BottomPillNavState();
}

class _BottomPillNavState extends State<BottomPillNav> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Container(
        height: 72,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.gradientTopBlack, AppColors.gradientBottomDeep],
          ),
        ),
        child: Row(
          children: [
            _item(icon: Icons.home_rounded, label: 'Ana Sayfa', i: 0),
            _item(icon: Icons.add_circle_outline, label: 'Ekle', i: 1),
            _item(icon: Icons.insights_rounded, label: 'Raporlar', i: 2),
          ],
        ),
      ),
    );
  }

  Widget _item({required IconData icon, required String label, required int i}) {
    final selected = _index == i;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() => _index = i);
          widget.onTap(i);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: selected ? AppColors.gold : Colors.white70),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: selected ? AppColors.gold : Colors.white70,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
