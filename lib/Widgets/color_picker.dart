import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:prm_final/ViewModel/color_view_model.dart';

class ColorPicker extends ConsumerWidget {
  const ColorPicker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<String>(
      tooltip: 'Chọn màu thanh ứng dụng',
      icon: const Icon(Icons.palette_outlined),
      itemBuilder: (_) => const [
        PopupMenuItem(value: 'green', child: Text('Xanh lá')),
        PopupMenuItem(value: 'blue', child: Text('Xanh dương')),
        PopupMenuItem(value: 'purple', child: Text('Tím')),
      ],
      onSelected: (color) async {
        try {
          final viewModel = ref.read(colorViewModelProvider.notifier);
          await viewModel.selectColor(color);
        } catch (_) {
          if (context.mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Không lưu được màu')));
          }
        }
      },
    );
  }
}
