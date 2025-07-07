import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/profile_model.dart';

class ProfileViewModel extends ChangeNotifier {
  final ValueNotifier<UserProfileData?> userProfile = ValueNotifier(null);
  final ValueNotifier<List<ExamHistory>> examHistory = ValueNotifier([]);
  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  ProfileViewModel() {
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    isLoading.value = true;
    try {
      final userDoc = FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid);
      final historialRef = FirebaseFirestore.instance
          .collection('historial')
          .where('userId', isEqualTo: currentUser.uid);

      // Fetch user profile
      final userSnapshot = await userDoc.get();
      if (userSnapshot.exists) {
        userProfile.value = UserProfileData.fromMap(
            userSnapshot.data() as Map<String, dynamic>);
      }

      // Fetch exam history
      final historialSnapshot = await historialRef.get();
      if (historialSnapshot.docs.isNotEmpty) {
        examHistory.value = historialSnapshot.docs
            .map((doc) => ExamHistory.fromMap(doc.data() as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      print('Error loading profile: $e');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void dispose() {
    userProfile.dispose();
    examHistory.dispose();
    isLoading.dispose();
    super.dispose();
  }
}