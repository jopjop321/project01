import 'package:jstock/constants/imports.dart';
import 'package:jstock/firebase_options.dart';
import 'package:jstock/view/outofstock.dart';
import 'package:jstock/view/posScreen.dart';


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(MyApp());

  // (MultiProvider(
  //     providers: [
  //       // ChangeNotifierProvider(create: (_) => CounterModel()),
  //       // Provider(create: (_) => OtherModel()),
  //     ],
  //     child: MyApp(),),);
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) {
            return TotlaProvider();
          },
        ),
      ],
      child: MaterialApp(
        title: 'Jstock',
        // theme: ThemeData(
        //   primarySwatch: Colors.blue,
        // ),
        home: LogoScreen(),
        debugShowCheckedModeBanner: false,
        routes: {
          '/pos': (context) => PosScreen(),
          '/oos': (context) => OutofstockScreen()
        },
      ),
    );
  }
}
