import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conveneapp/core/errors/failures.dart';
import 'package:conveneapp/core/type_defs/type_defs.dart';
import 'package:conveneapp/features/authentication/model/user_info.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userApiProvider = Provider<UserApi>((ref) => UserApi());

final CollectionReference users = FirebaseFirestore.instance.collection('users');
final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

class UserApi {
  Stream<UserInfo> getUser({required String uid}) {
    Stream<DocumentSnapshot> docSnapshot = users.doc(uid).snapshots();
    return docSnapshot.map<UserInfo>(
      (user) => UserInfo(
        uid: user.id,
        email: user["email"] ?? "no email",
        name: user["name"] ?? "no name",
        showTutorial: user['showTutorial'] ?? true,
        profilePic: (user.data() as Map)["profilePic"] ?? "",
      ),
    );
  }

  Future<UserInfo> getFutureUser({required String uid}) async {
    DocumentSnapshot docSnapshot = await users.doc(uid).get();
    return UserInfo(
      uid: docSnapshot.id,
      email: (docSnapshot.data() as dynamic)["email"] ?? "no email",
      name: (docSnapshot.data() as dynamic)["name"] ?? "no name",
      showTutorial: docSnapshot['showTutorial'] == 'true' ? true : false,
      profilePic: (docSnapshot.data() as dynamic)["profilePic"] ?? "",
    );
  }

  Future<void> addUser({required String uid, String? email, String? name}) async {
    DocumentSnapshot documentSnapshot = await users.doc(uid).get();

    if (documentSnapshot.exists) return;
    await users.doc(uid).set({
      'email': email ?? FieldValue.delete(),
      'name': name ?? FieldValue.delete(),
      'showTutorial': true,
    }, SetOptions(merge: true));
  }

  Future<void> removeTutorial({required String uid}) async {
    await users.doc(uid).update({
      'showTutorial': false,
    });
  }

  FutureEitherVoid updateUser({
    required String uid,
    required File? profilePic,
    required String name,
    required String currentProfilePic,
  }) async {
    String profilePicUrl = currentProfilePic;
    try {
      if (profilePic != null) {
        Reference ref = firebaseStorage.ref().child('users').child(uid);
        UploadTask uploadTask = ref.putFile(profilePic);
        TaskSnapshot snap = await uploadTask;
        profilePicUrl = await snap.ref.getDownloadURL();
      }
      await users.doc(uid).update(
        {
          'name': name,
          'profilePic': profilePicUrl,
        },
      );
      return right(null);
    } catch (e) {
      return left(StorageFailure('Some Internal Error Occurred, Please Try Again.'));
    }
  }
}
