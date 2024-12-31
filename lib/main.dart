import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyectofinal/pages/bloc/ebook_bloc.dart';
import 'package:proyectofinal/pages/main_page.dart';

void main() {
  runApp(
    BlocProvider(
      create: (context) => EbookBloc()
        ..add(LoadTrendingProductsEvent())
        ..add(LoadMostRecentReadingProductEvent())
        ..add(LoadCartItemsEvent()),
      child: const MaterialApp(
        home: MainPage(),
        debugShowCheckedModeBanner: false,
      ),
    ),
  );
}