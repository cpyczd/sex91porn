import 'dart:convert';

/*
 * @Description: 
 * @Author: chenzedeng
 * @Date: 2021-01-26 15:18:03
 * @LastEditTime: 2021-10-03 01:11:58
 */

///视屏模块
class VideoModel {
  ///编号ID
  final int id;

  ///标题
  final String title;

  ///封面
  final String? cover;

  ///时长
  final String? duration;

  ///原始视屏链接
  final String? href;

  ///视屏播放地址 m3u8
  String? src;
  VideoModel({
    required this.id,
    required this.title,
    this.cover,
    this.duration,
    this.href,
    this.src,
  });

  VideoModel copyWith({
    int? id,
    String? title,
    String? cover,
    String? duration,
    String? href,
    String? src,
  }) {
    return VideoModel(
      id: id ?? this.id,
      title: title ?? this.title,
      cover: cover ?? this.cover,
      duration: duration ?? this.duration,
      href: href ?? this.href,
      src: src ?? this.src,
    );
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
      id: map['id'],
      title: map['title'],
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
    return 'VideoModel(id: $id, title: $title, cover: $cover, duration: $duration, href: $href, src: $src)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is VideoModel &&
        other.id == id &&
        other.title == title &&
        other.cover == cover &&
        other.duration == duration &&
        other.href == href &&
        other.src == src;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        cover.hashCode ^
        duration.hashCode ^
        href.hashCode ^
        src.hashCode;
  }
}
