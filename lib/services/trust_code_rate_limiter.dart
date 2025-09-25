import 'package:shared_preferences/shared_preferences.dart';

/// Service pour gérer la limitation des tentatives de validation du code de confiance
/// 
/// Règles :
/// - Maximum 5 tentatives échouées par heure
/// - Blocage de 3 heures après 5 échecs
/// - Reset automatique des compteurs après les délais
class TrustCodeRateLimiter {
  static const String _keyFailedAttempts = 'trust_code_failed_attempts';
  static const String _keyBlockedUntil = 'trust_code_blocked_until';
  static const int _maxAttemptsPerHour = 5;
  static const int _blockDurationHours = 3;
  static const int _attemptWindowHours = 1;

  /// Vérifie si l'utilisateur peut tenter une validation
  static Future<bool> canAttemptValidation() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Vérifier si l'utilisateur est actuellement bloqué
    final blockedUntilString = prefs.getString(_keyBlockedUntil);
    if (blockedUntilString != null) {
      final blockedUntil = DateTime.parse(blockedUntilString);
      if (DateTime.now().isBefore(blockedUntil)) {
        return false; // Encore bloqué
      } else {
        // Le blocage a expiré, nettoyer les données
        await _clearBlockage();
      }
    }
    
    // Vérifier le nombre de tentatives dans la dernière heure
    final failedAttempts = await _getRecentFailedAttempts();
    return failedAttempts.length < _maxAttemptsPerHour;
  }

  /// Enregistre une tentative échouée
  static Future<void> recordFailedAttempt() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Récupérer les tentatives existantes
    final failedAttempts = await _getRecentFailedAttempts();
    
    // Ajouter la nouvelle tentative
    failedAttempts.add(DateTime.now());
    
    // Sauvegarder
    final attemptsJson = failedAttempts.map((date) => date.toIso8601String()).toList();
    await prefs.setStringList(_keyFailedAttempts, attemptsJson);
    
    // Vérifier si on doit bloquer l'utilisateur
    if (failedAttempts.length >= _maxAttemptsPerHour) {
      await _blockUser();
    }
  }

  /// Remet à zéro les tentatives après une validation réussie
  static Future<void> resetAttempts() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyFailedAttempts);
    await prefs.remove(_keyBlockedUntil);
  }

  /// Retourne le temps restant de blocage en minutes (0 si pas bloqué)
  static Future<int> getRemainingBlockTimeMinutes() async {
    final prefs = await SharedPreferences.getInstance();
    
    final blockedUntilString = prefs.getString(_keyBlockedUntil);
    if (blockedUntilString == null) return 0;
    
    final blockedUntil = DateTime.parse(blockedUntilString);
    final now = DateTime.now();
    
    if (now.isBefore(blockedUntil)) {
      return blockedUntil.difference(now).inMinutes;
    } else {
      // Le blocage a expiré
      await _clearBlockage();
      return 0;
    }
  }

  /// Retourne le nombre de tentatives échouées dans la dernière heure
  static Future<int> getRecentFailedAttemptsCount() async {
    final attempts = await _getRecentFailedAttempts();
    return attempts.length;
  }

  /// Récupère les tentatives échouées dans la fenêtre de temps valide
  static Future<List<DateTime>> _getRecentFailedAttempts() async {
    final prefs = await SharedPreferences.getInstance();
    final attemptsJson = prefs.getStringList(_keyFailedAttempts) ?? [];
    
    final now = DateTime.now();
    final cutoff = now.subtract(Duration(hours: _attemptWindowHours));
    
    // Filtrer les tentatives dans la fenêtre de temps
    final recentAttempts = attemptsJson
        .map((dateString) => DateTime.parse(dateString))
        .where((date) => date.isAfter(cutoff))
        .toList();
    
    // Sauvegarder la liste nettoyée
    if (recentAttempts.length != attemptsJson.length) {
      final cleanedJson = recentAttempts.map((date) => date.toIso8601String()).toList();
      await prefs.setStringList(_keyFailedAttempts, cleanedJson);
    }
    
    return recentAttempts;
  }

  /// Bloque l'utilisateur pour la durée définie
  static Future<void> _blockUser() async {
    final prefs = await SharedPreferences.getInstance();
    final blockedUntil = DateTime.now().add(Duration(hours: _blockDurationHours));
    await prefs.setString(_keyBlockedUntil, blockedUntil.toIso8601String());
  }

  /// Nettoie les données de blocage expirées
  static Future<void> _clearBlockage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyFailedAttempts);
    await prefs.remove(_keyBlockedUntil);
  }

  /// Méthode utilitaire pour formater le temps restant
  static String formatRemainingTime(int minutes) {
    if (minutes <= 0) return "";
    
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    
    if (hours > 0) {
      return "${hours}h ${remainingMinutes}min";
    } else {
      return "${remainingMinutes}min";
    }
  }
}
