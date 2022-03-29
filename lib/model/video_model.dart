import 'dart:convert';

/*
 * @Description: 
 * @Author: chenzedeng
 * @Date: 2021-01-26 15:18:03
 * @LastEditTime: 2022-03-27 21:23:27
 */

///视屏模块
class VideoModel {
  ///编号ID
  final int id;

  ///标题
  final String title;

  final String? subTtile;

  ///封面
  final String? cover;

  String? dynamicCover;

  ///时长
  final String? duration;

  ///原始视屏链接
  final String? href;

  ///视屏播放地址 m3u8
  String? src;
  VideoModel(
      {required this.id,
      required this.title,
      this.cover,
      this.dynamicCover,
      this.duration,
      this.href,
      this.src,
      this.subTtile});

  VideoModel copyWith(
      {int? id,
      String? title,
      String? cover,
      String? dynamicCover,
      String? duration,
      String? href,
      String? src,
      String? subTtile}) {
    return VideoModel(
        id: id ?? this.id,
        title: title ?? this.title,
        cover: cover ?? this.cover,
        dynamicCover: dynamicCover ?? this.dynamicCover,
        duration: duration ?? this.duration,
        href: href ?? this.href,
        src: src ?? this.src,
        subTtile: subTtile ?? this.subTtile);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'cover': cover,
      'duration': duration,
      'href': href,
      'src': src,
    };
  }

  factory VideoModel.fromMap(Map<String, dynamic> map) {
    return VideoModel(
      id: map['id']?.toInt() ?? 0,
      title: map['title'] ?? '',
      cover: map['cover'],
      duration: map['duration'],
      href: map['href'],
      src: map['src'],
    );
  }

  String toJson() => json.encode(toMap());

  factory VideoModel.fromJson(String source) =>
      VideoModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'VideoModel(id: $id, title: $title, subTitle: $subTtile cover: $cover, dynamicCover: $dynamicCover, duration: $duration, href: $href, src: $src)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is VideoModel &&
        other.id == id &&
        other.title == title &&
        other.cover == cover &&
        other.dynamicCover == dynamicCover &&
        other.duration == duration &&
        other.href == href &&
        other.src == src;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        cover.hashCode ^
        dynamicCover.hashCode ^
        duration.hashCode ^
        href.hashCode ^
        src.hashCode;
  }
}
