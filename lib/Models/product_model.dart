import 'dart:convert';

class ProductModel {
    List<Product> products;

    ProductModel({
        required this.products,
    });

    factory ProductModel.fromRawJson(String str) => ProductModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        products: List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
    };
}

class Product {
    String barcodeNumber;
    String barcodeFormats;
    String mpn;
    String model;
    String asin;
    String title;
    String category;
    String manufacturer;
    String brand;
    List<dynamic> contributors;
    String ageGroup;
    String ingredients;
    String nutritionFacts;
    String energyEfficiencyClass;
    String color;
    String gender;
    String material;
    String pattern;
    String format;
    String multipack;
    String size;
    String length;
    String width;
    String height;
    String weight;
    String releaseDate;
    String description;
    List<dynamic> features;
    List<String> images;
    DateTime lastUpdate;
    List<dynamic> stores;
    List<dynamic> reviews;

    Product({
        required this.barcodeNumber,
        required this.barcodeFormats,
        required this.mpn,
        required this.model,
        required this.asin,
        required this.title,
        required this.category,
        required this.manufacturer,
        required this.brand,
        required this.contributors,
        required this.ageGroup,
        required this.ingredients,
        required this.nutritionFacts,
        required this.energyEfficiencyClass,
        required this.color,
        required this.gender,
        required this.material,
        required this.pattern,
        required this.format,
        required this.multipack,
        required this.size,
        required this.length,
        required this.width,
        required this.height,
        required this.weight,
        required this.releaseDate,
        required this.description,
        required this.features,
        required this.images,
        required this.lastUpdate,
        required this.stores,
        required this.reviews,
    });

    factory Product.fromRawJson(String str) => Product.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        barcodeNumber: json["barcode_number"],
        barcodeFormats: json["barcode_formats"],
        mpn: json["mpn"],
        model: json["model"],
        asin: json["asin"],
        title: json["title"],
        category: json["category"],
        manufacturer: json["manufacturer"],
        brand: json["brand"],
        contributors: List<dynamic>.from(json["contributors"].map((x) => x)),
        ageGroup: json["age_group"],
        ingredients: json["ingredients"],
        nutritionFacts: json["nutrition_facts"],
        energyEfficiencyClass: json["energy_efficiency_class"],
        color: json["color"],
        gender: json["gender"],
        material: json["material"],
        pattern: json["pattern"],
        format: json["format"],
        multipack: json["multipack"],
        size: json["size"],
        length: json["length"],
        width: json["width"],
        height: json["height"],
        weight: json["weight"],
        releaseDate: json["release_date"],
        description: json["description"],
        features: List<dynamic>.from(json["features"].map((x) => x)),
        images: List<String>.from(json["images"].map((x) => x)),
        lastUpdate: DateTime.parse(json["last_update"]),
        stores: List<dynamic>.from(json["stores"].map((x) => x)),
        reviews: List<dynamic>.from(json["reviews"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "barcode_number": barcodeNumber,
        "barcode_formats": barcodeFormats,
        "mpn": mpn,
        "model": model,
        "asin": asin,
        "title": title,
        "category": category,
        "manufacturer": manufacturer,
        "brand": brand,
        "contributors": List<dynamic>.from(contributors.map((x) => x)),
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
        "features": List<dynamic>.from(features.map((x) => x)),
        "images": List<dynamic>.from(images.map((x) => x)),
        "last_update": lastUpdate.toIso8601String(),
        "stores": List<dynamic>.from(stores.map((x) => x)),
        "reviews": List<dynamic>.from(reviews.map((x) => x)),
    };
}
