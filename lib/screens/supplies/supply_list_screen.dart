import 'package:flutter/material.dart';

import '../../data/app_state.dart';
import '../../data/sample_data.dart';
import '../../models/supply_item.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/pet_switcher_sheet.dart';
import '../../widgets/square_icon_button.dart';
import 'widgets/active_pet_bar.dart';

/// Shopping list of the active pet: pending items first then the purchased ones
class SupplyListScreen extends StatefulWidget {
  const SupplyListScreen({super.key});

  @override
  State<SupplyListScreen> createState() => _SupplyListScreenState();
}

class _SupplyListScreenState extends State<SupplyListScreen> {
  /// Opens another screen and refreshes the list when we come back
  Future<void> _openScreen(String routeName, {Object? arguments}) async {
    await Navigator.pushNamed(context, routeName, arguments: arguments);
    if (!mounted) return;
    setState(() {});
  }

  /// Opens the pet switcher and refreshes the list for the new pet
  Future<void> _changePet() async {
    await showPetSwitcher(context);
    if (!mounted) return;
    setState(() {});
  }

  /// Marks an item as bought or back to not bought
  void _toggleBought(SupplyItem item) {
    final index = sampleSupplies.indexWhere((s) => s.id == item.id);
    if (index == -1) return;

    setState(() {
      sampleSupplies[index] = item.copyWith(bought: !item.bought);
    });
  }

  /// confirmation then deletes the item
  Future<void> _confirmDelete(SupplyItem item) async {
    final ok = await showConfirmDialog(
      context: context,
      title: 'Delete ${item.name}?',
      message: 'This item will be removed from the shopping list.',
      confirmText: 'Delete',
    );

    if (!ok || !mounted) return;

    setState(() {
      sampleSupplies.removeWhere((s) => s.id == item.id);
    });
  }

  ///asks for confirmation then removes all bought items of the pet
  Future<void> _confirmClearPurchased() async {
    final ok = await showConfirmDialog(
      context: context,
      title: 'Clear purchased items?',
      message: 'All items marked as purchased will be removed from the list.',
      confirmText: 'Clear',
    );

    if (!ok || !mounted) return;

    setState(() {
      clearPurchasedSupplies(activePet.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final pet = activePet;
    final supplies = suppliesFor(pet.id);

    // split the list into pending and purchased items
    final pending = <SupplyItem>[];
    final purchased = <SupplyItem>[];
    for (final item in supplies) {
      if (item.bought) {
        purchased.add(item);
      } else {
        pending.add(item);
      }
    }

    // Everything on the screen
    final children = <Widget>[
      ActivePetBar(pet: pet, onTap: _changePet),
      const SizedBox(height: AppSpacing.lg),
      _SummaryBox(
        pendingCount: pending.length,
        canClear: purchased.isNotEmpty,
        onClear: _confirmClearPurchased,
      ),
      const SizedBox(height: AppSpacing.md),
      _AddSupplyCard(onTap: () => _openScreen(AppRoutes.supplyForm)),
      const SizedBox(height: AppSpacing.md),
    ];

    if (supplies.isEmpty) {
      children.add(
        const EmptyState(
          icon: Icons.shopping_bag_outlined,
          title: 'No supplies yet',
          message: 'Add food, litter or toys to your shopping list.',
        ),
      );
    }

    for (final item in pending) {
      children.add(
        _SupplyCard(
          item: item,
          onToggle: () => _toggleBought(item),
          onEdit: () => _openScreen(AppRoutes.supplyForm, arguments: item),
          onDelete: () => _confirmDelete(item),
        ),
      );
    }

    if (purchased.isNotEmpty) {
      children.add(
        const Padding(
          padding: EdgeInsets.only(top: AppSpacing.md, bottom: 12),
          child: Text(
            'PURCHASED',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
              color: AppColors.secondaryText,
            ),
          ),
        ),
      );

      for (final item in purchased) {
        children.add(
          _SupplyCard(
            item: item,
            onToggle: () => _toggleBought(item),
            onEdit: () => _openScreen(AppRoutes.supplyForm, arguments: item),
            onDelete: () => _confirmDelete(item),
          ),
        );
      }
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.darkGreen,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        shape: const Border(
          bottom: BorderSide(color: AppColors.cardBorder),
        ),
        title: const Text(
          'Supply list',
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.darkGreen,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md + AppSpacing.xs, // 20
          AppSpacing.md,
          AppSpacing.md + AppSpacing.xs,
          AppSpacing.lg,
        ),
        children: children,
      ),
    );
  }
}

///  num of pending items and "Clear purchased"
class _SummaryBox extends StatelessWidget {
  final int pendingCount;
  final bool canClear;
  final VoidCallback onClear;

