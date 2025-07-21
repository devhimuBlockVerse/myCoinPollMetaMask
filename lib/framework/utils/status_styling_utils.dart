
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
  final normalized = status.toLowerCase();

  switch (normalized) {
    case 'completed':
      return StatusStyling(
        backgroundColor: const Color(0xFF0A2A1F), // Very dark, desaturated green
        borderColor: const Color(0xFF29C77F),    // Bright Green
        textColor: const Color(0xFF29C77F),       // Bright Green
      );
    case 'unstake':
      return StatusStyling(
        backgroundColor: const Color(0xFF13313C), // Teal background
        borderColor: const Color(0xFF29C7C7),      // Cyan border
        textColor: const Color(0xFF29C7C7),        // Cyan text
      );

    case 'force':
      return StatusStyling(
        backgroundColor: const Color(0xFF3B171E), // Very dark, desaturated red
        borderColor: const Color(0xFFF46A7A),    // Bright Red
        textColor: const Color(0xFFF46A7A),       // Bright Red
      );
    case 'pending':
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

StatusStyling getTransactionStatusStyling(String status) {
  if (status == 'In') {
    return StatusStyling(
      backgroundColor: const Color(0xFF1A3E39), // Dark green background
      textColor: const Color(0xFF7EE4C2),       // Light green text
      borderColor: const Color(0xFF7EE4C2).withOpacity(0.5),
    );
  } else if (status == 'Out') {
    return StatusStyling(
      backgroundColor: const Color(0xFF402B2B), // Dark red background
      textColor: const Color(0xFFE47E7E),       // Light red text
      borderColor: const Color(0xFFE47E7E).withOpacity(0.5),
    );
  }
   return StatusStyling(
    backgroundColor: Colors.grey.shade800,
    textColor: Colors.white70,
    borderColor: Colors.grey.shade600,
  );
}

StatusStyling getReferralUserStatusStyle(String status) {
  if (status == 'Active') {
    return StatusStyling(
      backgroundColor: const Color(0xFF1CD494).withOpacity(0.20),
      textColor: const Color(0xFF1CD494),
      borderColor: const Color(0xFF1CD494),
    );
  } else if (status == 'Inactive') {
    return StatusStyling(
      backgroundColor: const Color(0xFFE04043).withOpacity(0.20),
      textColor: const Color(0xFFE04043),
      borderColor: const Color(0xFFE04043),
    );
  }
  // Default styling for unknown statuses
  return StatusStyling(
    backgroundColor: Colors.grey.shade800,
    textColor: Colors.white70,
    borderColor: Colors.grey.shade600,
  );
}
