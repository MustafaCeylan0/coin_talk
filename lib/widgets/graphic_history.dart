// ignore_for_file: prefer_const_constructors, must_be_immutable, curly_braces_in_flow_control_structures, avoid_unnecessary_containers

import 'package:coin_talk/constants.dart';
import 'package:coin_talk/models/coin.dart';
import 'package:coin_talk/repositories/coin_repository.dart';
import 'package:coin_talk/theme_changer.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';

class GraphicHistory extends StatefulWidget {
  Coin coin;
  bool isDetailed;

  GraphicHistory({Key? key, required this.coin, required this.isDetailed})
      : super(key: key);

  @override
  _GraphicHistoryState createState() => _GraphicHistoryState();
}

enum Period { hour, day, week, month, year, total }

class _GraphicHistoryState extends State<GraphicHistory> {
  Period period = Period.day;
  List<Map<String, dynamic>> history = [];
  List completeData = [];
  List<FlSpot> graphicData = [];
  double maxX = 0;
  double maxY = 0;
  double minY = 0;
  ValueNotifier<bool> loaded = ValueNotifier(false);
  late CoinRepository repository;
  NumberFormat real = NumberFormat.currency(locale: 'pt_BR', name: '\$');

  setData() async {
    loaded.value = false;
    graphicData = [];

    if (history.isEmpty) {
      history = await repository.getCoinHistory(widget.coin);
    }

    completeData = history[period.index]['prices'];
    completeData = completeData.reversed.map((item) {
      double price = double.parse(item[0]);
      int time = int.parse(item[1].toString() + '000');
      return [price, DateTime.fromMillisecondsSinceEpoch(time)];
    }).toList();

    maxX = completeData.length.toDouble();
    maxY = 0;
    minY = double.infinity;

    for (var item in completeData) {
      maxY = item[0] > maxY ? item[0] : maxY;
      minY = item[0] < minY ? item[0] : minY;
    }

    for (int i = 0; i < completeData.length; i++) {
      graphicData.add(FlSpot(
        i.toDouble(),
        completeData[i][0],
      ));
    }
    loaded.value = true;
  }

  LineChartData getChartData() {
    return LineChartData(
      gridData: FlGridData(show: false),
      titlesData: FlTitlesData(show: false),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: maxX,
      minY: minY,
      maxY: maxY,
      lineBarsData: [
        LineChartBarData(
          spots: graphicData,
          isCurved: true,
          colors:
              getChange(period) > 0 ? positiveGraphColors : negativeGraphColors,
          barWidth: 2,
          dotData: FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            colors: getChange(period) > 0
                ? positiveGraphColors
                    .map((color) => color.withOpacity(0.15))
                    .toList()
                : negativeGraphColors
                    .map((color) => color.withOpacity(0.15))
                    .toList(),
          ),
        ),
      ],
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: ThemeProvider.themeOf(context).id == '2' ? Color(0xFF343434): Colors.white,
          getTooltipItems: (data) {
            return data.map((item) {
              final date = getDate(item.spotIndex);
              return LineTooltipItem(
                real.format(item.y),
                TextStyle(
                  
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
                children: [
                  TextSpan(
                    text: '\n $date',
                    style: TextStyle(
                      fontSize: 12,
                      color: ThemeProvider.themeOf(context).id == '2' ? Colors.white.withOpacity(0.5) : Colors.black.withOpacity(0.5),
                    ),
                  ),
                ],
              );
            }).toList();
          },
        ),
      ),
    );
  }

  getDate(int index) {
    DateTime date = completeData[index][1];
    if (period != Period.year && period != Period.total)
      return DateFormat('dd/MM - HH:mm').format(date);
    else
      return DateFormat('dd/MM/y').format(date);
  }

  chartButton(Period p, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: OutlinedButton(
        onPressed: () => setState(() => period = p),
        child: Text(label),
        style: (period != p)
            ? ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.grey),
              )
            : ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.indigo[50]),
              ),
      ),
    );
  }

  double getChange(Period p) {
    double change;
    switch (p) {
      case Period.hour:
        change = widget.coin.changeHour;
        break;
      case Period.day:
        change = widget.coin.changeDay;
        break;
      case Period.week:
        change = widget.coin.changeWeek;
        break;
      case Period.month:
        change = widget.coin.changeMonth;
        break;
      case Period.year:
        change = widget.coin.changeYear;
        break;
      case Period.total:
        change = widget.coin.changeTotalPeriod;
        break;
    }
    return change;
  }

  Text getChangeText(Period p) {
    double change = getChange(p);

    return Text(
      "%${(change * 100).toStringAsFixed(2)}",
      style: TextStyle(
          fontSize: 13,
          color: change.toDouble() > 0 ? Colors.green : Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    repository = context.read<CoinRepository>();
    setData();

    return Container(
      child: AspectRatio(
        aspectRatio: 2,
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                widget.isDetailed
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network(
                            widget.coin.icon,
                            scale: 2.5,
                          ),
                          Container(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                real.format(widget.coin.price),
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: -1,
                                  color: Colors.deepPurple,
                                ),
                              ),
                              getChangeText(period),
                            ],
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Container(
                            width: 120,
                            height: 60,
                            child: CupertinoPicker(
                              scrollController:
                                  FixedExtentScrollController(initialItem: 1),
                              backgroundColor: Colors.red.withOpacity(0),
                              itemExtent: 32.0,
                              onSelectedItemChanged: (selectedIndex) {
                                setState(() {
                                  switch (selectedIndex) {
                                    case 0:
                                      period = Period.hour;
                                      break;
                                    case 1:
                                      period = Period.day;
                                      break;
                                    case 2:
                                      period = Period.week;
                                      break;
                                    case 3:
                                      period = Period.month;
                                      break;
                                    case 4:
                                      period = Period.year;
                                      break;
                                    case 5:
                                      period = Period.total;
                                      break;
                                  }
                                });
                              },
                              children: [
                                Center(
                                  child: Text(
                                    "1${UserData.getText(UiTexts.hour)}",
                                    style: TextStyle(
                                        color: ThemeProvider.themeOf(context).id == '2'
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    "24${UserData.getText(UiTexts.hour)}",
                                    style: TextStyle(
                                        color: ThemeProvider.themeOf(context).id == '2'
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    "7${UserData.getText(UiTexts.day)}",
                                    style: TextStyle(
                                        color: ThemeProvider.themeOf(context).id == '2'
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    "1${UserData.getText(UiTexts.month)}",
                                    style: TextStyle(
                                        color: ThemeProvider.themeOf(context).id == '2'
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    "1${UserData.getText(UiTexts.year)}",
                                    style: TextStyle(
                                        color: ThemeProvider.themeOf(context).id == '2'
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    "${UserData.getText(UiTexts.all)}",
                                    style: TextStyle(
                                        color: ThemeProvider.themeOf(context).id == '2'
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : Material(),
              ],
            ),
            //OLD PADDING HERE
            Padding(
              padding: !widget.isDetailed
                  ? EdgeInsets.all(0)
                  : const EdgeInsets.only(top: 80),
              child: ValueListenableBuilder(
                valueListenable: loaded,
                builder: (context, bool isLoaded, _) {
                  return (isLoaded)
                      ? LineChart(
                        getChartData(),
                      )
                      : Center(
                          child: CircularProgressIndicator(),
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
