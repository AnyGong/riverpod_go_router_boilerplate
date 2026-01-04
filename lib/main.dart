import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_go_router_boilerplate/app/bootstrap.dart';

void main() {
  runApp(const ProviderScope(child: AppBootstrap()));
}