  const _SummaryBox({
    required this.pendingCount,
    required this.canClear,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.lightMint,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '$pendingCount',
            style: const TextStyle(
              fontFamily: 'Manrope',
              fontSize: 26,
              fontWeight: FontWeight.w800,
              height: 1,
              color: AppColors.darkGreen,
            ),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Pending items',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.secondaryText,
              ),
            ),
          ),
          GestureDetector(
            // Does nothing when there is nothing to clear
            onTap: canClear ? onClear : null,
            child: Text(
              'Clear purchased',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: canClear ? AppColors.darkGreen : AppColors.hint,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Card that opens the Add supply form
class _AddSupplyCard extends StatelessWidget {
  final VoidCallback onTap;

  const _AddSupplyCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.lightMint,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.primary, width: 1.5),
          boxShadow: const [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.add, color: AppColors.darkGreen, size: 26),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add supply item',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.darkGreen,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Add something to the shopping list',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.darkGreen),
          ],
        ),
      ),
    );
  }
}

/// One supply item: check box, name, amount, and edit / delete buttons
class _SupplyCard extends StatelessWidget {
  final SupplyItem item;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _SupplyCard({
    required this.item,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  /// "2 kg · Grain-free", "2 packs", "1 item"
  static String _amountText(SupplyItem item) {
    String unitText;
    final unit = item.unit?.trim() ?? '';

    if (unit.isEmpty) {
      unitText = item.quantity == 1 ? 'item' : 'items';
    } else if (item.quantity == 1 ||
        unit == 'kg' ||
        unit == 'g' ||
        unit == 'l' ||
        unit == 'ml' ||
        unit.endsWith('s')) {
      // Units like "kg" or words
      unitText = unit;
    } else {
      unitText = '${unit}s'; // "pack" -> "packs"
    }

    var text = '${item.quantity} $unitText';

    final note = item.note?.trim() ?? '';
    if (note.isNotEmpty) {
      text = '$text · $note';
    }
    return text;
  }

  @override
  Widget build(BuildContext context) {
    final bought = item.bought;

    final card = Card(
      margin: const EdgeInsets.only(bottom: 10),
      color: AppColors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: AppColors.cardBorder, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          children: [
            // Check box
            GestureDetector(
              onTap: onToggle,
              child: Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: bought ? AppColors.primary : AppColors.white,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: bought ? AppColors.primary : AppColors.secondaryText,
                    width: 1.5,
                  ),
                ),
                child: bought
                    ? const Icon(Icons.check, size: 15, color: AppColors.white)
                    : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.darkGreen,
                      decoration: bought ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _amountText(item),
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            SquareIconButton(
              icon: Icons.edit_outlined,
              color: AppColors.darkGreen,
              onTap: onEdit,
              size: 34,
            ),
            const SizedBox(width: 6),
            SquareIconButton(
              icon: Icons.delete_outline,
              color: AppColors.danger,
              onTap: onDelete,
              size: 34
            ),
          ],
        ),
      ),
    );

    // Purchased items 
    if (bought) {
      return Opacity(opacity: 0.55, child: card);
    }
    return card;
  }
}