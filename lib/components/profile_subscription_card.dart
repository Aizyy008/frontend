import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_subscription_management/controllers/subscription_controller.dart';
import 'package:user_subscription_management/providers/subscription_provider.dart';
import '../utils/colors_util.dart';
import '../utils/screen_util.dart';

class ProfileSubscriptionCard extends StatelessWidget {
  final String planType;
  final String startDate;
  final String endDate;
  final int duration;
  final bool isActive;
  final String description;

  const ProfileSubscriptionCard({
    Key? key,
    required this.planType,
    required this.startDate,
    required this.endDate,
    required this.duration,
    required this.isActive,
    required this.description,
  }) : super(key: key);

  void _unsubscribe(BuildContext context) {
    final subscriptionController = SubscriptionController();
    subscriptionController.unsubscribe(context);
  }


  @override
  Widget build(BuildContext context) {
    final screenSize = ScreenUtils(context);
    final subscriptionProvider = Provider.of<SubscriptionProvider>(context);
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: screenSize.height * 0.04,
        horizontal: screenSize.width * 0.05,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: ColorConverter.black,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            spreadRadius: 2,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShaderMask(
            shaderCallback: (Rect bounds) {
              return LinearGradient(
                colors: [ColorConverter.blue, Colors.cyanAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds);
            },
            blendMode: BlendMode.srcIn,
            child: Text(
              planType,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          SizedBox(height: screenSize.height * 0.015),

          _buildDetailRow("Duration", "$duration days"),
          _buildDetailRow("Start Date", startDate),
          _buildDetailRow("End Date", endDate),

          SizedBox(height: screenSize.height * 0.025),

          Row(
            children: [
              Icon(
                isActive ? Icons.check_circle : Icons.cancel,
                color: isActive ? Colors.green : Colors.red,
                size: 20,
              ),
              SizedBox(width: 6),
              Text(
                isActive ? "Active" : "Expired",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isActive ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),

          SizedBox(height: screenSize.height * 0.025),

          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: ColorConverter.white.withOpacity(0.7),
              height: 1.5,
            ),
          ),

          SizedBox(height: screenSize.height * 0.03),

          Center(
            child: ElevatedButton(
              onPressed: () {
                if (isActive) {

                  _showUnsubscribeDialog(context);
                } else {
                  subscriptionProvider.subscribeUser(context, planType);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorConverter.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(
                  vertical: screenSize.height * 0.018,
                  horizontal: screenSize.width * 0.12,
                ),
              ),
              child: Text(
                isActive ? "Manage Subscription" : "Renew Plan",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );


  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$title:",
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.6),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
  void _showUnsubscribeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black.withOpacity(0.85),
          title: Text(
            "Unsubscribe from $planType?",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          content: Text(
            "Are you sure you want to unsubscribe from this plan? This action cannot be undone.",
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                final subscriptionProvider = Provider.of<SubscriptionProvider>(context);
                subscriptionProvider.unsubscribeUser(context); // Unsubscribe action
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text(
                "Unsubscribe",
                style: TextStyle(
                  color: Colors.redAccent,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

