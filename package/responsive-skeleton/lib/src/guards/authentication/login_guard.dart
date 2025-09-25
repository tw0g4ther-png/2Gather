import 'package:core_kosmos/core_package.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:auto_route/auto_route.dart';
import 'package:get_it/get_it.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart';

/// Check if User is already logged in. If not, redirect to Login Page.
///
/// {@category Guard}
/// {@subCategory authentication}
class LoginGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final currentUser = FirebaseAuth.instance.currentUser;
    
    if (currentUser != null) {
      printInDebug("[LoginGuard] User connected: ${currentUser.uid}");
      
      if (GetIt.instance<ApplicationDataModel>()
          .applicationConfig
          .emailMustBeVerified) {
        printInDebug("[LoginGuard] Email verification required");
        
        // Vérifier le type de provider - pas de vérification email pour Google/Apple
        final isEmailPasswordAuth = currentUser.providerData.any((provider) => 
          provider.providerId == 'password');
        
        if (!isEmailPasswordAuth) {
          // Connexion Google/Apple - pas besoin de vérification email
          printInDebug("[LoginGuard] Social login detected - skipping email verification");
          resolver.next(true);
          return;
        }
        
        if (currentUser.emailVerified) {
          printInDebug("[LoginGuard] Email verified - access granted");
          resolver.next(true); // Email vérifié = accès autorisé
        } else {
          printInDebug("[LoginGuard] Email not verified - disconnecting user and redirecting to login");
          // Déconnecter l'utilisateur pour éviter la boucle infinie
          FirebaseAuth.instance.signOut().then((_) {
            // Vider complètement la pile de navigation
            router.popUntilRoot();
            router.pushNamed("/login");
          });
        }
        return;
      }
      resolver.next(true);
    } else {
      printInDebug("[LoginGuard] No User connected - redirecting to login");
      router.replaceNamed("/login");
    }
  }
}
