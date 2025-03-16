import "dart:convert";

import "package:flutter/material.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:http/http.dart" as http;
import "package:user_subscription_management/controllers/constants/apis.dart";
import "package:user_subscription_management/controllers/profile_controller.dart";
import "../models/profile_subscription.dart";
import "../models/subscription_plans.dart";
import "../utils/flushbar_messages.dart";


class SubscriptionController{
  final storage = const FlutterSecureStorage();
  final profileController = ProfileController();


  Future<void> subscribe(BuildContext context, String planType) async {
    print("Subscribing user...");

    String? jwtToken = await storage.read(key: "jwtToken");
    if (jwtToken == null) {
      print("No access token found!");
      Utils.showErrorMessage("No access token found. Please log in again.", context);
      throw Exception("No access token found.");
    }

    print("Using access token: $jwtToken");

    try {
      print("Sending subscribe request...");
      final Uri uri = Uri.parse(subscribe_api);

      final response = await http.post(
        uri,
        headers: {
          "Authorization": "Bearer $jwtToken",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "plan_type": planType, // Only send the plan type
        }),
      );

      // Log the full response body for debugging
      print("Subscribe response status: ${response.statusCode}");
      print("Subscribe response body: ${response.body}");

      if (response.statusCode == 201) {
        print("Subscription successful!");
        getAllSubscriptionPlans(context);
      } else if (response.statusCode == 400) {
        print("Error subscribing: ${response.body}");
        Utils.showErrorMessage("Error subscribing: ${response.body}", context);
        throw Exception("Error subscribing: ${response.body}");
      } else if (response.statusCode == 401) {
        print("Token expired! Attempting to refresh...");

        // Try to refresh the token
        String? newToken = await profileController.refreshAccessToken();

        if (newToken != null) {
          print("Token refreshed successfully! Retrying subscription request");
          return subscribe(context, planType); // Retry after refreshing the token
        } else {
          print("Failed to refresh token. User must log in again.");
          Utils.showErrorMessage("Session expired. Please log in again.", context);
          await profileController.logout(context);
          throw Exception("Session expired. Please log in again.");
        }
      } else {
        print("Error subscribing: ${response.statusCode} - ${response.body}");
        Utils.showErrorMessage("Failed to subscribe.", context);
        throw Exception("Failed to subscribe: ${response.statusCode}");
      }
    } catch (error) {
      print("Exception in subscribe: $error");
      Utils.showErrorMessage("Network error: $error", context);
      throw Exception("Failed to subscribe: $error");
    }
  }

  Future<void> unsubscribe(BuildContext context) async {
    print("Unsubscribing user...");

    String? jwtToken = await storage.read(key: "jwtToken");
    if (jwtToken == null) {
      print("No access token found!");
      Utils.showErrorMessage("No access token found. Please log in again.", context);
      throw Exception("No access token found.");
    }

    print("Using access token: $jwtToken");

    try {
      print("Sending unsubscribe request...");
      final Uri uri = Uri.parse(unsubscribe_api);

      final response = await http.post(
        uri,
        headers: {
          "Authorization": "Bearer $jwtToken",
          "Content-Type": "application/json",
        },
      );

      // Log the full response body for debugging
      print("Unsubscribe response status: ${response.statusCode}");
      print("Unsubscribe response body: ${response.body}");

      if (response.statusCode == 200) {
        print("Unsubscription successful!");
        getAllSubscriptionPlans(context);
      } else if (response.statusCode == 400) {
        print("Error unsubscribing: ${response.body}");
        Utils.showErrorMessage("Error unsubscribing: ${response.body}", context);
        throw Exception("Error unsubscribing: ${response.body}");
      } else if (response.statusCode == 401) {
        print("Token expired! Attempting to refresh...");

        // Try to refresh the token
        String? newToken = await profileController.refreshAccessToken();

        if (newToken != null) {
          print("Token refreshed successfully! Retrying unsubscribe request");
          return unsubscribe(context); // Retry after refreshing the token
        } else {
          print("Failed to refresh token. User must log in again.");
          Utils.showErrorMessage("Session expired. Please log in again.", context);
          await profileController.logout(context);
          throw Exception("Session expired. Please log in again.");
        }
      } else {
        print("Error unsubscribing: ${response.statusCode} - ${response.body}");
        Utils.showErrorMessage("Failed to unsubscribe.", context);
        throw Exception("Failed to unsubscribe: ${response.statusCode}");
      }
    } catch (error) {
      print("Exception in unsubscribe: $error");
      Utils.showErrorMessage("Network error: $error", context);
      throw Exception("Failed to unsubscribe: $error");
    }
  }

  Future<ProfileSubscription> getProfile(BuildContext context) async {
    print("Fetching profile data...");

    String? jwtToken = await storage.read(key: "jwtToken");
    if (jwtToken == null) {
      print("No access token found!");
      Utils.showErrorMessage("No access token found. Please log in again.", context);
      throw Exception("No access token found.");
    }

    print("Using access token: $jwtToken");

    try {
      print("Sending profile request...");
      final Uri uri = Uri.parse(profile_api);

      final response = await http.get(
        uri,
        headers: {
          "Authorization": "Bearer $jwtToken",
          "Content-Type": "application/json",
        },
      );

      // Log the full response body for debugging
      print("Profile response status: ${response.statusCode}");
      print("Profile response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Profile fetched successfully!");

        if (data["subscription"] != null) {
          print(ProfileSubscription.fromJson(data).toString());
          return ProfileSubscription.fromJson(data);
        } else {
          print("No subscription data found!");
          throw Exception("No subscription data found.");
        }
      } else if (response.statusCode == 401) {
        print("Token expired! Attempting to refresh...");

        // Try to refresh the token
        String? newToken = await profileController.refreshAccessToken();

        if (newToken != null) {
          print("Token refreshed successfully! Retrying profile request");
          return getProfile(context);
        } else {
          print("Failed to refresh token. User must log in again.");
          Utils.showErrorMessage("Session expired. Please log in again.", context);
          await profileController.logout(context);
          throw Exception("Session expired. Please log in again.");
        }
      } else if (response.statusCode == 404) {
        print("User profile not found: ${response.body}");
        Utils.showErrorMessage("Profile not found.", context);
        throw Exception("Profile not found.");
      } else {
        print("Error fetching profile: ${response.statusCode} - ${response.body}");
        Utils.showErrorMessage("Failed to load profile.", context);
        throw Exception("Failed to load profile: ${response.statusCode}");
      }
    } catch (error) {
      if (error is Exception && error.toString().contains("Session expired")) {
        rethrow;
      }
      print("Exception in getProfile: $error");
      Utils.showErrorMessage("Network error: $error", context);
      throw Exception("Failed to fetch profile: $error");
    }
  }



  Future<List<SubscriptionPlans>> getAllSubscriptionPlans(BuildContext context) async {
    print("Fetching subscription plans data...");

    String? jwtToken = await storage.read(key: "jwtToken");
    if (jwtToken == null) {
      print("No access token found!");
      Utils.showErrorMessage("No access token found. Please log in again.", context);
      throw Exception("No access token found.");
    }

    print("Using access token: $jwtToken");

    try {
      print("Sending subscription plans request...");
      final Uri uri = Uri.parse(all_subscription_plans);

      final response = await http.get(
        uri,
        headers: {
          "Authorization": "Bearer $jwtToken",
          "Content-Type": "application/json",
        },
      );

      print("Response status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        print("Subscription plans fetched successfully!");

        // Ensure it's a List before mapping
        if (data is List) {
          return data.map((json) => SubscriptionPlans.fromJson(json)).toList();
        } else {
          throw Exception("Unexpected response format. Expected a list.");
        }
      } else {
        throw Exception("Failed to load subscription plans: ${response.statusCode}");
      }
    } catch (error) {
      print("Exception in getAllSubscriptionPlans: $error");
      throw Exception("Failed to fetch subscription plans: $error");
    }
  }

}