import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/menu_item.dart';
import '../providers/providers.dart';

class ItemScreen extends ConsumerStatefulWidget {
  final String itemId;
  final MenuItem? item;

  const ItemScreen({
    super.key,
    required this.itemId,
    this.item,
  });

  @override
  ConsumerState<ItemScreen> createState() => _ItemScreenState();
}

class _ItemScreenState extends ConsumerState<ItemScreen> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  bool _isLoading = false;
  MenuItem? _currentItem;

  @override
  void initState() {
    super.initState();
    _currentItem = widget.item;
    _nameController = TextEditingController(text: _currentItem?.name ?? '');
    _descriptionController = TextEditingController(text: _currentItem?.description ?? '');
    _priceController = TextEditingController(
      text: _currentItem?.price.toString() ?? '0',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _enrichItem() async {
    if (_currentItem == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final apiService = ref.read(apiServiceProvider);
      final enrichedItem = await apiService.enrichDish(_currentItem!);
      
      setState(() {
        _currentItem = enrichedItem;
        _nameController.text = enrichedItem.name;
        _descriptionController.text = enrichedItem.description;
        _priceController.text = enrichedItem.price.toString();
      });

      await ref.read(menuItemsProvider.notifier).updateItem(enrichedItem);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item enriched successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error enriching item: $e')),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveChanges() async {
    if (_currentItem == null) return;

    final updatedItem = _currentItem!.copyWith(
      name: _nameController.text,
      description: _descriptionController.text,
      price: double.tryParse(_priceController.text) ?? 0,
    );

    await ref.read(menuItemsProvider.notifier).updateItem(updatedItem);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Changes saved')),
      );
      context.go('/review');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/review'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveChanges,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _descriptionController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Price',
                      border: OutlineInputBorder(),
                      prefixText: '\$ ',
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (_currentItem?.nutrition != null) ...[
                    const Text(
                      'Nutrition Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            _nutritionRow('Calories', '${_currentItem!.nutrition!.calories}'),
                            _nutritionRow('Protein', '${_currentItem!.nutrition!.protein}g'),
                            _nutritionRow('Carbs', '${_currentItem!.nutrition!.carbs}g'),
                            _nutritionRow('Fat', '${_currentItem!.nutrition!.fat}g'),
                            _nutritionRow('Fiber', '${_currentItem!.nutrition!.fiber}g'),
                            _nutritionRow('Sugar', '${_currentItem!.nutrition!.sugar}g'),
                            _nutritionRow('Sodium', '${_currentItem!.nutrition!.sodium}mg'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _currentItem?.isEnriched == true ? null : _enrichItem,
                      icon: const Icon(Icons.auto_awesome),
                      label: Text(
                        _currentItem?.isEnriched == true
                            ? 'Already Enriched'
                            : 'Enrich with AI',
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _nutritionRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
