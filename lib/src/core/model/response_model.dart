import 'dart:convert';

ApiResponse apiResponseFromJson(String str) =>
    ApiResponse.fromJson(json.decode(str));

String apiResponseToJson(ApiResponse body) => json.encode(body.toJson());

class ApiResponse {
  final bool status;
  final String message;
  dynamic data;
  final String? timestamp;

  ApiResponse({
    required this.status,
    required this.message,
    this.data,
    this.timestamp,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) => ApiResponse(
    status: json["status"] ?? false,
    message: json["message"] ?? '',
    data: json["data"],
    timestamp: json["timestamp"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data,
    "timestamp": timestamp,
  };
}
