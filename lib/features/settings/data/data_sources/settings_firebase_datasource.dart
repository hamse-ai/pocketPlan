import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/settings_model.dart';
import '../../../../core/error/exceptions.dart';

abstract class SettingsFirebaseDataSource {
  /// Fetches settings from Firestore for the current user
  Future<SettingsModel> getSettings();
  
  /// Saves settings to Firestore for the current user
  Future<void> saveSettings(SettingsModel settings);
  
  /// Fetches user profile data (email, userName) from Firebase Auth & Firestore
  Future<Map<String, String>> getUserProfile();
}

class SettingsFirebaseDataSourceImpl implements SettingsFirebaseDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  SettingsFirebaseDataSourceImpl({
    required this.firestore,
    required this.auth,
  });

  String get _userId {
    final user = auth.currentUser;
    if (user == null) throw ServerException();
    return user.uid;
  }

  DocumentReference get _userDoc => firestore.collection('users').doc(_userId);
  DocumentReference get _settingsDoc => _userDoc.collection('settings').doc('preferences');

  @override
  Future<SettingsModel> getSettings() async {
    try {
      final doc = await _settingsDoc.get();

      if (doc.exists && doc.data() != null) {
        return SettingsModel.fromFirestore(doc.data() as Map<String, dynamic>);
      }

      // No settings document yet — return defaults
      return const SettingsModel(
        autoSaveNotifications: true,
        weeklySummary: true,
        showBalance: true,
        shareAnalytics: false,
        notificationsEnabled: true,
        userName: '',
        email: '',
      );
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<void> saveSettings(SettingsModel settings) async {
    try {
      await _settingsDoc.set(
        settings.toFirestore(),
        SetOptions(merge: true),
      );
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<Map<String, String>> getUserProfile() async {
    try {
      final user = auth.currentUser;
      if (user == null) throw ServerException();

      final userDoc = await _userDoc.get();
      final userData = userDoc.data() as Map<String, dynamic>?;

      return {
        'email': user.email ?? '',
        'userName': userData?['userName'] as String? ?? 
                    userData?['displayName'] as String? ?? 
                    user.displayName ?? '',
      };
    } catch (e) {
      throw ServerException();
    }
  }
}