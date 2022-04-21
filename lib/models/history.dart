import 'package:coin_talk/models/coin.dart';

class History {
  DateTime dateOperation;
  String typeOperation;
  Coin coin;
  double value;
  double amount;

  History({
    required this.dateOperation,
    required this.typeOperation,
    required this.coin,
    required this.value,
    required this.amount,
  });
}
