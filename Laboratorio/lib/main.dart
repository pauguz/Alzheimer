import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/login_viewmodel.dart';
import 'viewmodels/search_viewmodel.dart';
import 'services/api_service.dart';
import 'views/login_view.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final apiService = ApiService(); // 🔹 un solo servicio compartido

    return MultiProvider(
      providers: [
        Provider<ApiService>(create: (_) => ApiService()),

        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => SearchViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'PMV Flutter',
        theme: ThemeData(primarySwatch: Colors.indigo),
        home: const LoginView(),
      ),
    );
  }
}

