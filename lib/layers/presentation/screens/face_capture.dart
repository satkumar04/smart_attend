import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smart_attendance/main.dart';

Future<void> main() async {
  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print('Error in fetching the cameras: $e');
  }
  runApp(const LoginScreen());
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      home: FaceCapture(),
    );
  }
}

class FaceCapture extends StatefulWidget {
  const FaceCapture({super.key});

  @override
  State<FaceCapture> createState() => _FaceCaptureState();
}

class _FaceCaptureState extends State<FaceCapture> with WidgetsBindingObserver {
  CameraController? controller;
  bool _isCameraInitialized = false;
  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 1.0;
  double _currentZoomLevel = 1.0;
  final resolutionPresets = ResolutionPreset.values;
  ResolutionPreset currentResolutionPreset = ResolutionPreset.high;
  double _minAvailableExposureOffset = 0.0;
  double _maxAvailableExposureOffset = 0.0;
  double _currentExposureOffset = 0.0;
  FlashMode? _currentFlashMode;
  bool _isRearCameraSelected = true;
  bool _isVideoCameraSelected = false;
  bool _isRecordingInProgress = false;

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    final previousCameraController = controller;
    // Instantiating the camera controller
    final CameraController cameraController = CameraController(
      cameraDescription,
      currentResolutionPreset,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );
    //  _currentFlashMode = controller!.value.flashMode;

    // Dispose the previous controller
    await previousCameraController?.dispose();

    // Replace with the new controller
    if (mounted) {
      setState(() {
        controller = cameraController;
      });
    }

    // Update UI if controller updated
    cameraController.addListener(() {
      if (mounted) setState(() {});
    });

    // Initialize controller
    try {
      await cameraController.initialize();
      await Future.wait(
        [
          cameraController
              .getMaxZoomLevel()
              .then((value) => _maxAvailableZoom = value),
          cameraController
              .getMinZoomLevel()
              .then((value) => _minAvailableZoom = value),
          cameraController
              .getMinExposureOffset()
              .then((value) => _minAvailableExposureOffset = value),
          cameraController
              .getMaxExposureOffset()
              .then((value) => _maxAvailableExposureOffset = value),
        ],
      );
      _currentFlashMode = controller!.value.flashMode;
    } on CameraException catch (e) {
      print('Error initializing camera: $e');
    }

