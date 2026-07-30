import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_canteen_shop/models/category.dart';
import 'package:smart_canteen_shop/models/menu_model.dart';
import 'package:smart_canteen_shop/provider/menu_provider.dart';
import 'package:smart_canteen_shop/services/api_service.dart';
import '../data/menu_inventory.dart';
import '../widgets/page_header.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'notification_page.dart';

class MenuPage extends ConsumerStatefulWidget {
  const MenuPage({super.key});

  @override
  ConsumerState<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends ConsumerState<MenuPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController pointsController = TextEditingController();
  final TextEditingController stockController = TextEditingController();

  bool isAvailable = true;
  bool isAddingMenu = false;

  File? selectedImage;
  final ImagePicker picker = ImagePicker();

  String? selectedMealType;
  // String selectedCategory = "All";
  String selectedMealFilter = "အားလုံး";
  String selectedStatusFilter = "အားလုံး";
  int? selectedCategoryId;
  bool get isStockItem {
    final name = selectedCategory?.categoryName ?? "";

    return name == "အချိုရည်နှင့် အဖျော်ယမကာ" ||
        name == "လက်ဖက်ရည်နှင့်ကော်ဖီ" ||
        name == "သရေစာနှင့်သကြားလုံး";
  }

  List<CategoryModel> categories = [];
  String selectedCategoryName = "အားလုံး";
  CategoryModel? selectedCategory;

