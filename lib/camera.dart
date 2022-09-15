import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:object_detection/model_manager.dart';
import 'package:object_detection/my_painter.dart';
import 'package:provider/provider.dart';



/// CameraScreen is the Main Application.
class CameraScreen extends StatefulWidget {
  /// Default Constructor
  const CameraScreen({Key? key}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
   List<CameraDescription>? _cameras;
  
  late CameraController ?controller;

  @override
  void initState() {
     availableCameras().then((value) {


      _cameras=value;
      print(_cameras);
controller = CameraController(_cameras![0], ResolutionPreset.medium,enableAudio:false,);
print("++++++++++++++++++++++++");
// print(controller.value.aspectRatio);

    controller?.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            print('User denied camera access.');
            break;
          default:
            print('Handle other errors.');
            break;
        }
      }
    });


     } );
    super.initState();
    
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    


    if(controller == null){
     return Container(color: Colors.white,);
    }
    if (!controller!.value.isInitialized) {
      return Container();
    }

    print(controller?.value.aspectRatio);


 if(!context.read<ModelManager>().isRunning){
          context.read<ModelManager>().realTimeCameraDetection(controller!);
        }

    return Consumer<ModelManager>(

      builder: (context, modelManager, _){

       
          return SafeArea(


         child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
            children:[
       
               SizedBox(
              height: MediaQuery.of(context).size.width*controller!.value.aspectRatio,
              width: MediaQuery.of(context).size.width,
              child: CustomPaint(
                painter: MycustomPainter(
                  context: context,
                  objects: modelManager.detectedObjects,
                    height: MediaQuery.of(context).size.width*controller!.value.aspectRatio,
              width: MediaQuery.of(context).size.width,
                ),
                child: CameraPreview(controller!))),
            ]
          
           ),
       );
      }
     );
  }
}
