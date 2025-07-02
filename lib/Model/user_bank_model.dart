class Bank {
  final String id;
  final String user;
  final String accountNumber;
  final String bankCode;
  final double amount;
  final String bankName;
  final DateTime createdAt;

  Bank({
    required this.id,
    required this.user,
    required this.accountNumber,
    required this.bankCode,
    required this.amount,
    required this.bankName,
    required this.createdAt,
  });

  // Factory method to create a Bank from JSON
  factory Bank.fromJson(Map<String, dynamic> json) {
    return Bank(
      id: json['_id'],
      user: json['user'],
      accountNumber: json['accountNumber'],
      bankCode: json['bankCode'],
      amount: json['amount'].toDouble(), // Ensure it's a double
      bankName: json['bankName'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  // Method to convert Bank to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': user,
      'accountNumber': accountNumber,
      'bankCode': bankCode,
      'amount': amount,
      'bankName': bankName,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
