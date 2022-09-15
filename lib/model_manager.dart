import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:object_detection/detection_object.dart';
import 'package:tflite_flutter/tflite_flutter.dart' ;
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';


import 'package:image/image.dart' as img;
class ModelManager extends ChangeNotifier{


  bool _isRunning=false;
  bool started = false;

  int inputSize;
  String modelName;

  double confThreshold;

  Map<String ,int> outPutIndexes = {
    "probs":0,
    "boxes":1,
    "classes":3
  };

  List<DetectionObject> detectedObjects=[];

  ModelManager({required this.inputSize,required this.modelName,this.confThreshold=0.5}){
    initializeModel();
  }









Interpreter ?interpreter;
Future<void> initializeModel() async {


              interpreter =await  Interpreter.fromAsset(modelName);

            if(interpreter!=null) print("Model was initialized successfuly");

            notifyListeners();
}

void MakePrediction({File ?file,img.Image? image}){

              ImageProcessor imageProcessor = ImageProcessorBuilder()
              .add(ResizeOp(inputSize, inputSize, ResizeMethod.NEAREST_NEIGHBOUR))

              .build();
              TensorImage tensorImage;

              if(image==null){
                tensorImage= TensorImage.fromFile(file!);
              }
               
              else{
                tensorImage = TensorImage.fromImage(image);
              }
               

              

            // Preprocess the image.
            // The image for imageFile will be resized to (224, 224)
            tensorImage = imageProcessor.process(tensorImage);
            print(tensorImage);
              var outputs = <int, TensorBuffer>{};
              outputs[0] = TensorBuffer.createFixedSize(<int>[1, 25], TfLiteType.float32);
              outputs[1] = TensorBuffer.createFixedSize(<int>[1, 25,4], TfLiteType.float32);
              outputs[2] = TensorBuffer.createFixedSize(<int>[1], TfLiteType.float32);
              outputs[3] = TensorBuffer.createFixedSize(<int>[1, 25], TfLiteType.float32);

            interpreter!.runForMultipleInputs([tensorImage.buffer], outputs);
            print(outputs);
            getDetection(outputs);


            
}



  getDetection(Map<int,TensorBuffer> outputs){


    List<double> probs = outputs[outPutIndexes['probs']]!.getDoubleList();
    print(probs);

    List<double> boxes = outputs[outPutIndexes['boxes']]!.getDoubleList();

    List<double> classes = outputs[outPutIndexes['classes']]!.getDoubleList();

    List<DetectionObject> objects = [];
    for(int i =0; i<probs.length ; i++){
      if(probs[i] > confThreshold){

        objects.add(
          DetectionObject(ymin: boxes[i*4],xmin: boxes[i*4 +1], ymax: boxes[i*4 +2],xmax: boxes[i*4 +3],  confidence: probs[i], clas: boxes[i].toInt()));
      }
    }

    detectedObjects =  objects;
    notifyListeners();

  }


  realTimeCameraDetection(CameraController controller)async{

    await initializeModel();
    _isRunning=true;
    notifyListeners();

    await controller.startImageStream((cameraImage){

      if(_isRunning ){
            img.Image image = img.Image.fromBytes(cameraImage.width, cameraImage.height, cameraImage.planes[0].bytes);
      MakePrediction(image: image);
      _isRunning=false;
      
      notifyListeners();
      }


  
      
    });

    
  }


  void stopRunning(){
    _isRunning=false;
    notifyListeners();
  }


get isRunning=>_isRunning;





  
}




