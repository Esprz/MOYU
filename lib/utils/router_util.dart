import 'package:MOYU/view/user/on_sell_list/on_sell_item_page.dart';
import 'package:MOYU/view/register/user_initialization.dart';
import 'package:MOYU/view/user/setting/private_contrast.dart';
import 'package:MOYU/view/user/setting/user_account_setting_page.dart';
import 'package:MOYU/view/user/setting/user_feedback_page.dart';
import 'package:flutter/material.dart';
import 'package:MOYU/view/categorize/categorize_page.dart';
import 'package:MOYU/view/homepage.dart';
import 'package:MOYU/view/index_page.dart';
import 'package:MOYU/view/register/register_page.dart';
import 'package:MOYU/view/add_product/add_product_page.dart';
import 'package:MOYU/view/product/product_page.dart';
import 'package:MOYU/view/search_product/search_result_page.dart';
import 'package:MOYU/view/user/like_good_list/user_like_list_page.dart';
import 'package:MOYU/view/user/on_sell_list/user_on_sell_list.dart';
import 'package:MOYU/view/user/setting/user_setting.dart';
import 'package:MOYU/view/user/user_profile.dart';

import '../view/login/login_page.dart';

class RouterUtil {
  static toLoginPage(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
        (route) => route == null);
  }

  static toIndexPage(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => IndexPage(),
        ),
        (route) => route == null);
  }

  static toHomePage(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ));
  }

  static toRegisterPage(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RegisterPage(),
        ));
  }

  static toUserProfilePage(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserProfilePage(),
        ));
  }

  static toUserSettingPage(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserSettingPage(),
        ));
  }

  static pop(BuildContext context) {
    Navigator.pop(context);
  }

  static toAddProductPage(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddProductPage(),
        ));
  }

  static toUserOnSellGoodsPage(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserOnSellPage(),
        ));
  }

  static toUserLikePage(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserLikePage(),
          //fullscreenDialog: true
        ));
  }

  static toSearchResultPage(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchResultPage(),
          //fullscreenDialog: true
        ));
  }

  static toProductPage(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductDetailPage(),
          //fullscreenDialog: true
        ));
  }

  static toCategorizePage(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CategorizePage(),
        ));
  }

  static toUserInitializationPage(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserInitializationPage(),
        ));
  }

  static toOnSellItemPage(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OnSellItemPage(),
        ));
  }

  static toUserAccountSettingPage(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserAccountSettingPage(),
        ));
  }

  static toUserPasswordChangePage(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserPasswordChangePage(),
        ));
  }

  static toUserContactChangePage(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserContactChangePage(),
        ));
  }

  static toPrivacyPolicyPage(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PrivacyPolicyPage(),
        ));
  }

  static toUserAgreementPage(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserAgreementPage(),
        ));
  }

  static toUserFeedbackPage(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserFeedbackPage(),
        ));
  }

  static toCopyrightNoticePage(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CopyrightNoticePage(),
        ));
  }
}
