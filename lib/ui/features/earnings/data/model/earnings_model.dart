class ServiceBreakdown {
  final String name;
  final int amount;
  final int percent;
  final String emoji;

  const ServiceBreakdown({
    required this.name,
    required this.amount,
    required this.percent,
    required this.emoji,
  });

  factory ServiceBreakdown.fromJson(Map<String, dynamic> j) =>
      ServiceBreakdown(
        name: j['name'] as String,
        amount: j['amount'] as int,
        percent: j['percent'] as int,
        emoji: j['emoji'] as String,
      );
}

class Transaction {
  final String id;
  final String title;
  final String? bookingRef;
  final String customer;
  final String date;
  final int amount;
  final String type; // 'credit' | 'debit'

  const Transaction({
    required this.id,
    required this.title,
    this.bookingRef,
    required this.customer,
    required this.date,
    required this.amount,
    required this.type,
  });

  factory Transaction.fromJson(Map<String, dynamic> j) => Transaction(
        id: j['id'] as String,
        title: j['title'] as String,
        bookingRef: j['bookingRef'] as String?,
        customer: j['customer'] as String,
        date: j['date'] as String,
        amount: j['amount'] as int,
        type: j['type'] as String,
      );
}

class EarningsModel {
  final int totalThisMonth;
  final double growthPercent;
  final int today;
  final int thisWeek;
  final int thisYear;
  final String month;
  final List<ServiceBreakdown> serviceBreakdown;
  final List<Transaction> transactions;

  const EarningsModel({
    required this.totalThisMonth,
    required this.growthPercent,
    required this.today,
    required this.thisWeek,
    required this.thisYear,
    required this.month,
    required this.serviceBreakdown,
    required this.transactions,
  });

  factory EarningsModel.fromJson(Map<String, dynamic> j) => EarningsModel(
        totalThisMonth: j['totalThisMonth'] as int,
        growthPercent: (j['growthPercent'] as num).toDouble(),
        today: j['today'] as int,
        thisWeek: j['thisWeek'] as int,
        thisYear: j['thisYear'] as int,
        month: j['month'] as String,
        serviceBreakdown: (j['serviceBreakdown'] as List)
            .map((e) => ServiceBreakdown.fromJson(e as Map<String, dynamic>))
            .toList(),
        transactions: (j['transactions'] as List)
            .map((e) => Transaction.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}
