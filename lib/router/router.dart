import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/capture_screen.dart';
import '../screens/review_screen.dart';
import '../screens/item_screen.dart';
import '../models/menu_item.dart';

final router = GoRouter(
  initialLocation: '/capture',
  routes: [
    GoRoute(
      path: '/capture',
      name: 'capture',
      builder: (context, state) => const CaptureScreen(),
    ),
    GoRoute(
      path: '/review',
      name: 'review',
      builder: (context, state) => const ReviewScreen(),
    ),
    GoRoute(
      path: '/item/:id',
      name: 'item',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        final extra = state.extra as MenuItem?;
        return ItemScreen(itemId: id, item: extra);
      },
    ),
  ],
);
