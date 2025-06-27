import 'dart:convert';

List<PzPlanModel> pzPlanModelFromJson(String str) => List<PzPlanModel>.from(
  json.decode(str).map((x) => PzPlanModel.fromJson(x)),
);

String pzPlanModelToJson(List<PzPlanModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PzPlanModel {
  final String id;
  final String name;
  final double price;
  final String currency;
  final String billingCycle;
  final String description;

  PzPlanModel({
    required this.id,
    required this.name,
    required this.price,
    required this.currency,
    required this.billingCycle,
    required this.description,
  });

  factory PzPlanModel.fromJson(Map<String, dynamic> json) => PzPlanModel(
    id: json["id"] ?? '',
    name: json["name"] ?? '',
    price: (json["price"] != null) ? json["price"].toDouble() : 0.0,
    currency: json["currency"] ?? '',
    billingCycle: json["billing_cycle"] ?? '',
    description: json["description"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "price": price,
    "currency": currency,
    "billing_cycle": billingCycle,
    "description": description,
  };
}