  Future<void> _pickImage(void Function(void Function()) setModalState) async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setModalState(() {
        selectedImage = File(image.path);
      });
    }
  }

  bool _isShopOpen = true; // SHOP STATUS STATE

  void _handleLogout() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("ထွက်မည်"),
          content: const Text("ထွက်မယ်ဆိုတာ သေချာပါသလား။"),
          actions: [
            // Cancel logout
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text("မလုပ်တော့ပါ"),
            ),

            // Confirm logout
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              onPressed: () {
                // Close confirmation dialog first
                Navigator.of(dialogContext).pop();

                // Go to LoginPage
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil('/login', (route) => false);
              },
              child: const Text(
                "ထွက်မည်",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  final TextEditingController _searchController = TextEditingController();

  List<MenuModel> allItems = [];

  List<MenuModel> filteredItems = [];

  @override
  void initState() {
    super.initState();

    filteredItems = List.from(allItems);

    loadCategories();

    _searchController.addListener(_filterItems);
  }

  Future<void> loadCategories() async {
    try {
      final result = await ApiService().getAllCategories();

      setState(() {
        categories = result;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _filterItems() {
    if (selectedCategoryId == null) {
      filteredItems = List.from(allItems);
    } else {
      filteredItems = allItems.where((item) {
        return item.categoryId == selectedCategoryId;
      }).toList();
    }

    setState(() {});
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
            title: "Moe's Burmese Kitchen",
            subtitle: "မီနူးပြင်ဆင်ခြင်း",
            icon: Icons.restaurant_menu,
            isShopOpen: _isShopOpen,
            onStatusChanged: (isOpen) {
              setState(() {
                _isShopOpen = isOpen;
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _isShopOpen ? "ဆိုင်ဖွင့်ထားပါပြီ" : "ဆိုင်ပိတ်ထားပါပြီ",
                  ),
                  duration: const Duration(seconds: 2),
                  backgroundColor: _isShopOpen ? Colors.green : Colors.red,
                ),
              );
            },

            notificationCount: 6,

            onNotification: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationPage()),
              );
            },

            onLogout: _handleLogout,
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
                      "အစားအစာအမျိုးအစား",
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
                      _buildMealFilterChip("အားလုံး"),
                      _buildMealFilterChip("မနက်စာ"),
                      _buildMealFilterChip("နေ့လယ်စာ"),
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
                      "အခြေအနေ",
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
                      _buildStatusFilterChip("အားလုံး"),
                      _buildStatusFilterChip("ရရှိနိုင်သည်"),
                      _buildStatusFilterChip("ကုန်သွားပြီ"),
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
                      "အမျိုးအစားများ",
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
                      if (index == 0) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),

                          child: _buildCategoryChip("အားလုံး", null),
                        );
                      }

                      final category = categories[index - 1];

                      return Padding(
                        padding: const EdgeInsets.only(right: 8),

                        child: _buildCategoryChip(
                          category.categoryName,

                          category.categoryId,
                        ),
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
                      hintText: "မီနူး ရှာဖွေပါ...",
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
                      SizedBox(width: 4),
                      Text(
                        "မီနူးထည့်ရန်",
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
            "${filteredItems.length} ခု",
            style: TextStyle(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 16),

          ...filteredItems.map((item) => _buildMenuCard(item)),

          /// BOTTOM SPACE
          const SizedBox(height: 60),
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
                "အစားအစာ ရောင်းချချိန်",
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
                  "မနက်စာ",
                  breakfastStart,
                  breakfastEnd,
                  Icons.free_breakfast,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: _buildMealTimeCard(
                  "နေ့လယ်စာ",
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

  Widget _buildCategoryChip(String name, int? categoryId) {
    final selected = selectedCategoryId == categoryId;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategoryId = categoryId;
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
            name,

            style: TextStyle(
              color: selected ? Colors.white : Colors.black87,

              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard(MenuModel item) {
    final name = item.itemName;
    final description = item.description;
    final imagePath = item.imageUrl;
    final points = item.price;
    final mealType = "";
    final trackStock = item.quantity > 0;
    final available = item.isAvailable;
    final stock = item.quantity;

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
                              "ကုန်သွားပြီ",
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
                        "လက်ကျန်: $stock",
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
                            "$points ပွိုင့်",
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
                              color: mealType == "မနက်စာ"
                                  ? const Color(0xffFFF7E6)
                                  : const Color(0xffEAF7FA),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              mealType,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: mealType == "မနက်စာ"
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
                    final index = allItems.indexOf(item);

                    if (index == -1) return;

                    setState(() {
                      allItems[index] = item.copyWith(
                        isAvailable: !item.isAvailable,
                      );

                      _filterItems();
                    });
                  },

                  child: Container(
                    height: 40,

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),

                      border: Border.all(
                        color: item.isAvailable
                            ? const Color(0xffCFEFD8)
                            : const Color(0xffFFCACA),
                      ),
                    ),

                    child: Center(
                      child: Text(
                        item.isAvailable ? "ရရှိနိုင်သည်" : "ကုန်သွားပြီ",

                        style: TextStyle(
                          color: item.isAvailable
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
    nameController.clear();
    descController.clear();
    pointsController.clear();
    stockController.clear();
    selectedImage = null;
    selectedCategory = null;
    selectedMealType = null;
    isAvailable = true;
    _showMenuFormSheet();
  }

  void _showEditMenuSheet(int index) {
    if (index < 0 || index >= allItems.length) return;

    final item = allItems[index];
    nameController.text = item.itemName;
    descController.text = item.description;
    pointsController.text = item.price;
    stockController.text = item.quantity.toString();
    selectedImage = item.imageUrl != null ? File(item.imageUrl!) : null;
    selectedMealType = null;
    isAvailable = item.isAvailable;

    if (categories.isNotEmpty) {
      selectedCategory = categories.cast<CategoryModel?>().firstWhere(
        (category) => category?.categoryId == item.categoryId,
        orElse: () => categories.first,
      );
    } else {
      selectedCategory = null;
    }

    _showMenuFormSheet(editIndex: index);
  }

  void _showMenuFormSheet({int? editIndex}) {
    final bool isEditing = editIndex != null;

    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'မီနူးဖောင်',
      barrierColor: Colors.black.withValues(alpha: 0.25),
      transitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (sheetContext, animation, secondaryAnimation) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final bool stockEnabled = isStockItem;

            return Material(
              color: const Color(0xffF8FAFC),
              child: SafeArea(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(8, 10, 16, 12),
                      decoration: const BoxDecoration(color: Color(0xff0F7B94)),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(sheetContext),
                            icon: const Icon(Icons.arrow_back_rounded),
                            color: Colors.white,
                            tooltip: 'နောက်သို့',
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              isEditing
                                  ? 'မီနူး ပြင်ဆင်ရန်'
                                  : 'မီနူးအသစ် ထည့်ရန်',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.14),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              isEditing
                                  ? Icons.edit_rounded
                                  : Icons.add_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        padding: EdgeInsets.fromLTRB(
                          20,
                          0,
                          20,
                          MediaQuery.viewInsetsOf(context).bottom + 26,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 18),
                            const SizedBox(height: 20),
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: const Color(0xffE2E8F0),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(
                                      alpha: 0.035,
                                    ),
                                    blurRadius: 14,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () => _pickImage(setModalState),
                                    child: Container(
                                      width: 92,
                                      height: 92,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(
                                        color: const Color(0xffEAF6F8),
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      child: selectedImage != null
                                          ? Image.file(
                                              selectedImage!,
                                              fit: BoxFit.cover,
                                            )
                                          : const Icon(
                                              Icons
                                                  .add_photo_alternate_outlined,
                                              color: Color(0xff0F7B94),
                                              size: 34,
                                            ),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'မီနူးဓာတ်ပုံ',
                                          style: TextStyle(
                                            color: Color(0xff0F172A),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        const Text(
                                          'ရှင်းလင်းသော စတုရန်းပုံကို ရွေးချယ်ပါ',
                                          style: TextStyle(
                                            color: Color(0xff64748B),
                                            fontSize: 10.5,
                                            height: 1.4,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        SizedBox(
                                          height: 36,
                                          child: OutlinedButton.icon(
                                            onPressed: () =>
                                                _pickImage(setModalState),
                                            icon: const Icon(
                                              Icons.upload_rounded,
                                              size: 17,
                                            ),
                                            label: Text(
                                              selectedImage == null
                                                  ? 'ပုံရွေးချယ်ရန်'
                                                  : 'ပုံပြောင်းရန်',
                                            ),
                                            style: OutlinedButton.styleFrom(
                                              foregroundColor: const Color(
                                                0xff0F7B94,
                                              ),
                                              side: const BorderSide(
                                                color: Color(0xffB9DDE4),
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(11),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'အခြေခံအချက်အလက်',
                              style: TextStyle(
                                color: Color(0xff0F172A),
                                fontSize: 15,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _menuTextField(
                              controller: nameController,
                              label: 'မီနူးအမည်',
                              hint: 'ဥပမာ - မုန့်ဟင်းခါး',
                              icon: Icons.restaurant_rounded,
                            ),
                            const SizedBox(height: 14),
                            _menuTextField(
                              controller: descController,
                              label: 'ဖော်ပြချက်',
                              hint: 'မီနူးအကြောင်း အကျဉ်းချုပ်ရေးပါ',
                              icon: Icons.subject_rounded,
                              maxLines: 3,
                            ),
                            const SizedBox(height: 14),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: _menuDropdownField<CategoryModel>(
                                    label: 'အမျိုးအစား',
                                    icon: Icons.grid_view_rounded,
                                    value: categories.contains(selectedCategory)
                                        ? selectedCategory
                                        : null,
                                    hint: 'ရွေးချယ်ပါ',
                                    items: categories
                                        .map(
                                          (category) =>
                                              DropdownMenuItem<CategoryModel>(
                                                value: category,
                                                child: Text(
                                                  category.categoryName,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                        )
                                        .toList(),
                                    onChanged: (value) {
                                      setModalState(() {
                                        selectedCategory = value;
                                        if (isStockItem) {
                                          selectedMealType = null;
                                        } else {
                                          stockController.clear();
                                        }
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _menuDropdownField<String?>(
                                    label: 'အစားအစာအချိန်',
                                    icon: Icons.schedule_rounded,
                                    value: stockEnabled
                                        ? null
                                        : selectedMealType,
                                    hint: 'မသတ်မှတ်ပါ',
                                    enabled: !stockEnabled,
                                    items: const [
                                      DropdownMenuItem<String?>(
                                        value: null,
                                        child: Text('မသတ်မှတ်ပါ'),
                                      ),
                                      DropdownMenuItem<String?>(
                                        value: 'မနက်စာ',
                                        child: Text('မနက်စာ'),
                                      ),
                                      DropdownMenuItem<String?>(
                                        value: 'နေ့လယ်စာ',
                                        child: Text('နေ့လယ်စာ'),
                                      ),
                                    ],
                                    onChanged: stockEnabled
                                        ? null
                                        : (value) {
                                            setModalState(() {
                                              selectedMealType = value;
                                            });
                                          },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 22),
                            const Divider(color: Color(0xffE2E8F0)),
                            const SizedBox(height: 18),
                            const Text(
                              'ပွိုင့်နှင့် ရရှိနိုင်မှု',
                              style: TextStyle(
                                color: Color(0xff0F172A),
                                fontSize: 15,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: _menuTextField(
                                    controller: pointsController,
                                    label: 'ပွိုင့်ဈေးနှုန်း',
                                    hint: '100',
                                    icon: Icons.stars_rounded,
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _menuTextField(
                                    controller: stockController,
                                    label: 'လက်ကျန်အရေအတွက်',
                                    hint: stockEnabled ? '24' : 'မလိုအပ်ပါ',
                                    icon: Icons.inventory_2_rounded,
                                    keyboardType: TextInputType.number,
                                    enabled: stockEnabled,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            InkWell(
                              onTap: () {
                                setModalState(() {
                                  isAvailable = !isAvailable;
                                });
                              },
                              borderRadius: BorderRadius.circular(18),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: isAvailable
                                      ? const Color(0xffEAF8F2)
                                      : const Color(0xffFFF3F0),
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                    color: isAvailable
                                        ? const Color(0xffA7E6CC)
                                        : const Color(0xffF8C5BA),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      isAvailable
                                          ? Icons.check_circle_rounded
                                          : Icons.do_not_disturb_on_rounded,
                                      color: isAvailable
                                          ? const Color(0xff11996A)
                                          : const Color(0xffE35D45),
                                      size: 25,
                                    ),
                                    const SizedBox(width: 11),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            isAvailable
                                                ? 'ယခု ရောင်းချနိုင်သည်'
                                                : 'ယခု မရောင်းချပါ',
                                            style: const TextStyle(
                                              color: Color(0xff0F172A),
                                              fontSize: 13,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            isAvailable
                                                ? 'ကျောင်းသားများ၏ မီနူးတွင် ပြသမည်'
                                                : 'မီနူးကို ယာယီပိတ်ထားမည်',
                                            style: const TextStyle(
                                              color: Color(0xff64748B),
                                              fontSize: 10.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Switch.adaptive(
                                      value: isAvailable,
                                      activeColor: const Color(0xff0F7B94),
                                      onChanged: (value) {
                                        setModalState(() {
                                          isAvailable = value;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              height: 54,
                              child: ElevatedButton.icon(
                                onPressed: isAddingMenu
                                    ? null
                                    : () async {
                                        if (nameController.text
                                            .trim()
                                            .isEmpty) {
                                          _showMenuMessage(
                                            sheetContext,
                                            'မီနူးအမည် ထည့်ပါ',
                                          );
                                          return;
                                        }
                                        if (selectedCategory == null) {
                                          _showMenuMessage(
                                            sheetContext,
                                            'အမျိုးအစား ရွေးချယ်ပါ',
                                          );
                                          return;
                                        }
                                        if (pointsController.text
                                            .trim()
                                            .isEmpty) {
                                          _showMenuMessage(
                                            sheetContext,
                                            'ပွိုင့်ပမာဏ ထည့်ပါ',
                                          );
                                          return;
                                        }

                                        if (isEditing) {
                                          final item = allItems[editIndex];
                                          setState(() {
                                            allItems[editIndex] = item.copyWith(
                                              categoryId:
                                                  selectedCategory!.categoryId,
                                              itemName: nameController.text
                                                  .trim(),
                                              description: descController.text
                                                  .trim(),
                                              price: pointsController.text
                                                  .trim(),
                                              quantity:
                                                  int.tryParse(
                                                    stockController.text,
                                                  ) ??
                                                  item.quantity,
                                              isAvailable: isAvailable,
                                              imageUrl:
                                                  selectedImage?.path ??
                                                  item.imageUrl,
                                            );
                                            _filterItems();
                                          });
                                          if (sheetContext.mounted) {
                                            Navigator.pop(sheetContext);
                                          }
                                          return;
                                        }

                                        setModalState(() {
                                          isAddingMenu = true;
                                        });
                                        try {
                                          await ref
                                              .read(menuProvider.notifier)
                                              .addMenu(
                                                categoryId: selectedCategory!
                                                    .categoryId,
                                                itemName: nameController.text
                                                    .trim(),
                                                description: descController.text
                                                    .trim(),
                                                price: pointsController.text
                                                    .trim(),
                                                quantity:
                                                    int.tryParse(
                                                      stockController.text,
                                                    ) ??
                                                    0,
                                                available: isAvailable,
                                                image: selectedImage,
                                              );
                                          if (!mounted) return;
                                          ScaffoldMessenger.of(
                                            this.context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'မီနူးကို အောင်မြင်စွာ ထည့်ပြီးပါပြီ',
                                              ),
                                            ),
                                          );
                                          if (sheetContext.mounted) {
                                            Navigator.pop(sheetContext);
                                          }
                                        } catch (error) {
                                          if (sheetContext.mounted) {
                                            _showMenuMessage(
                                              sheetContext,
                                              error.toString(),
                                            );
                                          }
                                        } finally {
                                          if (mounted) {
                                            setModalState(() {
                                              isAddingMenu = false;
                                            });
                                          }
                                        }
                                      },
                                icon: isAddingMenu
                                    ? const SizedBox(
                                        width: 19,
                                        height: 19,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2.2,
                                        ),
                                      )
                                    : Icon(
                                        isEditing
                                            ? Icons.done_rounded
                                            : Icons.add_rounded,
                                      ),
                                label: Text(
                                  isEditing
                                      ? 'ပြောင်းလဲမှုများ သိမ်းရန်'
                                      : 'မီနူးအသစ် ထည့်ရန်',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: const Color(0xff0F7B94),
                                  foregroundColor: Colors.white,
                                  disabledBackgroundColor: const Color(
                                    0xff94A3B8,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                              ),
                            ),
                          ],
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
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        );
      },
    );
  }

  Widget _menuSectionTitle({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xffE6F4F7),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(icon, color: const Color(0xff0F7B94), size: 19),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xff0F172A),
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Color(0xff64748B),
                  fontSize: 10.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _menuFormCard({required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xffE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _menuTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xff475569),
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 7),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          enabled: enabled,
          style: const TextStyle(
            color: Color(0xff0F172A),
            fontSize: 13.5,
            fontWeight: FontWeight.w700,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: Color(0xff94A3B8),
              fontSize: 12.5,
              fontWeight: FontWeight.w400,
            ),
            prefixIcon: Icon(icon, color: const Color(0xff0F7B94), size: 19),
            filled: true,
            fillColor: enabled
                ? const Color(0xffF8FAFC)
                : const Color(0xffF1F5F9),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xffE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xffE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: Color(0xff0F7B94),
                width: 1.5,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xffE2E8F0)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _menuDropdownField<T>({
    required String label,
    required IconData icon,
    required T? value,
    required String hint,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?>? onChanged,
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xff475569),
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 7),
        DropdownButtonFormField<T>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          hint: Text(
            hint,
            style: const TextStyle(color: Color(0xff94A3B8), fontSize: 12.5),
          ),
          items: items,
          onChanged: enabled ? onChanged : null,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: const Color(0xff0F7B94), size: 19),
            filled: true,
            fillColor: enabled
                ? const Color(0xffF8FAFC)
                : const Color(0xffF1F5F9),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 13,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xffE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xffE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: Color(0xff0F7B94),
                width: 1.5,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xffE2E8F0)),
            ),
          ),
        ),
      ],
    );
  }

  void _showMenuMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xff0F7B94),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
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
            "မီနူး ဖျက်ရန်",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          content: const Text("ဤမီနူးကို ဖျက်ရန် သေချာပါသလား။"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // ❌ Cancel
              },
              child: const Text(
                "မလုပ်တော့ပါ",
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
                "ဖျက်မည်",
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
                      "အစားအစာ ရောင်းချချိန်",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// Breakfast
                    const Text(
                      "မနက်စာ",
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
                            label: "စတင်ချိန်",
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
                            label: "ပြီးဆုံးချိန်",
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
                      "နေ့လယ်စာ",
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
                            label: "စတင်ချိန်",
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
                            label: "ပြီးဆုံးချိန်",
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
                          "ပြောင်းလဲမှုများ သိမ်းရန်",
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
