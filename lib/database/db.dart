import 'dart:async';
import 'package:budget_app/models/transactions.dart';
import 'package:budget_app/models/account.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AccountsDatabase {
  static final AccountsDatabase instance = AccountsDatabase._intl();

  static Database? _database;

  AccountsDatabase._intl();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {}
    _database = await _initDB('accounts.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const doubleType = 'DOUBLE NOT NULL';
    const intType = 'INTEGER NOT NULL';

    await db.execute('''
    CREATE TABLE $tableAccounts(
      ${AccountFields.id} $idType,
      ${AccountFields.name} $textType,
      ${AccountFields.description} $textType,
      ${AccountFields.balance} $doubleType,
      ${AccountFields.currency} $textType,
      ${AccountFields.currencySign} $textType,
      ${AccountFields.lastLog} $textType
    )
    ''');
    await db.execute('''
    CREATE TABLE $tableTransactions(
      ${TransactionFields.id} $idType,
      ${TransactionFields.name} $textType,
      ${TransactionFields.description} $textType,
      ${TransactionFields.amount} $doubleType,
      ${TransactionFields.foreignKey} $intType,
      ${TransactionFields.time} $textType
    )
    ''');

  }



  Future<Account> createAnAccount(Account account) async {
    final db = await instance.database;
    int? id = await db.insert(tableAccounts, account.toJson());

    return account.copy(id: id);
  }

  // Future<Account> readAccount() async {
  //   final db = await instance.database;
    
  //   final maps = await db.query(
  //     tableAccounts,
  //     where: '${AccountFields.id} = ?',
     
  //   );

  //   if (maps.isNotEmpty) {
  //     return Account.fromJson(maps.first);
  //   } else {
  //     throw Exception('Account not found');
  //   }
  // }

  Future<List<Account>> readAllAccounts() async {
    final db = await instance.database;
    const orderBy = '${AccountFields.lastLog} DESC';
    final result = await db.query(tableAccounts, orderBy: orderBy);
   
    

    return result.map((json) => Account.fromJson(json)).toList();
  }

  Future<int> updateAccount(Account account) async {
    final db = await instance.database;

    return db.update(tableAccounts, account.toJson(),
        where: '${AccountFields.id} = ?', whereArgs: [account.id]);
  }

  Future<int> deleteAccount(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableAccounts,
      where: '${AccountFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }

  Future<Transactions> createATransaction(Transactions transaction) async {
    final db = await instance.database;
    int? id = await db.insert(tableTransactions, transaction.toJson());

    return transaction.copy(id: id);
  }

  Future<List<Transactions>> readAllTransactions(int key) async {
    final db = await instance.database;
    const orderBy = '${TransactionFields.time} DESC';
    final result = await db.query(
      tableTransactions,
      where: '${TransactionFields.foreignKey} = $key',
      orderBy: orderBy,
    );

    return result.map((json) => Transactions.fromJson(json)).toList();
  }

  Future<int> deleteTransaction(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableTransactions,
      where: '${TransactionFields.id} = $id',
    );
  }

  Future<int> deleteTransactions(int key) async {
    final db = await instance.database;

    return await db.delete(
      tableTransactions,
      where: '${TransactionFields.foreignKey} = $key',
    );
  }
}
