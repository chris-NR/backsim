import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'background_cubit.dart';
import 'background_view.dart';

void main() {
  runApp(MaterialApp(
    title: 'Background Task Simulator',
    home: BlocProvider(
      create: (context) => BackgroundCubit(),
      child: const Scaffold(
        body: Center(
          child: BackgroundView(),
        ),
      ),
    ),
  ));
}
