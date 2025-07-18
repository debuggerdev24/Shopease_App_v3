class HistoryItemDetail {
  String histId;
  String itemId;
  String? itemCount;
  String? itemCategory;
  String? brand;
  String? shopName;
  DateTime? updatedDate;
  String? locationId;
  String? productDescription;
  String? productName;
  String? imageUrl;

  HistoryItemDetail({
    required this.histId,
    required this.itemId,
    this.itemCount,
    this.itemCategory,
    this.brand,
    this.shopName,
    this.updatedDate,
    this.locationId,
    this.productDescription,
    this.productName,
    this.imageUrl,
  });

  factory HistoryItemDetail.fromJson(Map<String, dynamic> json) =>
      HistoryItemDetail(
        histId: json["hist_id"],
        itemId: json["item_id"],
        itemCount: json["item_count"],
        itemCategory: json["item_category"],
        brand: json["brand"],
        shopName: json["shop_name"],
        updatedDate: json["updated_date"] == null
            ? null
            : DateTime.parse(json["updated_date"]),
        locationId: json["location_id"],
        productDescription: json["product_description"],
        productName: json["product_name"],
        imageUrl: json["image_url"],
      );

  Map<String, dynamic> toJson() => {
        "hist_id": histId,
        "item_id": itemId,
        "item_count": itemCount,
        "item_category": itemCategory,
        "brand": brand,
        "shop_name": shopName,
        "updated_date": updatedDate?.toIso8601String(),
        "location_id": locationId,
        "product_description": productDescription,
        "product_name": productName,
        "image_url": imageUrl,
      };
}
