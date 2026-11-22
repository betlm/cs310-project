import 'package:flutter/material.dart';

import '../models/health_record.dart';
import 'app_colors.dart';

Color healthRecordColor(HealthRecordType type) {
  return switch (type) {
    HealthRecordType.vaccination => AppColors.primary,
    HealthRecordType.vetVisit => AppColors.speciesHamster,
    HealthRecordType.checkUp => AppColors.peach,
    HealthRecordType.medication => AppColors.darkGreen,
    HealthRecordType.parasiteTreatment => AppColors.speciesRabbit,
    HealthRecordType.feedingNote => AppColors.speciesBird,
    HealthRecordType.other => AppColors.speciesBird,
  };
}