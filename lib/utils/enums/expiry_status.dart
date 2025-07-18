import 'package:flutter/material.dart';
import 'package:shopease_app_flutter/utils/app_colors.dart';

enum ExpiryStatus {
  normal(color: AppColors.transperent, displayText: ''),
  expiring(color: AppColors.orange, displayText: 'Expiring'),
  expired(color: AppColors.redColor, displayText: 'Expired');

  final Color color;
  final String displayText;

  const ExpiryStatus({required this.color, required this.displayText});
}
