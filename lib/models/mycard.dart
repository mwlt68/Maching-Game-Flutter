import 'package:flutter/cupertino.dart';

class MyCard {
  static String coverImg="assets/images/cover.jpg";
  int index;
  int imgId;
  bool isOpen;
  MyCard(@required this.index,{this.imgId,this.isOpen=false,});
  
  String getImgAsset(){
    if(isOpen)
      return "assets/images/"+imgId.toString()+".PNG";
    else
      return coverImg;
  }
}