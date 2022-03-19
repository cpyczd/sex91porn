import 'dart:convert';

import 'package:flutter/foundation.dart';

/*
 * @Description: 
 * @Author: chenzedeng
 * @Date: 2022-03-19 22:44:23
 * @LastEditTime: 2022-03-19 22:45:24
 */
///图文详情模型类
class ImageModel {
  final String href;
  final String title;
  final List<String> imageUrls;
  ImageModel({
    required this.href,
    required this.title,
    required this.imageUrls,
  });

  ImageModel copyWith({
    String? href,
    String? title,
    List<String>? imageUrls,
  }) {
    return ImageModel(
      href: href ?? this.href,
      title: title ?? this.title,
      imageUrls: imageUrls ?? this.imageUrls,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'href': href,
      'title': title,
      'imageUrls': imageUrls,
    };
  }

  factory ImageModel.fromMap(Map<String, dynamic> map) {
    return ImageModel(
      href: map['href'] ?? '',
      title: map['title'] ?? '',
      imageUrls: List<String>.from(map['imageUrls']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ImageModel.fromJson(String source) =>
      ImageModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'ImageModel(href: $href, title: $title, imageUrls: $imageUrls)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ImageModel &&
        other.href == href &&
        other.title == title &&
        listEquals(other.imageUrls, imageUrls);
  }

  @override
  int get hashCode => href.hashCode ^ title.hashCode ^ imageUrls.hashCode;
}
