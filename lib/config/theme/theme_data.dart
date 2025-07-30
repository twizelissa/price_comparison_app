import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeMode { light, dark, system }
enum AppLanguage { english, kinyarwanda, french }
enum FontSize { small, medium, large }

class ThemeData {
  static const String _themeKey = 'app_theme_mode';
  static const String _languageKey = 'app_language';
  static const String _fontSizeKey = 'app_font_size';
  static const String _notificationsKey = 'app_notifications_enabled';
  static const String _priceAlertsKey = 'app_price_alerts_enabled';
  static const String _locationKey = 'app_location_enabled';
  
  static SharedPreferences? _prefs;
  
  // Theme Management
  static AppThemeMode _currentTheme = AppThemeMode.system;
  static AppLanguage _currentLanguage = AppLanguage.english;
  static FontSize _currentFontSize = FontSize.medium;
  static bool _notificationsEnabled = true;
  static bool _priceAlertsEnabled = true;
  static bool _locationEnabled = false;
  
  // Callbacks for theme changes
  static final List<VoidCallback> _themeChangeListeners = [];
  static final List<VoidCallback> _settingsChangeListeners = [];
  
  // Initialize SharedPreferences
  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadPreferences();
  }
  
  // Load all preferences from SharedPreferences
  static Future<void> _loadPreferences() async {
    if (_prefs == null) return;
    
    // Load theme
    final themeIndex = _prefs!.getInt(_themeKey) ?? AppThemeMode.system.index;
    _currentTheme = AppThemeMode.values[themeIndex];
    
    // Load language
    final languageIndex = _prefs!.getInt(_languageKey) ?? AppLanguage.english.index;
    _currentLanguage = AppLanguage.values[languageIndex];
    
    // Load font size
    final fontSizeIndex = _prefs!.getInt(_fontSizeKey) ?? FontSize.medium.index;
    _currentFontSize = FontSize.values[fontSizeIndex];
    
    // Load other settings
    _notificationsEnabled = _prefs!.getBool(_notificationsKey) ?? true;
    _priceAlertsEnabled = _prefs!.getBool(_priceAlertsKey) ?? true;
    _locationEnabled = _prefs!.getBool(_locationKey) ?? false;
  }
  
  // Theme getters and setters
  static AppThemeMode get currentTheme => _currentTheme;
  
  static Future<void> setTheme(AppThemeMode theme) async {
    if (_currentTheme == theme) return;
    
    _currentTheme = theme;
    await _prefs?.setInt(_themeKey, theme.index);
    _notifyThemeListeners();
  }
  
  // Language getters and setters
  static AppLanguage get currentLanguage => _currentLanguage;
  
  static Future<void> setLanguage(AppLanguage language) async {
    if (_currentLanguage == language) return;
    
    _currentLanguage = language;
    await _prefs?.setInt(_languageKey, language.index);
    _notifySettingsListeners();
  }
  
  // Font size getters and setters
  static FontSize get currentFontSize => _currentFontSize;
  
  static Future<void> setFontSize(FontSize fontSize) async {
    if (_currentFontSize == fontSize) return;
    
    _currentFontSize = fontSize;
    await _prefs?.setInt(_fontSizeKey, fontSize.index);
    _notifyThemeListeners(); // Font size affects theme
  }
  
  // Notifications getters and setters
  static bool get notificationsEnabled => _notificationsEnabled;
  
  static Future<void> setNotificationsEnabled(bool enabled) async {
    if (_notificationsEnabled == enabled) return;
    
    _notificationsEnabled = enabled;
    await _prefs?.setBool(_notificationsKey, enabled);
    _notifySettingsListeners();
  }
  
  // Price alerts getters and setters
  static bool get priceAlertsEnabled => _priceAlertsEnabled;
  
  static Future<void> setPriceAlertsEnabled(bool enabled) async {
    if (_priceAlertsEnabled == enabled) return;
    
    _priceAlertsEnabled = enabled;
    await _prefs?.setBool(_priceAlertsKey, enabled);
    _notifySettingsListeners();
  }
  
  // Location getters and setters
  static bool get locationEnabled => _locationEnabled;
  
  static Future<void> setLocationEnabled(bool enabled) async {
    if (_locationEnabled == enabled) return;
    
    _locationEnabled = enabled;
    await _prefs?.setBool(_locationKey, enabled);
    _notifySettingsListeners();
  }
  
  // Get font scale factor based on selected font size
  static double get fontScaleFactor {
    switch (_currentFontSize) {
      case FontSize.small:
        return 0.85;
      case FontSize.medium:
        return 1.0;
      case FontSize.large:
        return 1.15;
    }
  }
  
  // Get theme mode for MaterialApp
  static ThemeMode get themeMode {
    switch (_currentTheme) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }
  
  // Get locale for MaterialApp
  static Locale get locale {
    switch (_currentLanguage) {
      case AppLanguage.english:
        return const Locale('en', 'US');
      case AppLanguage.kinyarwanda:
        return const Locale('rw', 'RW');
      case AppLanguage.french:
        return const Locale('fr', 'FR');
    }
  }
  
  // Helper methods for UI
  static String getThemeName(AppThemeMode theme) {
    switch (theme) {
      case AppThemeMode.light:
        return 'Light';
      case AppThemeMode.dark:
        return 'Dark';
      case AppThemeMode.system:
        return 'System';
    }
  }
  
  static String getLanguageName(AppLanguage language) {
    switch (language) {
      case AppLanguage.english:
        return 'English';
      case AppLanguage.kinyarwanda:
        return 'Kinyarwanda';
      case AppLanguage.french:
        return 'Français';
    }
  }
  
  static String getFontSizeName(FontSize fontSize) {
    switch (fontSize) {
      case FontSize.small:
        return 'Small';
      case FontSize.medium:
        return 'Medium';
      case FontSize.large:
        return 'Large';
    }
  }
  
  // Listener management
  static void addThemeChangeListener(VoidCallback listener) {
    _themeChangeListeners.add(listener);
  }
  
  static void removeThemeChangeListener(VoidCallback listener) {
    _themeChangeListeners.remove(listener);
  }
  
  static void addSettingsChangeListener(VoidCallback listener) {
    _settingsChangeListeners.add(listener);
  }
  
  static void removeSettingsChangeListener(VoidCallback listener) {
    _settingsChangeListeners.remove(listener);
  }
  
  static void _notifyThemeListeners() {
    for (final listener in _themeChangeListeners) {
      listener();
    }
  }
  
  static void _notifySettingsListeners() {
    for (final listener in _settingsChangeListeners) {
      listener();
    }
  }
  
  // Reset all preferences to default
  static Future<void> resetToDefaults() async {
    _currentTheme = AppThemeMode.system;
    _currentLanguage = AppLanguage.english;
    _currentFontSize = FontSize.medium;
    _notificationsEnabled = true;
    _priceAlertsEnabled = true;
    _locationEnabled = false;
    
    await _prefs?.setInt(_themeKey, _currentTheme.index);
    await _prefs?.setInt(_languageKey, _currentLanguage.index);
    await _prefs?.setInt(_fontSizeKey, _currentFontSize.index);
    await _prefs?.setBool(_notificationsKey, _notificationsEnabled);
    await _prefs?.setBool(_priceAlertsKey, _priceAlertsEnabled);
    await _prefs?.setBool(_locationKey, _locationEnabled);
    
    _notifyThemeListeners();
    _notifySettingsListeners();
  }
  
  // Get all preferences as a map (useful for debugging or export)
  static Map<String, dynamic> getAllPreferences() {
    return {
      'theme': _currentTheme.name,
      'language': _currentLanguage.name,
      'fontSize': _currentFontSize.name,
      'notifications': _notificationsEnabled,
      'priceAlerts': _priceAlertsEnabled,
      'location': _locationEnabled,
    };
  }
}