import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class Utils {
  static void showErrorMessage(String message, BuildContext context) {
    toastification.show(
      context: context,
      type: ToastificationType.error,
      style: ToastificationStyle.fillColored,
      autoCloseDuration: const Duration(seconds: 3),
      title: const Text('Error', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      description: Text(message, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      alignment: Alignment.topCenter,
      direction: TextDirection.ltr,
      animationDuration: const Duration(milliseconds: 300),
      icon: const Icon(Icons.error, color: Colors.white),
      showIcon: true,
      primaryColor: Colors.red, // Darker red for primary color
      backgroundColor: Colors.red, // Medium red for background color
      foregroundColor: Colors.white, // White text color for better contrast
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: Color(0x07000000),
          blurRadius: 16,
          spreadRadius: 0,
        )
      ],
      showProgressBar: true,
      closeButtonShowType: CloseButtonShowType.onHover,
      closeOnClick: false,
      pauseOnHover: true,
      dragToClose: true,
      applyBlurEffect: true,
      callbacks: ToastificationCallbacks(
        onTap: (toastItem) => print('Toast ${toastItem.id} tapped'),
        onCloseButtonTap: (toastItem) => print('Toast ${toastItem.id} close button tapped'),
        onAutoCompleteCompleted: (toastItem) => print('Toast ${toastItem.id} auto complete completed'),
        onDismissed: (toastItem) => print('Toast ${toastItem.id} dismissed'),
      ),
    );
  }

  static void flushBarMessage(String message, BuildContext context) {
    toastification.show(
      context: context,
      type: ToastificationType.success,
      style: ToastificationStyle.fillColored,
      autoCloseDuration: const Duration(seconds: 3),
      title: const Text('Success', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      description: Text(message, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      alignment: Alignment.topCenter,
      direction: TextDirection.ltr,
      animationDuration: const Duration(milliseconds: 300),
      icon: const Icon(Icons.check, color: Colors.white),
      showIcon: true,
      primaryColor: Colors.green, // Darker green for primary color
      backgroundColor: Colors.green, // Medium green for background color
      foregroundColor: Colors.white, // White text color for better contrast
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: Color(0x07000000),
          blurRadius: 16,
          spreadRadius: 0,
        )
      ],
      showProgressBar: true,
      closeButtonShowType: CloseButtonShowType.onHover,
      closeOnClick: false,
      pauseOnHover: true,
      dragToClose: true,
      applyBlurEffect: true,
      callbacks: ToastificationCallbacks(
        onTap: (toastItem) => print('Toast ${toastItem.id} tapped'),
        onCloseButtonTap: (toastItem) => print('Toast ${toastItem.id} close button tapped'),
        onAutoCompleteCompleted: (toastItem) => print('Toast ${toastItem.id} auto complete completed'),
        onDismissed: (toastItem) => print('Toast ${toastItem.id} dismissed'),
      ),
    );
  }

  static void showBottomErrorMessage(String message, BuildContext context) {
    Flushbar(
      message: message,
      backgroundColor: Colors.red.shade600,
      icon: const Icon(
        Icons.error,
        color: Colors.white,
      ),
      duration: const Duration(seconds: 3),
      flushbarPosition: FlushbarPosition.BOTTOM,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: BorderRadius.circular(12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      boxShadows: const [
        BoxShadow(
          color: Color(0x07000000),
          blurRadius: 16,
          spreadRadius: 0,
        ),
      ],
      shouldIconPulse: true,
      isDismissible: true,
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
    ).show(context);
  }
  static void showBottomMessage(String message, BuildContext context) {
    Flushbar(
      message: message,
      messageColor: Colors.white,
      backgroundColor: Colors.green,
      icon: const Icon(
        Icons.info_outline,
        color: Colors.white,
      ),
      duration: const Duration(seconds: 3),
      flushbarPosition: FlushbarPosition.BOTTOM,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: BorderRadius.circular(12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      boxShadows: const [
        BoxShadow(
          color: Color(0x07000000),
          blurRadius: 16,
          spreadRadius: 0,
        ),
      ],
      shouldIconPulse: true,
      isDismissible: true,
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
    ).show(context);
  }
  static void showBottomSuccessMessage(String message, BuildContext context) {
    Flushbar(
      message: message,
      backgroundColor: Colors.green,
      icon: const Icon(
        Icons.check_circle_outline,
        color: Colors.white,
      ),
      duration: const Duration(seconds: 3),
      flushbarPosition: FlushbarPosition.BOTTOM,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: BorderRadius.circular(12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      boxShadows: const [
        BoxShadow(
          color: Color(0x07000000),
          blurRadius: 16,
          spreadRadius: 0,
        ),
      ],
      shouldIconPulse: true,
      isDismissible: true,
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
    ).show(context);
  }

  static focusOtherField(FocusNode currentFocusNode, FocusNode nextFocusNode, BuildContext context) {
    currentFocusNode.unfocus();
    FocusScope.of(context).requestFocus(nextFocusNode);
  }
}