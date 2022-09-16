import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:object_detection/detection_object.dart';



import 'package:image/image.dart' as img;
import 'package:tflite/tflite.dart';
class ModelManager extends ChangeNotifier{


  bool _isRunning=false;


  int inputSize;
  String modelName;

  double confThreshold;


  List<DetectionObject> detectedObjects=[
    DetectionObject(xmin: 0.1, xmax: 0.4, ymin: 0.2, ymax: 0.5, confidence: 0.6, clas: "D00")
  ];

  ModelManager({required this.inputSize,required this.modelName,this.confThreshold=0.3}){
    initializeModel();
  }









Future<void> initializeModel() async {


          String ?res = await Tflite.loadModel(
                          model: "assets/"+modelName,
                          labels: "assets/labels.txt",
                          numThreads: 1, // defaults to 1
                          isAsset: true, // defaults to true, set to false to load resources outside assets
                          useGpuDelegate: false // defaults to false, set to true to use GPU delegate
                        );
                        print(res);
}

Future<void> MakePrediction({File ?file,img.Image? image,List<Uint8List>? frame,Uint8List ?bytes,height,width}) async{

              
               

              

            // Preprocess the image.
            // The image for imageFile will be resized to (224, 224)

          var res;

           if(file != null){

             res = await   Tflite.detectObjectOnImage(path: file.path,model: "efficientdet",threshold: confThreshold);



           }
           else if (frame!=null){

             res = await   Tflite.detectObjectOnFrame(bytesList: frame, model: "efficientdet",imageHeight: height,imageWidth: width,threshold: confThreshold);
            print(res.runtimeType);
            print(res);


           }

            if(res !=null){


            print(res.runtimeType);
            print(res);
            detectedObjects=[];
            for( var ob in res!){

              // detectedObjects.add(DetectionObject(xmin:  ob['rect']['x'],  xmax:ob['rect']['w'], ymin: ob['rect']['y'], ymax: ob['rect']['h'], confidence: ob["confidenceInClass"], clas: ob['detectedClass']));
              detectedObjects.add(DetectionObject(xmin: ob['rect']['xmin'],  xmax:ob['rect']['xmax'], ymin: ob['rect']['ymin'], ymax: ob['rect']['ymax'], confidence: ob["confidenceInClass"], clas: ob['detectedClass']));
            }

            print(detectedObjects);
            notifyListeners();
            }






            
}



  // getDetection(){


  //   List<double> probs = _probOutPut.getDoubleList();
  //   print(probs);

  //   List<double> boxes = _boxesOutPut.getDoubleList();
  //   print(boxes);

  //   List<double> classes = _classesOutPut.getDoubleList();
  //   print(classes);

  //   List<DetectionObject> objects = [];
  //   for(int i =0; i<probs.length ; i++){
  //     if(probs[i] >= confThreshold){

  //       objects.add(
  //         DetectionObject(ymin: boxes[i*4],xmin: boxes[i*4 +1], ymax: boxes[i*4 +2],xmax: boxes[i*4 +3],  confidence: probs[i], clas: boxes[i].toInt()));
  //     }
  //   }

  //   detectedObjects =  objects;

  //   print(detectedObjects);
  //   notifyListeners();

  // }


  realTimeCameraDetection(CameraController controller)async{

    await initializeModel();
    // _isRunning=true;
    // notifyListeners();
    

controller.setFlashMode(FlashMode.off);
    
      var f = await controller.takePicture();

     await  MakePrediction(file: File(f.path));

    // await controller.startImageStream((cameraImage) async{
      

    //   if(!_isRunning ){
    //    _isRunning=true;
      
    //   notifyListeners();
      
    //   var frame =  cameraImage.planes.map((plane) => plane.bytes).toList();
    //   var width =  cameraImage.width;
    //   var height = cameraImage.height;
            
    // await   MakePrediction(frame:frame,width: width,height: height);

 

    //   }
      
    // });



    
  }


  void stopRunning(){
    _isRunning=false;
    notifyListeners();
  }


get isRunning=>_isRunning;





  
}




