
import 'package:flutter/material.dart';

class StatusStyling {
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;

  StatusStyling({
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
  });
}

StatusStyling getStatusStyling(String status) {
  switch (status) {
    case 'Completed':
      return StatusStyling(
        backgroundColor: const Color(0xFF0A2A1F), // Very dark, desaturated green
        borderColor: const Color(0xFF29C77F),    // Bright Green
        textColor: const Color(0xFF29C77F),       // Bright Green
      );
    case 'Unstack Now':
      return StatusStyling(
        backgroundColor: const Color(0xFF3B171E), // Very dark, desaturated red
        borderColor: const Color(0xFFF46A7A),    // Bright Red
        textColor: const Color(0xFFF46A7A),       // Bright Red
      );
    case 'Pending':
      return StatusStyling(
        backgroundColor: const Color(0xFF3D3013), // Very dark, desaturated orange/yellow
        borderColor: const Color(0xFFFABE2B),    // Bright Orange/Yellow
        textColor: const Color(0xFFFABE2B),       // Bright Orange/Yellow
      );
    default: // Fallback for unknown statuses
      return StatusStyling(
        backgroundColor: const Color(0xFF2A2A2A), // Dark grey
        borderColor: Colors.grey[600]!,
        textColor: Colors.white,
      );
  }
}

