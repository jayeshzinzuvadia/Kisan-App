class AppUser {
  final String uid;
  String userType;
  // Basic User Details
  String firstName;
  String lastName;
  String imageURL;
  DateTime dateOfBirth;
  int gender;
  int mobileNumber;
  String state;
  String city;
  String village;
  // For agricultural expert users only
  int salary;
  String education;
  // For deactivating user's account
  bool accountStatus;

  AppUser({
    this.uid,
    this.userType,
    this.firstName,
    this.lastName,
    this.imageURL,
    this.gender,
    this.dateOfBirth,
    this.mobileNumber,
    this.state,
    this.city,
    this.village,
    this.accountStatus,
    this.education,
    this.salary,
  });
}
