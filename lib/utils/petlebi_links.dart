import '../models/pet.dart';

/// Petlebi pages for one kind of pet: the main page of the section
/// and four category pages shown on the Supply list.
class PetlebiLinks {
  final String home;
  final String food;
  final String health;
  final String toys;
  final String care;

  const PetlebiLinks({
    required this.home,
    required this.food,
    required this.health,
    required this.toys,
    required this.care,
  });
}

/// Returns the Petlebi pages that match the pet's species.
/// Rabbits and hamsters share the rodent section, fish use the aquarium.
PetlebiLinks petlebiLinksFor(PetSpecies species) {
  switch (species) {
    case PetSpecies.cat:
      return const PetlebiLinks(
        home: 'https://www.petlebi.com/kedi-urunleri',
        food: 'https://www.petlebi.com/kedi-mamasi',
        health: 'https://www.petlebi.com/kedi-vitamin-ve-ek-besinleri',
        toys: 'https://www.petlebi.com/kedi-oyuncaklari',
        care: 'https://www.petlebi.com/kedi-bakim-urunleri',
      );
    case PetSpecies.dog:
      return const PetlebiLinks(
        home: 'https://www.petlebi.com/kopek-urunleri',
        food: 'https://www.petlebi.com/kopek-mamasi',
        health: 'https://www.petlebi.com/kopek-vitamin-ve-ek-besini',
        toys: 'https://www.petlebi.com/kopek-oyuncaklari',
        care: 'https://www.petlebi.com/kopek-bakim-urunleri',
      );
    case PetSpecies.bird:
      return const PetlebiLinks(
        home: 'https://www.petlebi.com/kus-urunleri',
        food: 'https://www.petlebi.com/kus-yemleri',
        health: 'https://www.petlebi.com/kus-vitaminleri-saglik-urunleri',
        toys: 'https://www.petlebi.com/kus-oyuncaklari',
        care: 'https://www.petlebi.com/kus-bakim-urunleri',
      );
    case PetSpecies.rabbit:
      return const PetlebiLinks(
        home: 'https://www.petlebi.com/kemirgen-urunleri',
        food: 'https://www.petlebi.com/tavsan-yemi',
        health: 'https://www.petlebi.com/tavsan-kemirme-tasi',
        toys: 'https://www.petlebi.com/tavsan-oyuncaklari',
        care: 'https://www.petlebi.com/tavsan-leke-ve-koku-gidericiler',
      );
    case PetSpecies.hamster:
      return const PetlebiLinks(
        home: 'https://www.petlebi.com/kemirgen-urunleri',
        food: 'https://www.petlebi.com/hamster-yemi',
        health: 'https://www.petlebi.com/hamster-kemirme-tasi',
        toys: 'https://www.petlebi.com/hamster-oyuncaklari',
        care: 'https://www.petlebi.com/hamster-petshop-urunleri',
      );
    case PetSpecies.fish:
      return const PetlebiLinks(
        home: 'https://www.petlebi.com/akvaryum-urunleri',
        food: 'https://www.petlebi.com/balik-yemleri',
        health: 'https://www.petlebi.com/akvaryum-tedavi-urunleri',
        toys: 'https://www.petlebi.com/akvaryum-tasarim-dekor',
        care: 'https://www.petlebi.com/akvaryum-filtreleri',
      );
  }
}