import 'package:equatable/equatable.dart';

enum BookingStatus { pending, confirmed, completed, cancelled, inProgress }

extension BookingStatusX on BookingStatus {
  String get label {
    switch (this) {
      case BookingStatus.pending:
        return 'Pending';
      case BookingStatus.confirmed:
        return 'Confirmed';
      case BookingStatus.completed:
        return 'Completed';
      case BookingStatus.cancelled:
        return 'Cancelled';
      case BookingStatus.inProgress:
        return 'In Progress';
    }
  }

  static BookingStatus fromString(String s) {
    switch (s.toLowerCase()) {
      case 'confirmed':
        return BookingStatus.confirmed;
      case 'completed':
        return BookingStatus.completed;
      case 'cancelled':
        return BookingStatus.cancelled;
      case 'inprogress':
      case 'in_progress':
        return BookingStatus.inProgress;
      default:
        return BookingStatus.pending;
    }
  }
}

class BookingModel extends Equatable {
  final String id;
  final String customerName;
  final String customerInitials;
  final String customerAvatarColor;
  final String customerNakshatra;
  final double customerRating;
  final int customerBookingCount;
  final String customerPhone;
  final String customerEmail;
  final String customerLocation;
  final String service;
  final String serviceEmoji;
  final String duration;
  final String date;
  final String time;
  final String location;
  final String attendees;
  final int serviceFee;
  final int platformFee;
  final int gst;
  final int totalAmount;
  final BookingStatus status;
  final String specialInstructions;
  final String createdAt;

  const BookingModel({
    required this.id,
    required this.customerName,
    required this.customerInitials,
    required this.customerAvatarColor,
    required this.customerNakshatra,
    required this.customerRating,
    required this.customerBookingCount,
    required this.customerPhone,
    required this.customerEmail,
    required this.customerLocation,
    required this.service,
    required this.serviceEmoji,
    required this.duration,
    required this.date,
    required this.time,
    required this.location,
    required this.attendees,
    required this.serviceFee,
    required this.platformFee,
    required this.gst,
    required this.totalAmount,
    required this.status,
    required this.specialInstructions,
    required this.createdAt,
  });

  BookingModel copyWith({BookingStatus? status}) {
    return BookingModel(
      id: id,
      customerName: customerName,
      customerInitials: customerInitials,
      customerAvatarColor: customerAvatarColor,
      customerNakshatra: customerNakshatra,
      customerRating: customerRating,
      customerBookingCount: customerBookingCount,
      customerPhone: customerPhone,
      customerEmail: customerEmail,
      customerLocation: customerLocation,
      service: service,
      serviceEmoji: serviceEmoji,
      duration: duration,
      date: date,
      time: time,
      location: location,
      attendees: attendees,
      serviceFee: serviceFee,
      platformFee: platformFee,
      gst: gst,
      totalAmount: totalAmount,
      status: status ?? this.status,
      specialInstructions: specialInstructions,
      createdAt: createdAt,
    );
  }

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] as String,
      customerName: json['customerName'] as String,
      customerInitials: json['customerInitials'] as String,
      customerAvatarColor: (json['customerAvatarColor'] as String?) ?? '0xFF4A0080',
      customerNakshatra: json['customerNakshatra'] as String,
      customerRating: (json['customerRating'] as num).toDouble(),
      customerBookingCount: json['customerBookingCount'] as int,
      customerPhone: json['customerPhone'] as String,
      customerEmail: json['customerEmail'] as String,
      customerLocation: json['customerLocation'] as String,
      service: json['service'] as String,
      serviceEmoji: json['serviceEmoji'] as String,
      duration: json['duration'] as String,
      date: json['date'] as String,
      time: json['time'] as String,
      location: json['location'] as String,
      attendees: json['attendees'] as String,
      serviceFee: json['serviceFee'] as int,
      platformFee: json['platformFee'] as int,
      gst: json['gst'] as int,
      totalAmount: json['totalAmount'] as int,
      status: BookingStatusX.fromString(json['status'] as String),
      specialInstructions: json['specialInstructions'] as String,
      createdAt: json['createdAt'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerName': customerName,
      'customerInitials': customerInitials,
      'customerAvatarColor': customerAvatarColor,
      'customerNakshatra': customerNakshatra,
      'customerRating': customerRating,
      'customerBookingCount': customerBookingCount,
      'customerPhone': customerPhone,
      'customerEmail': customerEmail,
      'customerLocation': customerLocation,
      'service': service,
      'serviceEmoji': serviceEmoji,
      'duration': duration,
      'date': date,
      'time': time,
      'location': location,
      'attendees': attendees,
      'serviceFee': serviceFee,
      'platformFee': platformFee,
      'gst': gst,
      'totalAmount': totalAmount,
      'status': status.name,
      'specialInstructions': specialInstructions,
      'createdAt': createdAt,
    };
  }

  @override
  List<Object?> get props => [id, status];
}
