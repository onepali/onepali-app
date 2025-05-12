import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../src.dart';

class LessonRepo {
  Future<ApiResponse> lessons() async {
    try {
      var response = await rootBundle.loadString(Assets.lessonJson);
      debugPrint("Raw Lesson JSON: $response");

      final apiResponse = ApiResponse.fromJson(
        json.decode(response) as Map<String, dynamic>,
      );

      if (apiResponse.status) {
        final lessonData = lessonModelFromJson(json.encode(apiResponse.data));
        debugPrint("Parsed Lesson Data: ${lessonData.toJson()}");

        return ApiResponse(
          status: true,
          message: "Lessons Fetched Successfully",
          data: lessonData,
        );
      } else {
        debugPrint("API Error: ${apiResponse.message}");
        return ApiResponse(status: false, message: apiResponse.message);
      }
    } catch (e) {
      debugPrint("Exception in lessons(): $e");
      return ApiResponse(status: false, message: "Something went wrong! $e");
    }
  }
}
