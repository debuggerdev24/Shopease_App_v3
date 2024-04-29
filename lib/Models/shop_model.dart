class Shop {
  String shopId;
  String shopName;
  String? shopLocation;
  String? imageUrl;

  Shop({
    required this.shopId,
    required this.shopName,
    this.shopLocation,
    this.imageUrl,
  });

  Shop copyWith({
    String? shopId,
    String? shopName,
    String? shopLocation,
    String? imageUrl,
  }) =>
      Shop(
        shopId: shopId ?? this.shopId,
        shopName: shopName ?? this.shopName,
        shopLocation: shopLocation ?? this.shopLocation,
        imageUrl: imageUrl ?? this.imageUrl,
      );

  factory Shop.fromJson(Map<String, dynamic> json) => Shop(
        shopId: json["shop_id"],
        shopName: json["shop_name"],
        shopLocation: json["shop_location"],
        imageUrl: json["image_url"],
      );

  Map<String, dynamic> toJson() => {
        "shop_id": shopId,
        "shop_name": shopName,
        "shop_location": shopLocation,
        "image_url": imageUrl,
      };
}
