import 'package:firebase_auth/firebase_auth.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:skeleton_kosmos/src/services/authentication/model/auth_response.dart';

AuthResponse updateEmailErrorHandler(FirebaseAuthException e) {
  switch (e.code) {
    case "user-mismatch":
      return AuthResponse(
          "error", "field.form-validator.firebase.user-mismatch".tr());

    case "user-not-found":
      return AuthResponse(
          "error", "authentication.error.must-create-account-first".tr());

    case "invalid-credential":
      return AuthResponse(
          "error", "field.form-validator.firebase.invalid-crendential".tr());

    case "email-already-in-use":
      return AuthResponse(
          "error", "field.form-validator.firebase.email-already-in-use".tr());

    case "invalid-email":
      return AuthResponse(
          "error", "field.form-validator.firebase.invalid-email".tr());

    case "wrong-password":
      return AuthResponse(
          "error", "field.form-validator.firebase.wrong-password".tr());

    case "too-many-requests":
      return AuthResponse("error",
          "field.form-validator.firebase.too-many-requests".tr());

    case "network-request-failed":
      return AuthResponse("error",
          "field.form-validator.firebase.network-request-failed".tr());

    case "operation-not-allowed":
      return AuthResponse(
          "error", "field.form-validator.firebase.operation-not-allowed".tr());

    case "user-disabled":
      return AuthResponse("error", "field.form-validator.firebase.user-disabled".tr());

    default:
      return AuthResponse(
          "error", "field.form-validator.firebase.default".tr());
  }
}

AuthResponse updatePasswordErrorHandler(FirebaseAuthException e) {
  switch (e.code) {
    case "user-mismatch":
      return AuthResponse(
          "error", "field.form-validator.firebase.user-mismatch".tr());

    case "user-not-found":
      return AuthResponse(
          "error", "authentication.error.must-create-account-first".tr());

    case "invalid-credential":
      return AuthResponse(
          "error", "field.form-validator.firebase.invalid-credential".tr());

    case "invalid-email":
      return AuthResponse(
          "error", "field.form-validator.firebase.invalid-email".tr());

    case "wrong-password":
      return AuthResponse(
          "error", "field.form-validator.firebase.wrong-password".tr());

    case "weak-password":
      return AuthResponse(
          "error", "field.form-validator.firebase.weak-password".tr());

    default:
      return AuthResponse(
          "error", "field.form-validator.firebase.default".tr());
  }
}

AuthResponse sendPasswordResetError(FirebaseAuthException e) {
  switch (e.code) {
    case "invalid-email":
      return AuthResponse(
          "error", "field.form-validator.firebase.invalid-email".tr());
    case "user-not-found":
      return AuthResponse(
          "error", "authentication.error.must-create-account-first".tr());
    default:
      return AuthResponse(
          "error", "field.form-validator.firebase..default".tr());
  }
}

AuthResponse verificationFailed(FirebaseAuthException e) {
  switch (e.code) {
    case "invalid-phone-number":
      return AuthResponse("invalid-phone-number",
          "field.form-validator.firebase.invalid-phone-number".tr());

    default:
      return AuthResponse(
          "_", "field.form-validator.firebase.too-many-attempts".tr());
  }
}

AuthResponse verificationError(FirebaseAuthException e) {
  switch (e.code) {
    case "invalid-credential":
      return AuthResponse("invalid-credential",
          "field.form-validator.firebase.invalid-credential".tr());

    case "operation-not-allowed":
      return AuthResponse("operation-not-allowed",
          "field.form-validator.firebase.operation-not-allowed".tr());

    case "user-disabled":
      return AuthResponse(
          "user-disabled", "field.form-validator.firebase.user-disabled".tr());

    case "invalid-verification-code":
      return AuthResponse("invalid-verification-code",
          "field.form-validator.firebase.invalid-verification-code".tr());

    case "invalid-verification-id":
      return AuthResponse("invalid-verification-id",
          "field.form-validator.firebase.invalid-verification-id".tr());
    case "invalid-email":
      return AuthResponse(
          "error", "field.form-validator.firebase.invalid-email".tr());
    case "session-expired":
      return AuthResponse(
          "error", "field.form-validator.firebase.session-expired".tr());
    default:
      return AuthResponse(
          "error", "field.form-validator.firebase.default".tr());
  }
}
