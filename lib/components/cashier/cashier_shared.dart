import 'package:flutter/material.dart';
import '../../core/constants/theme.dart';

class CashierShared {
  static Widget card({
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: BatKittyTheme.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: BatKittyTheme.borderSubtle,
        ),
      ),
      child: child,
    );
  }

  static Widget header({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: BatKittyTheme.hotPink.withOpacity(.09),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(
            icon,
            color: BatKittyTheme.hotPink,
            size: 17,
          ),
        ),

        const SizedBox(width: 11),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: BatKittyTheme.textMain,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              subtitle,
              style: const TextStyle(
                color: BatKittyTheme.textSubtle,
                fontSize: 8.5,
              ),
            ),
          ],
        ),
      ],
    );
  }

  static Widget label(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: BatKittyTheme.textSubtle,
        fontSize: 8.5,
        fontWeight: FontWeight.w800,
        letterSpacing: .7,
      ),
    );
  }

  static Widget textField({
    required TextEditingController controller,
    required String hint,
    IconData? icon,
    Function(String)? onChanged,
  }) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: const TextStyle(
        color: BatKittyTheme.textMain,
        fontSize: 10.5,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: BatKittyTheme.textSubtle,
          fontSize: 10,
        ),
        prefixIcon: icon == null
            ? null
            : Icon(
                icon,
                color: BatKittyTheme.textMuted,
                size: 17,
              ),
        filled: true,
        fillColor: BatKittyTheme.surfaceElevated,
        contentPadding:
            const EdgeInsets.symmetric(
          horizontal: 13,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: const BorderSide(
            color: BatKittyTheme.borderSubtle,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: const BorderSide(
            color: BatKittyTheme.borderSubtle,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: const BorderSide(
            color: BatKittyTheme.hotPink,
            width: 1.2,
          ),
        ),
      ),
    );
  }

  static Widget badge(
    String text,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(.08),
        borderRadius: BorderRadius.circular(7),
        border: Border.all(
          color: color.withOpacity(.18),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 7.5,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}