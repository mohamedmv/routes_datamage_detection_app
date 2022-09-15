import 'dart:io';

import 'package:flutter/material.dart';
import 'package:object_detection/camera.dart';
import 'package:object_detection/model_manager.dart';
import 'package:provider/provider.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tf;
import 'package:image_picker/image_picker.dart' ;
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:(context)=> ModelManager(inputSize: 640, modelName: "model.tflite"),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: Home(),
    
        routes: {
          "camera": (context)=> CameraScreen()
        },
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({ Key? key }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  

  TensorBuffer probOutPut =TensorBuffer.createFixedSize(<int>[1, 25], tf.TfLiteType.float32);
  TensorBuffer boxesOutPut =TensorBuffer.createFixedSize(<int>[1, 25,4], tf.TfLiteType.float32);
  TensorBuffer out3 =TensorBuffer.createFixedSize(<int>[1], tf.TfLiteType.float32);
  TensorBuffer classesOutPut =TensorBuffer.createFixedSize(<int>[1, 25], tf.TfLiteType.float32);
  String ?input_path;
     tf.Interpreter ?interpreter;
  @override
  Widget build(BuildContext context) { 
    return Scaffold(

      appBar: AppBar(),

      body: Column(

        children: [

          
          TextButton(onPressed: ()async {
          Navigator.pushNamed(context, "camera");
            
          }, child: Text("camera")),


          TextButton(onPressed: ()async {
            interpreter =await  tf.Interpreter.fromAsset("model.tflite");
            setState(() {
              
            });
            if(interpreter!=null) print("success");
            
          }, child: Text("load model")),



          // make prediction

          TextButton(onPressed: ()async {
            ImageProcessor imageProcessor = ImageProcessorBuilder()
              .add(ResizeOp(640, 640, ResizeMethod.NEAREST_NEIGHBOUR))
              .build();


              var xfile =await ImagePicker().pickImage(source: ImageSource.camera);

              File file = File(xfile!.path);
              input_path= xfile.path;
            // Create a TensorImage object from a File
            TensorImage tensorImage = TensorImage.fromFile(file);

            // Preprocess the image.
            // The image for imageFile will be resized to (224, 224)
            tensorImage = imageProcessor.process(tensorImage);
            print(tensorImage);
              var outputs = <int, Object>{};
              outputs[0] = probOutPut.buffer;
              outputs[1] = boxesOutPut.buffer;
              outputs[2] = out3.buffer;
              outputs[3] = classesOutPut.buffer;

            interpreter!.runForMultipleInputs([tensorImage.buffer], outputs);

    //      try{

    //           List<Object> inputs = [tensorImage.buffer];
            
    //            var inputTensors = interpreter!.getInputTensors();

    //                   for (int i = 0; i < inputs.length; i++) {
    //                     var tensor = inputTensors.elementAt(i);
    //                     final newShape = tensor.getInputShapeIfDifferent(inputs[i]);
    //                     if (newShape != null) {
    //                       interpreter!.resizeInputTensor(i, newShape);
    //                     }
    //                      print(newShape);
    //                   }


                     

                      
    //                     interpreter!.allocateTensors();
                      

    //                   inputTensors = interpreter!.getInputTensors();
    //                   print(inputTensors);
    //                   for (int i = 0; i < inputs.length; i++) {
    //                     inputTensors.elementAt(i).setTo(inputs[i]);

    //                     interpreter!.invoke();
                  

    //                   var outputTensors = interpreter!.getOutputTensors();
    //                   for (var i = 0; i < outputTensors.length; i++) {
    //                     outputTensors[i].copyTo(outputs[i]!);
    // }

    // }

    //      }catch(e){
    //       print("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
    //       print(e);
    //       print("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");

    //      }
             

    //                   var outputTensors = interpreter!.getOutputTensors();
                      // print(outputTensors);

  setState(() {
    
  });

          }, child: Text("predict ")),


          TextButton(onPressed: ()async{
            List<String> labels = await FileUtil.loadLabels("assets/labels.txt");
            var x = probOutPut.getDoubleList();
            print(x.length);
            print(x);
           

          }, child: Text("output")),


          if(input_path!=null) CustomPaint(
            child: Image.file(File(input_path!)),
            foregroundPainter: MycustomPainter(context),
          )

          
        ],
      ),
      
    );
  }
}







  class MycustomPainter extends CustomPainter {
    BuildContext context;
    MycustomPainter( this.context);
  @override 
  void paint(Canvas canvas, Size size) {


    var ps = [[0.8235445022583008, 0.625006914138794, 0.9715267419815063, 0.6957175731658936],[0.9212177395820618, 0.6674784421920776, 0.9726956486701965, 0.6960903406143188,]];
    double width = MediaQuery.of(context).size.width;

    for(int i =0; i< ps.length;i++){
      for (int j =0; j<4; j++){
      ps[i][j]=ps[i][j]*width;

      }
    }

    for (var p in ps){
    final Rect rect = Rect.fromPoints(Offset(p[1],p[0]), Offset(p[3],p[2]));
  
    canvas.drawRect(
      rect,
      Paint()..style=PaintingStyle.stroke ..strokeWidth=3
    );

    }
    
  }
  @override
  bool shouldRepaint(CustomPainter oldPainter){
    return true;

  }


  
}