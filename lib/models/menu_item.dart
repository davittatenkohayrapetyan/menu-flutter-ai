import 'package:freezed_annotation/freezed_annotation.dart';
import 'nutrition.dart';

part 'menu_item.freezed.dart';
part 'menu_item.g.dart';

@freezed
class MenuItem with _$MenuItem {
  const factory MenuItem({
    required String id,
    required String name,
    @Default('') String description,
    @Default(0) double price,
    Nutrition? nutrition,
    @Default('') String imagePath,
    @Default(false) bool isEnriched,
    DateTime? createdAt,
  }) = _MenuItem;

  factory MenuItem.fromJson(Map<String, dynamic> json) =>
      _$MenuItemFromJson(json);
}
