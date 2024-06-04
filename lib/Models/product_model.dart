class Product {
  String? itemId;
  String? productName;
  String? itemCategory;
  bool? isInChecklist;
  String? productDescription;
  String? brand;
  String? itemLevel;
  String? itemCount;
  String? locationId;
  String? itemImage;
  String? itemStorage;
  String? barcode;
  final DateTime? addedDate;
  bool isSelectedForComplete;

  Product({
    this.itemId,
    this.productName,
    this.itemCategory,
    this.isInChecklist = false,
    this.productDescription,
    this.brand,
    this.itemLevel,
    this.itemCount,
    this.locationId,
    this.itemImage,
    this.itemStorage,
    this.barcode,
    this.isSelectedForComplete = false,
    this.addedDate,
  });

  get name => null;

  get timestamp => null;

  void changeSelectedState(bool newValue) => isSelectedForComplete = newValue;

  Product copyWith({
    String? itemId,
    String? productName,
    String? itemCategory,
    bool? isInChecklist,
    String? productDescription,
    String? brand,
    String? itemLevel,
    String? itemCount,
    String? locationId,
    String? itemImage,
    String? itemStorage,
    final DateTime? addedDate,
  }) =>
      Product(
        itemId: itemId ?? this.itemId,
        productName: productName ?? this.productName,
        itemCategory: itemCategory ?? this.itemCategory,
        isInChecklist: isInChecklist ?? this.isInChecklist,
        productDescription: productDescription ?? this.productDescription,
        brand: brand ?? this.brand,
        itemLevel: itemLevel ?? this.itemLevel,
        itemCount: itemCount ?? this.itemCount,
        locationId: locationId ?? this.locationId,
        itemImage: itemImage,
        itemStorage: itemStorage ?? this.itemStorage,
      );

  factory Product.fromJson(Map<String, dynamic> json) => Product(
      itemId: json["item_id"],
      productName: json["product_name"],
      itemCategory: json["item_category"],
      isInChecklist: json['is_in_checklist'] ?? false,
      productDescription: json["product_description"],
      brand: json["brand"],
      itemLevel: json["item_level"],
      itemCount: json["item_count"],
      locationId: json["location_id"],
      itemImage: (json["image_url"] is List)
          ? json['image_url'][0]
          : json['image_url'],
      itemStorage: json['item_storage'] ?? '',
      barcode: json['barcode']);

  Map<String, dynamic> toJson() => {
        "item_id": itemId,
        "product_name": productName,
        "item_category": itemCategory,
        'is_in_checklist': isInChecklist,
        "product_description": productDescription,
        "brand": brand,
        "item_level": itemLevel,
        "item_count": itemCount,
        "location_id": locationId,
        "item_image": itemImage,
        'item_storage': itemStorage,
        'barcode': barcode,
      };
}
