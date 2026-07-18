class MenuInventory {
  static List<Map<String, dynamic>> items = [
    // MAIN
    {
      "name": "Mohinga",
      "desc": "Classic Burmese fish noodle soup",
      "category": "Main",
      "mealType": "Breakfast",
      "points": "250",
      "trackStock": false,
      "available": true,
    },

    {
      "name": "Ohn No Khao Swe",
      "desc": "Coconut chicken noodle soup",
      "category": "Main",
      "mealType": "Breakfast",
      "points": "300",
      "trackStock": false,
      "available": true,
    },

    // DRINKS
    {
      "name": "Coca Cola",
      "desc": "330ml can",
      "category": "Drinks",
      "mealType": null,
      "points": "100",
      "stock": 24,
      "trackStock": true,
      "available": true,
    },

    {
      "name": "Pepsi",
      "desc": "330ml can",
      "category": "Drinks",
      "mealType": null,
      "points": "100",
      "stock": 20,
      "trackStock": true,
      "available": true,
    },

    {
      "name": "Fanta",
      "desc": "330ml can",
      "category": "Drinks",
      "mealType": null,
      "points": "100",
      "stock": 18,
      "trackStock": true,
      "available": true,
    },

    // TEA
    {
      "name": "Myanmar Milk Tea",
      "desc": "Traditional sweet milk tea",
      "category": "Tea",
      "mealType": "Breakfast",
      "points": "70",
      "stock": 15,
      "trackStock": true,
      "available": true,
    },

    // SNACKS
    {
      "name": "Samosa",
      "desc": "Crispy potato filled pastry",
      "category": "Snacks",
      "mealType": "Breakfast",
      "points": "90",
      "stock": 12,
      "trackStock": true,
      "available": true,
    },

    {
      "name": "Potato Chips",
      "desc": "Crunchy snack",
      "category": "Snacks",
      "mealType": null,
      "points": "80",
      "stock": 30,
      "trackStock": true,
      "available": true,
    },
  ];

  static Map<String, dynamic>? findItem(String name) {
    try {
      return items.firstWhere(
        (item) => item["name"].toString().toLowerCase() == name.toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }

  static void reduceStock(String itemName, int quantity) {
    final item = findItem(itemName);

    if (item == null) return;

    if (item["trackStock"] == true) {
      item["stock"] = (item["stock"] ?? 0) - quantity;

      if (item["stock"] <= 0) {
        item["stock"] = 0;
        item["available"] = false;
      }
    }
  }

  static void addStock(String itemName, int quantity) {
    final item = findItem(itemName);

    if (item == null) return;

    if (item["trackStock"] == true) {
      item["stock"] = (item["stock"] ?? 0) + quantity;

      if (item["stock"] > 0) {
        item["available"] = true;
      }
    }
  }
}
