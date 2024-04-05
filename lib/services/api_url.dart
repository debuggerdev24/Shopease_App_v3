class ApiUrl {
  static const String baseUrlLocal = "http://localhost:4000/api";

  static const String baseUrl = "https://devapi.shopeaseapp.com";

  static const String signUP = "$baseUrl/signup";

  static const String login = "/signup";



  static const String appointmentURl = "$baseUrl/appointment/bookAppointment";
  static const String notificationHistory =
      "$baseUrl/appointment/getNotifications";
  static const String addFCM = "/auth/addOrRemoveFcmToken";

  static const String apiTermsAndConditions =
      "$baseUrl/websitepages/getTermsAndConditions";

  static const String apiPrivacyStatement =
      "$baseUrl/websitepages/getPrivacyPolicy";

  // ignore: constant_identifier_names
  static const String acceptAppointment = "/appointment/appointmentHistory";

  // ignore: constant_identifier_names
  static const String pendingAppointment =
      "$baseUrl/appointment/getAllAppointment";

  // ignore: constant_identifier_names
  static const String approveAppointment =
      "$baseUrl/appointment/approveAppointment";

  static const String completeAppointment = "/appointment/completeAppointment";

  static const String pastAppointmentHistory =
      "/appointment/pastAppointmentHistory";
  static const String rejectAppointment = "/appointment/rejectAppointment";
  static const String checkAppointment =
      "$baseUrl/appointment/checkAppointment";
  static const String getDoctorTimings = "$baseUrl/doctor/getDoctorTimings";
  static const String changePassword = "/doctor/resetpassword";
  static String cancelAppointmentApi = "$baseUrl/appointment/cancelAppointment";
  static String appointmentStatus =
      "$baseUrl/appointment/getAppointmentStatus?id=";
  static String timeForAppointment =
      "$baseUrl/appointment/getDefaultTimeForAppointment";
}
