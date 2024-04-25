import 'package:flutter/material.dart';

class Product {
  String itemId;
  String productName;
  String itemCategory;
  bool isInCart;
  String? productDescription;
  String? brand;
  String? itemLevel;
  String? itemCount;
  String? locationId;
  String? itemImage;

  Product({
    required this.itemId,
    required this.productName,
    required this.itemCategory,
    this.isInCart = false,
    this.productDescription,
    this.brand,
    this.itemLevel,
    this.itemCount,
    this.locationId,
    this.itemImage,
  });

  Product copyWith({
    String? itemId,
    String? productName,
    String? itemCategory,
    bool? isInCart,
    String? productDescription,
    String? brand,
    String? itemLevel,
    String? itemCount,
    String? locationId,
    String? itemImage,
  }) =>
      Product(
        itemId: itemId ?? this.itemId,
        productName: productName ?? this.productName,
        itemCategory: itemCategory ?? this.itemCategory,
        isInCart: isInCart ?? this.isInCart,
        productDescription: productDescription ?? this.productDescription,
        brand: brand ?? this.brand,
        itemLevel: itemLevel ?? this.itemLevel,
        itemCount: itemCount ?? this.itemCount,
        locationId: locationId ?? this.locationId,
        itemImage: itemImage ?? this.itemImage,
      );

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        itemId: json["item_id"],
        productName: json["product_name"],
        itemCategory: json["item_category"],
        isInCart: json['is_in_cart'] ?? false,
        productDescription: json["product_description"],
        brand: json["brand"],
        itemLevel: json["item_level"],
        itemCount: json["item_count"],
        locationId: json["location_id"],
        itemImage: json["image_url"],
      );

  Map<String, dynamic> toJson() => {
        "item_id": itemId,
        "product_name": productName,
        "item_category": itemCategory,
        'is_in_cart': isInCart,
        "product_description": productDescription,
        "brand": brand,
        "item_level": itemLevel,
        "item_count": itemCount,
        "location_id": locationId,
        "image_url": itemImage,
      };
}
