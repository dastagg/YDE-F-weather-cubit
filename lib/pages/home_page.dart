import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_cubit/cubits/weather/weather_cubit.dart';
import 'package:weather_cubit/pages/search_page.dart';
import 'package:weather_cubit/widgets/error_dialog.dart';

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
      body: _showWeather(),
    );
  }
}

Widget _showWeather() {
  return BlocConsumer<WeatherCubit, WeatherState>(
    builder: (context, state) {
      if (state.status == WeatherStatus.initial) {
        return const Center(
          child: Text(
            'Select a city',
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
        );
      }

      if (state.status == WeatherStatus.loading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      if (state.status == WeatherStatus.error && state.weather.title == '') {
        return const Center(
          child: Text(
            'Select a city',
            style: TextStyle(fontSize: 18.0),
          ),
        );
      }

      return Center(
        child: Text(
          state.weather.title,
          style: const TextStyle(fontSize: 18.0),
        ),
      );
    },
    listener: (context, state) {
      if (state.status == WeatherStatus.error) {
        errorDialog(context, state.error.errMsg);
      }
    },
  );
}
