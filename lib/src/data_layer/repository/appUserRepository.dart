import 'package:firebase_auth/firebase_auth.dart';

import '../models/appUserViewModel.dart';
import '../services/appUserService.dart';
import '../services/authService.dart';
import '../models/appUser.dart';

class AppUserRepository {
  AppUserService _appUserService = AppUserService();
  AuthService _authService = AuthService();

  // Get Stream of AppUser
  Stream<AppUser> appUserInfo(String uid) => _appUserService.appUserInfo(uid);

  // Listen for auth changes
  Stream<AppUser> get appUserAuthState => _authService.appUserAuthState;

  // Login Method
  Future<AppUser> signIn(String email, String password) =>
      _authService.signInWithEmailAndPassword(email, password);

  // Logout Method
  Future<void> signOut() => _authService.signOut();

  // Register Method
  Future<AppUser> registerNewAppUser(
    String email,
    String password,
    String firstName,
    String lastName, {
    String userType,
    String imageURL,
    DateTime dateOfBirth,
    int gender,
    String state,
    String city,
    String village,
    int mobileNumber,
    int salary,
    String education,
  }) =>
      _authService.registerNewAppUser(
        email,
        password,
        firstName,
        lastName,
        userType: userType,
        imageURL: imageURL,
        gender: gender,
        dateOfBirth: dateOfBirth,
        mobileNumber: mobileNumber,
        state: state,
        city: city,
        village: village,
        salary: salary,
        education: education,
      );

  // Add New User From Admin side
  Future<UserCredential> addNewAppUserByAdmin(
    String email,
    String password,
    String firstName,
    String lastName, {
    String userType,
    String imageURL,
    DateTime dateOfBirth,
    int gender,
    String state,
    String city,
    String village,
    int mobileNumber,
    int salary,
    String education,
  }) =>
      _authService.addNewAppUserByAdmin(
        email,
        password,
        firstName,
        lastName,
        userType: userType,
        imageURL: imageURL,
        gender: gender,
        dateOfBirth: dateOfBirth,
        mobileNumber: mobileNumber,
        state: state,
        city: city,
        village: village,
        salary: salary,
        education: education,
      );

  // Add or Update User Method
  Future<void> updateAppUserData(AppUser appUser) =>
      _appUserService.updateAppUserData(appUser);

  // Deactivate app user account by admin
  Future<bool> manageAppUserAccount(String uid, bool accStatus) =>
      _appUserService.manageAppUserAccount(uid, accStatus);

  // Delete Account by user
  Future<bool> deleteMyAccount(String uid) async =>
      await _authService.deleteMyAccount();

  // View farmer list method
  Future<List<AppUserViewModel>> get farmerList async =>
      await _appUserService.farmerList;

  // View agriExpert list method
  Future<List<AppUserViewModel>> get agriExpertList =>
      _appUserService.agriExpertList;

  // View active agriExpert list method
  Future<List<AppUserViewModel>> get activeAgriExpertList =>
      _appUserService.activeAgriExpertList;

  // View User Info Method
  Future<AppUser> getAppUserData(String uid) =>
      _appUserService.getAppUserData(uid);
}
