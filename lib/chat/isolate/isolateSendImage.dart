// YOU CAN UNDERSTAND AS IT IS RUNNING PARALLEL TO OUR MAIN ISOLATE
// OUR MAIN ISOLATE IS ALWAYS A STATIC TOP LEVEL FUNCTION I.E void main()
import 'dart:io';
import 'dart:isolate';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_isolate/flutter_isolate.dart';

enum UploadStatus { Idle, Uploading, Finished }

String uploadedUrl = "";
//we will notify our homepage when upload status changes
//this status will be changed from the isolate itself
ValueNotifier isUploading = ValueNotifier<UploadStatus>(UploadStatus.Idle);
void uploadFileToFirebase(String filePath, Function(String path) ondone) async {
  //HERE WE NEED TO MAKE CONNECTION TO OTHER ISOLATE
  ///[REMEMBER] 2 ISOLATES RUNS ON INDEPENDENT CHUNK OF MEMORY, THEY DON'T SHARE MEMORY
  ///INORDER TO MAKE COMMUNICATION BETWEEN TWO ISOLATES WE HAVE TO MAKE A PORTS AT BOTH THE ENDS
  ///YOU CAN UNDERSTAND AS ONE WAY BRIDGE GOING FROM A=>B (MAIN ISOLATE=> UPLOAD ISOLATE) AND ANOTHER BRIDGE TO COME BACK FROM B=>A (UPLOAD ISOLATE=>MAIN ISOLATE)
  final mainIsolatePort = ReceivePort();
  try {
    //NOW INORDER TO PASS ARGUMENTS, WE CAN ONLY PASS STRING,BOOL,NULL ETC I.E DART CORE DATA TYPE, SO WE CANNOT PASS MODEL(ENCODE TO JSON) FIRST
    //AS WE CAN ONLY PASS ONE ARGUMENT YOU CAN FILL ALL YOUR DATA TO A MAP WHICH IS SCALABLE METHOD TO PASS ARGS
    Map payload = {};
    //FILL ALL YOUR DATA HERE
    payload['path'] = filePath;
    //NOW TIME TO SPAWN OUR HERO I.E ISOLATE
    //HERE WE DIDN'T USED FLUTTER'S CORE ISOLATE, IT STILL DOESN'T SUPPORT THIRD PARTY PLUGINS SO USING FLUTTER ISOLATE(PLUGIN) WE CAN MAKE THIRD PARTY PLUGINS WORK
    //HERE WE SPAWNED THE ISOLATE AND WE HAVE SENT THE SEND PORT OF OUR MAIN ISOLATE
    final uploadIsolate = await FlutterIsolate.spawn(
      uploadImageStorage,
      mainIsolatePort.sendPort,
    );
    //NOW IN OUR MAIN ISOLATE WE WILL LISTEN FOR THE COMMUNICATION BETWEEN THE TWO ISOLATES

    //ONCE ISOLATE IS SPAWNED WE WILL ENABLE UPLOADING STATUS
    isUploading.value = UploadStatus.Uploading;

    mainIsolatePort.listen(
      (messageFromUploadIsolate) {
        //WE GONNA MAKE SURE THAT COMMUNICATION LINK (A=>B) IS ESTABLISHED BEFORE SENDING THE INPUT PAYLOAD
        if (messageFromUploadIsolate is SendPort) {
          //FROM UPLOAD IMAGE ISOLATE WE GONNA SEND THE COMMUNICATION LINK (PORT) ON WHICH UPLOAD ISOLATE ACCEPTS THE DATA
          //SO NOW WE WILL SEND PAYLOAD TO THIS ROAD
          print("COMMUNICATION SETUP SUCCESS");
          messageFromUploadIsolate.send(payload);
          print("SENT INPUT PAYLOAD TO UPLOAD ISOLATE");
        }
        //WHEN THE MESSAGE RECEIVED FROM UPLOAD IMAGE ISOLATE IS STRING I.E WE GONNA WRITE URL IF UPLOADING IMAGE IS SUCCESSFUL OR NOT
        if (messageFromUploadIsolate is String) {
          print(
            "GOT THE UPLOAD RESULT FROM UPLOAD ISOLATE:$messageFromUploadIsolate",
          );
          if (messageFromUploadIsolate != '') {
            //success with url
            uploadedUrl = messageFromUploadIsolate;
            ondone(uploadedUrl);
            isUploading.value = UploadStatus.Finished;
          } else {
            //failed
            uploadedUrl = '';

            isUploading.value = UploadStatus.Finished;
          }
        }
      },
      onDone: () {
        //ON COMPLETION WE WILL CLOSE THE PORT AND KILL THE ISOLATE (A RUNNING ISOLATE MAY CONSUME MEMORY WHICH CAN CAUSE APP CRASH)
        uploadIsolate.kill();
        mainIsolatePort.close();
      },
      onError: (e) {
        print("Error in main Isolate : $e");
        //ON ERROR WE WILL CLOSE THE PORT AND KILL THE ISOLATE (A RUNNING ISOLATE MAY CONSUME MEMORY WHICH CAN CAUSE APP CRASH)
        uploadIsolate.kill();
        mainIsolatePort.close();
      },
    );
  } catch (err) {
    print("Error in the main Isolate:$err");
    //ON ERROR WE WILL CLOSE THE PORT
    mainIsolatePort.close();
  }
}

