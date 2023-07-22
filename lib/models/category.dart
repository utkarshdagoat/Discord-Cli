class Category {
  late int categoryId;
  late String categoryName;
  late bool isPublic;

  Category(int id, String name, bool isPu) {
    categoryId = id;
    categoryName = name;
    isPublic = isPu;
  }

  static Category fromResponse({required List<dynamic> response}) =>
      Category(response[0], response[1], response[2]);
}
