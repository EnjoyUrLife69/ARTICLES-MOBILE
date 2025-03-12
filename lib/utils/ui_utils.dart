// lib/utils/ui_utils.dart
import 'package:flutter/material.dart';

void showElegantNotification(BuildContext context, String message) {
  // Hilangkan notifikasi sebelumnya jika ada
  ScaffoldMessenger.of(context).hideCurrentSnackBar();

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
      backgroundColor: Colors.black,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height -50,
        // Perbesar margin horizontal untuk memperkecil lebar
        left: 90,
        right: 90,
      ),
      elevation: 4,
      duration: Duration(seconds: 3),
      // Hapus properti animation yang bermasalah
    ),
  );
}
