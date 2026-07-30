import 'dart:io';

import 'package:dio/dio.dart';
import 'package:smart_canteen_shop/models/category.dart';
import 'package:smart_canteen_shop/models/category_menu_model.dart';
import 'package:smart_canteen_shop/models/menu_model.dart';

import '../models/login_response.dart';

class ApiService {
  final Dio dio = Dio();

  static const String baseUrl =
      "https://81eb70f126dfa7de-202-165-86-247.serveousercontent.com/api";

  Future<LoginResponse> login({
    required String email,
    required String password,
    String? fcmToken,
  }) async {
    try {
      final response = await dio.post(
        "$baseUrl/login",

        data: {
          "user_email": email,
          "user_password": password,
          "fcm_token": fcmToken,
        },
      );

      print("fcm token $fcmToken");
      if (response.data["success"] == false) {
        throw Exception(response.data["message"]);
      }
      print(response.data);
      return LoginResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          e.response!.data["message"] ?? "Invalid username or password",
        );
      }

      throw Exception("Network error");
    }
  }

  Future<String> changePasswordWallet({
    required String token,
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final response = await dio.post(
        "$baseUrl/wallet/update-pin",
        data: {"current_pin": currentPassword, "new_pin": newPassword},
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
          },
        ),
      );

      if (response.data["status"] == true) {
        return response.data["message"];
      }

      throw Exception(response.data["message"]);
    } on DioException catch (e) {
      throw Exception(e.response?.data["message"] ?? "Password change failed");
    }
  }

  Future<String> changePassword({
    required String token,
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final response = await dio.post(
        "$baseUrl/change-password",
        data: {
          "current_password": currentPassword,
          "new_password": newPassword,
          "new_password_confirmation": confirmPassword,
        },
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
          },
        ),
      );

      if (response.data["status"] == true) {
        return response.data["message"];
      }

      throw Exception(response.data["message"]);
    } on DioException catch (e) {
      throw Exception(e.response?.data["message"] ?? "Password change failed");
    }
  }

  Future<List<CategoryModel>> getAllCategories() async {
    try {
      final response = await dio.get("$baseUrl/shops/all-categories");

      if (response.data["success"] == true) {
        final List data = response.data["data"];

        return data.map((e) => CategoryModel.fromJson(e)).toList();
      }

      throw Exception(response.data["message"]);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ?? "Failed to load categories",
      );
    }
  }

  Future<MenuModel> addMenu({
    required String token,

    required int categoryId,

    required String itemName,

    required String description,

    required String price,

    required int quantity,

    required bool isAvailable,

    File? image,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        "category_id": categoryId.toString(),

        "item_name": itemName,

        "description": description,

        "item_price": price,

        "quantity": quantity.toString(),

        "is_available": isAvailable ? "1" : "0",

        if (image != null)
          "item_image": await MultipartFile.fromFile(
            image.path,
            filename: image.path.split('/').last,
          ),
      });

      final response = await dio.post(
        "$baseUrl/shop/add-menus",

        data: formData,

        options: Options(
          headers: {
            "Authorization": "Bearer $token",

            "Accept": "application/json",

            "Content-Type": "multipart/form-data",
          },
        ),
      );

      if (response.data["success"] == true) {
        return MenuModel.fromJson(response.data["data"]);
      }

      throw Exception(response.data["message"]);
    } on DioException catch (e) {
      throw Exception(e.response?.data["message"] ?? "Add menu failed");
    }
  }

  Future<List<CategoryMenuModel>> getDashboardMenus({
    required String token,
  }) async {
    try {
      final response = await dio.get(
        "$baseUrl/shop/dashboard/view-menus",

        options: Options(
          headers: {
            "Authorization": "Bearer $token",

            "Accept": "application/json",
          },
        ),
      );

      if (response.data["success"] == true) {
        List data = response.data["data"];

        return data.map((e) => CategoryMenuModel.fromJson(e)).toList();
      }

      throw Exception(response.data["message"]);
    } catch (e) {
      throw Exception("Failed load menus");
    }
  }
}
