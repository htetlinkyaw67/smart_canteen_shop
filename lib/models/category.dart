class CategoryModel {

  final int categoryId;
  final String categoryName;


  CategoryModel({
    required this.categoryId,
    required this.categoryName,
  });


  factory CategoryModel.fromJson(
      Map<String,dynamic> json){

    return CategoryModel(
      categoryId: json["category_id"],
      categoryName: json["category_name"],
    );

  }



  @override
  bool operator ==(Object other){

    return other is CategoryModel &&
        other.categoryId == categoryId;

  }


  @override
  int get hashCode =>
      categoryId.hashCode;

}