import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/error/exceptions.dart';
import '../models/user_profile_model.dart';

abstract class ProfileFirebaseDataSource {
  Future<UserProfileModel> getProfile();

  Future<void> saveProfile(UserProfileModel profile);

  Future<String> uploadProfilePhoto(XFile file);
}

class ProfileFirebaseDataSourceImpl implements ProfileFirebaseDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final FirebaseStorage storage;

  ProfileFirebaseDataSourceImpl({
    required this.firestore,
    required this.auth,
    required this.storage,
  });

  String get _userId {
    final user = auth.currentUser;
    if (user == null) throw ServerException();
    return user.uid;
  }

  DocumentReference<Map<String, dynamic>> get _userDoc =>
      firestore.collection('users').doc(_userId);

  @override
  Future<UserProfileModel> getProfile() async {
    try {
      final user = auth.currentUser;
      if (user == null) throw ServerException();

      final snap = await _userDoc.get();
      final data = snap.data() ?? {};

      return UserProfileModel.fromFirestore(data, user);
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<void> saveProfile(UserProfileModel profile) async {
    try {
      await _userDoc.set(
        {
          ...profile.toFirestore(),
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );

      final user = auth.currentUser;
      if (user != null && profile.fullName.trim().isNotEmpty) {
        await user.updateDisplayName(profile.fullName.trim());
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<String> uploadProfilePhoto(XFile file) async {
    try {
      final bytes = await file.readAsBytes();
      final ext = _extensionFromPath(file.name);
      final contentType = ext == 'png' ? 'image/png' : 'image/jpeg';
      final ref = storage.ref().child('users/$_userId/profile/avatar.$ext');
      await ref.putData(bytes, SettableMetadata(contentType: contentType));
      final url = await ref.getDownloadURL();
      await _userDoc.set(
        {
          'photoUrl': url,
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
      return url;
    } catch (e) {
      throw ServerException();
    }
  }

  String _extensionFromPath(String name) {
    final lower = name.toLowerCase();
    if (lower.endsWith('.png')) return 'png';
    return 'jpg';
  }
}
