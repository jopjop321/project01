import 'package:jstock/constants/imports.dart';
import 'package:jstock/firebase_options.dart';
import 'package:jstock/view/nearyofstockScreen.dart';
import 'package:jstock/view/posScreen.dart';
import 'package:easy_localization/easy_localization.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en' , 'US'), Locale('th' , 'TH')],
      path: 'assets/langs',
      fallbackLocale: Locale('en', 'US'),
      saveLocale: true,
      child: MyApp(),
    ),
  );
  // runApp(MyApp());
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
        ChangeNotifierProvider(create: (context) => PosProvider()),
        ChangeNotifierProvider(create: (context) => ProfileProvider()),
      ],
      child: MaterialApp(
        title: 'Jstock',
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        // theme: ThemeData(
        //   primarySwatch: Colors.blue,
        // ),
        home: LogoScreen(),
        debugShowCheckedModeBanner: false,
        routes: {
          '/home': (context) => Home(),
          '/pos': (context) => PosScreen(),
          '/nos': (context) => NearyofstockScreen(),
        },
      ),
    );
  }
}
