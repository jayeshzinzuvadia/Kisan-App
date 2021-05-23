import 'package:flutter/material.dart';
import '../../app.dart';

Widget getProfileImageAsset(String userType) {
  AssetImage assetImage;
  assetImage = (userType == UniversalConstant.AGRI_EXPERT)
      ? AssetImage('assets/images/agriExpertUser.png')
      : AssetImage('assets/images/farmerUser.png');
  Image image = Image(
    image: assetImage,
    width: 150.0,
    height: 120.0,
  );
  return Container(
    child: image,
    margin: EdgeInsets.all(15),
  );
}
