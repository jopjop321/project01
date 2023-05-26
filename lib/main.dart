import 'package:jstock/constants/imports.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());

  // (MultiProvider(
  //     providers: [
  //       // ChangeNotifierProvider(create: (_) => CounterModel()),
  //       // Provider(create: (_) => OtherModel()),
  //     ],
  //     child: MyApp(),),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      ),
    );
  }
}
