// import 'dart:ui_web';

// import 'package:flutter/material.dart';

// class SocialButton extends StatelessWidget{
//   final String text;
//   final IconData icon;
//   final VoidCallback onPressed;

//   const SocialButton({
//     super.key,
//     required this.text,
//     required this.icon,
//     required this.onPressed,
//   });
//   @override
//   Widget build(BuildContext context){
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical:8),
//       width: double.infinity,
//       child: OutlinedButton.icon(
//         icon: Icon(icon, color: Colors.blue),
//         label: Text(
//           text,
//           style: const TextStyle(color: Colors.blue),
//         ),
//         style: OutlinedButton.styleFrom(
//           padding: const EdgeInsets.symmetric(vertical: 14),
//           side: const BorderSide(color: Colors.blue),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//         ),
//         onPressed: onPressed,
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SocialIconButton extends StatelessWidget {
  final String? assetPath;
  final IconData? icon;
  final Color? iconColor;
  final VoidCallback onTap;

  const SocialIconButton({
    super.key,
    this.assetPath,

    this.icon,
    this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Center(
          child: assetPath != null
              ? Image.asset(
                  assetPath!,
                  width: 25,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.error),
                )
              : FaIcon(icon!, color: iconColor, size: 30),
        ),
      ),
    );
  }
}
