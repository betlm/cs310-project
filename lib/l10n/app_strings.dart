class AppStrings {
  AppStrings._();

  static const Map<String, Map<String, String>> _strings = {
    'en': {
      'appName': 'PetPocket',
      'welcome': 'Welcome to PetPocket',
      'login': 'Log In',
      'signUp': 'Sign Up',
      'email': 'Email',
      'password': 'Password',
      'home': 'Home',
      'pets': 'My Pets',
      'health': 'Health',
      'reminders': 'Reminders',
      'photos': 'Photos',
      'supplies': 'Supplies',
      'settings': 'Settings',
      'addPet': 'Add Pet',
      'petName': 'Pet Name',
      'petType': 'Pet Type',
      'activePet': 'Active Pet',
      'save': 'Save',
      'cancel': 'Cancel',
      'delete': 'Delete',
      'confirm': 'Confirm',
      'continue': 'Continue',
      'requiredField': 'This field is required',
      'success': 'Saved successfully',
    },
    'tr': {
      'appName': 'PetPocket',
      'welcome': 'PetPocket\'a Hoş Geldiniz',
      'login': 'Giriş Yap',
      'signUp': 'Kayıt Ol',
      'email': 'E-posta',
      'password': 'Şifre',
      'home': 'Ana Sayfa',
      'pets': 'Hayvanlarım',
      'health': 'Sağlık',
      'reminders': 'Hatırlatıcılar',
      'photos': 'Fotoğraflar',
      'supplies': 'Malzemeler',
      'settings': 'Ayarlar',
      'addPet': 'Hayvan Ekle',
      'petName': 'Hayvan Adı',
      'petType': 'Hayvan Türü',
      'activePet': 'Aktif Hayvan',
      'save': 'Kaydet',
      'cancel': 'İptal',
      'delete': 'Sil',
      'confirm': 'Onayla',
      'continue': 'Devam Et',
      'requiredField': 'Bu alan zorunludur',
      'success': 'Başarıyla kaydedildi',
    },
  };

  static String get(
    String key, {
    String languageCode = 'en',
  }) {
    return _strings[languageCode]?[key] ??
        _strings['en']?[key] ??
        key;
  }
}
