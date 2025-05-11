import 'dart:convert';
import 'package:flutter/services.dart';
import '../../src.dart';

class LessonRepo {
  Future<ApiResponse> lessons() async {
    try {
      var response = await rootBundle.loadString(Assets.lessons).then((value) {
        return value;
      });
      final apiResponse = ApiResponse.fromJson(
        json.decode(response) as Map<String, dynamic>,
      );

      if (apiResponse.status) {
        final lessonData = lessonModelFromJson(json.encode(apiResponse.data));
        if (apiResponse.status && apiResponse.data != null) {
          return ApiResponse(
            status: true,
            message: "Lessons Fetched Successfully",
            data: lessonData,
          );
        } else {
          return ApiResponse(status: false, message: "Lessons not found");
        }
      } else {
        return ApiResponse(status: false, message: apiResponse.message);
      }
    } catch (e) {
      return ApiResponse(status: false, message: "Something went wrong! $e");
    }
  }
}
