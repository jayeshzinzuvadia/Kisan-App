import 'package:firebase_auth/firebase_auth.dart';
import 'package:kisan_app/src/data_layer/models/appUser.dart';
import 'package:kisan_app/src/data_layer/models/appUserViewModel.dart';
import 'package:kisan_app/src/data_layer/repository/appUserRepository.dart';

// Used mostly by admin user
// Also used by farmer and agriExpert for profile and sign out
class AppUserController {
  AppUserRepository _repository = AppUserRepository();

  // get stream of appuser
  Stream<AppUser> appUserInfo(String uid) {
    return _repository.appUserInfo(uid);
  }

  // Listen for auth changes
  Stream<AppUser> get appUserAuthState {
    return _repository.appUserAuthState;
  }

  // Provides farmer list
  Future<List<AppUserViewModel>> getFarmerList() async {
    return await _repository.farmerList;
  }

  // Provides agri expert list
  Future<List<AppUserViewModel>> getAgriExpertList() async {
    return await _repository.agriExpertList;
  }

  // Provides active agri expert list
  Future<List<AppUserViewModel>> getActiveAgriExpertList() async {
    return await _repository.activeAgriExpertList;
  }

  // For registering new user
  Future<AppUser> addNewAppUserInfo(
    String email,
    String password,
    String firstName,
    String lastName, {
    String userType,
    String imageURL,
    DateTime dateOfBirth,
    int gender,
    int mobileNumber,
    String state,
    String city,
    String village,
    int salary,
    String education,
  }) {
    return _repository.registerNewAppUser(
      email,
      password,
      firstName,
      lastName,
      userType: userType,
      imageURL: imageURL,
      dateOfBirth: dateOfBirth,
      gender: gender,
      mobileNumber: mobileNumber,
      state: state,
      city: city,
      village: village,
      salary: salary,
      education: education,
    );
  }

  // For registering new user
  Future<UserCredential> addNewUserByAdmin(
    String email,
    String password,
    String firstName,
    String lastName, {
    String userType,
    String imageURL,
    DateTime dateOfBirth,
    int gender,
    int mobileNumber,
    String state,
    String city,
    String village,
    int salary,
    String education,
  }) {
    return _repository.addNewAppUserByAdmin(
      email,
      password,
      firstName,
      lastName,
      userType: userType,
      imageURL: imageURL,
      dateOfBirth: dateOfBirth,
      gender: gender,
      mobileNumber: mobileNumber,
      state: state,
      city: city,
      village: village,
      salary: salary,
      education: education,
    );
  }

  // For updating existing user information
  Future<bool> updateAppUserInfo(AppUser appUser) async {
    if (appUser != null) {
      await _repository.updateAppUserData(appUser);
      return true;
    }
    return false;
  }

  // My Profile
  Future<AppUser> getAppUserInfo(String uid) async {
    return await _repository.getAppUserData(uid);
  }

  // Delete my account
  Future<bool> deleteMyAccount(String uid) async {
    return await _repository.deleteMyAccount(uid);
  }

  // For account deactivation or reactivation by admin
  Future<bool> manageAppUserAccount(String uid, bool accStatus) async {
    return await _repository.manageAppUserAccount(uid, accStatus);
  }

  // User Signout
  Future<void> handleUserSignOut() async {
    return await _repository.signOut();
  }
}
