import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_subscription_management/models/subscription_plans.dart';
import 'package:user_subscription_management/providers/subscription_provider.dart';
import 'package:user_subscription_management/utils/screen_util.dart';
import '../components/subscription_card.dart';
import '../controllers/profile_controller.dart';
import '../models/profile_subscription.dart';
import '../utils/colors_util.dart';

class SubscriptionsScreen extends StatefulWidget {
  const SubscriptionsScreen({super.key});

  @override
  State<SubscriptionsScreen> createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends State<SubscriptionsScreen> {

  final profileController = ProfileController();

  @override
  Widget build(BuildContext context) {
    final screenSize = ScreenUtils(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConverter.blue,
        title: Text(
          "SubscriEase",
          style: TextStyle(
            color: ColorConverter.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: screenSize.width * 0.05),
            child: InkWell(
                onTap: (){
                  profileController.logout(context);
                },
                child: Icon(Icons.logout_sharp, color: ColorConverter.white,)),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
        child: Consumer<SubscriptionProvider>(
          builder: (context, subscriptionProvider, child) {
            // Ensure we are loading data if it is not already loaded
            if (subscriptionProvider.profileSubscription == null) {
              subscriptionProvider.loadProfileSubscription(context);
            }

            if (subscriptionProvider.subscriptionPlans.isEmpty) {
              subscriptionProvider.loadSubscriptionPlans(context);
            }

            // Profile subscription check
            final profileSubscription = subscriptionProvider.profileSubscription;
            if (profileSubscription == null || profileSubscription.subscription == null) {
              return const Center(child: Text("No subscription data available."));
            }

            final planType = profileSubscription.subscription?.subscriptionDetails?.planType;
            final isSubscribed = profileSubscription.subscription?.isSubscribed ?? false;

            // Plans list check
            if (subscriptionProvider.subscriptionPlans.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            final plans = subscriptionProvider.subscriptionPlans;
            return ListView.builder(
              itemCount: plans.length,
              itemBuilder: (context, index) {
                final plan = plans[index];
                return SubscriptionCard(
                  planType: plan.planType.toString(),
                  description: plan.planType.toString() == "Basic"
                      ? "Essential features with limited support for small-scale users."
                      : "Full access with priority support for a superior experience.",
                  duration: int.parse(plan.duration.toString()),
                  startDate: plan.startDate.toString(),
                  endDate: plan.endDate.toString(),
                  isActive: planType == plan.planType && isSubscribed == plan.isActive,
                );
              },
            );
          },
        ),
      ),
    );
  }
}

