import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_subscription_management/providers/subscription_provider.dart';
import '../controllers/subscription_controller.dart';
import '../utils/colors_util.dart';
import '../utils/screen_util.dart';

class SubscriptionCard extends StatelessWidget {
  final String planType;
  final String description;
  final int duration;
  final String startDate;
  final String endDate;
  final bool isActive;

  const SubscriptionCard({
    Key? key,
    required this.planType,
    required this.description,
    required this.duration,
    required this.startDate,
    required this.endDate,
    required this.isActive,
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    final screenSize = ScreenUtils(context);
    final subscriptionProvider = Provider.of<SubscriptionProvider>(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: [ColorConverter.black.withOpacity(0.85), ColorConverter.black],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 8,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(
        horizontal: screenSize.width * 0.06,
        vertical: screenSize.height * 0.03,
      ),
      margin: EdgeInsets.symmetric(vertical: screenSize.height * 0.012),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            planType,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: ColorConverter.blue,
            ),
          ),
          SizedBox(height: screenSize.height * 0.015),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.75),
            ),
          ),
          SizedBox(height: screenSize.height * 0.02),
          Divider(color: Colors.white.withOpacity(0.2)),
          SizedBox(height: screenSize.height * 0.02),
          _buildDetailRow("Duration", "$duration days"),
          _buildDetailRow("Start Date", startDate),
          _buildDetailRow("End Date", endDate),
          SizedBox(height: screenSize.height * 0.025),
          Row(
            children: [
              Icon(
                isActive ? Icons.check_circle : Icons.cancel,
                color: isActive ? Colors.greenAccent : Colors.redAccent,
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                isActive ? "Active" : "Not Active",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isActive ? Colors.greenAccent : Colors.redAccent,
                ),
              ),
            ],
          ),
          SizedBox(height: screenSize.height * 0.025),
          GestureDetector(
            onTap: () {
              if (isActive) {
                // Show confirmation dialog for unsubscribe
                _showUnsubscribeDialog(context);
              } else {
               subscriptionProvider.subscribeUser(context, planType);
              }
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: screenSize.height * 0.015),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [ColorConverter.blue, Colors.cyanAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueAccent.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                isActive ? "Manage Subscription" : "Subscribe Now",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: ColorConverter.black,
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
            style: const TextStyle(
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
                subscriptionProvider.unsubscribeUser(context);
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
