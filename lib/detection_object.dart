class DetectionObject{

  double xmin,xmax, ymin, ymax;

  double confidence;
  String clas;

  double _width=1;
  double _height=1;

  DetectionObject({required this.xmin,required this.xmax,required this.ymin,required this.ymax,required this.confidence,required this.clas});

  get width =>_width;
  get height =>_height;

  setSize({required double newwidth,required double newheight}){

    xmin= (xmin/_width)*newwidth;
    xmax= (xmax/_width)*newwidth;
    ymin= (ymin/_height)*newheight;
    ymax= (ymax/_height)*newheight;
    _width = newwidth;
    _height=newheight;
  }


   toString(){

    var d = {
        "xmin":xmin,
        "xmax":xmax,
        "ymin":ymin,
        "ymax":ymax,

        "conf":confidence,
        "class":clas,

        "width":_width,
        "height":_height,

        
        
    };
    return d.toString();
  }






}