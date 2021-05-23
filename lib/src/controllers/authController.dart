import 'package:kisan_app/src/data_layer/models/appUser.dart';
import 'package:kisan_app/src/data_layer/repository/appUserRepository.dart';

class AuthController {
  AppUserRepository _repository = AppUserRepository();

  // For signin
  Future<AppUser> handleUserSignIn(String email, String password) async {
    // print("email - $email");
    return _repository.signIn(email, password);
  }

  // For register
  handleUserSignUp(
      String email, String password, String firstName, String lastName) {
    return _repository.registerNewAppUser(
      email,
      password,
      firstName,
      lastName,
    );
  }
}
