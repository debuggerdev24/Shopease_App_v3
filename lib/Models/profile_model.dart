class ProfileData {
  String preferredUsername;
  String userId;
  String phoneNumber;
  String? imageUrl;
  bool? isInvited;

  ProfileData(
      {required this.preferredUsername,
      required this.userId,
      required this.phoneNumber,
      this.imageUrl,
      this.isInvited});

  ProfileData copyWith({
    String? preferredUsername,
    String? userId,
    String? phoneNumber,
    String? imageUrl,
    bool? isInvited,
  }) =>
      ProfileData(
        preferredUsername: preferredUsername ?? this.preferredUsername,
        userId: userId ?? this.userId,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        imageUrl: imageUrl ?? this.imageUrl,
        isInvited: isInvited ?? this.isInvited,
      );

  factory ProfileData.fromJson(Map<String, dynamic> json) => ProfileData(
        preferredUsername: json["preferred_username"],
        userId: json["user_id"],
        phoneNumber: json["phone_number"],
        imageUrl: json["image_url"],
        isInvited: json['is_invited'],
      );

  Map<String, dynamic> toJson() => {
        "preferred_username": preferredUsername,
        "user_id": userId,
        "phone_number": phoneNumber,
        "image_url": imageUrl,
        'is_invited': isInvited,
      };
}
