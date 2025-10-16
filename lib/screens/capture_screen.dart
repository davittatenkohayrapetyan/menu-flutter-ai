import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';
import '../providers/providers.dart';
import '../models/menu_item.dart';

class CaptureScreen extends ConsumerStatefulWidget {
  const CaptureScreen({super.key});

  @override
  ConsumerState<CaptureScreen> createState() => _CaptureScreenState();
}

class _CaptureScreenState extends ConsumerState<CaptureScreen> {
  String? _imagePath;
  bool _isLoading = false;

  Future<void> _captureFromCamera() async {
    final imageService = ref.read(imageServiceProvider);
    final path = await imageService.pickFromCamera();
    if (path != null) {
      setState(() {
        _imagePath = path;
      });
    }
  }

  Future<void> _pickFromGallery() async {
    final imageService = ref.read(imageServiceProvider);
    final path = await imageService.pickFromGallery();
    if (path != null) {
      setState(() {
        _imagePath = path;
      });
    }
  }

  Future<void> _parseMenu() async {
    if (_imagePath == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final apiService = ref.read(apiServiceProvider);
      final items = await apiService.parseMenu(_imagePath!);
      
      final menuItemsNotifier = ref.read(menuItemsProvider.notifier);
      await menuItemsNotifier.addItems(items);

      if (mounted) {
        context.go('/review');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error parsing menu: $e')),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Capture Menu'),
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_imagePath != null) ...[
                    Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Image.file(
                        File(_imagePath!),
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _parseMenu,
                      child: const Text('Parse Menu'),
                    ),
                    const SizedBox(height: 10),
                  ],
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _captureFromCamera,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Take Photo'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: _pickFromGallery,
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Pick from Gallery'),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () => context.go('/review'),
                    child: const Text('View Saved Items'),
                  ),
                ],
              ),
      ),
    );
  }
}
