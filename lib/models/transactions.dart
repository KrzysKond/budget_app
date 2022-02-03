const String tableTransactions = 'transactions';

class TransactionFields {
  static List<String>? values = [
    id,
    name,
    amount,
    description,
    foreignKey,
    time
  ];
  static const String id = '_id';
  static const String name = 'name';
  static const String amount = 'amount';
  static const String description = 'description';
  static const String foreignKey = '_foreignKey';
  static const String time = 'time';
}

class Transactions {
  int? id;
  String name;
  double amount;
  String description;
  int? foreignKey;
  DateTime time;

  Transactions(
      {this.id,
      required this.name,
      required this.amount,
      required this.description,
      this.foreignKey,
      required this.time
      });
  Transactions copy({
    int? id,
    String? name,
    double? amount,
    String? description,
    int? foreignKey,
    DateTime? time,
  }) =>
      Transactions(
          id: id ?? this.id,
          name: name ?? this.name,
          amount: amount ?? this.amount,
          description: description ?? this.description,
          foreignKey: foreignKey ?? this.foreignKey,
          time: time ?? this.time);
  Map<String, Object?> toJson() => {
        TransactionFields.id: id,
        TransactionFields.name: name,
        TransactionFields.amount: amount,
        TransactionFields.description: description,
        TransactionFields.foreignKey: foreignKey,
        TransactionFields.time: time.toIso8601String()
      };
  static Transactions fromJson(Map<String, Object?> json) => Transactions(
        id: json[TransactionFields.id] as int?,
        name: json[TransactionFields.name] as String,
        amount: json[TransactionFields.amount] as double,
        description: json[TransactionFields.description] as String,
        foreignKey: json[TransactionFields.foreignKey] as int?,
        time: DateTime.parse(json[TransactionFields.time] as String),
      );
}
