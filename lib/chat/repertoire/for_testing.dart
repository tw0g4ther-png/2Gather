import '../freezed/user/userModel.dart';
import 'indexRepertoire.dart';
import '../riverpods/me_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChooseUser extends ConsumerStatefulWidget {
  const ChooseUser({super.key});

  @override
  ChooseUserState createState() => ChooseUserState();
}

class ChooseUserState extends ConsumerState<ChooseUser> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection("users").snapshots(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  if (snapshot.data!.docs.isNotEmpty) {
                    List<UserModel> users = snapshot.data!.docs
                        .map((e) =>
                            UserModel.fromJson(e.data()).copyWith(id: e.id))
                        .toList();
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: users
                          .map((e) => InkWell(
                              onTap: () {
                                ref.read(meModelChangeNotifier).setMyUid(e.id!);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) => IndexRepertoire(
                                              meId: e.id!,
                                            ))));
                              },
                              child: Container(
                                  height: 200,
                                  width: double.infinity,
                                  margin: const EdgeInsets.only(top: 30),
                                  color: Colors.green,
                                  child: Center(
                                      child: Text(
                                    e.pseudo ?? "",
                                    style: const TextStyle(
                                        fontSize: 30, color: Colors.white),
                                  )))))
                          .toList(),
                    );
                  }
                }
                return const Center(
                    child: SizedBox(child: Text("Empty", style: TextStyle())));
              }),
          // IconButton(
          //     color: Colors.green,
          //     onPressed: () {
          //       FirebaseFirestore.instance.collection("users").add(UserModel(
          //               pseudo: "Zinoutssou",
          //               firstname: "Sinsi",
          //               lastname: "Zin",
          //               profilImage: "https://i.pinimg.com/736x/2d/ba/25/2dba2521f1d3d9167f3e7529266df402.jpg",
          //               createdAt: DateTime.now(),
          //               lastSeen: DateTime.now())
          //           .toJson());
          //     },
          //     icon: Row(
          //       children: [
          //         Text('AddU'),
          //       ],
          //     )),
          // IconButton(
          //     color: Colors.green,
          //     onPressed: () {
          //       FirebaseFirestore.instance.collection("Salons").add(SalonModel(
          //             nom: "Football",
          //             type: SalonType.all,
          //             users: ["QDLs2ekXoglT60lt6A5e", "RAArpSNg6T48evpWHfvf"],
          //           ).toJson());
          //     },
          //     icon: Row(
          //       children: [
          //         Text('Rm+'),
          //       ],
          //     ))
        ],
      ),
    );
  }
}
