import 'dart:convert';

/*
 * @Description: 
 * @Author: chenzedeng
 * @Date: 2021-01-26 11:06:12
 * @LastEditTime: 2021-10-02 22:08:09
 */

///类别选择器模块
class CategoryModel {
  final String name;
  final String url;
  int? endPage;

  CategoryModel({
    required this.name,
    required this.url,
    this.endPage,
  });

  CategoryModel copyWith({
    String? name,
    String? url,
    int? endPage,
  }) {
    return CategoryModel(
      name: name ?? this.name,
      url: url ?? this.url,
      endPage: endPage ?? this.endPage,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'url': url,
      'endPage': endPage,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      name: map['name'],
      url: map['url'],
      endPage: map['endPage'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryModel.fromJson(String source) =>
      CategoryModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'CategoryModel(name: $name, url: $url, endPage: $endPage)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CategoryModel &&
        other.name == name &&
        other.url == url &&
        other.endPage == endPage;
  }

  @override
  int get hashCode => name.hashCode ^ url.hashCode ^ endPage.hashCode;
}
