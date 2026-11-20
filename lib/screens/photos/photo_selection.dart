
import 'package:flutter/material.dart';

import '../../models/pet_photo.dart';
import '../../theme/app_colors.dart';

class PhotoSelection extends StatefulWidget {
  final List<PetPhoto> photos;
  final Widget Function(PetPhoto photo) imageBuilder;
  final void Function(Set<String> selectedIds) onDelete;
  final VoidCallback onCancel;

  const PhotoSelection({
    super.key,
    required this.photos,
    required this.imageBuilder,
    required this.onDelete,
    required this.onCancel,
  });

  @override
  State<PhotoSelection> createState() => _PhotoSelectionState();
}

class _PhotoSelectionState extends State<PhotoSelection> {
  final Set<String> _selectedIds = {};

  Future<void> _confirmDelete() async {
    if (_selectedIds.isEmpty) return;

    final count = _selectedIds.length;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: AppColors.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 84,
                  height: 84,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFF0E8),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.delete_outline,
                    color: AppColors.danger,
                    size: 36,
                  ),
                ),
                const SizedBox(height: 20),
                 Text(
                  'Delete Photos?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: AppColors.darkGreen,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '$count selected ${count == 1 ? 'photo' : 'photos'} '
                  'will be permanently removed from the album.\n'
                  'This action cannot be undone.',
                  textAlign: TextAlign.center,
                  style:  TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.secondaryText,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () =>
                            Navigator.pop(dialogContext, false),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.darkGreen,
                          backgroundColor: AppColors.white,
                          side:  BorderSide(
                            color: AppColors.fieldBorder,
                          ),
                          minimumSize: const Size(0, 56),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () =>
                            Navigator.pop(dialogContext, true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.danger,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          minimumSize: const Size(0, 56),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text('Delete'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    if (!mounted || confirmed != true) return;

    widget.onDelete(Set<String>.from(_selectedIds));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                '${_selectedIds.length} selected',
                style:  TextStyle(
                  fontFamily: 'DM Sans',
                  fontWeight: FontWeight.w700,
                  color: AppColors.darkGreen,
                ),
              ),
            ),
            TextButton(
              onPressed: widget.onCancel,
              child: const Text('Cancel'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final itemWidth = (constraints.maxWidth - 14) / 3;

            return Wrap(
              spacing: 7,
              runSpacing: 7,
              children: widget.photos.map((photo) {
                final selected = _selectedIds.contains(photo.id);

                return SizedBox(
                  width: itemWidth,
                  height: itemWidth,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Material(
                      color: AppColors.lightMint,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            if (selected) {
                              _selectedIds.remove(photo.id);
                            } else {
                              _selectedIds.add(photo.id);
                            }
                          });
                        },
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            widget.imageBuilder(photo),
                            if (selected)
                              Container(
                                color: AppColors.darkGreen.withValues(
                                  alpha: 0.30,
                                ),
                              ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: selected
                                      ? AppColors.darkGreen
                                      : AppColors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.white,
                                    width: 2,
                                  ),
                                ),
                                child: Icon(
                                  selected
                                      ? Icons.check
                                      : Icons.circle_outlined,
                                  size: 19,
                                  color: selected
                                      ? AppColors.white
                                      : AppColors.darkGreen,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed:
                _selectedIds.isEmpty ? null : _confirmDelete,
            icon: const Icon(Icons.delete_outline),
            label: Text(
              'Delete Selected (${_selectedIds.length})',
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
              foregroundColor: Colors.white,
              disabledBackgroundColor: AppColors.fieldBorder,
              disabledForegroundColor: AppColors.secondaryText,
              minimumSize: const Size(0, 56),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
