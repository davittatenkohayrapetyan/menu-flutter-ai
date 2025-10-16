import 'package:hive_flutter/hive_flutter.dart';
import 'dart:convert';
import '../models/menu_item.dart';

class StorageService {
  static const String _menuItemsBox = 'menu_items';
  Box<String>? _box;

  Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox<String>(_menuItemsBox);
  }

  Future<void> saveMenuItem(MenuItem item) async {
    final json = jsonEncode(item.toJson());
    await _box?.put(item.id, json);
  }

  Future<void> saveMenuItems(List<MenuItem> items) async {
    for (final item in items) {
      await saveMenuItem(item);
    }
  }

  Future<MenuItem?> getMenuItem(String id) async {
    final jsonStr = _box?.get(id);
    if (jsonStr == null) return null;
    return MenuItem.fromJson(jsonDecode(jsonStr) as Map<String, dynamic>);
  }

  List<MenuItem> getAllMenuItems() {
    final items = <MenuItem>[];
    for (final jsonStr in _box?.values ?? []) {
      try {
        final item = MenuItem.fromJson(jsonDecode(jsonStr) as Map<String, dynamic>);
        items.add(item);
      } catch (e) {
        // Skip invalid items
      }
    }
    return items;
  }

  Future<void> deleteMenuItem(String id) async {
    await _box?.delete(id);
  }

  Future<void> clear() async {
    await _box?.clear();
  }
}

