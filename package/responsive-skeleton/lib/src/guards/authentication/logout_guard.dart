import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:core_kosmos/core_package.dart';

/// Check if User is already logged in. If yes, signOut him and redirect to [loginRoute].
///
/// {@category Guard}
/// {@subCategory authentication}
class LogoutGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    printInDebug("[LogoutGuard] ========== LOGOUT GUARD DÉCLENCHÉ ==========");
    printInDebug("[LogoutGuard] Utilisateur actuel: ${FirebaseAuth.instance.currentUser?.uid ?? 'null'}");
    printInDebug("[LogoutGuard] Route demandée: ${resolver.route.name}");
    
    if (FirebaseAuth.instance.currentUser != null) {
      printInDebug("[LogoutGuard] Utilisateur connecté détecté - déconnexion en cours...");
      FirebaseAuth.instance.signOut().then((value) {
        printInDebug("[LogoutGuard] ✓ Déconnexion Firebase Auth terminée");
        printInDebug("[LogoutGuard] Nettoyage pile de navigation...");
        
        // Vider complètement la pile de navigation
        router.popUntilRoot();
        printInDebug("[LogoutGuard] ✓ Pile de navigation vidée");
        
        printInDebug("[LogoutGuard] Redirection vers /login...");
        router.pushNamed("/login");
        printInDebug("[LogoutGuard] ✓ Redirection effectuée");
      }).catchError((error) {
        printInDebug("[LogoutGuard] ❌ Erreur lors de la déconnexion: $error");
        // Même en cas d'erreur, rediriger vers login
        router.popUntilRoot();
        router.pushNamed("/login");
      });
    } else {
      printInDebug("[LogoutGuard] Aucun utilisateur connecté - redirection directe vers login");
      // Vider complètement la pile de navigation même si pas connecté
      router.popUntilRoot();
      router.pushNamed("/login");
      printInDebug("[LogoutGuard] ✓ Redirection directe effectuée");
    }
    
    printInDebug("[LogoutGuard] ========== FIN LOGOUT GUARD ==========");
  }
}
