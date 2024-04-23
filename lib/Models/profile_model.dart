class Profile {
  String preferredUsername;
  String locationId;
  String userId;
  String phoneNumber;
  String userPhoto;

  Profile({
    required this.preferredUsername,
    required this.locationId,
    required this.userId,
    required this.phoneNumber,
    required this.userPhoto,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        preferredUsername: json["preferred_username"],
        locationId: json["location_id"],
        userId: json["user_id"],
        phoneNumber: json["phone_number"],
        userPhoto: json["user_photo"],
      );

  Map<String, dynamic> toJson() => {
        "preferred_username": preferredUsername,
        "location_id": locationId,
        "user_id": userId,
        "phone_number": phoneNumber,
        "user_photo": userPhoto,
      };
}