    // Update the Boolean
    if (mounted) {
      setState(() {
        _isCameraInitialized = controller!.value.isInitialized;
      });
    }
  }

  void onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
    if (controller == null) {
      return;
    }

    final offset = Offset(
      details.localPosition.dx / constraints.maxWidth,
      details.localPosition.dy / constraints.maxHeight,
    );
    controller!.setExposurePoint(offset);
    controller!.setFocusPoint(offset);
  }

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    onNewCameraSelected(cameras[1]);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      // Free up memory when camera not active
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      // Reinitialize the camera with same properties
      onNewCameraSelected(cameraController.description);
    }
  }

  Future<XFile?> takePicture() async {
    final CameraController? cameraController = controller;
    if (cameraController!.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }
    try {
      XFile file = await cameraController.takePicture();
      return file;
    } on CameraException catch (e) {
      print('Error occured while taking picture: $e');
      return null;
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: const Color(0xFFDADADA),
            ),
            child: const Icon(
              Icons.navigate_before_rounded,
              color: Colors.black,
              size: 30.0,
            ),
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () => {},
            icon: Image.asset(
              'assets/images/profile.png',
            ),
            padding: const EdgeInsets.only(right: 20),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: [
            _isCameraInitialized
                ? Padding(
                    padding: const EdgeInsets.all(8),
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey,
                        ),
                        width: 350,
                        height: 470,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Stack(
                            children: [
                              CameraPreview(
                                controller!,
                                child: LayoutBuilder(
                                  builder: (BuildContext context,
                                      BoxConstraints constraints) {
                                    return GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTapDown: (details) =>
                                          onViewFinderTap(details, constraints),
                                    );
                                  },
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black87,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 8.0,
                                          right: 8.0,
                                        ),
                                        child: DropdownButton<ResolutionPreset>(
                                          dropdownColor: Colors.black87,
                                          underline: Container(),
                                          value: currentResolutionPreset,
                                          items: [
                                            for (ResolutionPreset preset
                                                in resolutionPresets)
                                              DropdownMenuItem(
                                                value: preset,
                                                child: Text(
                                                  preset
                                                      .toString()
                                                      .split('.')[1]
                                                      .toUpperCase(),
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                              )
                                          ],
                                          onChanged: (value) {
                                            setState(() {
                                              currentResolutionPreset = value!;
                                              _isCameraInitialized = false;
                                            });
                                            onNewCameraSelected(
                                                controller!.description);
                                          },
                                          hint: const Text("Select item"),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 8.0, top: 16.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          '${_currentExposureOffset.toStringAsFixed(1)}x',
                                          style: const TextStyle(
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: RotatedBox(
                                      quarterTurns: 3,
                                      child: Container(
                                        height: 30,
                                        child: Slider(
                                          value: _currentExposureOffset,
                                          min: _minAvailableExposureOffset,
                                          max: _maxAvailableExposureOffset,
                                          activeColor: Colors.white,
                                          inactiveColor: Colors.white30,
                                          onChanged: (value) async {
                                            setState(() {
                                              _currentExposureOffset = value;
                                            });
                                            await controller!
                                                .setExposureOffset(value);
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Slider(
                                          value: _currentZoomLevel,
                                          min: _minAvailableZoom,
                                          max: _maxAvailableZoom,
                                          activeColor: Colors.white,
                                          inactiveColor: Colors.white30,
                                          onChanged: (value) async {
                                            setState(() {
                                              _currentZoomLevel = value;
                                            });
                                            await controller!
                                                .setZoomLevel(value);
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.black87,
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              '${_currentZoomLevel.toStringAsFixed(1)}x',
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  InkWell(
                                    onTap: _isVideoCameraSelected
                                        ? () async {
                                            if (_isRecordingInProgress) {
                                              // XFile? rawVideo =
                                              //     await stopVideoRecording();
                                              // File videoFile =
                                              //     File(rawVideo!.path);

                                              // int currentUnix = DateTime
                                              //         .now()
                                              //     .millisecondsSinceEpoch;

                                              // final directory =
                                              //     await getApplicationDocumentsDirectory();

                                              // String fileFormat = videoFile
                                              //     .path
                                              //     .split('.')
                                              //     .last;

                                              // _videoFile =
                                              //     await videoFile.copy(
                                              //   '${directory.path}/$currentUnix.$fileFormat',
                                              // );

                                              // _startVideoPlayer();
                                            } else {
                                              // await startVideoRecording();
                                            }
                                          }
                                        : () async {
                                            XFile? rawImage =
                                                await takePicture();
                                            File imageFile =
                                                File(rawImage!.path);

                                            int currentUnix = DateTime.now()
                                                .millisecondsSinceEpoch;

                                            final directory =
                                                await getApplicationDocumentsDirectory();

                                            String fileFormat =
                                                imageFile.path.split('.').last;

                                            print(fileFormat);

                                            await imageFile.copy(
                                              '${directory.path}/$currentUnix.$fileFormat',
                                            );

                                            // refreshAlreadyCapturedImages();
                                          },
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Icon(
                                          Icons.circle,
                                          color: _isVideoCameraSelected
                                              ? Colors.white
                                              : Colors.white38,
                                          size: 80,
                                        ),
                                        Icon(
                                          Icons.circle,
                                          color: _isVideoCameraSelected
                                              ? Colors.red
                                              : Colors.white,
                                          size: 65,
                                        ),
                                        _isVideoCameraSelected &&
                                                _isRecordingInProgress
                                            ? Icon(
                                                Icons.stop_rounded,
                                                color: Colors.white,
                                                size: 32,
                                              )
                                            : Container(),
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        _isCameraInitialized = false;
                                      });
                                      onNewCameraSelected(
                                        cameras[_isRearCameraSelected ? 0 : 1],
                                      );
                                      setState(() {
                                        _isRearCameraSelected =
                                            !_isRearCameraSelected;
                                      });
                                    },
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        const Icon(
                                          Icons.circle,
                                          color: Colors.black38,
                                          size: 60,
                                        ),
                                        Icon(
                                          _isRearCameraSelected
                                              ? Icons.camera_front
                                              : Icons.camera_rear,
                                          color: Colors.white,
                                          size: 30,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        16.0, 8.0, 16.0, 8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            setState(() {
                                              _currentFlashMode = FlashMode.off;
                                            });
                                            await controller!.setFlashMode(
                                              FlashMode.off,
                                            );
                                          },
                                          child: Icon(
                                            Icons.flash_off,
                                            color: _currentFlashMode ==
                                                    FlashMode.off
                                                ? Colors.amber
                                                : Colors.white,
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            setState(() {
                                              _currentFlashMode =
                                                  FlashMode.auto;
                                            });
                                            await controller!.setFlashMode(
                                              FlashMode.auto,
                                            );
                                          },
                                          child: Icon(
                                            Icons.flash_auto,
                                            color: _currentFlashMode ==
                                                    FlashMode.auto
                                                ? Colors.amber
                                                : Colors.white,
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            setState(() {
                                              _currentFlashMode =
                                                  FlashMode.always;
                                            });
                                            await controller!.setFlashMode(
                                              FlashMode.always,
                                            );
                                          },
                                          child: Icon(
                                            Icons.flash_on,
                                            color: _currentFlashMode ==
                                                    FlashMode.always
                                                ? Colors.amber
                                                : Colors.white,
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            setState(() {
                                              _currentFlashMode =
                                                  FlashMode.torch;
                                            });
                                            await controller!.setFlashMode(
                                              FlashMode.torch,
                                            );
                                          },
                                          child: Icon(
                                            Icons.highlight,
                                            color: _currentFlashMode ==
                                                    FlashMode.torch
                                                ? Colors.amber
                                                : Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        )),
                  )
                : Container(),

            // Center(
            //   child: Container(
            //     width: 100,
            //     height: 100,
            //     decoration: const BoxDecoration(
            //     ),
            //     child: _isCameraInitialized
            //         ? AspectRatio(
            //             aspectRatio: 1 / controller!.value.aspectRatio,
            //             child: controller!.buildPreview(),
            //           )
            //         : Container(),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
