import "package:flutter/material.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:provider/provider.dart";
import "package:user_subscription_management/controllers/profile_controller.dart";
import "package:user_subscription_management/providers/subscription_provider.dart";
import "package:user_subscription_management/utils/colors_util.dart";
import "package:user_subscription_management/utils/screen_util.dart";
import "../components/profile_subscription_card.dart";
import "../controllers/subscription_controller.dart";
import "../models/profile_subscription.dart";

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? userEmail = "";
  String? userID = "";
  final storage = const FlutterSecureStorage();
  Future<ProfileSubscription>? subscriptionData;

  final profileController = ProfileController();

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    userEmail = await storage.read(key: "user_email");
    userID = await storage.read(key: "user_id");

    if (userID != null) {
      setState(() {
        final subscriptionProvider = Provider.of<SubscriptionProvider>(context);
        subscriptionProvider.loadProfileSubscription(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = ScreenUtils(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConverter.blue,
        title: Text(
          "SubscriEase",
          style: TextStyle(
              color: ColorConverter.white, fontWeight: FontWeight.w600),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: screenSize.height * 0.05),
            const Center(
              child: CircleAvatar(
                backgroundImage: AssetImage("assets/images/emoji.jpg"),
                radius: 50,
              ),
            ),
            SizedBox(height: screenSize.height * 0.02),
            _divider(screenSize),
            _sectionTitle("Personal Details:", screenSize),
            SizedBox(height: screenSize.height * 0.02),
            userDetails("UserID:", userID ?? "N/A"),
            userDetails("Email:", userEmail ?? "N/A"),
            SizedBox(height: screenSize.height * 0.02),
            _divider(screenSize),
            SizedBox(height: screenSize.height * 0.01,),
            _sectionTitle("Active Subscription Plan:", screenSize),
            SizedBox(height: screenSize.height * 0.02),

            FutureBuilder<ProfileSubscription>(
              future: subscriptionData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError || !snapshot.hasData) {
                  return noSubscriptionWidget();
                } else {
                  SubscriptionDetails subscription = snapshot.data!.subscription!.subscriptionDetails!;
                  return Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenSize.width * 0.05),
                    child: ProfileSubscriptionCard(
                      planType: subscription.planType ?? "Basic Plan",
                      duration: subscription.duration ?? 0,
                      startDate: subscription.startDate ?? "N/A",
                      endDate: subscription.endDate ?? "N/A",
                      isActive: snapshot.data!.subscription!.isSubscribed ?? false,
                      description: getPlanDescription(subscription.planType ?? "Basic Plan"),
                    ),
                  );
                }
              },
            ),

            SizedBox(height: screenSize.height * 0.1),
          ],
        ),
      ),
    );
  }

  Widget userDetails(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
                color: ColorConverter.blue, fontWeight: FontWeight.w400, fontSize: 18),
          ),
          Text(
            value,
            style: TextStyle(
                color: ColorConverter.black, fontWeight: FontWeight.w400, fontSize: 18),
          ),
        ],
      ),
    );
  }

  String getPlanDescription(String planType) {
    switch (planType.toLowerCase()) {
      case "premium":
        return "Enjoy unlimited access to all features and exclusive perks.";
      case "basic":
        return "Limited access to features. Upgrade for more benefits.";
      default:
        return "No active subscription. Subscribe now to unlock features.";
    }
  }

  Widget noSubscriptionWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Text(
            "No Active Subscriptions",
            style: const TextStyle(
                color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              // Navigate to Subscription Page (Implement navigation logic)
              print("Navigate to Subscription Page");
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              "Subscribe Now",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider(ScreenUtils screenSize) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
      child: Divider(
        color: Colors.grey.withOpacity(0.3),
        thickness: 1,
      ),
    );
  }

  Widget _sectionTitle(String title, ScreenUtils screenSize) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: EdgeInsets.only(left: screenSize.width * 0.05),
        child: Text(
          title,
          style: TextStyle(
              color: ColorConverter.black,
              fontWeight: FontWeight.w500,
              fontSize: 25),
        ),
      ),
    );
  }
}
