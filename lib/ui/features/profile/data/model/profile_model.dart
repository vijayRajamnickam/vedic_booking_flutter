class ProfileModel {
  final String name;
  final String id;
  final String location;
  final double rating;
  final int reviewCount;
  final int totalBookings;
  final int yearsExperience;
  final int totalEarned;
  final bool isFeatured;
  final bool isAvailable;
  final String avatarInitials;
  final String subscription;
  final String subscriptionExpiry;

  const ProfileModel({
    required this.name,
    required this.id,
    required this.location,
    required this.rating,
    required this.reviewCount,
    required this.totalBookings,
    required this.yearsExperience,
    required this.totalEarned,
    required this.isFeatured,
    required this.isAvailable,
    required this.avatarInitials,
    required this.subscription,
    required this.subscriptionExpiry,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> j) => ProfileModel(
        name: j['name'] as String,
        id: j['id'] as String,
        location: j['location'] as String,
        rating: (j['rating'] as num).toDouble(),
        reviewCount: j['reviewCount'] as int,
        totalBookings: j['totalBookings'] as int,
        yearsExperience: j['yearsExperience'] as int,
        totalEarned: j['totalEarned'] as int,
        isFeatured: j['isFeatured'] as bool,
        isAvailable: j['isAvailable'] as bool,
        avatarInitials: j['avatarInitials'] as String,
        subscription: j['subscription'] as String,
        subscriptionExpiry: j['subscriptionExpiry'] as String,
      );
}
