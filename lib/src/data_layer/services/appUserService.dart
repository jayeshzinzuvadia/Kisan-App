import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../src/app.dart';
import '../models/appUserViewModel.dart';
import '../models/appUser.dart';
import '../services/constants.dart';

class AppUserService {
  // Collection Reference for AppUser Collection
  final CollectionReference _appUserCollection =
      FirebaseFirestore.instance.collection(DbConstant.APPUSER_COLLECTION);

  // add or update AppUser data
  Future<void> updateAppUserData(AppUser appUser) async {
    print('Updating user data : ' + appUser.uid);
    return await _appUserCollection.doc(appUser.uid).set({
      'UserType': appUser.userType,
      'FirstName': appUser.firstName,
      'LastName': appUser.lastName,
      'ImageURL': appUser.imageURL,
      'DateOfBirth': appUser.dateOfBirth ?? DateTime(1991, 6, 1),
      'Gender': appUser.gender ?? UniversalConstant.MALE,
      'MobileNumber': appUser.mobileNumber ?? 0,
      'State': appUser.state,
      'City': appUser.city,
      'Village': appUser.village,
      'Salary': appUser.salary,
      'Education': appUser.education,
      'AccountStatus': appUser.accountStatus,
    });
  }

  // get AppUser object from DocumentSnapshot
  AppUser _appUserDataFromSnapshot(DocumentSnapshot snapshot) {
    var appUser = AppUser(
      uid: snapshot.id,
      userType: snapshot.data()['UserType'],
      firstName: snapshot.data()['FirstName'],
      lastName: snapshot.data()['LastName'],
      imageURL: snapshot.data()['ImageURL'],
      dateOfBirth: DateTime.fromMillisecondsSinceEpoch(
          snapshot.data()['DateOfBirth'].seconds * 1000),
      gender: snapshot.data()['Gender'],
      mobileNumber: snapshot.data()['MobileNumber'],
      state: snapshot.data()['State'],
      city: snapshot.data()['City'],
      village: snapshot.data()['Village'],
      salary: snapshot.data()['Salary'],
      education: snapshot.data()['Education'],
      accountStatus: snapshot.data()['AccountStatus'],
    );
    print('app User object' + appUser.toString());
    return appUser;
  }

  Stream<AppUser> appUserInfo(String uid) {
    return _appUserCollection
        .doc(uid)
        .snapshots()
        .map(_appUserDataFromSnapshot);
  }

  // get AppUser info from id
  Future<AppUser> getAppUserData(String uid) async {
    DocumentSnapshot snapshot = await _appUserCollection.doc(uid).get();
    print(snapshot);
    return _appUserDataFromSnapshot(snapshot);
  }

  // Used for displaying users in list
  List<AppUserViewModel> _appUserListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return AppUserViewModel(
        uid: doc.id,
        userType: doc.data()['UserType'] ?? '',
        firstName: doc.data()['FirstName'] ?? 'Anonymous',
        lastName: doc.data()['LastName'] ?? '',
        imageURL: doc.data()['ImageURL'] ?? '',
        city: doc.data()['City'] ?? '',
        state: doc.data()['State'] ?? '',
        education: doc.data()['Education'] ?? '',
        accountStatus: doc.data()['AccountStatus'] ?? true,
      );
    }).toList();
  }

  // get farmer user list
  Future<List<AppUserViewModel>> get farmerList async {
    QuerySnapshot _snapshot = await _appUserCollection
        .where("UserType", isEqualTo: UniversalConstant.FARMER)
        .orderBy("AccountStatus", descending: true)
        .get();
    return _appUserListFromSnapshot(_snapshot);
  }

  // get agri expert list
  Future<List<AppUserViewModel>> get agriExpertList async {
    QuerySnapshot _snapshot = await _appUserCollection
        .where("UserType", isEqualTo: UniversalConstant.AGRI_EXPERT)
        .orderBy("AccountStatus", descending: true)
        .get();
    return _appUserListFromSnapshot(_snapshot);
  }

  // get active agri expert users list for message requirement
  Future<List<AppUserViewModel>> get activeAgriExpertList async {
    QuerySnapshot _snapshot = await _appUserCollection
        .where("UserType", isEqualTo: UniversalConstant.AGRI_EXPERT)
        .where("AccountStatus", isEqualTo: UniversalConstant.ACTIVATE_ACCOUNT)
        .get();
    return _appUserListFromSnapshot(_snapshot);
  }

  // Used for deactivating and re-activating user account
  Future<bool> manageAppUserAccount(String uid, bool accStatus) async {
    try {
      AppUser _appUser = await getAppUserData(uid);
      _appUser.accountStatus = accStatus;
      updateAppUserData(_appUser);
      return true;
    } catch (e) {
      print("Caught Exception : " + e.toString());
    }
    return false;
  }

  // delete user
  bool deleteAppUserData(String uid) {
    try {
      var obj = _appUserCollection.doc(uid);
      if (obj != null) {
        obj.delete();
        print('AppUser deleted');
        return true;
      }
    } catch (e) {
      print(e.toString());
    }
    return false;
  }
}
