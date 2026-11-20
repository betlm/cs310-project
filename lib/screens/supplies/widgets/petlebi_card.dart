import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/pet.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../utils/petlebi_links.dart';

/// "Shop on Petlebi" card on the Supply list.
class PetlebiCard extends StatefulWidget {
  final Pet pet;

  const PetlebiCard({super.key, required this.pet});

  @override
  State<PetlebiCard> createState() => _PetlebiCardState();
}

class _PetlebiCardState extends State<PetlebiCard> {
  bool _expanded = false;

  /// Opens a Petlebi page in the browser
  Future<void> _open(String url) async {
    var opened = false;
    try {
      opened = await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      opened = false;
    }

    if (!opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open Petlebi.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final links = petlebiLinksFor(widget.pet.species);
    final isFish = widget.pet.species == PetSpecies.fish;

    final children = <Widget>[
      // Header
      GestureDetector(
        onTap: () {
          setState(() {
            _expanded = !_expanded;
          });
        },
        child: Container(
          color: Colors.transparent, 
          child: Row(
            children: [
              Image.asset(
                'assets/images/petlebi_logo.png',
                width: 40,
                height: 40,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'SHOPPING',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                        color: AppColors.secondaryText,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Shop on Petlebi for ${widget.pet.name}',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.darkGreen,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Food, health, toy and care products in one place.',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  _expanded ? Icons.expand_less : Icons.expand_more,
                  color: AppColors.darkGreen,
                ),
              ),
            ],
          ),
        ),
      ),
    ];

    // Categories, button and note only when the card is open
    if (_expanded) {
      children.add(const SizedBox(height: 14));
      children.add(
        Row(
          children: [
            Expanded(
              child: _CategoryTile(
                icon: Icons.restaurant_outlined,
                iconBackground: AppColors.speciesDog,
                title: 'Food',
                subtitle: 'Dry and wet food',
                onTap: () => _open(links.food),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _CategoryTile(
                icon: Icons.favorite_border,
                iconBackground: AppColors.dangerLight,
                title: 'Health',
                subtitle: 'Vitamins and care',
                onTap: () => _open(links.health),
              ),
            ),
          ],
        ),
      );
      children.add(const SizedBox(height: 10));
      children.add(
        Row(
          children: [
            Expanded(
              child: _CategoryTile(
                icon: isFish ? Icons.water_outlined : Icons.toys_outlined,
                iconBackground: AppColors.lightMint,
                title: isFish ? 'Decor' : 'Toys',
                subtitle: isFish ? 'Aquarium design' : 'Play and fun',
                onTap: () => _open(links.toys),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _CategoryTile(
                icon: Icons.cleaning_services_outlined,
                iconBackground: AppColors.speciesHamster,
                title: 'Care',
                subtitle: 'Cleaning and hygiene',
                onTap: () => _open(links.care),
              ),
            ),
          ],
        ),
      );
      children.add(const SizedBox(height: 14));
      children.add(
        ElevatedButton.icon(
          onPressed: () => _open(links.home),
          icon: const Icon(Icons.open_in_new, size: 18),
          label: const Text('Go to Petlebi'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.darkGreen,
            foregroundColor: AppColors.white,
            elevation: 0,
            minimumSize: const Size(double.infinity, 46),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontFamily: 'DM Sans',
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      );
      children.add(const SizedBox(height: AppSpacing.sm));
      children.add(
        const Text(
          'Opens petlebi.com in your browser. Prices and stock are shown on Petlebi.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: AppColors.secondaryText,
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}

/// One category box
class _CategoryTile extends StatelessWidget {
  final IconData icon;
  final Color iconBackground;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _CategoryTile({
    required this.icon,
    required this.iconBackground,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: iconBackground,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 18, color: AppColors.darkGreen),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: AppColors.darkGreen,
                    ),
                  ),
                  Text(
                    subtitle,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10,
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
    );
  }
}