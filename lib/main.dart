import 'package:ev_testing_app/Screens/SplashScreen/SplashScreen.dart';
import 'package:ev_testing_app/bloc/CustomerLogin_bloc.dart';
import 'package:ev_testing_app/bloc/EnginerLogin_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:device_preview/device_preview.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp( MyApp());

// //! DevicePreview
//   runApp(DevicePreview(
//     enabled: !kReleaseMode,
//     builder: (context) => MyApp(),
//   ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<CustomerLoginBloc>(create: (context) => CustomerLoginBloc()),
        Provider<EngineerLoginBloc>(create: (context) => EngineerLoginBloc()),
      ],
      child: MaterialApp(
        useInheritedMediaQuery: true,
        locale: DevicePreview.locale(context),
        debugShowCheckedModeBanner: false,
        title: 'Eurovesion',
        theme: ThemeData(
          accentColor: Colors.red,
          brightness: Brightness.light,
          primaryColor: Colors.amber,
          primarySwatch: Colors.indigo,
        ),
        home: SplashScreen(),
      ),
    );
  }
}


// main added newly