import 'dart:developer';

class ProfileData {
  String preferredUsername;
  String userId;
  String phoneNumber;
  bool isAdmin;
  bool isInvited;
  String imageUrl;

  ProfileData({
    required this.preferredUsername,
    required this.userId,
    required this.phoneNumber,
    required this.isAdmin,
    required this.isInvited,
    required this.imageUrl,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    log("check is_invited : ${json["is_invited"]}");
    return ProfileData(
      preferredUsername: json["preferred_username"],
      userId: json["user_id"],
      phoneNumber: json["phone_number"],
      isAdmin: json["is_admin"],
      isInvited: json["is_invited"],
      imageUrl: json["image_url"],
    );
  }
}
