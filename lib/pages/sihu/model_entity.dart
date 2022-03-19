/*
 * @Description: 
 * @Author: chenzedeng
 * @Date: 2022-03-19 15:56:16
 * @LastEditTime: 2022-03-19 15:58:12
 */

import 'package:flutter/material.dart';

class SihuCategoryModel {
  final String title;
  final String href;
  final Icon icon;
  SihuCategoryModel({
    required this.title,
    required this.href,
    required this.icon,
  });

  SihuCategoryModel copyWith({
    String? title,
    String? href,
    Icon? icon,
  }) {
    return SihuCategoryModel(
      title: title ?? this.title,
      href: href ?? this.href,
      icon: icon ?? this.icon,
    );
  }

  @override
  String toString() => 'CategoryModel(title: $title, href: $href, icon: $icon)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SihuCategoryModel &&
        other.title == title &&
        other.href == href &&
        other.icon == icon;
  }

  @override
  int get hashCode => title.hashCode ^ href.hashCode ^ icon.hashCode;
}
