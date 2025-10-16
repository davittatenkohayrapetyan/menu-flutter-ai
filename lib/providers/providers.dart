import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';
import '../services/image_service.dart';
import '../models/menu_item.dart';

// Service providers
final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});

final imageServiceProvider = Provider<ImageService>((ref) {
  return ImageService();
});

// Menu items state provider
final menuItemsProvider = StateNotifierProvider<MenuItemsNotifier, List<MenuItem>>((ref) {
  return MenuItemsNotifier(ref.watch(storageServiceProvider));
});

class MenuItemsNotifier extends StateNotifier<List<MenuItem>> {
  final StorageService _storageService;

  MenuItemsNotifier(this._storageService) : super([]) {
    loadItems();
  }

  void loadItems() {
    state = _storageService.getAllMenuItems();
  }

  Future<void> addItem(MenuItem item) async {
    await _storageService.saveMenuItem(item);
    state = [...state, item];
  }

  Future<void> addItems(List<MenuItem> items) async {
    await _storageService.saveMenuItems(items);
    state = [...state, ...items];
  }

  Future<void> updateItem(MenuItem item) async {
    await _storageService.saveMenuItem(item);
    state = [
      for (final i in state)
        if (i.id == item.id) item else i
    ];
  }

  Future<void> deleteItem(String id) async {
    await _storageService.deleteMenuItem(id);
    state = state.where((item) => item.id != id).toList();
  }

  Future<void> clear() async {
    await _storageService.clear();
    state = [];
  }
}
