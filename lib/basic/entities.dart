class SortBy {
  final String _value;
  final String _name;

  const SortBy._(this._value, this._name);

  get value => _value;

  @override
  String toString() {
    return _name;
  }
}

const sortByDefault = SortBy._("", "默认");
const sortByNew = SortBy._("mr", "最新");
const sortByLike = SortBy._("tf", "心");
const sortByView = SortBy._("mv", "查看");
const sortByViewDay = SortBy._("mv_t", "日榜");
const sortByViewWeek = SortBy._("mv_w", "周榜");
const sortByViewMonth = SortBy._("mv_m", "月榜");

const sorts = [
  sortByDefault,
  sortByNew,
  sortByLike,
  sortByView,
  sortByViewDay,
  sortByViewWeek,
  sortByViewMonth,
];

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

  late final int id;
  late final String author;
  late final String description;
  late final String name;
  late final String image;
  late final ComicSimpleCategory category;
  late final ComicSimpleCategory categorySub;

  ComicSimple.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    author = json['author'];
    description = json['description'];
    name = json['name'];
    image = json['image'];
    category = ComicSimpleCategory.fromJson(json['category']);
    categorySub = ComicSimpleCategory.fromJson(json['category_sub']);
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
    this.id,
    this.title,
  });

  late final String? id;
  late final String? title;

  ComicSimpleCategory.fromJson(Map<String, dynamic> json) {
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

class CategoriesResponse {
  CategoriesResponse({
    required this.categories,
    required this.blocks,
  });

  late final List<Categories> categories;
  late final List<Blocks> blocks;

  CategoriesResponse.fromJson(Map<String, dynamic> json) {
    categories = List.from(json['categories'])
        .map((e) => Categories.fromJson(e))
        .toList();
    blocks = List.from(json['blocks']).map((e) => Blocks.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['categories'] = categories.map((e) => e.toJson()).toList();
    _data['blocks'] = blocks.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Categories {
  Categories({
    required this.id,
    required this.name,
    required this.slug,
    required this.totalAlbums,
    this.type,
  });

  late final int id;
  late final String name;
  late final String slug;
  late final int totalAlbums;
  late final String? type;

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    totalAlbums = json['total_albums'];
    type = null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['slug'] = slug;
    _data['total_albums'] = totalAlbums;
    _data['type'] = type;
    return _data;
  }
}

class Blocks {
  Blocks({
    required this.title,
    required this.content,
  });

  late final String title;
  late final List<String> content;

  Blocks.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    content = List.castFrom<dynamic, String>(json['content']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['title'] = title;
    _data['content'] = content;
    return _data;
  }
}
