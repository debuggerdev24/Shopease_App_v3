class History {
  String histId;
  int? itemCount;
  DateTime? updatedDate;
  String shopName;
  String? imageUrl;
  String? totalPrice;

  History({
    required this.histId,
    required this.shopName,
    this.itemCount,
    this.updatedDate,
    this.imageUrl,
    this.totalPrice,
  });

  History copyWith({
    String? histId,
    int? itemCount,
    DateTime? updatedDate,
    String? shopName,
    String? imageUrl,
    String? totalPrice,
  }) =>
      History(
        histId: histId ?? this.histId,
        itemCount: itemCount ?? this.itemCount,
        updatedDate: updatedDate ?? this.updatedDate,
        shopName: shopName ?? this.shopName,
        imageUrl: imageUrl ?? this.imageUrl,
        totalPrice: totalPrice ?? this.totalPrice,
      );

  factory History.fromJson(Map<String, dynamic> json) => History(
        histId: json["hist_id"],
        itemCount: int.tryParse(json["item_count"]),
        updatedDate: json["updated_date"] == null
            ? null
            : DateTime.tryParse(json["updated_date"]),
        shopName: json["shop_name"],
        imageUrl: json["image_url"],
        totalPrice: json['total_amount'],
      );

  Map<String, dynamic> toJson() => {
        "hist_id": histId,
        "item_count": itemCount.toString(),
        "updated_date": updatedDate?.toIso8601String(),
        "shop_name": shopName,
        "image_url": imageUrl,
        'total_amount': totalPrice,
        
      };
}
