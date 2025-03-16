import 'dart:convert';
/// subscription : {"subscription_details":{"id":1,"plan_type":"Basic","start_date":"2025-03-16","duration":30,"end_date":"2025-04-16","is_active":true},"is_subscribed":true}

ProfileSubscription profileSubscriptionFromJson(String str) => ProfileSubscription.fromJson(json.decode(str));
String profileSubscriptionToJson(ProfileSubscription data) => json.encode(data.toJson());
class ProfileSubscription {
  ProfileSubscription({
    this.subscription,});

  ProfileSubscription.fromJson(dynamic json) {
    subscription = json['subscription'] != null ? Subscription.fromJson(json['subscription']) : null;
  }
  Subscription? subscription;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (subscription != null) {
      map['subscription'] = subscription?.toJson();
    }
    return map;
  }

  @override
  String toString() {
    return 'ProfileSubscription{subscription: $subscription}';
  }
}

/// subscription_details : {"id":1,"plan_type":"Basic","start_date":"2025-03-16","duration":30,"end_date":"2025-04-16","is_active":true}
/// is_subscribed : true

Subscription subscriptionFromJson(String str) => Subscription.fromJson(json.decode(str));
String subscriptionToJson(Subscription data) => json.encode(data.toJson());
class Subscription {
  Subscription({
    this.subscriptionDetails,
    this.isSubscribed,});

  Subscription.fromJson(dynamic json) {
    subscriptionDetails = json['subscription_details'] != null ? SubscriptionDetails.fromJson(json['subscription_details']) : null;
    isSubscribed = json['is_subscribed'];
  }
  SubscriptionDetails? subscriptionDetails;
  bool? isSubscribed;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (subscriptionDetails != null) {
      map['subscription_details'] = subscriptionDetails?.toJson();
    }
    map['is_subscribed'] = isSubscribed;
    return map;
  }

  @override
  String toString() {
    return 'Subscription{subscriptionDetails: $subscriptionDetails, isSubscribed: $isSubscribed}';
  }
}

/// id : 1
/// plan_type : "Basic"
/// start_date : "2025-03-16"
/// duration : 30
/// end_date : "2025-04-16"
/// is_active : true

SubscriptionDetails subscriptionDetailsFromJson(String str) => SubscriptionDetails.fromJson(json.decode(str));
String subscriptionDetailsToJson(SubscriptionDetails data) => json.encode(data.toJson());
class SubscriptionDetails {
  SubscriptionDetails({
    this.id,
    this.planType,
    this.startDate,
    this.duration,
    this.endDate,
    this.isActive,});

  SubscriptionDetails.fromJson(dynamic json) {
    id = json['id'];
    planType = json['plan_type'];
    startDate = json['start_date'];
    duration = json['duration'];
    endDate = json['end_date'];
    isActive = json['is_active'];
  }
  int? id;
  String? planType;
  String? startDate;
  int? duration;
  String? endDate;
  bool? isActive;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['plan_type'] = planType;
    map['start_date'] = startDate;
    map['duration'] = duration;
    map['end_date'] = endDate;
    map['is_active'] = isActive;
    return map;
  }

  @override
  String toString() {
    return 'SubscriptionDetails{id: $id, planType: $planType, startDate: $startDate, duration: $duration, endDate: $endDate, isActive: $isActive}';
  }
}
