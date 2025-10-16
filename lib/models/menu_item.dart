import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'nutrition.dart';

part 'menu_item.freezed.dart';
part 'menu_item.g.dart';

@HiveType(typeId: 0)
@freezed
class MenuItem with _$MenuItem {
  const factory MenuItem({
    @HiveField(0) required String id,
    @HiveField(1) required String name,
    @HiveField(2) @Default('') String description,
    @HiveField(3) @Default(0) double price,
    @HiveField(4) Nutrition? nutrition,
    @HiveField(5) @Default('') String imagePath,
    @HiveField(6) @Default(false) bool isEnriched,
    @HiveField(7) DateTime? createdAt,
  }) = _MenuItem;

  factory MenuItem.fromJson(Map<String, dynamic> json) =>
      _$MenuItemFromJson(json);
}
