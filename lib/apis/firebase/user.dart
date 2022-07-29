import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conveneapp/apis/firebase/firebase_api_providers.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:conveneapp/core/constants/firebase_constants.dart';
import 'package:conveneapp/core/errors/failures.dart';
import 'package:conveneapp/core/type_defs/type_defs.dart';
import 'package:conveneapp/features/authentication/model/user_info.dart';

final userApiProvider = Provider<UserApi>((ref) {
  return UserApi(
    firestore: ref.watch(firebaseFirestoreProvider),
    firebaseStorage: ref.watch(firebaseStorageProvider),
  );
});

class UserApi {
  FirebaseFirestore firestore;
  FirebaseStorage firebaseStorage;
  UserApi({
    required this.firestore,
    required this.firebaseStorage,
  });

  Stream<UserInfo> getUser({required String uid}) {
    Stream<DocumentSnapshot> docSnapshot = _users.doc(uid).snapshots();
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
    DocumentSnapshot docSnapshot = await _users.doc(uid).get();
    return UserInfo(
      uid: docSnapshot.id,
      email: (docSnapshot.data() as dynamic)["email"] ?? "no email",
      name: (docSnapshot.data() as dynamic)["name"] ?? "no name",
      showTutorial: docSnapshot['showTutorial'] == 'true' ? true : false,
      profilePic: (docSnapshot.data() as dynamic)["profilePic"] ?? "",
    );
  }

  Future<void> addUser({required String uid, String? email, String? name}) async {
    DocumentSnapshot documentSnapshot = await _users.doc(uid).get();

    if (documentSnapshot.exists) return;
    await _users.doc(uid).set({
      'email': email ?? FieldValue.delete(),
      'name': name ?? FieldValue.delete(),
      'showTutorial': true,
    }, SetOptions(merge: true));
  }

  Future<void> removeTutorial({required String uid}) async {
    await _users.doc(uid).update({
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
      await _users.doc(uid).update(
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

  FutureEitherVoid deleteUser(String uid) async {
    try {
      List<String> usersClubId = [];
      var currentClubsDocs = await _users.doc(uid).collection(FirebaseConstants.currentClubsCollection).get();
      for (var club in currentClubsDocs.docs) {
        usersClubId.add(club.id);
        await club.reference.delete();
      }

      var finishedBooksDocs = await _users.doc(uid).collection(FirebaseConstants.finishedBooksCollection).get();
      for (var finishedBook in finishedBooksDocs.docs) {
        await finishedBook.reference.delete();
      }

      await _users.doc(uid).delete();

      for (var clubId in usersClubId) {
        await _clubsCollection.doc(clubId).update(
          {
            'members': FieldValue.arrayRemove([uid]),
          },
        );
      }
      var image = await firebaseStorage.ref().child('users').child(uid).getData();
      if (image != null) {
        await firebaseStorage.ref().child('users').child(uid).delete();
      }
      return right(null);
    } on auth.FirebaseAuthException catch (e) {
      return left(AuthFailure(e.message!));
    } catch (e) {
      return left(StorageFailure('Some Internal Error Occurred, Please Try Again.'));
    }
  }

  CollectionReference get _users {
    return firestore.collection(FirebaseConstants.usersCollection);
  }

  CollectionReference get _clubsCollection {
    return firestore.collection(FirebaseConstants.clubsCollection);
  }
}
