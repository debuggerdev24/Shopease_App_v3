class NotificationModel {
  String notificationId;
  bool isMessageRead;
  String message;
  String? imageUrl;
  DateTime? recievedDate;

  NotificationModel({
    required this.notificationId,
    required this.isMessageRead,
    required this.message,
    this.imageUrl,
    this.recievedDate,
  });

  void updateRead(bool newValue) {
    isMessageRead = newValue;
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        notificationId: json["notification_id"],
        isMessageRead: json["is_message_read"],
        imageUrl: json["image_url"],
        message: json["message"],
        recievedDate: json["recieved_date"] == null
            ? null
            : DateTime.parse(json["recieved_date"]),
      );

  Map<String, dynamic> toJson() => {
        "notification_id": notificationId,
        "is_message_read": isMessageRead,
        "image_url": imageUrl,
        "message": message,
        "recieved_date": recievedDate?.toIso8601String(),
      };
}
