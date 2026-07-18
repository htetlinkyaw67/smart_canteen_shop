import 'package:flutter/material.dart';
import '../data/menu_inventory.dart';
import '../widgets/page_header.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController pointsController = TextEditingController();
  final TextEditingController stockController = TextEditingController();

  bool isAvailable = true;

  File? selectedImage;
  final ImagePicker picker = ImagePicker();

  String? selectedMealType;
  String selectedCategory = "All";
  String selectedMealFilter = "All";
  String selectedStatusFilter = "All";

  bool get isStockItem =>
      selectedCategory == "Drinks" ||
      selectedCategory == "Tea" ||
      selectedCategory == "Snacks";

  final List<String> categories = [
    "All",
    "Main",
    "Appetizer",
    "Salad",
    "Noodles",
    "Drinks",
    "Tea",
    "Snacks",
    "Desserts",
  ];

  Future<void> _pickImage(void Function(void Function()) setModalState) async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setModalState(() {
        selectedImage = File(image.path);
      });
    }
  }

  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> allItems = MenuInventory.items;

  List<Map<String, dynamic>> filteredItems = [];

  @override
  void initState() {
    super.initState();
    filteredItems = allItems;

    _searchController.addListener(_filterItems);
  }

  void _filterItems() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      filteredItems = allItems.where((item) {
        final name = item["name"].toString().toLowerCase();

        final desc = item["desc"].toString().toLowerCase();

        final category = item["category"] ?? "Main";

        final mealType = item["mealType"] ?? "Breakfast";

        final matchesSearch = name.contains(query) || desc.contains(query);

        final matchesCategory =
            selectedCategory == "All" || category == selectedCategory;

        final available = item["available"] ?? false;

        final matchesMeal =
            selectedMealFilter == "All" || mealType == selectedMealFilter;

        final matchesStatus =
            selectedStatusFilter == "All" ||
            (selectedStatusFilter == "Available" && available) ||
            (selectedStatusFilter == "Sold Out" && !available);

        return matchesSearch && matchesCategory && matchesMeal && matchesStatus;
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),

          PageHeader(
            title: "Menu",
            subtitle: "Manage food & drinks",
            icon: Icons.restaurant_menu,
          ),

          _buildMealScheduleCard(),

          const SizedBox(height: 10),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Meal Type
                const Row(
                  children: [
                    Icon(
                      Icons.restaurant_menu,
                      size: 18,
                      color: Color(0xff0F7B94),
                    ),
                    SizedBox(width: 6),
                    Text(
                      "Meal Type",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildMealFilterChip("All"),
                      _buildMealFilterChip("Breakfast"),
                      _buildMealFilterChip("Lunch"),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                const Row(
                  children: [
                    Icon(
                      Icons.inventory_2_outlined,
                      size: 18,
                      color: Color(0xff0F7B94),
                    ),
                    SizedBox(width: 6),
                    Text(
                      "Status",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildStatusFilterChip("All"),
                      _buildStatusFilterChip("Available"),
                      _buildStatusFilterChip("Sold Out"),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// Categories
                const Row(
                  children: [
                    Icon(
                      Icons.category_outlined,
                      size: 18,
                      color: Color(0xff0F7B94),
                    ),
                    SizedBox(width: 6),
                    Text(
                      "Categories",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length + 1,
                    itemBuilder: (context, index) {
                      if (index == categories.length) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: _buildAddCategoryChip(),
                        );
                      }

                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: _buildCategoryChip(categories[index]),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Search menu...",
                      hintStyle: TextStyle(color: Colors.grey.shade500),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey.shade500,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              GestureDetector(
                onTap: _showAddMenuSheet,
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xff0F7B94),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.add, color: Colors.white),
                      SizedBox(width: 6),
                      Text(
                        "Add",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          const SizedBox(height: 16),

          Text(
            "${filteredItems.length} items",
            style: TextStyle(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 16),

          ...filteredItems.map((item) => _buildMenuCard(item: item)),
        ],
      ),
    );
  }

  TimeOfDay breakfastStart = const TimeOfDay(hour: 6, minute: 0);

  TimeOfDay breakfastEnd = const TimeOfDay(hour: 10, minute: 0);

  TimeOfDay lunchStart = const TimeOfDay(hour: 11, minute: 0);

  TimeOfDay lunchEnd = const TimeOfDay(hour: 14, minute: 0);

  Widget _buildMealScheduleCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xff0F7B94),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Meal Schedule",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),

              IconButton(
                onPressed: () {
                  _showMealScheduleDialog();
                },
                icon: const Icon(Icons.edit_outlined, color: Colors.white),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _buildMealTimeCard(
                  "Breakfast",
                  breakfastStart,
                  breakfastEnd,
                  Icons.free_breakfast,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: _buildMealTimeCard(
                  "Lunch",
                  lunchStart,
                  lunchEnd,
                  Icons.lunch_dining,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMealTimeCard(
    String title,
    TimeOfDay start,
    TimeOfDay end,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white),

          const SizedBox(height: 8),

          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            "${start.format(context)}\n${end.format(context)}",
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildTimePickerTile({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xffF8F8F8),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),

            const SizedBox(height: 6),

            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealFilterChip(String title) {
    final selected = selectedMealFilter == title;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedMealFilter = title;
          });

          _filterItems();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: selected ? const Color(0xff0F7B94) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? const Color(0xff0F7B94) : Colors.grey.shade300,
            ),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: selected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusFilterChip(String title) {
    final selected = selectedStatusFilter == title;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedStatusFilter = title;
          });

          _filterItems();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: selected ? const Color(0xff0F7B94) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? const Color(0xff0F7B94) : Colors.grey.shade300,
            ),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: selected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String category) {
    final selected = selectedCategory == category;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = category;
        });
        _filterItems();
      },

      onLongPress: () {
        _showDeleteCategoryDialog(category);
      },

      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: selected ? const Color(0xff0F7B94) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? const Color(0xff0F7B94) : Colors.grey.shade300,
          ),
        ),
        child: Center(
          child: Text(
            category,
            style: TextStyle(
              color: selected ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddCategoryChip() {
    return GestureDetector(
      onTap: _showAddCategoryDialog,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: const Center(
          child: Icon(
            Icons.add,
            color: Colors.black87,
            size: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _showAddCategoryDialog() {
    categoryController.clear();

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: const Color(0xff0F7B94).withOpacity(.08),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.category_outlined,
                    color: Color(0xff0F7B94),
                    size: 38,
                  ),
                ),

                const SizedBox(height: 18),

                const Text(
                  "Add Category",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                Text(
                  "Create a new menu category",
                  style: TextStyle(color: Colors.grey.shade600),
                ),

                const SizedBox(height: 20),

                TextField(
                  controller: categoryController,
                  decoration: InputDecoration(
                    hintText: "e.g. Coffee",
                    prefixIcon: const Icon(
                      Icons.folder_outlined,
                      color: Color(0xff0F7B94),
                    ),
                    filled: true,
                    fillColor: const Color(0xffF7F9FA),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text("Cancel"),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          final category = categoryController.text.trim();

                          if (category.isNotEmpty &&
                              !categories.contains(category)) {
                            setState(() {
                              categories.add(category);
                            });
                          }

                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.add),
                        label: const Text("Add"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff0F7B94),
                          foregroundColor: Colors.white,
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDeleteCategoryDialog(String category) {
    if (category == "All") {
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: const Color(0xff0F7B94).withOpacity(.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.lock_outline,
                      color: Color(0xff0F7B94),
                      size: 38,
                    ),
                  ),

                  const SizedBox(height: 18),

                  const Text(
                    "Cannot Delete",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    '"All" is a system category and cannot be deleted.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff0F7B94),
                        foregroundColor: Colors.white,
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text("Got it"),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );

      return;
    }

    final hasMenuItems = allItems.any((item) => item["category"] == category);

    if (hasMenuItems) {
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.orange,
                      size: 38,
                    ),
                  ),

                  const SizedBox(height: 18),

                  const Text(
                    "Cannot Delete",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    '"$category" contains menu items.\n\n'
                    'Move or delete the menu items first.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff0F7B94),
                        foregroundColor: Colors.white,
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text("Got it"),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );

      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(.08),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                    size: 36,
                  ),
                ),

                const SizedBox(height: 18),

                const Text(
                  "Delete Category",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                Text(
                  'Delete "$category"?',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
                ),

                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text("Cancel"),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            categories.remove(category);

                            if (selectedCategory == category) {
                              selectedCategory = "All";
                            }

                            _filterItems();
                          });

                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text("Delete"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMenuCard({required Map<String, dynamic> item}) {
    final name = item["name"] ?? "";
    final description = item["desc"] ?? "";
    final imagePath = item["image"];
    final points = item["points"] ?? "";
    final mealType = item["mealType"] ?? "";
    final available = item["available"] ?? false;
    final stock = item["stock"] ?? 0;
    final trackStock = item["trackStock"] ?? false;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xffFCFCFC),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: imagePath != null
                    ? Image.file(
                        File(imagePath),
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey.shade200,
                        child: const Icon(
                          Icons.fastfood,
                          size: 36,
                          color: Colors.grey,
                        ),
                      ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        if (!available) ...[
                          const SizedBox(width: 6),

                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xffFFF4F4),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xffFFD7D7),
                              ),
                            ),
                            child: const Text(
                              "SOLD OUT",
                              style: TextStyle(
                                color: Colors.redAccent,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),

                    const SizedBox(height: 6),

                    Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),

                    if (trackStock) ...[
                      const SizedBox(height: 6),
                      Text(
                        "Stock: $stock",
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff0F7B94),
                        ),
                      ),
                    ],

                    const SizedBox(height: 8),

                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        // Points Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xffEAF7FA),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "$points pts",
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff0F7B94),
                            ),
                          ),
                        ),

                        // Breakfast/Lunch Badge
                        if (mealType.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: mealType == "Breakfast"
                                  ? const Color(0xffFFF7E6)
                                  : const Color(0xffEAF7FA),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              mealType,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: mealType == "Breakfast"
                                    ? Colors.orange
                                    : const Color(0xff0F7B94),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ✅ BOTTOM ROW RESTORED
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      // ✅ Toggle value
                      item["available"] = !item["available"];
                      _filterItems(); // refresh filtered list
                    });
                  },
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: available
                            ? const Color(0xffCFEFD8)
                            : const Color(0xffFFCACA),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        available ? "Available" : "Sold out",
                        style: TextStyle(
                          color: available
                              ? const Color(0xff6DAE83)
                              : Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              // ✅ EDIT BUTTON
              GestureDetector(
                onTap: () {
                  _showEditMenuSheet(allItems.indexOf(item));
                },
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: const Icon(
                    Icons.edit_outlined,
                    color: Color(0xff0F7B94),
                    size: 20,
                  ),
                ),
              ),

              const SizedBox(width: 10),

              // ✅ DELETE BUTTON
              GestureDetector(
                onTap: () {
                  _showDeleteDialog(allItems.indexOf(item));
                },
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: const Icon(
                    Icons.delete_outline,
                    color: Colors.redAccent,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddMenuSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// HEADER
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Add menu item",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    Center(
                      child: GestureDetector(
                        onTap: () {
                          _pickImage(setModalState);
                        },
                        child: Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: selectedImage == null
                              ? const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_photo_alternate_outlined,
                                      size: 38,
                                      color: Color(0xff0F7B94),
                                    ),
                                    SizedBox(height: 6),
                                    Text("Add image"),
                                  ],
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(24),
                                  child: Image.file(
                                    selectedImage!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// NAME
                    _buildInput(nameController, "Name", "e.g. Mohinga"),

                    const SizedBox(height: 12),

                    /// DESCRIPTION
                    _buildInput(
                      descController,
                      "Description",
                      "Short description",
                    ),

                    const SizedBox(height: 12),

                    /// CATEGORY
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Category",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 6),

                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedCategory,
                              isExpanded: true,
                              items: categories
                                  .map(
                                    (cat) => DropdownMenuItem(
                                      value: cat,
                                      child: Text(cat),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                setModalState(() {
                                  selectedCategory = value!;

                                  if (isStockItem) {
                                    selectedMealType = null;
                                  } else {
                                    stockController.clear();
                                  }
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    /// MEAL TYPE (OPTIONAL)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Meal Type (Optional)",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 6),

                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: isStockItem
                                ? Colors.grey.shade100
                                : Colors.white,
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String?>(
                              value: isStockItem ? null : selectedMealType,
                              isExpanded: true,
                              hint: const Text("No meal type"),
                              items: const [
                                DropdownMenuItem<String?>(
                                  value: null,
                                  child: Text("No meal type"),
                                ),

                                DropdownMenuItem<String?>(
                                  value: "Breakfast",
                                  child: Text("Breakfast"),
                                ),

                                DropdownMenuItem<String?>(
                                  value: "Lunch",
                                  child: Text("Lunch"),
                                ),
                              ],
                              onChanged: isStockItem
                                  ? null
                                  : (value) {
                                      setModalState(() {
                                        selectedMealType = value;
                                      });
                                    },
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    /// POINTS
                    _buildInput(pointsController, "Points", "100"),

                    const SizedBox(height: 12),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Stock Quantity",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        const SizedBox(height: 6),

                        TextField(
                          controller: stockController,
                          enabled: isStockItem,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: "24",
                            filled: true,
                            fillColor: isStockItem
                                ? Colors.white
                                : Colors.grey.shade100,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    /// AVAILABLE
                    Row(
                      children: [
                        Checkbox(
                          value: isAvailable,
                          onChanged: (value) {
                            setModalState(() {
                              isAvailable = value!;
                            });
                          },
                        ),
                        const Text("Available for sale"),
                      ],
                    ),

                    const SizedBox(height: 20),

                    /// ADD BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff0F7B94),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            allItems.add({
                              "name": nameController.text,
                              "desc": descController.text,
                              "image": selectedImage?.path,
                              "category": selectedCategory,
                              "mealType": selectedMealType,
                              "points": pointsController.text,
                              "stock": int.tryParse(stockController.text) ?? 0,
                              "trackStock": true,
                              "available": isAvailable,
                            });

                            _filterItems();
                          });

                          nameController.clear();
                          descController.clear();
                          pointsController.clear();

                          selectedMealType = null;
                          selectedCategory = "Main";
                          isAvailable = true;

                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Add to menu",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildInput(
    TextEditingController controller,
    String label,
    String hint,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          ),
        ),
      ],
    );
  }

  void _showEditMenuSheet(int index) {
    final item = allItems[index];

    final imagePath = item["image"];

    if (imagePath != null) {
      selectedImage = File(imagePath);
    } else {
      selectedImage = null;
    }

    selectedMealType = item["mealType"];
    selectedCategory = item["category"] ?? "Main";

    // ✅ preload values
    nameController.text = item["name"] ?? "";
    descController.text = item["desc"] ?? "";
    pointsController.text = item["points"] ?? "";
    stockController.text = (item["stock"] ?? 0).toString();
    selectedCategory = item["category"] ?? "Main";
    isAvailable = item["available"] ?? true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Edit menu item",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    Center(
                      child: GestureDetector(
                        onTap: () {
                          _pickImage(setModalState);
                        },
                        child: Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: selectedImage == null
                              ? const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_photo_alternate_outlined,
                                      size: 38,
                                      color: Color(0xff0F7B94),
                                    ),
                                    SizedBox(height: 6),
                                    Text("Add image"),
                                  ],
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(24),
                                  child: Image.file(
                                    selectedImage!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    _buildInput(nameController, "Name", "e.g. Mohinga"),
                    const SizedBox(height: 12),

                    _buildInput(
                      descController,
                      "Description",
                      "Short description",
                    ),
                    const SizedBox(height: 12),

                    // ✅ CATEGORY DROPDOWN
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Category"),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedCategory,
                              isExpanded: true,
                              items: categories
                                  .map(
                                    (cat) => DropdownMenuItem(
                                      value: cat,
                                      child: Text(cat),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                setModalState(() {
                                  selectedCategory = value!;

                                  if (isStockItem) {
                                    selectedMealType = null;
                                  } else {
                                    stockController.clear();
                                  }
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Meal Type (Optional)"),
                        const SizedBox(height: 6),

                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: isStockItem
                                ? Colors.grey.shade100
                                : Colors.white,
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String?>(
                              value: isStockItem ? null : selectedMealType,
                              isExpanded: true,
                              items: const [
                                DropdownMenuItem<String?>(
                                  value: null,
                                  child: Text("No meal type"),
                                ),

                                DropdownMenuItem(
                                  value: "Breakfast",
                                  child: Text("Breakfast"),
                                ),

                                DropdownMenuItem(
                                  value: "Lunch",
                                  child: Text("Lunch"),
                                ),
                              ],

                              onChanged: isStockItem
                                  ? null
                                  : (value) {
                                      setModalState(() {
                                        selectedMealType = value;
                                      });
                                    },
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    _buildInput(pointsController, "Points", "100"),

                    const SizedBox(height: 12),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Stock Quantity",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        const SizedBox(height: 6),

                        TextField(
                          controller: stockController,
                          enabled: isStockItem,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: "24",
                            filled: true,
                            fillColor: isStockItem
                                ? Colors.white
                                : Colors.grey.shade100,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Checkbox(
                          value: isAvailable,
                          onChanged: (value) {
                            setState(() {
                              isAvailable = value!;
                            });
                          },
                        ),
                        const Text("Available for sale"),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // ✅ SAVE BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff0F7B94),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            allItems[index] = {
                              "name": nameController.text,
                              "desc": descController.text,
                              "image": selectedImage?.path,
                              "category": selectedCategory,

                              "mealType": isStockItem ? null : selectedMealType,

                              "points": pointsController.text,

                              "stock": isStockItem
                                  ? int.tryParse(stockController.text) ?? 0
                                  : item["stock"],

                              "trackStock": isStockItem,
                              "available": isAvailable,
                            };

                            _filterItems();
                          });

                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Save changes",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            "Delete item",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          content: const Text(
            "Are you sure you want to delete this menu item?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // ❌ Cancel
              },
              child: const Text(
                "Cancel",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                setState(() {
                  allItems.removeAt(index); // ✅ Delete item
                  _filterItems(); // refresh list
                });

                Navigator.pop(context); // close dialog
              },
              child: const Text(
                "Delete",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showMealScheduleDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            Future<void> pickTime({
              required bool isBreakfast,
              required bool isStart,
              required TimeOfDay currentTime,
            }) async {
              final picked = await showTimePicker(
                context: context,
                initialTime: currentTime,
              );

              if (picked == null) return;

              setDialogState(() {
                if (isBreakfast && isStart) {
                  breakfastStart = picked;
                } else if (isBreakfast && !isStart) {
                  breakfastEnd = picked;
                } else if (!isBreakfast && isStart) {
                  lunchStart = picked;
                } else {
                  lunchEnd = picked;
                }
              });

              setState(() {});
            }

            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Meal Schedule",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// Breakfast
                    const Text(
                      "Breakfast",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: _buildTimePickerTile(
                            label: "Start",
                            value: breakfastStart.format(context),
                            onTap: () {
                              pickTime(
                                isBreakfast: true,
                                isStart: true,
                                currentTime: breakfastStart,
                              );
                            },
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: _buildTimePickerTile(
                            label: "End",
                            value: breakfastEnd.format(context),
                            onTap: () {
                              pickTime(
                                isBreakfast: true,
                                isStart: false,
                                currentTime: breakfastEnd,
                              );
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    /// Lunch
                    const Text(
                      "Lunch",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: _buildTimePickerTile(
                            label: "Start",
                            value: lunchStart.format(context),
                            onTap: () {
                              pickTime(
                                isBreakfast: false,
                                isStart: true,
                                currentTime: lunchStart,
                              );
                            },
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: _buildTimePickerTile(
                            label: "End",
                            value: lunchEnd.format(context),
                            onTap: () {
                              pickTime(
                                isBreakfast: false,
                                isStart: false,
                                currentTime: lunchEnd,
                              );
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff0F7B94),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Save Changes",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
