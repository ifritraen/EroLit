import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          // Display & Appearance
          ListTile(
            title: Text(
              'Appearance',
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.palette_outlined),
            title: const Text('Theme Mode'),
            subtitle: const Text('OLED Pure Black, Dark, or Light'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.format_size),
            title: const Text('Default Typography'),
            subtitle: const Text('Font family, size, line spacing, margins'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          const Divider(),

          // Reader Behavior
          ListTile(
            title: Text(
              'Reader',
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.menu_book_outlined),
            title: const Text('Reading Mode'),
            subtitle: const Text('Paged (Horizontal) / Continuous Vertical Scroll'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          SwitchListTile(
            secondary: const Icon(Icons.volume_up_outlined),
            title: const Text('Volume Keys Navigation'),
            subtitle: const Text('Turn pages using volume up/down buttons'),
            value: true,
            onChanged: (_) {},
          ),
          const Divider(),

          // AI & Translation Layer
          ListTile(
            title: Text(
              'AI & Translation',
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.translate),
            title: const Text('Translation Engine'),
            subtitle: const Text('Hybrid: On-Device (ONNX/GGUF) + Cloud Fallback'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.memory),
            title: const Text('On-Device Models'),
            subtitle: const Text('Download MarianMT / NLLB / Qwen2.5 weights'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          const Divider(),

          // Backup & Storage
          ListTile(
            title: Text(
              'Data & Storage',
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.backup_outlined),
            title: const Text('Backup & Restore'),
            subtitle: const Text('Export library, history, and settings to JSON/DB'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.cleaning_services_outlined),
            title: const Text('Clear Cache'),
            subtitle: const Text('Manage downloaded chapters and translation cache'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          const Divider(),

          // About
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About EroLit'),
            subtitle: const Text('Version 1.0.0 (com.raen.erolit)'),
            onTap: () {},
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
