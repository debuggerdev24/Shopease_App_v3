import 'package:shopease_app_flutter/utils/enums/expiry_state.dart';

List<Product> productFromJson(List<dynamic> data) =>
    List<Product>.from(data.map((x) => Product.fromJson(x)));

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
  final DateTime? updatedDate;
  bool isSelectedForComplete;
  String inStockQuantity;
  String requiredQuantity;
  DateTime? expiryDate;
  ExpiryState expiryState;

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
    this.updatedDate,
    this.inStockQuantity = "",
    this.requiredQuantity = "",
    this.expiryDate,
  }) : expiryState = expiryDate?.isBefore(DateTime.now()) == true
            ? ExpiryState.expired
            : (expiryDate?.difference(DateTime.now()).inDays ?? 0) >= 5
                ? ExpiryState.expiring
                : ExpiryState.normal;

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
    bool? isSelectedForComplete,
    String? inStockQuantity,
    String? requiredQuantity,
    DateTime? expiryDate,
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
        isSelectedForComplete:
            isSelectedForComplete ?? this.isSelectedForComplete,
        inStockQuantity: inStockQuantity ?? this.inStockQuantity,
        requiredQuantity: requiredQuantity ?? this.requiredQuantity,
        expiryDate: expiryDate ?? this.expiryDate,
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
        barcode: json['barcode'],
        updatedDate: json["last_updated_date"] == null
            ? null
            : DateTime.tryParse(json["last_updated_date"]),
        isSelectedForComplete: json['is_selected_for_complete'] ?? false,
        inStockQuantity: json['in_stock_quantity'] ?? "",
        requiredQuantity: json['required_quantity'] ?? "",
        expiryDate: DateTime.tryParse(json['expiry_date'] ?? ""),
      );

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
        'is_selected_for_complete': isSelectedForComplete,
        "last_updated_date": updatedDate?.toIso8601String(),
        "in_stock_quantity": inStockQuantity,
        "required_quantity": requiredQuantity,
        "expiry_date": expiryDate?.toIso8601String(),
      };
}
