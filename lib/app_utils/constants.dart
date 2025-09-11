class Constants {
  static const String defaultError =
      "Connection to API server failed due to internet connection";

  static const String something_went_wrong = 'Something went wrong, try later.';

  static const String serverTimeOut =
      "Send timeout in connection with API server";
  static const String ReceiveserverTimeOut =
      "Receive timeout in connection with API server";
  static const String connectionTimeOut = "Connection timeout with API server";
  static const String cancelRequest = "Request to API server was cancelled";
  static const String errorPassword = "Please enter your password";
  static const String errorPasswordFormat =
      "Password must be 12 characters long and contains alpha and numeric.";

  static const String errorPhone = "Phone is incorrect";
  static const String errorPhoneFormat =
      "Phone number must be 10 digit number.";
  static const String errorEmail = "Email is incorect";
  static const String emptyUsername = "Enter user id";
  static const String enterPhone = "Please enter your phone";
  static const String enterEmail = "Please enter your email";
  static const String enterValidEmail = "Please enter valid email address.";

  static String? DEVICE_FCM_TOKEN = "";
  static String? AUTH_TOKEN = "";
}

class PrefKeys {
  static String authToken = "authToken";
  static String userId = "userId";
}
