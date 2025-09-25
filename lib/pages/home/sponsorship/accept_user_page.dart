import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core_kosmos/core_package.dart';
import 'package:get_it/get_it.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart';
import 'package:twogather/controller/complete_profil_controller.dart';
import 'package:twogather/model/color.dart';
import 'package:twogather/model/sponsorship/sponsorship_model.dart';
import 'package:twogather/widgets/button/core.dart';
import 'package:flutter/material.dart';
import 'package:ui_kosmos_v4/cta/cta.dart';

class AcceptUserPage extends StatefulWidget {
  final SponsorshipModel user;

  const AcceptUserPage({super.key, required this.user});

  @override
  State<AcceptUserPage> createState() => _AcceptUserPageState();
}

class _AcceptUserPageState extends State<AcceptUserPage> {
  List<String>? userImages;
  bool isLoadingImages = true;

  @override
  void initState() {
    super.initState();
    _loadUserImages();
  }

  /// Récupère les images de profil de l'utilisateur directement depuis son document
  Future<void> _loadUserImages() async {
    try {
      if (widget.user.user?.id != null) {
        printInDebug("[AcceptUserPage] Récupération des images pour l'utilisateur: ${widget.user.user!.id}");
        
        final userDoc = await FirebaseFirestore.instance
            .collection(GetIt.instance<ApplicationDataModel>().userCollectionPath)
            .doc(widget.user.user!.id)
            .get();

        if (userDoc.exists) {
          final userData = userDoc.data();
          final images = userData?['profilImages'] as List<dynamic>?;
          
          if (mounted) {
            setState(() {
              userImages = images?.cast<String>();
              isLoadingImages = false;
            });
          }
          
          printInDebug("[AcceptUserPage] Images récupérées: ${userImages?.length ?? 0} images");
        } else {
          printInDebug("[AcceptUserPage] Document utilisateur non trouvé");
          if (mounted) {
            setState(() {
              isLoadingImages = false;
            });
          }
        }
      } else {
        printInDebug("[AcceptUserPage] ID utilisateur manquant");
        if (mounted) {
          setState(() {
            isLoadingImages = false;
          });
        }
      }
    } catch (e) {
      printInDebug("[AcceptUserPage] Erreur lors de la récupération des images: $e");
      if (mounted) {
        setState(() {
          isLoadingImages = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.mainColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: formatWidth(22)),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              sh(12),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Button(
                    width: formatWidth(47),
                    height: formatWidth(47),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: const Color(0xFF02132B).withValues(alpha: .13),
                    ),
                    onTap: () {
                      // Fermer la popup sans supprimer le document
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      Icons.close_rounded,
                      color: Colors.white,
                      size: formatWidth(24),
                    ),
                  ),
                ],
              ),
              sh(26),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: formatWidth(20)),
                child: Text(
                  "Valider le parrainage de ${widget.user.user?.firstname ?? 'Utilisateur'}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: formatWidth(24),
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              sh(8),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: formatWidth(14)),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text:
                            "${widget.user.user?.firstname ?? 'Cet utilisateur'} vient de s'inscrire avec ton code de confiance. D'après la charte 2Gather que tu as accepté, tu seras responsable de son bon comportement, et tu t'y engages en tant que parrain. ",
                        style: AppTextStyle.white(13),
                      ),
                    ],
                    style: AppTextStyle.white(13),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              sh(45),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: formatWidth(135),
                      height: formatWidth(167),
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: isLoadingImages
                          ? Container(
                              color: Colors.grey[300],
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : userImages?.isNotEmpty == true
                              ? CachedNetworkImage(
                                  imageUrl: userImages!.first,
                                  fit: BoxFit.cover,
                                  errorWidget: (context, url, error) => Container(
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.person, size: 50),
                                  ),
                                )
                              : Container(
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage('assets/images/img_user_profil.png'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                    ),
                    sw(50),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Nom",
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: .65),
                              fontSize: sp(14),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            widget.user.user?.lastname ?? 'Non renseigné',
                            style: AppTextStyle.white(18, FontWeight.w600),
                          ),
                          sh(12),
                          Text(
                            "Prénom",
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: .65),
                              fontSize: sp(14),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            widget.user.user?.firstname ?? 'Non renseigné',
                            style: AppTextStyle.white(18, FontWeight.w600),
                          ),
                          sh(12),
                          Text(
                            "Date de naissance",
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: .65),
                              fontSize: sp(14),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            widget.user.user?.birthday != null 
                                ? "${widget.user.user!.birthday!.day.toString().padLeft(2, "0")}.${widget.user.user!.birthday!.month.toString().padLeft(2, "0")}.${widget.user.user!.birthday!.year}"
                                : "Non renseigné",
                            style: AppTextStyle.white(18, FontWeight.w600),
                          ),
                          sh(12),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              sh(18),
              CTA.primary(
                themeName: "primary_white",
                textButton: "Valider le parrainage",
                onTap: () async {
                  if (widget.user.user?.id != null && widget.user.id != null) {
                    await CompleteProfilController.acceptUser(
                      widget.user.user!.id!,
                      widget.user.id!,
                    );
                  }
                  if (!context.mounted) return;
                  Navigator.of(context).pop();
                },
              ),
              sh(11),
              CTA.primary(
                themeName: "primary_border_white",
                textButton: "Rejeter",
                onTap: () async {
                  if (widget.user.user?.id != null && widget.user.id != null) {
                    await CompleteProfilController.refuseUser(
                      widget.user.user!.id!,
                      widget.user.id!,
                    );
                  }
                  if (!context.mounted) return;
                  Navigator.of(context).pop();
                },
              ),
              sh(12),
            ],
          ),
        ),
      ),
    );
  }
}
