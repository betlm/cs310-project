import 'package:flutter/material.dart';

import '../../data/app_state.dart';
import '../../data/sample_data.dart';
import '../../models/pet.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/empty_state.dart';
import 'widgets/pet_list_card.dart';

/// Bottom navigation tab: Pets
/// Lists all pets as cards, pet can be opened, edited, added or deleted
class MyPetsScreen extends StatefulWidget {
  const MyPetsScreen({super.key});

  @override
  State<MyPetsScreen> createState() => _MyPetsScreenState();
}

class _MyPetsScreenState extends State<MyPetsScreen> {
  /// Opens another screen and refreshes this list when we come back,
  /// because a pet may have been added or changed there
  Future<void> _openScreen(String routeName, {Object? arguments}) async {
    await Navigator.pushNamed(context, routeName, arguments: arguments);
    if (!mounted) return;
    setState(() {});
  }

  /// Asks for confirmation, then deletes the pet
  /// The last pet cannot be deleted because Home needs at least one.
  Future<void> _confirmDelete(Pet pet) async {
    if (samplePets.length == 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You need at least one pet.')),
      );
      return;
    }

    final ok = await showConfirmDialog(
      context: context,
      title: 'Delete ${pet.name}?',
      message: 'All reminders, health records, weights, supplies and '
          'photos of ${pet.name} will be removed too.',
      confirmText: 'Delete',
    );

    if (!ok || !mounted) return;

    setState(() {
      deletePet(pet);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${pet.name} was deleted.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget body;

    if (samplePets.isEmpty) {
      body = EmptyState(
        icon: Icons.pets,
        title: 'No pets yet',
        message: 'Add your first pet to start tracking their care.',
        buttonText: 'Add pet',
        onButtonPressed: () => _openScreen(AppRoutes.petForm),
      );
    } else {
      body = ListView.builder(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.lg,
          AppSpacing.md,
          AppSpacing.lg,
        ),
        // the text at the top and the "Add" card at the bottom.
        itemCount: samplePets.length + 2,
        itemBuilder: (context, index) {
          // First row - the short explanation
          if (index == 0) {
            return const Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.md),
              child: Text(
                'Select the profile whose details you want to view.',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondaryText,
                ),
              ),
            );
          }

          // Last row-the dashed "Add a new profile" card 
          if (index == samplePets.length + 1) {
            return _AddPetCard(
              onTap: () => _openScreen(AppRoutes.petForm),
            );
          }

          // Rows in between- one card per pet
          final pet = samplePets[index - 1];
          return PetListCard(
            pet: pet,
            isActive: pet.id == activePet.id,
            onTap: () => _openScreen(AppRoutes.petDetails, arguments: pet),
            onEdit: () => _openScreen(AppRoutes.petForm, arguments: pet),
            onDelete: () => _confirmDelete(pet),
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.darkGreen,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        // Thin grey line under the app bar.
        shape: const Border(
          bottom: BorderSide(color: AppColors.cardBorder),
        ),
        title: const Text(
          'My pets',
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.darkGreen,
          ),
        ),
      ),
      body: body,
    );
  }
}

/// Dashed card at the bottom of the list that opens the Create pet form
class _AddPetCard extends StatelessWidget {
  final VoidCallback onTap;

  const _AddPetCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CustomPaint(
        foregroundPainter: _DashedBorderPainter(
          color: AppColors.dashedBorder,
          radius: 16,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 26,
                backgroundColor: AppColors.lightMint,
                child: Icon(Icons.add, color: AppColors.darkGreen, size: 28),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add a new profile',
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.darkGreen,
                      ),
                    ),
                    SizedBox(height: AppSpacing.xs),
                    Text(
                      'Add another companion',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


/// used also home page  it is func for dash lines
/// Draws a dashed, rounded border: short lines with gaps
/// along the edge of the "Add a new profile" card.
class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double radius;

  _DashedBorderPainter({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 1.5;
    const dashLength = 6.0;
    const gapLength = 4.0;

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    // The rounded rectangle along the edge of the card.
    // It is moved in by half the line width so the line is not cut off.
    final rect = Rect.fromLTWH(
      strokeWidth / 2,
      strokeWidth / 2,
      size.width - strokeWidth,
      size.height - strokeWidth,
    );
    final path = Path();
    path.addRRect(RRect.fromRectAndRadius(rect, Radius.circular(radius)));

    // Walk along the outline: draw a dash, skip a gap, draw a dash...
    for (final outline in path.computeMetrics()) {
      double distance = 0;
      while (distance < outline.length) {
        final dash = outline.extractPath(distance, distance + dashLength);
        canvas.drawPath(dash, paint);
        distance = distance + dashLength + gapLength;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.radius != radius;
  }
}

/// mounted -> still on screen? bool
///snack bar -> temporal message