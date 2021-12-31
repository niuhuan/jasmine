class SearchPage {
  SearchPage({
    required this.searchQuery,
    required this.total,
  });

  late final String searchQuery;
  late final String total;

  SearchPage.fromJson(Map<String, dynamic> json) {
    searchQuery = json['search_query'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['search_query'] = searchQuery;
    _data['total'] = total;
    return _data;
  }
}

class ComicsResponse extends SearchPage {
  late final List<ComicSimple> content;

  ComicsResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    content =
        List.from(json['content']).map((e) => ComicSimple.fromJson(e)).toList();
  }

  @override
  Map<String, dynamic> toJson() {
    final _data = super.toJson();
    _data['content'] = content;
    return _data;
  }
}

class ComicSimple {
  ComicSimple({
    required this.id,
    required this.author,
    required this.description,
    required this.name,
    required this.image,
    required this.category,
    required this.categorySub,
  });

  late final String id;
  late final String author;
  late final String description;
  late final String name;
  late final String image;
  late final ComicSimpleCategory category;
  late final CategorySub categorySub;

  ComicSimple.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    author = json['author'];
    description = json['description'];
    name = json['name'];
    image = json['image'];
    category = ComicSimpleCategory.fromJson(json['category']);
    categorySub = CategorySub.fromJson(json['category_sub']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['author'] = author;
    _data['description'] = description;
    _data['name'] = name;
    _data['image'] = image;
    _data['category'] = category.toJson();
    _data['category_sub'] = categorySub.toJson();
    return _data;
  }
}

class ComicSimpleCategory {
  ComicSimpleCategory({
    required this.id,
    required this.title,
  });

  late final String id;
  late final String title;

  ComicSimpleCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['title'] = title;
    return _data;
  }
}

class CategorySub {
  CategorySub({
    this.id,
    this.title,
  });

  late final String? id;
  late final String? title;

  CategorySub.fromJson(Map<String, dynamic> json) {
    id = null;
    title = null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['title'] = title;
    return _data;
  }
}
