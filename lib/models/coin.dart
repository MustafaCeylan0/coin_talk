class Coin {
  String baseId;
  String icon;
  String name;
  String initials;
  double price;
  DateTime timestamp;
  double changeHour;
  double changeDay;
  double changeWeek;
  double changeMonth;
  double changeYear;
  double changeTotalPeriod;

  Coin({
    required this.baseId,
    required this.icon,
    required this.name,
    required this.initials,
    required this.price,
    required this.timestamp,
    required this.changeHour,
    required this.changeDay,
    required this.changeWeek,
    required this.changeMonth,
    required this.changeYear,
    required this.changeTotalPeriod,
  });
}
