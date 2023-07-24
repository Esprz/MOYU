import 'package:MOYU/config/decoration.dart';
import 'package:flutter/material.dart';
import 'package:MOYU/data/search_result_data_center.dart';
import 'package:MOYU/utils/router_util.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class CategorizePage extends StatefulWidget {
  @override
  State<CategorizePage> createState() => _CategorizePageState();
}

class _CategorizePageState extends State<CategorizePage> {
  late double Screenwidth, Screenheight;
  String _selectGrade = '';

  String bookname = '';

  bool selectListview = true;

  TextEditingController newbookname = TextEditingController();

  List<String> versionItems = ['旧教材', '新教材'];
  List<bool> _versionselect = [false, false];

  List<String> tagItems = ['高一', '高二', '高三', '高中综合'];
  List<bool> _tagselect = [false, false, false, false];
  var _BookVersion;

  List<String> subjectItems = [
    '全部',
    '语文',
    '数学',
    '英语',
    '物理',
    '化学',
    '生物',
    '历史',
    '地理',
    '政治',
    '其他'
  ];

  List<String> subjectImgs = [
    'images/clip-1710.png',
    'images/literature_clip-305.png',
    'images/math_clip-352.png',
    'images/ikigai-school-teacher-checks-the-assignment.png',
    'images/physics_clip-1639.png',
    'images/chemistry_clip-science-research.png',
    'images/biology_clip-1653.png',
    'images/history_thegreatwall_monochromatic.png',
    'images/geography_clip-238.png',
    'images/politics_clip-politician.png',
    'images/clip-library.png'
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Screenwidth = MediaQuery.of(context).size.width;
    Screenheight = MediaQuery.of(context).size.height;

    List<Tab> _tabs = [
      Tab(
        text: '教辅',
      ),
      /*
      Tab(
        text: '工具书',
      )*/
    ];

    //var Orderlist=context.read<OrderDataCenter>();
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: TextField(
                style: TextStyle(color: Colors.black),
                controller: newbookname,
                decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black87)),
                    hintText: "搜索",
                    hintStyle: TextStyle(color: Colors.black38))),
            bottom: TabBar(tabs: _tabs),
            actions: <Widget>[
              IconButton(
                  onPressed: () async {
                    await Provider.of<SearchResultDataCenter>(context,
                            listen: false)
                        .initSearchData(newbookname.text, [], '',[], context);
                    RouterUtil.toSearchResultPage(context);
                  },
                  icon: const Icon(Icons.search))
            ],
          ),
          body: TabBarView(
              //controller: ,
              children: [
                SafeArea(
                    child: Container(
                        margin: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '筛选',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            
                            Container(
                              height: 5,
                            ),
                            _selectBookVersion(context),
                            Container(
                              height: 5,
                            ),
                            _gradeButton(context),
                            Divider(
                              color: Colors.black26,
                              thickness: 0.8,
                            ),
                            Expanded(
                              child: Container(
                                  margin: EdgeInsets.all(20),
                                  child: _subjectButton(context)),
                            ),
                          ],
                        ))),
                /*
                SafeArea(
                    //maintainBottomViewPadding: ,
                    child: Container(
                        margin: EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          children: [
                            /*
                        Divider(
                          color: Colors.black38,
                          thickness: 0.8,
                        ),
                        Expanded(
                          child: _subjectButton(context),
                        ),*/
                          ],
                        ))),*/
              ])),
    );
  }

  Widget _subjectButton(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: 30,
        mainAxisSpacing: 30,
        crossAxisCount: 2,
      ),
      itemCount: subjectItems.length,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          child: Stack(
            children: [
              Container(
                alignment: Alignment.center,
                //child: Opacity(opacity: 0.5),
                decoration: BoxDecoration(
                  image: subjectImgs[index] != ''
                      ? DecorationImage(image: AssetImage(subjectImgs[index]))
                      : null,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              Positioned.fill(
                  child: Opacity(
                opacity: 0.2,
                child: Container(decoration: DefaultDecoration.gooditemDec),
              )),
              Positioned.fill(
                child: Text(subjectItems[index],
                    style: TextStyle(
                        shadows: [
                          Shadow(
                            color: Colors.white,
                            offset: Offset.fromDirection(150),
                            blurRadius: 1,
                          )
                        ],
                        fontWeight: FontWeight.w500,
                        fontSize: 26,
                        letterSpacing: 1,
                        fontFamily: 'YangRenDongZhuShiTi')),
              )
            ],
          ),
          onTap: () async {
            List<String> _tags = [];
            for (int i = 0; i < tagItems.length; i++) {
              if (_tagselect[i] == true) _tags.add(tagItems[i]);
            }
            List<String> _versions=[];
            for (int i = 0; i < versionItems.length; i++) {
              if (_versionselect[i] == true) _versions.add(versionItems[i]);
            }
            await Provider.of<SearchResultDataCenter>(context, listen: false)
                .initSearchData('', _tags, subjectItems[index], _versions, context);
            RouterUtil.toSearchResultPage(context);
          },
        );
      },
    );
  }

  Widget _gradeButton(BuildContext context) {
    String _selectGrade = '高一';
    return Container(
      width: Screenwidth,
      height: 35,
      child: Row(
        children: [
          Text('年级: '),
          Expanded(
            child: ListView.builder(
                itemCount: tagItems.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: ((context, index) => Container(
                      margin: EdgeInsets.only(left: 5),
                      child: FilterChip(
                          showCheckmark: true,
                          label: Text(tagItems[index]),
                          selected: _tagselect[index],
                          onSelected: (bool v) {
                            setState(() {
                              _tagselect[index] = v;
                            });
                          }),
                    ))),
          ),
        ],
      ),
    );
  }

  Widget _selectBookVersion(BuildContext context) {
    return Container(
      width: Screenwidth,
      height: 35,
      child: Row(
        children: [
          Text('版本: '),
          Expanded(
            child: ListView.builder(
                itemCount: versionItems.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: ((context, index) => Container(
                      margin: EdgeInsets.only(left: 5),
                      child: FilterChip(
                          showCheckmark: true,
                          label: Text(versionItems[index]),
                          selected: _versionselect[index],
                          onSelected: (bool v) {
                            setState(() {
                              _versionselect[index] = v;
                            });
                          }),
                    ))),
          ),
        ],
      ),
    );
  }
}


