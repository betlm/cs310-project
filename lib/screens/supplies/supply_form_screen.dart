import 'package:flutter/material.dart';

import '../../data/app_state.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../widgets/form_field_decoration.dart';
import '../../widgets/primary_button.dart';
import '../../data/sample_data.dart';
import '../../models/supply_item.dart';
import '../../l10n/app_strings.dart';
import '../../utils/sample_localization.dart';

/// Add / edit supply form
/// Opened empty to add an item
class SupplyFormScreen extends StatefulWidget {
  const SupplyFormScreen({super.key});

  @override
  State<SupplyFormScreen> createState() => _SupplyFormScreenState();
}

class _SupplyFormScreenState extends State<SupplyFormScreen> {
  final _formKey = GlobalKey<FormState>();

  /// The item being edited or null when a new item is being added
  SupplyItem? _editingItem;

  /// Makes sure the fields are filled only once
  bool _formInitialized = false;

  final _nameController = TextEditingController();
  final _quantityController = TextEditingController(text: '1');
  final _unitController = TextEditingController();
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _unitController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  /// Reads the item sent with the route from the edit button and fills the fields
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_formInitialized) return;
    _formInitialized = true;

    final arguments = ModalRoute.of(context)?.settings.arguments;
    if (arguments is! SupplyItem) return; // no item: adding a new one

    _editingItem = arguments;

    _nameController.text = SampleLocalization.text(
      id: arguments.id,
      field: 'name',
      value: arguments.name,
    );

    _quantityController.text = '${arguments.quantity}';

    _unitController.text = arguments.unit == null
        ? ''
        : SampleLocalization.text(
            id: arguments.id,
            field: 'unit',
            value: arguments.unit!,
          );

    _noteController.text = arguments.note == null
        ? ''
        : SampleLocalization.text(
            id: arguments.id,
            field: 'note',
            value: arguments.note!,
          );
  }

  /// Checks the form then adds the new item or updates the edited one and goes back to the list
  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final enteredName = _nameController.text.trim();
    final enteredUnit = _unitController.text.trim();
    final enteredNote = _noteController.text.trim();

    final existingItem = _editingItem;

    final originalDisplayedName = existingItem == null
        ? null
        : SampleLocalization.text(
            id: existingItem.id,
            field: 'name',
            value: existingItem.name,
          );

    final originalDisplayedUnit =
        existingItem == null || existingItem.unit == null
        ? null
        : SampleLocalization.text(
            id: existingItem.id,
            field: 'unit',
            value: existingItem.unit!,
          );

    final originalDisplayedNote =
        existingItem == null || existingItem.note == null
        ? null
        : SampleLocalization.text(
            id: existingItem.id,
            field: 'note',
            value: existingItem.note!,
          );

    final nameToSave =
        existingItem != null && enteredName == originalDisplayedName
        ? existingItem.name
        : enteredName;

    final unitToSave =
        existingItem != null && enteredUnit == originalDisplayedUnit
        ? existingItem.unit
        : enteredUnit.isEmpty
        ? null
        : enteredUnit;

    final noteToSave =
        existingItem != null && enteredNote == originalDisplayedNote
        ? existingItem.note
        : enteredNote.isEmpty
        ? null
        : enteredNote;

    final item = SupplyItem(
      // Keep the id, pet and bought state when editing
      id: existingItem?.id ?? 's-${DateTime.now().microsecondsSinceEpoch}',
      petId: existingItem?.petId ?? activePet.id,
      name: nameToSave,
      quantity: int.parse(_quantityController.text.trim()),
      unit: unitToSave,
      note: noteToSave,
      bought: existingItem?.bought ?? false,
    );

    if (_editingItem == null) {
      sampleSupplies.add(item);
    } else {
      final index = sampleSupplies.indexWhere((s) => s.id == item.id);
      if (index == -1) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(AppStrings.get('itemNotFound'))));
        return;
      }
      sampleSupplies[index] = item;
    }

    Navigator.pop(context, true);
  }

  /// Adds change (+1 or -1) to the quantity. It stays between 1 and 999
  void _changeQuantity(int change) {
    final current = int.tryParse(_quantityController.text.trim()) ?? 0;

    var newQuantity = current + change;
    if (newQuantity < 1) {
      newQuantity = 1;
    }
    if (newQuantity > 999) {
      newQuantity = 999;
    }

    _quantityController.text = '$newQuantity';
  }

  String? _validateName(String? value) {
    final name = value?.trim() ?? '';
    if (name.isEmpty) {
      return AppStrings.get('enterItemName');
    }
    if (name.length > 40) {
      return AppStrings.get('itemNameTooLong');
    }
    return null;
  }

  String? _validateQuantity(String? value) {
    final quantity = int.tryParse(value?.trim() ?? '');
    if (quantity == null) {
      return AppStrings.get('enterWholeNumberShort');
    }
    if (quantity < 1 || quantity > 999) {
      return AppStrings.get('quantityRange');
    }
    return null;
  }

  /// Field title like "Item Name *"
  Widget _label(String text, {bool required = false}) {
    final children = <Widget>[
      Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: AppColors.darkGreen,
        ),
      ),
    ];

    if (required) {
      children.add(
        const Text(
          ' *',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.danger,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(children: children),
    );
  }

  /// The shared field style
  InputDecoration _inputDecoration(String hint) {
    return fieldDecoration(hint: hint).copyWith(
      hintStyle: TextStyle(fontSize: 14, color: AppColors.hint),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
    );
  }

  /// Small up / down arrows on the right side of the quantity field
  Widget _quantityStepper() {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Center(
        widthFactor: 1,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.cardBorder,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => _changeQuantity(1),
                child: Icon(
                  Icons.keyboard_arrow_up,
                  size: 14,
                  color: AppColors.darkGreen,
                ),
              ),
              GestureDetector(
                onTap: () => _changeQuantity(-1),
                child: Icon(
                  Icons.keyboard_arrow_down,
                  size: 14,
                  color: AppColors.darkGreen,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.appBar,
        foregroundColor: AppColors.darkGreen,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        shape: Border(bottom: BorderSide(color: AppColors.cardBorder)),
        title: Text(
          AppStrings.get('addEditSupply'),
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.darkGreen,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md + AppSpacing.xs, // 20
            AppSpacing.lg,
            AppSpacing.md + AppSpacing.xs,
            AppSpacing.lg,
          ),
          children: [
            // Item name
            _label(AppStrings.get('itemName'), required: true),
            TextFormField(
              controller: _nameController,
              textCapitalization: TextCapitalization.sentences,
              style: TextStyle(fontSize: 14, color: AppColors.darkGreen),
              validator: _validateName,
              decoration: _inputDecoration(AppStrings.get('itemNameHint')),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Quantity and unit side by side
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label(AppStrings.get('quantity'), required: true),
                      TextFormField(
                        controller: _quantityController,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.darkGreen,
                        ),
                        validator: _validateQuantity,
                        decoration: _inputDecoration('1')
                            .copyWith(suffixIcon: _quantityStepper()),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label(AppStrings.get('unit')),
                      TextFormField(
                        controller: _unitController,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.darkGreen,
                        ),
                        decoration: _inputDecoration('kg'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Note
            _label(AppStrings.get('noteOptional')),
            TextFormField(
              controller: _noteController,
              maxLines: 2,
              textCapitalization: TextCapitalization.sentences,
              style: TextStyle(fontSize: 15, color: AppColors.darkGreen),
              decoration: _inputDecoration(AppStrings.get('noteHint')),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Info box: which pet the item belongs to
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.lightMint,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    color: AppColors.darkGreen,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      appLanguage == 'tr'
                          ? (_editingItem == null
                                ? '${activePet.name} adlı dostunun ihtiyaç listesine eklenecek.'
                                : 'Değişiklikler ${activePet.name} adlı dostunun ihtiyaç listesine kaydedilecek.')
                          : (_editingItem == null
                                ? "The item will be added to ${activePet.name}'s supply list."
                                : "Changes will be saved to ${activePet.name}'s supply list."),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkGreen,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // White strip at the bottom with the buton
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border(top: BorderSide(color: AppColors.cardBorder)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md + AppSpacing.xs,
              AppSpacing.md,
              AppSpacing.md + AppSpacing.xs,
              AppSpacing.md,
            ),
            child: PrimaryButton(
              text: _editingItem == null
                  ? AppStrings.get('addToList')
                  : AppStrings.get('saveChanges'),
              onPressed: _save,
            ),
          ),
        ),
      ),
    );
  }
}
