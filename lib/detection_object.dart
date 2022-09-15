class DetectionObject{

  double xmin,xmax, ymin, ymax;

  double confidence;
  int clas;

  double _width=1;
  double _height=1;

  DetectionObject({required this.xmin,required this.xmax,required this.ymin,required this.ymax,required this.confidence,required this.clas});

  get width =>_width;
  get height =>_height;

  setSize({required double width,required double height}){

    xmin= (xmin/_width)*width;
    xmax= (xmax/_width)*width;
    ymin= (ymin/_height)*height;
    ymax= (ymax/_height)*height;
    _width = width;
    _height=height;
  }






}