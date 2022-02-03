const String tableAccounts = 'accounts';

class AccountFields {
  static List<String>? values = [
    id,
    name,
    description!,
    balance,
    currency,
    currencySign,
    lastLog,
  ];
  static const String id = '_id';
  static const String name = 'name';
  static const String? description = 'description';
  static const String lastLog = 'lastLog';
  static const String balance = 'balance';
  static const String currency = 'currency';
  static const String currencySign = 'currencySign';
}

class Account {
  int? id;
  String name;
  String? description;
  double balance;
  String currency;
  String currencySign;
  DateTime lastLog;

  Account(
      {this.id,
      required this.name,
      required this.lastLog,
      this.description,
      required this.balance,
      required this.currency,
      required this.currencySign});

  Account copy({
    int? id,
    String? name,
    String? description,
    double? balance,
    DateTime? lastLog,
    String? currency,
    String? currencySign,
  }) =>
      Account(
          id: id ?? this.id,
          name: name ?? this.name,
          description: description ?? this.description,
          lastLog: lastLog ?? this.lastLog,
          balance: balance ?? this.balance,
          currency: currency ?? this.currency,
          currencySign: currencySign ?? this.currencySign);

  Map<String, Object?> toJson() => {
        AccountFields.id: id,
        AccountFields.name: name,
        AccountFields.description!: description,
        AccountFields.balance: balance,
        AccountFields.currency: currency,
        AccountFields.currencySign: currencySign,
        AccountFields.lastLog: lastLog.toIso8601String()
      };

  static Account fromJson(Map<String, Object?> json) => Account(
        id: json[AccountFields.id] as int?,
        name: json[AccountFields.name] as String,
        balance: json[AccountFields.balance] as double,
        description: json[AccountFields.description] as String?,
        currency: json[AccountFields.currency] as String,
        currencySign: json[AccountFields.currencySign] as String,
        lastLog: DateTime.parse(json[AccountFields.lastLog] as String)
      );
}
