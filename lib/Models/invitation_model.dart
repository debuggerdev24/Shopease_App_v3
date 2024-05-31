


List<Inviteduser> inviteduserFromJson(List<dynamic> data) => List<Inviteduser>.from(data.map((x) => Inviteduser.fromJson(x)));

class Inviteduser {
    String userId;
    String locationId;
    String invitedBy;
    DateTime lastUpdatedDate;

    Inviteduser({
        required this.userId,
        required this.locationId,
        required this.invitedBy,
        required this.lastUpdatedDate,
    });

    factory Inviteduser.fromJson(Map<String, dynamic> json) => Inviteduser(
        userId: json["user_id"],
        locationId: json["location_id"],
        invitedBy: json["invited_by"],
        lastUpdatedDate: DateTime.parse(json["last_updated_date"]),
    );

    Map<String, dynamic> toJson() => {
        "user_id": userId,
        "location_id": locationId,
        "invited_by": invitedBy,
        "last_updated_date": lastUpdatedDate.toIso8601String(),
    };
}
