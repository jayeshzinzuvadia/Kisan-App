import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../app.dart';
import '../models/appUser.dart';
import '../services/appUserService.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AppUserService _appUserService = AppUserService();

  // Convert appUser object based on User class
  AppUser _appUserFromUser(User user) {
    return user != null ? AppUser(uid: user.uid) : null;
  }

  // Auth change user stream
  Stream<AppUser> get appUserAuthState {
    // onAuthStateChanged is changed to authStateChanges()
    return _auth.authStateChanges().map(_appUserFromUser);
  }

  // Log in with email and password
  Future<AppUser> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User user = result.user;
      // AppUser appUser = await _appUserService.getAppUserData(user.uid);
      return _appUserFromUser(user);
    } catch (e) {
      print("Catch of SignInWithEmailAndPassword -> " + e.toString());
      return null;
    }
  }

  // Register New User
  Future<AppUser> registerNewAppUser(
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
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User user = result.user;
      // Get appUser from User class
      AppUser appUser = AppUser(
        uid: user.uid,
        firstName: firstName,
        lastName: lastName,
        userType: userType ?? UniversalConstant.FARMER,
        gender: gender ?? UniversalConstant.MALE,
        mobileNumber: mobileNumber ?? 0,
        dateOfBirth: dateOfBirth ?? DateTime(1991, 6, 1),
        imageURL: imageURL ?? "",
        state: state ?? "",
        city: city ?? "",
        village: village ?? "",
        salary: salary ?? 0,
        education: education ?? "",
        accountStatus: UniversalConstant.ACTIVATE_ACCOUNT,
      );
      // Create a new document for the AppUser with uid
      await _appUserService.updateAppUserData(appUser);
      return _appUserFromUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Code from stackoverflow
  // https://stackoverflow.com/questions/54412712/flutter-firebase-authentication-create-user-without-automatically-logging-in
  // Secondary approach
  Future<UserCredential> addNewAppUserByAdmin(
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
  }) async {
    FirebaseApp app = await Firebase.initializeApp(
        name: 'Secondary', options: Firebase.app().options);
    UserCredential userCredential;
    try {
      userCredential = await FirebaseAuth.instanceFor(app: app)
          .createUserWithEmailAndPassword(email: email, password: password);
      User user = userCredential.user;
      // Get appUser from User class
      AppUser appUser = AppUser(
        uid: user.uid,
        firstName: firstName,
        lastName: lastName,
        userType: userType ?? UniversalConstant.FARMER,
        gender: gender ?? UniversalConstant.MALE,
        mobileNumber: mobileNumber ?? 0,
        dateOfBirth: dateOfBirth ?? DateTime(1991, 6, 1),
        imageURL: imageURL ?? "",
        state: state ?? "",
        city: city ?? "",
        village: village ?? "",
        salary: salary ?? 0,
        education: education ?? "",
        accountStatus: UniversalConstant.ACTIVATE_ACCOUNT,
      );
      // Create a new document for the AppUser with uid
      await _appUserService.updateAppUserData(appUser);
    } on FirebaseAuthException catch (e) {
      // Do something with exception. This try/catch is here to make sure
      // that even if the user creation fails, app.delete() runs, if is not,
      // next time Firebase.initializeApp() will fail as the previous one was
      // not deleted.
      print(e.toString());
    }
    await app.delete();
    return Future.sync(() => userCredential);
  }

  // AppUser will provide the email to change the password
  Future resetPassword(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //@TODO: Google Sign In

  // Delete my account and data
  Future<bool> deleteMyAccount() async {
    try {
      User user = _auth.currentUser;
      if (_appUserService.deleteAppUserData(user.uid)) {
        await user.delete();
        return true;
      }
    } catch (e) {
      print("Exception caught - " + e.toString());
    }
    return false;
  }
}
