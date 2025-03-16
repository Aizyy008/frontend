import 'package:flutter/material.dart';
import 'package:user_subscription_management/controllers/subscription_controller.dart';
import 'package:user_subscription_management/models/profile_subscription.dart';
import 'package:user_subscription_management/models/subscription_plans.dart';

class SubscriptionProvider extends ChangeNotifier {
  final SubscriptionController _subscriptionController = SubscriptionController();

  List<SubscriptionPlans> _subscriptionPlans = [];
  ProfileSubscription? _profileSubscription;
  bool _isSubscribed = false;

  List<SubscriptionPlans> get subscriptionPlans => _subscriptionPlans;
  ProfileSubscription? get profileSubscription => _profileSubscription;
  bool get isSubscribed => _isSubscribed;

  Future<void> loadSubscriptionPlans(BuildContext context) async {
    try {
      _subscriptionPlans = await _subscriptionController.getAllSubscriptionPlans(context);
      notifyListeners();
    } catch (error) {
      print("Error loading subscription plans: $error");
    }
  }


  Future<void> loadProfileSubscription(BuildContext context) async {
    try {
      _profileSubscription = await _subscriptionController.getProfile(context);
      _isSubscribed = _profileSubscription?.subscription?.isSubscribed ?? false;
      notifyListeners();
    } catch (error) {
      print("Error loading profile subscription: $error");
    }
  }


  Future<void> subscribeUser(BuildContext context, String planType) async {
    try {
      await _subscriptionController.subscribe(context, planType);
      await loadProfileSubscription(context);
    } catch (error) {
      print("Error subscribing user: $error");
    }
  }

  Future<void> unsubscribeUser(BuildContext context) async {
    try {
      await _subscriptionController.unsubscribe(context);
      await loadProfileSubscription(context);
    } catch (error) {
      print("Error unsubscribing user: $error");
    }
  }
}
