class MuhurthaModel {
  final String name;
  final String timeRange;
  final String description;

  const MuhurthaModel({
    required this.name,
    required this.timeRange,
    required this.description,
  });

  factory MuhurthaModel.fromJson(Map<String, dynamic> json) {
    return MuhurthaModel(
      name: json['name'] as String,
      timeRange: json['timeRange'] as String,
      description: json['description'] as String,
    );
  }
}

class DashboardModel {
  final int totalBookings;
  final double totalBookingsGrowth;
  final int pendingBookings;
  final int completedBookings;
  final double completedGrowth;
  final int earningsThisMonth;
  final MuhurthaModel todaysMuhurtha;

  const DashboardModel({
    required this.totalBookings,
    required this.totalBookingsGrowth,
    required this.pendingBookings,
    required this.completedBookings,
    required this.completedGrowth,
    required this.earningsThisMonth,
    required this.todaysMuhurtha,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      totalBookings: json['totalBookings'] as int,
      totalBookingsGrowth: (json['totalBookingsGrowth'] as num).toDouble(),
      pendingBookings: json['pendingBookings'] as int,
      completedBookings: json['completedBookings'] as int,
      completedGrowth: (json['completedGrowth'] as num).toDouble(),
      earningsThisMonth: json['earningsThisMonth'] as int,
      todaysMuhurtha: MuhurthaModel.fromJson(
          json['todaysMuhurtha'] as Map<String, dynamic>),
    );
  }
}
