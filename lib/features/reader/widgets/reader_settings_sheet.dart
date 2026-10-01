import 'package:flutter/material.dart';
import '../models/reader_settings.dart';

class ReaderSettingsSheet extends StatelessWidget {
  final ReaderSettings settings;
  final ValueChanged<ReaderSettings> onSettingsChanged;

  const ReaderSettingsSheet({
    super.key,
    required this.settings,
    required this.onSettingsChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              Text(
                'Reading Mode',
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              SegmentedButton<ReadingMode>(
                segments: const [
                  ButtonSegment(
                    value: ReadingMode.continuousScroll,
                    icon: Icon(Icons.swap_vert),
                    label: Text('Scroll'),
                  ),
                  ButtonSegment(
                    value: ReadingMode.paged,
                    icon: Icon(Icons.menu_book),
                    label: Text('Paged'),
                  ),
                ],
                selected: {settings.readingMode},
                onSelectionChanged: (set) {
                  onSettingsChanged(settings.copyWith(readingMode: set.first));
                },
              ),
              const SizedBox(height: 20),

              Text(
                'Theme Palette',
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 8,
                children: ReaderThemePreset.values.map((preset) {
                  final isSelected = settings.themePreset == preset;
                  return ChoiceChip(
                    avatar: CircleAvatar(
                      backgroundColor: preset.backgroundColor,
                      radius: 8,
                      child: preset == ReaderThemePreset.oled || preset == ReaderThemePreset.dark
                          ? null
                          : Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.grey.shade400, width: 0.5),
                              ),
                            ),
                    ),
                    label: Text(preset.name),
                    selected: isSelected,
                    onSelected: (_) {
                      onSettingsChanged(settings.copyWith(themePreset: preset));
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // Font Size Slider
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Font Size', style: theme.textTheme.bodyMedium),
                  Text('${settings.fontSize.toInt()} sp', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
              Slider(
                value: settings.fontSize,
                min: 12.0,
                max: 32.0,
                divisions: 20,
                onChanged: (val) {
                  onSettingsChanged(settings.copyWith(fontSize: val));
                },
              ),

              // Line Height Slider
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Line Spacing', style: theme.textTheme.bodyMedium),
                  Text(settings.lineHeight.toStringAsFixed(1), style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
              Slider(
                value: settings.lineHeight,
                min: 1.2,
                max: 2.4,
                divisions: 12,
                onChanged: (val) {
                  onSettingsChanged(settings.copyWith(lineHeight: val));
                },
              ),

              // Side Margin Slider
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Side Margins', style: theme.textTheme.bodyMedium),
                  Text('${settings.horizontalMargin.toInt()} px', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
              Slider(
                value: settings.horizontalMargin,
                min: 8.0,
                max: 36.0,
                divisions: 14,
                onChanged: (val) {
                  onSettingsChanged(settings.copyWith(horizontalMargin: val));
                },
              ),

              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Volume Keys Navigation'),
                subtitle: const Text('Turn page or scroll using volume buttons'),
                value: settings.volumeKeyNavigation,
                onChanged: (val) {
                  onSettingsChanged(settings.copyWith(volumeKeyNavigation: val));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
