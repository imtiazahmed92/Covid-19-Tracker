import 'package:covid_19_tracker/Model/WorldStatesModel.dart';
import 'package:covid_19_tracker/Services/states_services.dart';
import 'package:covid_19_tracker/View/countries_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pie_chart/pie_chart.dart';

class WorldStatesScreen extends StatefulWidget {
  const WorldStatesScreen({Key? key}) : super(key: key);

  @override
  State<WorldStatesScreen> createState() => _WorldStatesScreenState();
}

class _WorldStatesScreenState extends State<WorldStatesScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(duration: Duration(seconds: 1), vsync: this)
        ..repeat();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  final _colorList = <Color>[
    const Color(0xff4285F4),
    const Color(0xff1aa268),
    const Color(0xffde5246)
  ];

  @override
  Widget build(BuildContext context) {
    StateServices stateServices = StateServices();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Covid Tracker'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * .01,
              ),
              FutureBuilder(
                  future: stateServices.fetchWorldStatesRocords(),
                  builder: (context, AsyncSnapshot<WorldStatesModel> snapshot) {
                    if (!snapshot.hasData) {
                      return Expanded(
                        flex: 1,
                        child: SpinKitFadingCircle(
                          color: Colors.white,
                          size: 50,
                          controller: _controller,
                        ),
                      );
                    } else {
                      return Column(
                        children: [
                          PieChart(
                            dataMap: {
                              'Total':
                                  double.parse(snapshot.data!.cases.toString()),
                              'Recovered': double.parse(
                                  snapshot.data!.recovered.toString()),
                              'Death': double.parse(
                                  snapshot.data!.deaths.toString()),
                            },
                            chartValuesOptions: const ChartValuesOptions(
                              showChartValuesInPercentage: true,
                            ),
                            chartRadius:
                                MediaQuery.of(context).size.width / 3.2,
                            legendOptions:const LegendOptions(
                                legendPosition: LegendPosition.left),
                            animationDuration:const Duration(milliseconds: 1200),
                            chartType: ChartType.ring,
                            colorList: _colorList,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical:
                                    MediaQuery.of(context).size.height * .06),
                            child: Card(
                              child: Column(
                                children: [
                                  ReusableRow(
                                    tittle: 'Total',
                                    value: snapshot.data!.cases.toString(),
                                  ),
                                  ReusableRow(
                                    tittle: 'Deaths',
                                    value: snapshot.data!.deaths.toString(),
                                  ),
                                  ReusableRow(
                                    tittle: 'Recovered',
                                    value: snapshot.data!.recovered.toString(),
                                  ),
                                  ReusableRow(
                                    tittle: 'Active',
                                    value: snapshot.data!.active.toString(),
                                  ),
                                  ReusableRow(
                                    tittle: 'Critical',
                                    value: snapshot.data!.critical.toString(),
                                  ),
                                  ReusableRow(
                                    tittle: 'Today Deaths',
                                    value:
                                        snapshot.data!.todayDeaths.toString(),
                                  ),
                                  ReusableRow(
                                    tittle: 'Today Recovered',
                                    value: snapshot.data!.todayRecovered
                                        .toString(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const CountriesListScreen()));
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: const Color(0xff1aa260),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                child: Text('Track Countries'),
                              ),
                            ),
                          )
                        ],
                      );
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

class ReusableRow extends StatelessWidget {
  String tittle, value;

  ReusableRow({Key? key, required this.tittle, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(tittle),
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
