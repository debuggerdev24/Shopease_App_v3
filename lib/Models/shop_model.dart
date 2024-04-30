class Shop {
  String shopId;
  String shopName;
  String? shopLocation;
  DateTime? updatedDate;
  String? itemImage;

  Shop({
    required this.shopId,
    required this.shopName,
    this.shopLocation,
    this.updatedDate,
    this.itemImage,
  });

  Shop copyWith({
    String? shopId,
    String? shopName,
    String? shopLocation,
    DateTime? updatedDate,
    String? itemImage,
  }) =>
      Shop(
        shopId: shopId ?? this.shopId,
        shopName: shopName ?? this.shopName,
        shopLocation: shopLocation ?? this.shopLocation,
        updatedDate: updatedDate ?? this.updatedDate,
        itemImage: itemImage ?? this.itemImage,
      );

  factory Shop.fromJson(Map<String, dynamic> json) => Shop(
        shopId: json["shop_id"],
        shopName: json["shop_name"],
        shopLocation: json["shop_location"],
        updatedDate: json["updated_date"] == null
            ? null
            : DateTime.parse(json["updated_date"]),
        itemImage: json["item_image"],
      );

  Map<String, dynamic> toJson() => {
        "shop_id": shopId,
        "shop_name": shopName,
        "shop_location": shopLocation,
        "updated_date": updatedDate?.toIso8601String(),
        "item_image": itemImage,
      };
}
