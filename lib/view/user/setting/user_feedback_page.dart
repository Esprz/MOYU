import 'dart:io';
import 'package:MOYU/utils/router_util.dart';
import 'package:MOYU/utils/token_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:provider/provider.dart';

class UserFeedbackPage extends StatefulWidget {
  UserFeedbackPage({Key? key}) : super(key: key);

  @override
  State<UserFeedbackPage> createState() => _UserFeedbackPageState();
}

class _UserFeedbackPageState extends State<UserFeedbackPage> {
  TextEditingController _emailbody = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('用户反馈'),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color.fromARGB(197, 90, 164, 174),
          onPressed: () async {
            _addImage(context);
          },
          child: Icon(Icons.add_a_photo,),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(30),
            child: Column(
              children: [
                Container(
                  height: 300,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      border: Border.all(color: Color.fromARGB(197, 90, 164, 174),width: 2),
                      borderRadius: BorderRadius.circular(8)),
                  child: TextField(
                    controller: _emailbody,
                    maxLines: 15,
                  ),
                ),
                Container(
                  height: 20,
                ),
                Container(
                  height: 80,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: showAttachments.length,
                      itemBuilder: ((context, index) => Container(
                            margin: EdgeInsets.only(right: 10),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onLongPress: (() {
                                showDialog(
                                    context: context,
                                    builder: (context) => CupertinoAlertDialog(
                                          title: Text('确认删除？'),
                                          actions: [
                                            CupertinoDialogAction(
                                                textStyle: TextStyle(
                                                    color: Colors.black),
                                                child: Text('确认'),
                                                onPressed: () {
                                                  attachments.removeAt(index);
                                                  setState(() {
                                                    showAttachments
                                                        .removeAt(index);
                                                  });
                                                  RouterUtil.pop(context);
                                                }),
                                            CupertinoDialogAction(
                                                textStyle: TextStyle(
                                                    color: Colors.black),
                                                child: Text('取消'),
                                                onPressed: () =>
                                                    RouterUtil.pop(context)),
                                          ],
                                        ));
                              }),
                              child: Image.file(
                                showAttachments[index],
                                width: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ))),
                ),
                Container(
                  height: 20,
                ),
                ElevatedButton(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.resolveWith((states) =>
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20))),
                        backgroundColor: MaterialStateProperty.resolveWith(
                            (states) => Color.fromARGB(197, 90, 164, 174))),
                    child: Container(
                        width: 300,
                        height: 50,
                        alignment: Alignment.center,
                        child: Text(
                          '提  交',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        )),
                    onPressed: () async {
                      await _sendEmail(context);
                    }),

                
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<FileAttachment> attachments = [];

  List<File> showAttachments = [];

  _addImage(BuildContext context) async {
    var _picker = ImagePicker();
    var img = await _picker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      var _file = new File(img.path);

      attachments.add(FileAttachment(_file));
      setState(() {
        showAttachments.add(_file);
      });
    }
  }

  _sendEmail(BuildContext context) async {
    var _user = context.read<TokenUtil>().localuser;
    var _sendemail = '461937343@qq.com', _sendpw = 'owtwpnpsgjuxbhee';

    var smtpServer = qq(_sendemail, _sendpw);

    var _getemail = '461937343@qq.com';

    var message = Message();
    message.from = Address(_sendemail);
    message.recipients = [_getemail];
    message.text = _emailbody.text;
    message.subject =
        '来自${_user['grade']}年级${_user['class']}班${_user['nickname']}的反馈';
    message.attachments = attachments;

    try {
      var sendRep = await send(message, smtpServer);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('成功提交')));
      //print('Message sent: ' + sendReport.toString());
    } catch (exception) {
      //print(exception.toString());
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('错误:${exception.toString()}')));
    }

    /*
    Email email = Email(
      body: _emailbody.text,
      recipients: ['syesprz_11347@outlook.com'],
      attachmentPaths: attachments,
    );

    var sendRes;

    try {
      await FlutterEmailSender.send(email);
      sendRes = 'success';
    } catch (exception) {
      print(exception.toString());
      sendRes = exception.toString();
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(sendRes)));*/
  }
}
