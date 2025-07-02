class Transaction {
  final String id;
  final double amount;
  String status; // This can remain mutable
  final String description;
  final String createdAt;
  final String accountName;
  final String accountNumber;
  final String currency;
  final String bankCode;
  final Sender? sender; // Made nullable
  final Receiver? receiver; // Made nullable

  Transaction({
    required this.id,
    required this.amount,
    required this.status,
    required this.description,
    required this.createdAt,
    required this.accountName,
    required this.accountNumber,
    required this.currency,
    required this.bankCode,
    this.sender,
    this.receiver,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['_id'],
      amount: json['amount'],
      status: json['status'],
      description: json['description'],
      createdAt: json['createdAt'],
      accountName: json['account_name'],
      accountNumber: json['account_number'],
      currency: json['currency'],
      bankCode: json['bank_code'],
      sender: json['sender'] != null ? Sender.fromJson(json['sender']) : null,
      receiver:
          json['receiver'] != null ? Receiver.fromJson(json['receiver']) : null,
    );
  }

  // Method to update status
  void updateStatus(String newStatus) {
    status = newStatus;
  }

  // CopyWith method
  Transaction copyWith({
    String? id,
    double? amount,
    String? status,
    String? description,
    String? createdAt,
    String? accountName,
    String? accountNumber,
    String? currency,
    String? bankCode,
    Sender? sender,
    Receiver? receiver,
  }) {
    return Transaction(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      accountName: accountName ?? this.accountName,
      accountNumber: accountNumber ?? this.accountNumber,
      currency: currency ?? this.currency,
      bankCode: bankCode ?? this.bankCode,
      sender: sender ?? this.sender,
      receiver: receiver ?? this.receiver,
    );
  }
}

class Sender {
  final String firstName;
  final String lastName;

  Sender({required this.firstName, required this.lastName});

  factory Sender.fromJson(Map<String, dynamic> json) {
    return Sender(
      firstName: json['first_name'],
      lastName: json['last_name'],
    );
  }
}

class Receiver {
  final String firstName;
  final String lastName;

  Receiver({required this.firstName, required this.lastName});

  factory Receiver.fromJson(Map<String, dynamic> json) {
    return Receiver(
      firstName: json['first_name'],
      lastName: json['last_name'],
    );
  }
}
