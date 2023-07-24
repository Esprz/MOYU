import 'package:MOYU/config/decoration.dart';
import 'package:MOYU/model/home_page_featured_model.dart';
import 'package:MOYU/utils/router_util.dart';
import 'package:MOYU/utils/token_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserInitializationPage extends StatefulWidget {
  @override
  State<UserInitializationPage> createState() => _UserInitializationPageState();
}

class _UserInitializationPageState extends State<UserInitializationPage> {
  final TextEditingController _qqController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _wechatController = TextEditingController();
  //final PageController _Controller = PageController(keepPage: false);

  bool isInputValid = false;
  bool isInputClass = false, isInputGrade = false;

  var _nowpage = 0;

  void _checkInputValid() {
    isInputValid = (_qqController.text != '') ||
        (_wechatController.text != '') ||
        (_phoneController.text != '') ||
        (_contactInClass == true);
    return;
    //if (isInputValid == canLogin) {
    //  return;
    //}
    //setState(() => canLogin = isInputValid);
  }

  double _class = 1, _grade = 10;
  bool _contactInClass = false;
  //int _actpageNum = 0;

  // //PageScrollPhysics _physicsController =
  //     PageScrollPhysics(parent: NeverScrollableScrollPhysics());
  PageController _Controller = PageController();
  TextStyle warntext = TextStyle(fontSize: 16);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nowpage = 0;
  }

  @override
  Widget build(BuildContext context) {
    var Swidth = MediaQuery.of(context).size.width,
        Sheight = MediaQuery.of(context).size.height;

    return SafeArea(
        child: Stack(
      children: [
        Scaffold(
          body: Container(
            width: Swidth,
            height: Sheight,
            alignment: Alignment.center,
            child: Center(
              child: PageView(
                //pageSnapping: false,
                //allowImplicitScrolling: true,
                //physics: _physicsController,
                onPageChanged: (value) {
                  switch (value) {
                    case 0:
                      setState(() {
                        _nowpage = 0;
                      });
                      break;
                    case 1:
                      if (isInputGrade == false) {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  content: Text(
                                    '请填写年段',
                                    style: warntext,
                                  ),
                                  actions: [
                                    BackButton(
                                      color: Colors.black,
                                      onPressed: () {
                                        RouterUtil.pop(context);
                                        _Controller.previousPage(
                                            duration: Duration(milliseconds: 1),
                                            curve: Curves.bounceIn);
                                      },
                                    )
                                  ],
                                ));
                      } else {
                        setState(() {
                          _nowpage = 1;
                        });
                        Provider.of<TokenUtil>(context, listen: false)
                            .setUserGrade('${_grade.ceil()}', context);
                      }
                      break;
                    case 2:
                      if (isInputClass == false) {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  content: Text(
                                    '请填写班级',
                                    style: warntext,
                                  ),
                                  actions: [
                                    BackButton(
                                      color: Colors.black,
                                      onPressed: () {
                                        RouterUtil.pop(context);
                                        _Controller.previousPage(
                                            duration: Duration(milliseconds: 1),
                                            curve: Curves.bounceIn);
                                      },
                                    )
                                  ],
                                ));
                      } else {
                        setState(() {
                          _nowpage = 2;
                        });
                        Provider.of<TokenUtil>(context, listen: false)
                            .setUserClass('${_class.ceil()}', context);
                      }
                      break;
                    case 3:
                      _checkInputValid();
                      //print('11111111111111');
                      if (isInputValid == false) {
                        //print('33333333333333');
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  content: Text(
                                    '至少填写一项联系方式',
                                    style: warntext,
                                  ),
                                  actions: [
                                    BackButton(
                                      color: Colors.black,
                                      onPressed: () {
                                        RouterUtil.pop(context);
                                        _Controller.previousPage(
                                            duration: Duration(milliseconds: 1),
                                            curve: Curves.bounceIn);
                                      },
                                    )
                                  ],
                                ));
                      } else {
                        setState(() {
                          _nowpage = 3;
                        });
                        Provider.of<TokenUtil>(context, listen: false)
                            .setUserContactWay(
                                _phoneController.text,
                                _qqController.text,
                                _wechatController.text,
                                _contactInClass,
                                context);
                      }
                      //print('222222222222');
                      break;
                    default:
                  }
                },
                // physics: (_Controller.page == _actpageNum)
                //   ? PageScrollPhysics()
                //    : NeverScrollableScrollPhysics(),
                controller: _Controller,
                children: <Widget>[
                  InputGrade(),
                  InputClass(),
                  InputContactInfo(),
                  LastPage()
                ],
              ),
            ),
          ),
        ),
        Positioned(
            bottom: 10,
            child: Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                    4,
                    (index) => Container(
                          margin: EdgeInsets.all(3),
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _nowpage == index
                                  ? Colors.black
                                  : Colors.black26),
                        )),
              ),
            )),
      ],
    ));
  }

  Widget InputGrade() {
    return Container(
      margin: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
              width: 200,
              margin: EdgeInsets.all(40),
              child: Image.asset('images/student_colour_400px.png')),
          Container(
            height: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(left: 15),
                child: Text('你的年段？${_grade.ceil()} 年级',
                    style: TextStyleDefault.IndividualText),
              ),
              Container(
                height: 10,
              ),
              Slider(
                value: _grade,
                onChanged: (double i) {
                  setState(() {
                    _grade = i;
                    isInputGrade = true;
                  });
                },
                min: 10,
                max: 12,
                divisions: 2,
                //label: '${_grade.ceil()}年级',
              ),
            ],
          ),
          Container(
            height: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                margin: EdgeInsets.only(right: 25),
                child: Text(
                  '划动滑动条切换',
                  style: TextStyle(color: Colors.black54),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 25),
                child: Text(
                  '请选择真实年段，将作为收发货地址哦',
                  style: TextStyle(color: Colors.black54),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget InputClass() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(30)),
              width: 250,
              padding: EdgeInsets.all(30),
              child: Image.asset('images/delivery.png')),
          Container(
            height: 25,
          ),
          Container(
            margin: EdgeInsets.only(left: 15),
            child: Text('你的班级？${_class.ceil()} 班',
                style: TextStyleDefault.IndividualText),
          ),
          Container(
            height: 10,
          ),
          Slider(
            value: _class,
            onChanged: (double i) {
              setState(() {
                _class = i;
                isInputClass = true;
              });
            },
            min: 1,
            max: 16,
            divisions: 15,
            //label: '${_class.ceil()}',
          ),
          Container(
            margin: EdgeInsets.fromLTRB(30, 10, 30, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '划动滑动条切换',
                  style: TextStyle(color: Colors.black54),
                ),
                Text(
                  '请选择真实班级，将作为收发货地址哦',
                  style: TextStyle(color: Colors.black54),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget InputContactInfo() {
    return SingleChildScrollView(
      child: Container(
        //decoration: DefaultDecoration.gooditemDec,
        margin: EdgeInsets.all(20),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 50,
              ),
              Image.asset('images/chat.png'),
              Container(
                margin: EdgeInsets.all(20),
                child: Text('联系方式?（至少填写一项）',
                    style: TextStyleDefault.IndividualText),
              ),
              TextField(
                decoration: InputDecoration(
                    labelText: "手机号", prefixIcon: Icon(Icons.class_outlined)),
                textInputAction: TextInputAction.next,
                //onChanged: _checkInputValid,
                controller: _phoneController,
                keyboardType: TextInputType.number,
                //inputFormatters: [],
              ),
              TextField(
                decoration: InputDecoration(
                    labelText: "QQ", prefixIcon: Icon(Icons.class_outlined)),
                textInputAction: TextInputAction.next,
                //onChanged: _checkInputValid,
                controller: _qqController,
                keyboardType: TextInputType.number,
                //inputFormatters: [],
              ),
              TextField(
                decoration: InputDecoration(
                    labelText: "微信", prefixIcon: Icon(Icons.class_outlined)),
                //textInputAction: TextInputAction.next,
                //onChanged: _checkInputValid,
                controller: _wechatController,
                //inputFormatters: [],
              ),
              /*
              ListTile(
                  leading: Icon(Icons.real_estate_agent_outlined),
                  title: Text(
                    '到班当面交涉',
                    style: TextStyle(fontSize: 16),
                  ),
                  trailing: Switch(
                      value: _contactInClass,
                      onChanged: (bool i) {
                        setState(() {
                          _contactInClass = i;
                        });
                      })),*/
            ]),
      ),
    );
  }

  Widget LastPage() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
              'images/clip-starting-new-chapter-in-life-with-education.png'),
          Text(
            '恭 喜 你, 设 置 完 毕',
            style: TextStyle(fontSize: 20),
          ),
          Container(
            height: 20,
          ),
          Text('欢 迎 来 到 M O Y U !', style: TextStyle(fontSize: 30)),
          Container(
            height: 30,
          ),
          Container(
              padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Color.fromARGB(255, 169, 199, 243)),
              child: InkWell(
                onTap: () {
                  var user = context.read<TokenUtil>().localuser;
                  Provider.of<TokenUtil>(context, listen: false)
                      .saveLoginInfo(user);
                  Provider.of<HomePageFeaturedModel>(context, listen: false)
                      .initData();
                  RouterUtil.toIndexPage(context);
                },
                child: Container(
                  child: Text(' 进 入 ', style: TextStyle(fontSize: 23)),
                ),
              )),
          /*
          OutlinedButton(
            onPressed: () {},
            child: Text('进入', style: TextStyle(fontSize: 20)),
          ),*/

          /*
          */
        ],
      ),
    );
  }
}
