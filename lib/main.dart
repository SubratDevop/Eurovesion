import 'package:eurovision/Screens/SplashScreen/SplashScreen.dart';
import 'package:eurovision/bloc/CustomerLogin_bloc.dart';
import 'package:eurovision/bloc/EnginerLogin_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'Screens/Customer/Login/CustomerLogin.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp( MyApp());
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
        debugShowCheckedModeBanner: false,
        title: 'Eurovesion',
        theme: ThemeData(
          
          hintColor: Colors.red, //^ accentColor: Colors.red,
          brightness: Brightness.light,
          primaryColor: Colors.amber,
          primarySwatch: Colors.indigo,
        ),

initialRoute: "/",
       routes: {
        "/" : (context) => SplashScreen(),
        "CustomerLogin" : (context)  => CustomerLogin(),
       },
        // home: SplashScreen(),
      ),
    );
  }
}


// main added newly