import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/database.dart';

class PartsTab extends ConsumerWidget {
  final Motorcycle motorcycle;
  const PartsTab({super.key, required this.motorcycle});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Text('Parts for ${motorcycle.nickname} coming soon!'),
    );
  }
}
