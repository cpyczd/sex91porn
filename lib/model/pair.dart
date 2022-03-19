import 'dart:convert';

/*
 * @Description: 
 * @Author: chenzedeng
 * @Date: 2022-03-19 19:38:19
 * @LastEditTime: 2022-03-19 19:38:19
 */

class Pair<T, K> {
  final T key;
  final K value;
  Pair({
    required this.key,
    required this.value,
  });

  Pair<T, K> copyWith({
    T? key,
    K? value,
  }) {
    return Pair<T, K>(
      key: key ?? this.key,
      value: value ?? this.value,
    );
  }

  @override
  String toString() => 'Pair(key: $key, value: $value)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Pair<T, K> && other.key == key && other.value == value;
  }

  @override
  int get hashCode => key.hashCode ^ value.hashCode;
}
