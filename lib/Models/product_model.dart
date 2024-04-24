import 'package:flutter/material.dart';

class Product {
  String itemId;
  String? barcodeNumber;
  String? barcodeFormats;
  String inventoryLevel;
  bool isInCart;
  String? mpn;
  String? model;
  String? asin;
  String title;
  String? category;
  String? manufacturer;
  String brand;
  List<dynamic>? contributors;
  String? ageGroup;
  String? ingredients;
  String? nutritionFacts;
  String? energyEfficiencyClass;
  String? color;
  String? gender;
  String? material;
  String? pattern;
  String? format;
  String? multipack;
  String? size;
  String? length;
  double? width;
  double? height;
  double? weight;
  DateTime? releaseDate;
  String description;
  List<dynamic>? features;
  List<String>? images;
  DateTime? lastUpdate;
  List<dynamic>? stores;
  List<dynamic>? reviews;

  Product({
    required this.itemId,
    this.barcodeNumber,
    this.barcodeFormats,
    required this.inventoryLevel,
    required this.isInCart,
    this.mpn,
    this.model,
    this.asin,
    required this.title,
    this.category,
    this.manufacturer,
    required this.brand,
    this.contributors,
    this.ageGroup,
    this.ingredients,
    this.nutritionFacts,
    this.energyEfficiencyClass,
    this.color,
    this.gender,
    this.material,
    this.pattern,
    this.format,
    this.multipack,
    this.size,
    this.length,
    this.width,
    this.height,
    this.weight,
    this.releaseDate,
    required this.description,
    this.features,
    this.images,
    this.lastUpdate,
    this.stores,
    this.reviews,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        itemId: json['item_id'],
        barcodeNumber: json["barcode_number"] ?? '',
        barcodeFormats: json["barcode_formats"] ?? '',
        inventoryLevel: json['inventory_level'] ?? '',
        isInCart: json['is_in_cart'] ?? false,
        mpn: json["mpn"] ?? '',
        model: json["model"] ?? '',
        asin: json["asin"] ?? '',
        title: json["title"] ?? '',
        category: json["category"] ?? '',
        manufacturer: json["manufacturer"] ?? '',
        brand: json["brand"] ?? '',
        contributors:
            List<dynamic>.from(json["contributors"].map((x) => x) ?? []),
        ageGroup: json["age_group"] ?? '',
        ingredients: json["ingredients"] ?? '',
        nutritionFacts: json["nutrition_facts"] ?? '',
        energyEfficiencyClass: json["energy_efficiency_class"] ?? '',
        color: json["color"] ?? '',
        gender: json["gender"] ?? '',
        material: json["material"] ?? '',
        pattern: json["pattern"] ?? '',
        format: json["format"] ?? '',
        multipack: json["multipack"] ?? '',
        size: json["size"] ?? '',
        length: json["length"] ?? '',
        width: double.tryParse(json["width"]),
        height: double.tryParse(json["height"]),
        weight: double.parse(json["weight"]),
        releaseDate: DateTime.tryParse(json["release_date"]),
        description: json["description"] ?? '',
        features: List<dynamic>.from(json["features"].map((x) => x) ?? []),
        images: List<String>.from(json["images"].map((x) => x) ?? []),
        lastUpdate: DateTime.tryParse(json["last_update"]),
        stores: List<dynamic>.from(json["stores"].map((x) => x) ?? []),
        reviews: List<dynamic>.from(json["reviews"].map((x) => x) ?? []),
      );

  Map<String, dynamic> toJson() => {
        'item_id': itemId,
        "barcode_number": barcodeNumber,
        "barcode_formats": barcodeFormats,
        'inventory_level': inventoryLevel,
        'is_in_cart': isInCart,
        "mpn": mpn,
        "model": model,
        "asin": asin,
        "title": title,
        "category": category,
        "manufacturer": manufacturer,
        "brand": brand,
        "contributors": List<dynamic>.from(contributors?.map((x) => x) ?? []),
        "age_group": ageGroup,
        "ingredients": ingredients,
        "nutrition_facts": nutritionFacts,
        "energy_efficiency_class": energyEfficiencyClass,
        "color": color,
        "gender": gender,
        "material": material,
        "pattern": pattern,
        "format": format,
        "multipack": multipack,
        "size": size,
        "length": length,
        "width": width,
        "height": height,
        "weight": weight,
        "release_date": releaseDate,
        "description": description,
        "features": List<dynamic>.from(features?.map((x) => x) ?? []),
        "images": List<dynamic>.from(images?.map((x) => x) ?? []),
        "last_update": lastUpdate?.toIso8601String(),
        "stores": List<dynamic>.from(stores?.map((x) => x) ?? []),
        "reviews": List<dynamic>.from(reviews?.map((x) => x) ?? []),
      };
}
