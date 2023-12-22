class ShopAgainFromRecentStoreModel {
  int? id;
  String? name;
  String? slug;
  String? thumbnail;
  double? unitPrice;
  int? userId;
  int? reviewsCount;
  Seller? seller;


  ShopAgainFromRecentStoreModel(
      {this.id,
        this.name,
        this.slug,
        this.thumbnail,
        this.unitPrice,
        this.userId,
        this.reviewsCount,
        this.seller,
       });

  ShopAgainFromRecentStoreModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    thumbnail = json['thumbnail'];
    unitPrice = json['unit_price'].toDouble();
    userId = json['user_id'];
    reviewsCount = json['reviews_count'];
    seller = json['seller'] != null ? Seller.fromJson(json['seller']) : null;
  }
}

class Seller {
  int? id;
  Shop? shop;

  Seller({this.id, this.shop});

  Seller.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shop = json['shop'] != null ? Shop.fromJson(json['shop']) : null;
  }

}

class Shop {
  int? id;
  int? sellerId;
  String? name;
  String? image;
  int? temporaryClose;
  String? banner;

  Shop(
      {this.id,
        this.sellerId,
        this.name,
        this.image,
        this.temporaryClose,
        this.banner,
 });

  Shop.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sellerId = json['seller_id'];
    name = json['name'];
    image = json['image'];
    temporaryClose = json['temporary_close'];
    banner = json['banner'];
  }
}
