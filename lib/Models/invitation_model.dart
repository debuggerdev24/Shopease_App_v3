List<Invitation> inviteduserFromJson(List<dynamic> data) =>
    List<Invitation>.from(data.map((x) => Invitation.fromJson(x)));

class Invitation {
  String userId;
  String locationId;
  String invitedBy;
  bool isMessageRead;
  DateTime lastUpdatedDate;

  Invitation({
    required this.userId,
    required this.locationId,
    required this.invitedBy,
    required this.isMessageRead,
    required this.lastUpdatedDate,
  });

  factory Invitation.fromJson(Map<String, dynamic> json) => Invitation(
        userId: json["user_id"],
        locationId: json["location_id"],
        invitedBy: json["invited_by"],
        isMessageRead: json["is_message_read"],
        lastUpdatedDate: DateTime.parse(json["last_updated_date"]),
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "location_id": locationId,
        "invited_by": invitedBy,
        "is_message_read": isMessageRead,
        "last_updated_date": lastUpdatedDate.toIso8601String(),
      };
}
