import 'dart:async';
import 'dart:convert';
import "package:http/http.dart" as http;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:user_subscription_management/utils/flushbar_messages.dart';

import '../components/bottom_nav_bar.dart';
import '../screens/login_screen.dart';
import 'constants/apis.dart';

class ProfileController{
  final _storage = const FlutterSecureStorage();


  Future<void> checkJwtToken(BuildContext context) async {
    print("Checking JWT token in storage");

    String? accessToken = await _storage.read(key: "access");
    String? refreshToken = await _storage.read(key: "refresh");

    if (accessToken != null && accessToken.isNotEmpty) {
      bool isTokenValid = await _validateToken(accessToken);

      if (isTokenValid) {
        print("Access token is valid");
        navigateToMainScreen(context);
      } else if (refreshToken != null && refreshToken.isNotEmpty) {
        print("Access token expired. Trying to refresh");
        logout(context);
      } else {
        print("No valid tokens found. Redirecting to login.");
        navigateToLoginScreen(context);
      }
    } else {
      print("No access token found. Redirecting to login.");
      navigateToLoginScreen(context);
    }
  }

  Future<bool> _validateToken(String accessToken) async {
    final String url = profile_api;

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $accessToken",
          "Content-Type": "application/json",
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      print("🔥 Token validation error: $e");
      return false;
    }
  }

  void navigateToLoginScreen(BuildContext context) async {
    print("Navigating to login screen");
    Timer(
        const Duration(seconds: 2),
            () =>
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            )
    );
  }

  void navigateToMainScreen(BuildContext context) async {
    print("Navigating to main screen");
    Timer(
      const Duration(seconds: 2),
          () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BottomNavBar()),
      ),
    );
  }



  Future<String?> refreshAccessToken() async {
    print("Attempting to refresh access token...");

    String? refreshToken = await _storage.read(key: "refresh");

    if (refreshToken == null) {
      print("No refresh token found! Cannot refresh access token.");
      return null;
    }

    try {
      print("Sending request to refresh token...");
      final response = await http.post(
        Uri.parse(refresh_api), // Your refresh token endpoint
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"refresh": refreshToken}),
      );

      print("Refresh token response status: ${response.statusCode}");
      print("Refresh token response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String? newAccessToken = data["access"];

        if (newAccessToken != null) {
          print("New access token received: $newAccessToken");
          await _storage.write(key: "jwtToken", value: newAccessToken);

          return newAccessToken;
        } else {
          print("Refresh token API did not return a new access token!");
          return null;
        }
      } else {
        print("Failed to refresh token: ${response.body}");
        return null;
      }
    } catch (error) {
      print("Exception while refreshing token: $error");
      return null;
    }
  }

  Future<void> logout(BuildContext context) async {
    await _storage.deleteAll();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  Future<void> register(BuildContext context, String email, String password) async {
    try {
      String bodyData = jsonEncode({"email": email, "password": password});
      final response = await http.post(
        Uri.parse(register_api),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: bodyData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Utils.flushBarMessage("Account created successfully", context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } else {
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        String errorMessage = errorData["error"] ?? "Failed to create account.";
        Utils.showErrorMessage(errorMessage, context);
      }
    } catch (e) {
      Utils.showErrorMessage("Failed to create account: ${e.toString()}", context);
    }
  }

  Future<void> login(BuildContext context, String email, String password) async {
    try {
      String bodyData = jsonEncode({"email": email, "password": password});
      final response = await http.post(
        Uri.parse(login_api),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: bodyData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        await _storage.write(key: 'user_id', value: data["user_id"].toString());
        await _storage.write(key: 'user_email', value: data["user_email"]);
        await _storage.write(key: "refresh", value: data["refresh"]);
        await _storage.write(key: "jwtToken", value: data["access"]);

        Utils.flushBarMessage("Login successful", context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BottomNavBar()),
        );
      } else {
        Utils.showErrorMessage("Login failed: ${response.reasonPhrase}", context);
      }
    } catch (e) {
      Utils.showErrorMessage("An error occurred: ${e.toString()}", context);
    }
  }

}