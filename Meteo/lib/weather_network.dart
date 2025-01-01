import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meteo/weather_record.dart';

import 'main.dart';

class DataFetcherState extends State<DataFetcher> with SingleTickerProviderStateMixin {
  String _data = "Fetching data...";
  String villeTarget;
  List<WeatherRecord> listWeatherRecord = [];


  DataFetcherState(this.villeTarget);

  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    debugPrint('init');
    super.initState();
    _fetchData();

    // Initialiser l'AnimationController
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      // Durée de l'animation (2 secondes)
      vsync: this,
      // Le TickerProvider (SingleTickerProviderStateMixin)
    );

    // Animation d'opacité (de 0 à 1)
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
        // Courbe d'animation pour un mouvement fluide
      ),
    );

    // Initialiser l'animation à la dernière frame (opacité = 1.0)
    _controller.value = 1.0; // Démarrer avec l'opacité maximale
  }
  void _startFadeAnimation() {
    // Réinitialiser l'animation à chaque appui
    _controller.reset();
    _controller.forward(); // Démarrer l'animation (fade-in)
  }
  @override
  void dispose() {
    _controller.dispose(); // Libérer les ressources lorsque le widget est détruit
    super.dispose();
  }

  Future<void> _fetchData() async {
    final url = Uri.parse(
        'http://api.openweathermap.org/data/2.5/forecast?'
            'q=$villeTarget&'
            'appid=405cabb2b4f4241d227cc64025cf6aab');
    debugPrint('fetchingData');
    listWeatherRecord = [];

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        setState(() {

          String city = json['city']['name'];
          String country = json['city']['country'];
          DateTime timestamp;// = json['city']['country'];
          String state;
          String descriptionState;
          double temp = -1, rain = -1;
          int humidity;
          _data = "$city in $country";

          for (final v in json['list']) {
            // debugPrint('v=$v');
            debugPrint('');
            timestamp = DateTime.parse(v['dt_txt']);
            debugPrint("timestamp=$timestamp");
            state = v['weather'][0]['main'];
            debugPrint("state=$state");
            descriptionState = v['weather'][0]['description'];
            debugPrint("descriptionState=$descriptionState");
            debugPrint('vPop=${v['pop']}');
            debugPrint('type=${v['pop'].runtimeType}}');
            if (v['main']['temp'] is int) {
              temp = v['main']['temp'].toDouble();
              debugPrint("temp=$temp");
            }
            if (v['main']['temp'] is double) {
              temp = v['main']['temp'];
              debugPrint("temp=$temp");
            }
            if (v['pop'] is int) {
              rain = (v['pop'].toDouble())*100;
              debugPrint("rain=$rain");
            }
            if (v['pop'] is double) {
              rain = (v['pop'])*100;
              debugPrint("rain=$rain");
            }
            humidity = v['main']['humidity'];
            debugPrint("humidity=$humidity");

            WeatherRecord aUnit = WeatherRecord(city, country, timestamp, state, descriptionState, temp, rain, humidity);
            listWeatherRecord.add(aUnit);
            debugPrint("aUnit=$aUnit");
          }

          debugPrint('list=$listWeatherRecord');
          _startFadeAnimation();
        });
      } else {
        setState(() {
          _data = "Error: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        _data = "Failed to fetch data: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> listWidget = [];
    listWidget.add(
      Padding(
          padding: const EdgeInsets.all(16.0),
          child: SearchBar(
            hintText: "Une ville",
            onSubmitted: (value) {
              debugPrint("userInput=$value");
              setState(() {
                villeTarget=value;
              });
              _fetchData();
            },
          )
      )
    );
    listWidget.add(Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Text(
        _data,
        style: const TextStyle(fontSize: 18),
        textAlign: TextAlign.center,
      ),));
    listWidget.add(Container(
      margin: const EdgeInsets.only(left: 16, right: 16),
      child: ElevatedButton(
        onPressed: () {
          _fetchData();
        },
        child: const Text('Reload'),),
      ));

    List<WeatherRecord> listDejaVu = [];
    Set<String> setDejaVuDate = {};
    List<WeatherRecord> listOneWeatherRecordPerDay = [];
    for (var aRecord in listWeatherRecord) {
      if (setDejaVuDate.contains(DateFormat('yyyy-MM-dd').format(aRecord.timestamp))) {
        listDejaVu.add(aRecord);
      } else {
        listOneWeatherRecordPerDay.add(aRecord);
        setDejaVuDate.add(DateFormat('yyyy-MM-dd').format(aRecord.timestamp));
      }
    }
    for (var v in listOneWeatherRecordPerDay) {
      List<Widget> listInfoColumn = [];
      // Container infoContainer = Column(children: [],);
      // listWidget.add(Center())
      listInfoColumn.add(Text(DateFormat('EEEE').format(v.timestamp)));
      listInfoColumn.add(Text('${v.temp}°K'));
      listInfoColumn.add(Text(v.state));
      listInfoColumn.add(Text('Humidity: ${v.humidity}%'));
      listInfoColumn.add(Text('${v.rain}% chance of rain'));

      ImageProvider<Object> imgWidget;
      if (v.state == "Clear") {
        imgWidget = Image.asset('assets/soleil.png').image;
      } else if (v.state == "Clouds") {
        imgWidget = Image.asset('assets/nuage.png').image;
      } else if (v.state == "Snow") {
        imgWidget = Image.asset('assets/neige.png').image;
      } else if (v.state == "Rain") {
        imgWidget = Image.asset('assets/pluit.png').image;
      } else {
        imgWidget = Image.asset('assets/smile.png').image;
      }

      listInfoColumn.add(Flexible(
          flex: 1,
          child: Image(
              image: imgWidget
          )
      ));


      Container c = Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          margin: const EdgeInsets.all(16.0), // Marge externe
          padding: const EdgeInsets.all(12.0), // Espacement interne
          child: Column(
              children: listInfoColumn
          )
      );

      AnimatedBuilder animatedBuilder = AnimatedBuilder(
        animation: _opacityAnimation, // Animation d'opacité
        builder: (context, child) {
          return Opacity(
            opacity: _opacityAnimation.value, // Appliquer la valeur d'opacité
            child: SizedBox(
              width: 200.0,
              height: 200.0,
              child: c
            ),
          );
        },
      );


      listWidget.add(animatedBuilder);
    }


    return Center(
        child: ListView(children: listWidget)
    );
  }
}