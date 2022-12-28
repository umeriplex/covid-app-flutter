import 'package:covid_app_flutter/model/WorldStateModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pie_chart/pie_chart.dart';

import '../services/states_services.dart';
import 'countries.dart';

class WorldStats extends StatefulWidget {
  const WorldStats({Key? key}) : super(key: key);

  @override
  State<WorldStats> createState() => _WorldStatsState();
}

class _WorldStatsState extends State<WorldStats> with TickerProviderStateMixin {
  late final AnimationController _controller =
  AnimationController(vsync: this, duration: const Duration(seconds: 3))
    ..repeat();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  final colorList = <Color>[
    const Color(0xff4285f4),
    const Color(0xff1aa260),
    const Color(0xffde5246),
  ];

  @override
  Widget build(BuildContext context) {
    StatesServices ss = StatesServices();
    return Scaffold(
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * .01,
                ),
                FutureBuilder(
                    future: ss.getWorldStates(),
                    builder: (context,
                        AsyncSnapshot<WorldStateModel> snapshot) {
                      if (!snapshot.hasData) {
                        return Expanded(
                          flex: 1,
                          child: SpinKitSpinningLines(
                            color: Colors.white60,
                            size: 70,
                            controller: _controller,
                          ),);
                      }
                      else{
                        return Column(
                          children: [
                            PieChart(
                              dataMap:  {
                                'Total' : double.parse(snapshot.data!.cases!.toString()),
                                'Recovered' : double.parse(snapshot.data!.recovered!.toString()),
                                'Deaths' : double.parse(snapshot.data!.deaths!.toString()),
                              },
                              chartValuesOptions: const ChartValuesOptions(
                                showChartValuesInPercentage: true,
                              ),
                              animationDuration: const Duration(milliseconds: 1500),
                              chartType: ChartType.ring,
                              colorList: colorList,
                              chartRadius: MediaQuery
                                  .of(context)
                                  .size
                                  .width / 2.5,
                              ringStrokeWidth: 12,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: MediaQuery
                                      .of(context)
                                      .size
                                      .height * .04),
                              child: Card(
                                child: Column(
                                  children: [
                                    ReusableRow(title: 'Total', value: snapshot.data!.cases.toString()),
                                    ReusableRow(title: 'Recovered', value: snapshot.data!.recovered.toString()),
                                    ReusableRow(title: 'Deaths', value: snapshot.data!.deaths.toString()),
                                    ReusableRow(title: 'Today`s Cases', value: snapshot.data!.todayCases.toString()),
                                    ReusableRow(title: 'Today`s Recovered', value: snapshot.data!.todayRecovered.toString()),
                                    ReusableRow(title: 'Today`s Deaths', value: snapshot.data!.todayDeaths.toString()),
                                    ReusableRow(title: 'Active', value: snapshot.data!.active.toString()),
                                    ReusableRow(title: 'Population', value: snapshot.data!.population.toString()),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const CountryScreen()));
                                },
                                child: Container(
                                  height: 45,
                                  decoration: BoxDecoration(
                                    color: colorList[2],
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: colorList[2].withOpacity(.3),
                                        blurRadius: 10,
                                        offset: Offset(4, 8), // Shadow position
                                      ),
                                    ],
                                  ),
                                  child: const Center(
                                      child: Text(
                                        'F I N D  C O U N T R Y',
                                        style: TextStyle(color: Colors.white),
                                      )),
                                )),
                          ],
                        );
                      }
                    }),
              ],
            ),
          )),
    );
  }
}

class ReusableRow extends StatelessWidget {
  String title, value;

  ReusableRow({Key? key, required this.title, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, right: 10, left: 10, bottom: 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              Text(value),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Divider()
        ],
      ),
    );
  }
}

// 'Total' : double.parse(snapshot.data!.cases!.toString()),
// 'Recovered' : double.parse(snapshot.data!.recovered!.toString()),
// 'Deaths' : double.parse(snapshot.data!.deaths!.toString()),
