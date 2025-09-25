import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core_kosmos/core_kosmos.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:twogather/model/color.dart';
import 'package:twogather/model/sponsorship/sponsorship_model.dart';
import 'package:twogather/model/user/fiestar_model.dart';
import 'package:twogather/pages/home/sponsorship/accept_user_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart';
import 'package:ui_kosmos_v4/cta/cta.dart';

class ShareTrustCode extends StatefulHookConsumerWidget {
  const ShareTrustCode({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ShareTrustCodeState();
}

class _ShareTrustCodeState extends ConsumerState<ShareTrustCode> {
  /// Affiche la liste des demandes de parrainage en attente
  void _showPendingSponsorshipRequests() {
    // Récupère l'ID utilisateur de manière réactive
    final userData =
        ref.watch(userChangeNotifierProvider).userData as FiestarUserModel?;
    String? userId = userData?.id;

    // Log de débogage pour vérifier l'ID utilisateur
    printInDebug("[ShareTrustCode] ID utilisateur depuis provider: $userId");
    printInDebug(
      "[ShareTrustCode] Données utilisateur complètes: ${userData?.toJson()}",
    );

    // Solution de secours : utiliser Firebase Auth si le provider n'est pas disponible
    if (userId == null || userId.isEmpty) {
      try {
        userId = FirebaseAuth.instance.currentUser?.uid;
        printInDebug(
          "[ShareTrustCode] ID utilisateur depuis Firebase Auth: $userId",
        );
      } catch (e) {
        printInDebug("[ShareTrustCode] Erreur Firebase Auth: $e");
      }
    }

    if (userId == null || userId.isEmpty) {
      Navigator.of(context).pop();
      SchedulerBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Erreur: Impossible de récupérer l'ID utilisateur",
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.red,
          ),
        );
      });
      return;
    }

    // Utilise un FutureBuilder pour récupérer les données de manière cohérente
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection("users")
            .doc(userId)
            .collection("sponsorship")
            .where("isAccepted", isEqualTo: false) // Documents non acceptés
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            printInDebug(
              "[ShareTrustCode] Erreur lors de la récupération: ${snapshot.error}",
            );
            Navigator.of(context).pop();
            SchedulerBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Erreur lors du chargement des demandes: ${snapshot.error}",
                    textAlign: TextAlign.center,
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            });
            return const SizedBox.shrink();
          }

          final docs = snapshot.data?.docs ?? [];
          printInDebug(
            "[ShareTrustCode] Nombre de documents trouvés: ${docs.length}",
          );
          printInDebug(
            "[ShareTrustCode] Documents: ${docs.map((doc) => doc.id).toList()}",
          );

          // Différer la fermeture du dialog pour éviter l'erreur de navigation
          SchedulerBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pop();
          });

          if (docs.isEmpty) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Aucune demande de parrainage en attente",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  backgroundColor: Colors.orange,
                ),
              );
            });
            return const SizedBox.shrink();
          }

          // Convertir les documents en modèles
          final requests = <SponsorshipModel>[];
          for (final doc in docs) {
            try {
              final model = SponsorshipModel.fromJson(
                doc.data() as Map<String, dynamic>,
              ).copyWith(id: doc.id);
              requests.add(model);
            } catch (e) {
              printInDebug(
                "[ShareTrustCode] Erreur lors de la création du modèle: $e",
              );
            }
          }

          if (requests.isEmpty) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Aucune demande de parrainage valide trouvée",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  backgroundColor: Colors.orange,
                ),
              );
            });
            return const SizedBox.shrink();
          }

          if (requests.length == 1) {
            // Affiche directement la demande s'il n'y en a qu'une
            SchedulerBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => AcceptUserPage(user: requests.first),
                ),
              );
            });
          } else {
            // Affiche une liste si il y a plusieurs demandes
            SchedulerBinding.instance.addPostFrameCallback((_) {
              _showSponsorshipRequestsList(requests);
            });
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  /// Affiche une liste des demandes de parrainage
  void _showSponsorshipRequestsList(List<SponsorshipModel> requests) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            sh(12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            sh(20),
            Text(
              "Demandes de parrainage (${requests.length})",
              style: AppTextStyle.black(18, FontWeight.w600),
            ),
            sh(16),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: formatWidth(20)),
                itemCount: requests.length,
                itemBuilder: (context, index) {
                  final request = requests[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: formatHeight(12)),
                    padding: EdgeInsets.all(formatWidth(16)),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        radius: formatWidth(25),
                        backgroundImage:
                            request.user?.pictures?.isNotEmpty == true
                            ? NetworkImage(request.user!.pictures!.first)
                            : null,
                        child: request.user?.pictures?.isEmpty != false
                            ? Icon(Icons.person, size: formatWidth(25))
                            : null,
                      ),
                      title: Text(
                        "${request.user?.firstname ?? 'Inconnu'} ${request.user?.lastname ?? ''}",
                        style: AppTextStyle.black(16, FontWeight.w500),
                      ),
                      subtitle: Text(
                        "Code utilisé: ${request.code ?? 'N/A'}",
                        style: AppTextStyle.gray(13),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: formatWidth(16),
                        color: Colors.grey[400],
                      ),
                      onTap: () {
                        Navigator.of(context).pop(); // Ferme la bottom sheet
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => AcceptUserPage(user: request),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              sh(12),
              SizedBox(
                height: formatHeight(35),
                width: double.infinity,
                child: Stack(
                  children: [
                    Center(
                      child: Text(
                        "app.trust-code".tr(),
                        style: AppTextStyle.black(17),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      bottom: 0,
                      child: InkWell(
                        onTap: () => AutoRouter.of(context).back(),
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.black,
                          size: formatWidth(18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              sh(24),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: formatWidth(26)),
                child: Column(
                  children: [
                    Text(
                      "app.sponsor_a_friend".tr(),
                      style: AppTextStyle.black(24),
                      textAlign: TextAlign.center,
                    ),
                    sh(9),
                    Text(
                      "app.sponsor_a_friend_desc".tr(),
                      style: AppTextStyle.gray(13),
                      textAlign: TextAlign.center,
                    ),
                    sh(13),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        "app.sponsor-friend-first".tr(),
                        style: AppTextStyle.black(13, FontWeight.w500),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    sh(4),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        "app.sponsor-friend-second".tr(),
                        style: AppTextStyle.black(13, FontWeight.w500),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    sh(4),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        "app.sponsor-friend-third".tr(),
                        style: AppTextStyle.black(13, FontWeight.w500),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ),
              sh(30),
              SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "app.my-sponsor-code".tr(),
                      style: AppTextStyle.black(15),
                    ),
                    sh(10),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: formatWidth(17),
                        vertical: formatHeight(9),
                      ),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        color: const Color(0xFF02132B).withValues(alpha: .03),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Text(
                              (ref.watch(userChangeNotifierProvider).userData!
                                          as FiestarUserModel)
                                      .personnalTrustCode ??
                                  "utils.wait".tr(),
                              style: AppTextStyle.black(30),
                            ),
                          ),
                          sw(8),
                          InkWell(
                            onTap: () async {
                              await SharePlus.instance.share(
                                ShareParams(
                                  text:
                                      "Rejoins moi sur FiestaFamily avec mon code ${(ref.read(userChangeNotifierProvider).userData! as FiestarUserModel).personnalTrustCode}",
                                ),
                              );
                            },
                            child: Container(
                              width: formatWidth(34),
                              height: formatWidth(34),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  formatWidth(34),
                                ),
                                color: AppColor.mainColor,
                              ),
                              child: Center(
                                child: SvgPicture.asset(
                                  "assets/svg/ic_share_second.svg",
                                  colorFilter: ColorFilter.mode(
                                    Colors.white,
                                    BlendMode.srcIn,
                                  ),
                                  width: formatHeight(17.8),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    sh(20),
                    // Bouton pour gérer les demandes de parrainage avec indicateur
                    Consumer(
                      builder: (context, ref, child) {
                        final userData =
                            ref.watch(userChangeNotifierProvider).userData
                                as FiestarUserModel?;
                        String? userId = userData?.id;

                        // Solution de secours : utiliser Firebase Auth si le provider n'est pas disponible
                        if (userId == null || userId.isEmpty) {
                          try {
                            userId = FirebaseAuth.instance.currentUser?.uid;
                          } catch (e) {
                            printInDebug(
                              "[ShareTrustCode] Erreur Firebase Auth: $e",
                            );
                          }
                        }

                        if (userId == null || userId.isEmpty) {
                          return CTA.primary(
                            themeName: "primary_border",
                            textButton: "Gérer les demandes de parrainage",
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Erreur: Impossible de récupérer l'ID utilisateur",
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            },
                          );
                        }

                        return StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("users")
                              .doc(userId)
                              .collection("sponsorship")
                              .where(
                                "isAccepted",
                                isEqualTo: false,
                              ) // Documents non acceptés
                              .snapshots(),
                          builder: (context, snapshot) {
                            final hasRequests =
                                snapshot.hasData &&
                                snapshot.data!.docs.isNotEmpty;
                            final requestCount = snapshot.hasData
                                ? snapshot.data!.docs.length
                                : 0;

                            return Stack(
                              children: [
                                CTA.primary(
                                  themeName: hasRequests
                                      ? "primary_main"
                                      : "primary_border",
                                  textButton: hasRequests
                                      ? "Gérer les demandes ($requestCount en attente)"
                                      : "Gérer les demandes de parrainage",
                                  onTap: _showPendingSponsorshipRequests,
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
