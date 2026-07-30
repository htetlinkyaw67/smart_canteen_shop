import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/menu_model.dart';
import '../models/category_menu_model.dart';
import '../services/api_service.dart';
import '../services/preference_service.dart';

// API Service Provider
final apiProvider = Provider<ApiService>((ref) {
  return ApiService();
});

// ================= ADD MENU PROVIDER =================

final menuProvider =
    StateNotifierProvider<MenuNotifier, AsyncValue<MenuModel?>>((ref) {
      return MenuNotifier(ref.read(apiProvider));
    });

class MenuNotifier extends StateNotifier<AsyncValue<MenuModel?>> {
  final ApiService service;

  MenuNotifier(this.service) : super(const AsyncData(null));

  Future<void> addMenu({
    required int categoryId,

    required String itemName,

    required String description,

    required String price,

    required int quantity,

    required bool available,

    File? image,
  }) async {
    state = const AsyncLoading();

    try {
      final token = await PreferenceService().getToken();

      if (token == null) {
        throw Exception("Login expired");
      }

      final menu = await service.addMenu(
        token: token,

        categoryId: categoryId,

        itemName: itemName,

        description: description,

        price: price,

        quantity: quantity,

        isAvailable: available,

        image: image,
      );

      state = AsyncData(menu);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

// ================= DASHBOARD VIEW MENUS =================

final dashboardMenuProvider =
    StateNotifierProvider<
      DashboardMenuNotifier,
      AsyncValue<List<CategoryMenuModel>>
    >((ref) {
      return DashboardMenuNotifier(ref.read(apiProvider));
    });

class DashboardMenuNotifier
    extends StateNotifier<AsyncValue<List<CategoryMenuModel>>> {
  final ApiService api;

  DashboardMenuNotifier(this.api) : super(const AsyncData([]));

  Future<void> loadMenus() async {
    state = const AsyncLoading();

    try {
      final token = await PreferenceService().getToken();

      if (token == null) {
        throw Exception("Login expired");
      }

      final result = await api.getDashboardMenus(token: token);

      state = AsyncData(result);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

// ================= SHOP ALL MENUS =================

