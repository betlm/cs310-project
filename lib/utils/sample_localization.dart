import '../l10n/app_strings.dart';

class SampleLocalization {
  SampleLocalization._();

  static const Map<String, String> _translations = {
    // Pet breeds
    'pet-1:breed': 'sampleBreedTabby',
    'pet-2:breed': 'sampleBreedGoldenRetriever',
    'pet-3:breed': 'sampleBreedBudgerigar',

    // Reminder titles
    'rem-1:title': 'sampleCombinationVaccine',
    'rem-2:title': 'sampleInternalParasiteMedicine',
    'rem-3:title': 'sampleEveningMeal',
    'rem-4:title': 'sampleMorningMedication',
    'rem-5:title': 'sampleVetCheckUp',
    'rem-6:title': 'sampleMorningWalk',
    'rem-7:title': 'sampleRefillSeeds',

    // Health record titles
    'hr-1:title': 'sampleRoutineCheckUp',
    'hr-2:title': 'sampleCombinationVaccine',
    'hr-3:title': 'sampleEyeDrops',
    'hr-4:title': 'sampleExternalParasiteTreatment',
    'hr-5:title': 'sampleAnnualVetVisit',

    // Health record notes
    'hr-1:notes': 'sampleGeneralExaminationNote',
    'hr-2:notes': 'sampleAnnualBoosterNote',
    'hr-3:notes': 'sampleSevenDayMedicationNote',
    'hr-4:notes': 'sampleMonthlyDropsNote',

    // Supply names
    's-1:name': 'sampleDryFood',
    's-2:name': 'sampleCatLitter',
    's-3:name': 'sampleGroomingBrush',
    's-4:name': 'sampleTreats',
    's-5:name': 'sampleDogTreats',

    // Supply notes and units
    's-1:note': 'sampleGrainFree',
    's-2:unit': 'samplePack',
    's-4:unit': 'samplePack',
    's-5:unit': 'samplePack',
  };

  static String text({
    required String id,
    required String field,
    required String value,
  }) {
    final key = _translations['$id:$field'];

    // If this is not a sample field, keep the original value.
    if (key == null) return value;

    // Get the original sample text in both languages.
    final originalEnglish = AppStrings.get(key, languageCode: 'en');

    final originalTurkish = AppStrings.get(key, languageCode: 'tr');

    // If the user changed the text, do not translate it.
    if (value != originalEnglish && value != originalTurkish) {
      return value;
    }

    // Otherwise, display the sample text in the selected language.
    return AppStrings.get(key);
  }
}
