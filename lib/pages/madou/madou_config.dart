import 'dart:convert';

import 'package:flutter/material.dart';

/*
 * @Description: 
 * @Author: chenzedeng
 * @Date: 2022-03-27 21:00:46
 * @LastEditTime: 2022-03-28 21:15:58
 */

const MAIN_URL = "https://madou.club/";

class MadouCategory {
  final String title;
  final String href;
  Icon? icon;
  MadouCategory({
    required this.title,
    required this.href,
    this.icon,
  });

  MadouCategory copyWith({
    String? title,
    String? href,
    Icon? icon,
  }) {
    return MadouCategory(
      title: title ?? this.title,
      href: href ?? this.href,
      icon: icon ?? this.icon,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'href': href,
    };
  }

  factory MadouCategory.fromMap(Map<dynamic, dynamic> map) {
    return MadouCategory(
      title: map['title'] ?? '',
      href: map['href'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory MadouCategory.fromJson(String source) =>
      MadouCategory.fromMap(json.decode(source));

  @override
  String toString() => 'MadouCategory(title: $title, href: $href, icon: $icon)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MadouCategory &&
        other.title == title &&
        other.href == href &&
        other.icon == icon;
  }

  @override
  int get hashCode => title.hashCode ^ href.hashCode ^ icon.hashCode;

  String getPagePath(int page) {
    if (page == 1) {
      return href;
    }
    return href + "/page/$page";
  }
}
