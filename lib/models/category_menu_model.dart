import 'menu_model.dart';

class CategoryMenuModel {
  final int categoryId;
  final String categoryName;

  final String startTime;
  final String endTime;

  final List<MenuModel> menus;

  CategoryMenuModel({
    required this.categoryId,

    required this.categoryName,

    required this.startTime,

    required this.endTime,

    required this.menus,
  });

  factory CategoryMenuModel.fromJson(Map<String, dynamic> json) {
    return CategoryMenuModel(
      categoryId: json["category_id"],

      categoryName: json["category_name"] ?? "",

      startTime: json["start_time"] ?? "",

      endTime: json["end_time"] ?? "",

      menus: (json["menus"] as List)
          .map(
            (e) => MenuModel.fromJson({
              ...e,

              "category_name": json["category_name"],
            }),
          )
          .toList(),
    );
  }
}
