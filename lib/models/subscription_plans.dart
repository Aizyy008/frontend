import 'dart:convert';
/// id : 1
/// plan_type : "Basic"
/// start_date : "2025-03-16"
/// duration : 30
/// end_date : "2025-04-16"
/// is_active : true

SubscriptionPlans subscriptionPlansFromJson(String str) => SubscriptionPlans.fromJson(json.decode(str));
String subscriptionPlansToJson(SubscriptionPlans data) => json.encode(data.toJson());
class SubscriptionPlans {
  SubscriptionPlans({
      this.id, 
      this.planType, 
      this.startDate, 
      this.duration, 
      this.endDate, 
      this.isActive,});

  SubscriptionPlans.fromJson(dynamic json) {
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

}