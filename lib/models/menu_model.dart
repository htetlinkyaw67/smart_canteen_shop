class MenuModel {
  final int menuId;
  final int categoryId;
  final String itemName;
  final String description;
  final String price;
  final int quantity;
  final bool isAvailable;
  final String? imageUrl;

  MenuModel({
    required this.menuId,
    required this.categoryId,
    required this.itemName,
    required this.description,
    required this.price,
    required this.quantity,
    required this.isAvailable,
    this.imageUrl,
  });

  factory MenuModel.fromJson(Map<String, dynamic> json) {
    return MenuModel(
      menuId: json["menu_id"],
      categoryId: int.parse(json["category_id"].toString()),
      itemName: json["item_name"] ?? "",
      description: json["description"] ?? "",
      price: json["item_price"].toString(),
      quantity: int.parse(json["quantity"].toString()),
      isAvailable:
          json["is_available"] == true || json["is_available"] == 1,
      imageUrl: json["image_url"],
    );
  }

  MenuModel copyWith({
    int? menuId,
    int? categoryId,
    String? itemName,
    String? description,
    String? price,
    int? quantity,
    bool? isAvailable,
    String? imageUrl,
  }) {
    return MenuModel(
      menuId: menuId ?? this.menuId,
      categoryId: categoryId ?? this.categoryId,
      itemName: itemName ?? this.itemName,
      description: description ?? this.description,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      isAvailable: isAvailable ?? this.isAvailable,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}