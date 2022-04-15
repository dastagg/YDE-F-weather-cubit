import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_cubit/cubits/weather/weather_cubit.dart';
import 'package:weather_cubit/pages/search_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _city;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              _city = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return const SearchPage();
                }),
              );
              print(_city);
              if (_city != null) {
                context.read<WeatherCubit>().fetchWeather(_city!);
              }
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('Home'),
      ),
    );
  }
}
