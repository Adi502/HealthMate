import 'package:camera/camera.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class ScanController extends GetxController {

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    initCamera();
    initTFLite();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    cameraController.dispose();
    Tflite.close();
  }

  late CameraController cameraController;
  late List<CameraDescription> cameras;

  var isCameraInitialized = false.obs;
  var cameraCount = 0;

  Future<List<String>> classifyImage(String imagePath) async {
    try {
      // Run inference on the captured image
      final results = await Tflite.runModelOnImage(
        path: imagePath,
        numResults: 1,
        threshold: 0.6,
        imageMean: 127.5,
        imageStd: 127.5,
        asynch: true,
      );

      // Process the output data to get the classification results
      final classificationResults = <String>[];
      if (results != null && results.isNotEmpty) {
        final label = results[0]['label'];
        final confidence = results[0]['confidence'];
        classificationResults.add('$label: $confidence');
      }

      // Print the classification results
      print('Classification results: $classificationResults');

      return classificationResults;
    } catch (e) {
      print('Error classifying image: $e');
      return [];
    }
  }

  initCamera() async {
    if (await Permission.camera.request().isGranted) {
      cameras = await availableCameras();

      cameraController = CameraController(
        cameras[0],
        ResolutionPreset.max,
      );
      await cameraController.initialize().then((value) {
        cameraController.startImageStream((image) {
          cameraCount++;
          if (cameraCount % 10 == 0) {
            cameraCount = 0;
            //ObjectDetector(image);
          }
          update();
        });
      });
      isCameraInitialized(true);
      update();
    } else {
      print("Permission Denied!");
    }
  }

  initTFLite() async {
    await Tflite.loadModel(
      model: "assets/model.tflite",
      labels: "assets/labels.txt",
      isAsset: true,
      numThreads: 1,
      useGpuDelegate: false,
    );
  }

  // ObjectDetector(CameraImage image) async {
  //   var detector = await Tflite.runModelOnFrame(
  //     bytesList: image.planes.map((e) {
  //       return e.bytes;
  //     }).toList(),
  //     asynch: true,
  //     imageHeight: image.height,
  //     imageWidth: image.width,
  //     imageMean: 127.5,
  //     imageStd: 127.5,
  //     numResults: 1,
  //     rotation: 90,
  //     threshold: 0.9,
  //   );
  //
  //   if (detector != null) {
  //     log("Result is $detector");
  //   }
  //}
}
