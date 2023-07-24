import 'package:MOYU/config/decoration.dart';
import 'package:MOYU/data/add_data_center.dart';
import 'package:MOYU/data/change_onsell_data_center.dart';
import 'package:MOYU/data/like_data_center.dart';
import 'package:MOYU/data/on_sell_data_center.dart';
import 'package:MOYU/data/search_result_data_center.dart';
import 'package:MOYU/model/home_page_featured_model.dart';
import 'package:MOYU/model/product_model.dart';
import 'package:MOYU/utils/token_util.dart';
import 'package:MOYU/view/index_page.dart';
import 'package:MOYU/view/login/login_page.dart';
import 'package:MOYU/view/register/user_initialization.dart';
import 'package:flutter/material.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:provider/provider.dart';

void main() async {
  //WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());

  //LCInstallation.getCurrentInstallation().saveInBackground();
  LeanCloud.initialize(
      '2NOIqAps19MPeBKbPiPHHYzb-gzGzoHsz', 'RDqWkuwJCfTMLpCv9mo2ILwE',
      server: 'https://2noiqaps.lc-cn-n1-shared.com',
      queryCache: LCQueryCache());
  // 在 LeanCloud.initialize 初始化之后执行

  //LCLogger.setLevel(LCLogger.DebugLevel);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TokenUtil()),
        ChangeNotifierProvider(create: (context) => AddDataCenter()),
        ChangeNotifierProvider(create: (context) => OnSellDataCenter()),
        ChangeNotifierProvider(create: (context) => ChangeOnSellDataCenter()),
        ChangeNotifierProvider(create: (context) => LikeDataCenter()),
        ChangeNotifierProvider(create: (context) => SearchResultDataCenter()),
        ChangeNotifierProvider(create: (context) => ProductModel()),
        ChangeNotifierProvider(create: (context) => HomePageFeaturedModel())
      ],
      child: Container(
        child: MaterialApp(
          title: 'MOYU',
          //onGenerateRoute: Application.router.generator,
          //debugShowCheckedModeBanner: false,
          theme: ThemeData(
              // This is the theme of your application.
              //
              // Try running your application with "flutter run". You'll see the
              // application has a blue toolbar. Then, without quitting the app, try
              // changing the primarySwatch below to Colors.green and then invoke
              // "hot reload" (press "r" in the console where you ran "flutter run",
              // or simply save your changes to "hot reload" in a Flutter IDE).
              // Notice that the counter didn't reset back to zero; the application
              // is not restarted.
              //primaryColorLight: Color.fromRGBO(128, 203, 196, 0.5),
              
              switchTheme: SwitchThemeData(
                trackColor: MaterialStateColor.resolveWith((states) {
                  if (states.contains(MaterialState.selected))
                    return Colors.black;
                  if (states.contains(MaterialState.focused))
                    return Colors.black;
                  return Colors.black12;
                }),
                overlayColor:
                    MaterialStateColor.resolveWith((states) => Colors.black),
                thumbColor:
                    MaterialStateColor.resolveWith((states) => Colors.black),
              ),
              listTileTheme: ListTileThemeData(
                iconColor: Colors.black,
                //shape: RoundedRectangleBorder(side: BorderSide(color: Colors.black38)),

                //selectedColor: Colors.black,
              ),
              floatingActionButtonTheme: FloatingActionButtonThemeData(
                  backgroundColor: Colors.black54),
              outlinedButtonTheme: OutlinedButtonThemeData(
                  style: ButtonStyle(
                      foregroundColor: MaterialStateColor.resolveWith(
                          (states) => Colors.black))),
              sliderTheme: SliderThemeData(
                  activeTrackColor: Colors.black,
                  activeTickMarkColor: Colors.black,
                  inactiveTrackColor: Colors.black38,
                  inactiveTickMarkColor: Colors.black38,
                  thumbColor: Colors.black),
              dialogTheme: DialogTheme(
                  contentTextStyle: TextStyle(color: Colors.black),
                  titleTextStyle: TextStyle(color: Colors.black)),
              tabBarTheme: TabBarTheme(labelColor: Colors.black),
              appBarTheme: AppBarTheme(
                  centerTitle: true,
                  //shadowColor: Colors.grey,
                  color: Colors.white,
                  iconTheme: IconThemeData(color: Colors.black, size: 35),
                  titleTextStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              //bottomAppBarColor: Colors.white,
              bottomNavigationBarTheme:
                  BottomNavigationBarThemeData(selectedItemColor: Colors.black),
              checkboxTheme: CheckboxThemeData(
                  side: BorderSide(color: Colors.black, width: 1.5)),
              chipTheme: ChipThemeData(
                  backgroundColor: Color.fromRGBO(236, 239, 241, 1),
                  selectedColor: Color.fromRGBO(197, 200, 201, 1)),
              unselectedWidgetColor: Colors.white30,
              bottomAppBarColor: Colors.black,
              iconTheme: IconThemeData(color: Colors.black),
              buttonTheme: ButtonThemeData(buttonColor: Colors.black),
              textButtonTheme: TextButtonThemeData(
                  style: ButtonStyle(
                      textStyle: MaterialStateTextStyle.resolveWith(
                          (states) => TextStyle(fontWeight: FontWeight.bold)),
                      foregroundColor: MaterialStateColor.resolveWith(
                          (states) => Colors.black))),
              elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith(
                          (states) => Colors.black))),
              inputDecorationTheme: InputDecorationTheme(
                hintStyle: TextStyle(color: Colors.black38, fontSize: 16),
                labelStyle: TextStyle(color: Colors.black, fontSize: 16),
                focusColor: Colors.black,
                prefixIconColor: Colors.black,
                iconColor: Colors.black,
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black38)),
              )
              //primaryColor: Colors.white,
              //bottomAppBarColor: Colors.white,

              //primaryColor: Color.fromARGB(255, 88, 181, 199),
              ),
          //home: const MyHomePage(title: 'Flutter Demo Home Page'),
          home: FirstPage(),
          //home: UserInitializationPage(),
        ),
      ),
    );
  }
}

class FirstPage extends StatelessWidget {
  FirstPage({Key? key}) : super(key: key);
  bool login = false;

  isLogin(BuildContext context) async {
    login = await Provider.of<TokenUtil>(context, listen: false).isLogin();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return loading();
          case ConnectionState.waiting:
            return loading();
          default:
            if (snapshot.hasError) {
              return SafeArea(
                  child: Card(
                child: Center(
                    child: SingleChildScrollView(
                        child: Text('程序君出错啦！  Error:$snapshot.error'))),
              ));
            } else {
              if (login == true) {
                var user = context.read<TokenUtil>().localuser;
                if (user['class'] != null) {
                  Provider.of<HomePageFeaturedModel>(context, listen: false)
                      .initData();
                  Provider.of<LikeDataCenter>(context, listen: false)
                      .initData(context);
                  return const IndexPage();
                } else {
                  return UserInitializationPage();
                }
              } else {
                return LoginPage();
              }
            }
        }
      },
      future: isLogin(context),
    );
  }
}

class loading extends StatelessWidget {
  const loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          margin: EdgeInsets.all(70),
          child: Center(
              child: Column(
            children: [
              Text(
                '程序君努力加载中……',
                style: TextStyleDefault.IndividualText,
              ),
              Container(
                height: 20,
              ),
              Image.asset('images/clip-loading.gif'),
              Container(
                height: 20,
              ),
            ],
          ))),
    ));
  }
}