/*Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.start,
            children: List.generate(
                subjectItems.length,
                (index) => InkWell(
                    child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromARGB(150, 186, 239, 246)),
                        margin: EdgeInsets.all(3),
                        alignment: Alignment.center,
                        child: Text(subjectItems[index],
                            style: TextStyle(
                                fontSize: 26,
                                letterSpacing: 1,
                                fontFamily: 'YangRenDongZhuShiTi'))),
                    onTap: () async {
                      /*
                      List<String> _characters = [];
                      if (_BookVersion != '')
                        _characters.add(_BookVersion);
                      if (_selectGrade != '')
                        _characters.add(_selectGrade);

                      //if(subjectItems[index]!='全部')_characters.add(subjectItems[index]);
                      await Provider.of<SearchResultDataCenter>(context,
                              listen: false)
                          .initCategorizefromManyTagsData(
                              _characters, subjectItems[index], context);
                      RouterUtil.toSearchResultPage(context);*/
                    })),
          )*/


/*
return Container(
      height: 50,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(20),
                  color: _BookVersion == '新教材' ? Colors.black : Colors.white70,
                ),
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _BookVersion = '新教材';
                    });
                  },
                  child: Text(
                    '新教材',
                    style: TextStyle(
                        color: _BookVersion == '新教材'
                            ? Color.fromARGB(255, 235, 194, 194)
                            : Colors.black),
                  ),
                ),
              ),
              Container(
                width: 20,
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(20),
                    color: _BookVersion == '旧教材' ? Colors.black : Colors.white),
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _BookVersion = '旧教材';
                    });
                  },
                  child: Text(
                    '旧教材',
                    style: TextStyle(
                        color: _BookVersion == '旧教材'
                            ? Colors.white
                            : Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
*/


/*
Container(
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide.none,
                left: BorderSide.none,
                bottom: BorderSide.none,
                right: BorderSide(
                  color: Colors.black38,
                ))),
        width: Screenwidth * 0.2,
        child: ListView.builder(
          itemCount: leftbarItems.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              child: InkWell(
                child: Container(
                    decoration: BoxDecoration(
                        color: _selectGrade == leftbarItems[index]
                            ? Colors.black
                            : Colors.white,
                        border: Border(
                            top: BorderSide.none,
                            left: BorderSide.none,
                            right: BorderSide.none,
                            bottom: BorderSide(
                              color: Colors.black38,
                            ))),
                    height: Screenwidth * 0.2,
                    alignment: Alignment.center,
                    child: Text(leftbarItems[index],
                        style: TextStyle(
                            color: _selectGrade == leftbarItems[index]
                                ? Colors.white
                                : Colors.black))),
                onTap: () {
                  setState(() {
                    _selectGrade = leftbarItems[index];
                  });
                },
              ),
            );
          },
        ));
*/