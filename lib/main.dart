import 'dart:io';

import 'package:flutter/material.dart';
import 'package:object_detection/camera.dart';
import 'package:object_detection/model_manager.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart' ;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:(context)=> ModelManager(inputSize: 640, modelName: "efficientdet_lite3_50_eps_augmentation_v1.tflite"),
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
  


  @override
  Widget build(BuildContext context) { 
    return Scaffold(

      appBar: AppBar(),

      body: Column(

        children: [

          
          TextButton(onPressed: ()async {
          Navigator.pushNamed(context, "camera");
            
          }, child: Text("camera")),




          
        ],
      ),
      
    );
  }
}







  