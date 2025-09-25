// AuthValidator.dart
// Classe utilitaire pour la validation des champs de formulaire.
// Contient des méthodes statiques pour valider email, mot de passe, etc.
// Règles :
// - Utilise les clés de traduction optimisées
// - Regex email conforme aux standards RFC
// - Validation mot de passe configurable
// - Code propre sans commentaires inutiles

abstract class AuthValidator {
  /// Valide le format d'une adresse email
  ///
  /// Retourne null si l'email est valide, sinon retourne la clé de traduction d'erreur
  static String? validEmail(String? email) {
    if (email == null || email.isEmpty) {
      return "field.form-validator.all-field-must-have-value";
    }

    final parsedEmail = email.trim();

    // Regex RFC 5322 simplifiée pour validation email
    const emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';

    if (!RegExp(emailPattern).hasMatch(parsedEmail)) {
      return "field.form-validator.email.incorrect";
    }

    return null;
  }

  /// Valide la robustesse d'un mot de passe
  ///
  /// Vérifie : 6 caractères min, 1 majuscule, 1 minuscule, 1 chiffre
  /// Retourne null si valide, sinon retourne la clé de traduction d'erreur
  static String? validPassword(String? password) {
    if (password == null || password.isEmpty) {
      return "field.form-validator.all-field-must-have-value";
    }

    if (password.length < 6) {
      return "field.form-validator.password.length";
    }

    // Vérification présence d'au moins une majuscule
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return "field.form-validator.password.maj";
    }

    // Vérification présence d'au moins une minuscule
    if (!RegExp(r'[a-z]').hasMatch(password)) {
      return "field.form-validator.password.min";
    }

    // Vérification présence d'au moins un chiffre
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return "field.form-validator.password.number";
    }

    return null;
  }

  /// Valide que deux mots de passe sont identiques
  ///
  /// Utilisé pour la confirmation de mot de passe
  /// Retourne null si identiques, sinon retourne la clé de traduction d'erreur
  static String? validSamePassword(String? password, String? secondPassword) {
    if (password == null || password.isEmpty) {
      return "field.form-validator.all-field-must-have-value";
    }

    if (secondPassword == null || secondPassword.isEmpty) {
      return "field.form-validator.all-field-must-have-value";
    }

    if (password != secondPassword) {
      return "field.form-validator.password.not-same";
    }

    return null;
  }

  /// Valide qu'un champ n'est pas vide
  ///
  /// Vérifie que la valeur n'est ni null ni vide (après trim)
  /// Retourne null si valide, sinon retourne la clé de traduction d'erreur
  static String? fieldNotEmpty(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "field.form-validator.all-field-must-have-value";
    }

    return null;
  }

  /// Valide un numéro de téléphone français
  ///
  /// Accepte les formats : 06 12 34 56 78, 0612345678, +33612345678
  /// Retourne null si valide, sinon retourne la clé de traduction d'erreur
  static String? validPhoneNumber(String? phone) {
    if (phone == null || phone.isEmpty) {
      return "field.form-validator.all-field-must-have-value";
    }

    final cleanPhone = phone.replaceAll(RegExp(r'[\s\-\.]'), '');

    // Formats acceptés : 06xxxxxxxx, +336xxxxxxxx, 0033xxxxxxxx
    const phonePattern = r'^(\+33|0033|0)[1-9][0-9]{8}$';

    if (!RegExp(phonePattern).hasMatch(cleanPhone)) {
      return "field.form-validator.bad-phone";
    }

    return null;
  }
}
