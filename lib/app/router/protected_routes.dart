import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final protectedRoutes = [
  GoRoute(
    path: '/',
    builder: (_, _) => const Scaffold(body: Center(child: Text('Home'))),
  ),
];
