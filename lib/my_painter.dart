 import 'package:flutter/material.dart';
import 'package:object_detection/detection_object.dart';

class MycustomPainter extends CustomPainter {
    BuildContext context;
    List<DetectionObject> objects;
    double width;
    double height;
    MycustomPainter( {required this.context,required  this.objects,required  this. width,required  this.height});
  @override 
  void paint(Canvas canvas, Size size) {


   
    double width = MediaQuery.of(context).size.width;

  

    for (var o in objects){
    final Rect rect = Rect.fromPoints(Offset(o.xmin,o.ymin), Offset(o.xmax,o.ymax));
  
    canvas.drawRect(
      rect,
      Paint()..style=PaintingStyle.stroke ..strokeWidth=3
    );

    }
    
  }
  @override
  bool shouldRepaint(CustomPainter oldPainter){
    return false;

  }


  
}