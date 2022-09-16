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

    print(objects);


   


  

    for (var o in objects){
      o.setSize(newwidth: width, newheight: height);
     Rect rect = Rect.fromPoints(Offset(o.xmax,o.ymin), Offset(o.xmin,o.ymax));
    //  Rect rect = Rect.fromCenter(center: Offset(o.xmin,o.ymin), width: o.xmax, height: o.ymax);

  
    canvas.drawRect(
      rect,
      Paint()..style=PaintingStyle.stroke ..strokeWidth=3
    );
    TextSpan span = new TextSpan(style: new TextStyle(color: Colors.black), text: o.clas);
TextPainter tp = new TextPainter(text: span, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
tp.layout();
tp.paint(canvas, Offset(o.xmax-20,o.ymin-20));

    }
    
    
  }
  @override
  bool shouldRepaint(CustomPainter oldPainter){
    return true;

  }


  
}