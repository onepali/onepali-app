import 'dart:convert';
import 'package:flutter/services.dart';
import '../../src.dart';

class UserRepo {
  Future<ApiResponse> user() async {
    try {
      var response = await rootBundle.loadString(Assets.user).then((value) {
        return value;
      });
      final apiResponse = ApiResponse.fromJson(
        json.decode(response) as Map<String, dynamic>,
      );

      if (apiResponse.status) {
        final userData = userModelFromJson(json.encode(apiResponse.data));
        if (apiResponse.status && apiResponse.data != null) {
          return ApiResponse(
            status: true,
            message: "User Fetched Successfully",
            data: userData,
          );
        } else {
          return ApiResponse(status: false, message: "User not found");
        }
      } else {
        return ApiResponse(status: false, message: apiResponse.message);
      }
    } catch (e) {
      return ApiResponse(status: false, message: "Something went wrong! $e");
    }
  }
}
