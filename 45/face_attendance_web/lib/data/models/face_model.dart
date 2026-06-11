class FaceModel {
  final int userId;
  final String image;

  FaceModel({
    required this.userId,
    required this.image,
  });

  factory FaceModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return FaceModel(
      userId: json['user_id'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'image': image,
    };
  }
}