//HERE WE EXPECT ANY ISOLATE SEND PORT ON WHICH THIS METHOD CAN SEND MESSAGE
//OUR BRIDGE FROM A=>B (YOU CAN UNDERSTAND AS ROAD) (MAIN ISOLATE => UPLOADIMAGE ISOLATE)
Future<void> uploadImageStorage(SendPort mainIsolatePort) async {
  //HERE WE WILL DECLARE THE LINK ON WHICH WE CAN PASS DATA FROM A=>B (MAIN ISOLATE => UPLOADIMAGE ISOLATE)
  final uploadIsolatePort = ReceivePort();
  try {
    //HERE WE HAVE SENT THE PORT ON WHICH UPLOAD IMAGE ISOLATE ACCEPTS DATA TO MAIN ISOLATE
    mainIsolatePort.send(uploadIsolatePort.sendPort);
    //WE WILL LISTEN FOR THE INCOMING PAYLOAD
    uploadIsolatePort.listen((messageFromMainIsolate) async {
      if (messageFromMainIsolate is Map) {
        //WE HAVE OUR PAYLOAD HERE
        //AS THIS IS NEW ISOLATE WHICH IS COMPLETELY DIFFERENT THAN THE MAIN ONE SO
        //WE NEED TO INITIALIZE THE FIREBASE APP AGAIN
        try {
          await Firebase.initializeApp();
        } catch (e) {
          // Firebase peut déjà être initialisé dans certains cas
          print("Firebase initialization in isolate: $e");
        }
        //EXTRACT THE ARGS FROM THE MAP
        String path = messageFromMainIsolate['path'];
        print("PATH:$path");
        String uploadedUrl = await uploadToStorage(path);
        //AFTER GETTING THE URL SEND IT TO THE MAIN ISOLATE
        print("UPLOAD URL :$uploadedUrl");
        mainIsolatePort.send(uploadedUrl);
      }
    });
  } catch (err) {
    print("ERROR IN UPLOAD ISOLATE:$err");
    // SEND EMPTY URL SO WE CAN HANDLER ERROR IN MAIN ISOLATE
    mainIsolatePort.send('');
  }
}

//METHOD TO UPLOAD IMAGE TO THE STORAGE
Future<String> uploadToStorage(String filePath) async {
  Reference storageReference = FirebaseStorage.instance.ref().child(
    "file/${DateTime.now().millisecondsSinceEpoch.toString()}/",
  );
  //IT IS GOOD PRACTICE TO SET METADATA OF THE FILE YOU UPLOAD
  UploadTask uploadTask = storageReference.putFile(File(filePath));
  await uploadTask;
  return await storageReference.getDownloadURL();
}

String getExtension(String filePath) {
  return filePath.split("/").last.split(".").last;
}
