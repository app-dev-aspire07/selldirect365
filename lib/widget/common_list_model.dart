class CommonListItemModel {
  final String imageUrl;
  final String title;
  final String? subtitle;

  CommonListItemModel({
    required this.imageUrl,
    required this.title,
     this.subtitle,
  });
}


class CommonTruckListItemModel {
  final String imageUrl;
  final String title;
  final String? subtitle;
  final String? price;
  final String? distance;

  CommonTruckListItemModel({
    required this.imageUrl,
    required this.title,
     this.subtitle,
     this.price,
     this.distance,
  });
}


class ImageListItemModel {
  final String imageUrl;
 

  ImageListItemModel({
    required this.imageUrl,
  
  });
}
