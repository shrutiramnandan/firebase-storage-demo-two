import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File imageFile;
  FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> pickImageFromSelectedSource(ImageSource imageSource) async{
    var image=await ImagePicker.pickImage(source: imageSource);
    setState(() {
      imageFile=image; 
    });
  }

  Future<void> _uploadProfilePicture() async{
    
   if(imageFile!=null){
     //StorageReference reference = _storage.ref().child("your_path/$imageFile"); imageFile.path

      String fileName = basename(imageFile.path);// get the file name
      StorageReference reference = _storage.ref().child(fileName);
      StorageUploadTask uploadTask = reference.putFile(imageFile);//Upload the file to firebase 
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;// 
      /*
      // Waits till the file is uploaded then stores the download url 
      Uri location = (await uploadTask.future).downloadUrl;

      //returns the download url 
      return location;
      */
      print("Image Uploaded succesfully");
      Fluttertoast.showToast(msg: "Image Uploded successfully");
   }else{
     Fluttertoast.showToast(msg: "please select an image");
   }
   
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body:Stack(
        children: <Widget>[
          Container(
            child: Center(
              child:Column(
                mainAxisAlignment:  MainAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    child: imageFile==null
                    ?new Text("Select image")
                    :Image.file(imageFile), 
                    radius: 80.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: RawMaterialButton(
                      child: Text("Upload Image"),
                      elevation: 5.0,
                      fillColor: Colors.blue,
                      onPressed: _uploadProfilePicture,
                    ),
                  )
                ],
              ) ,
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera),
        onPressed: (){
          pickImageFromSelectedSource(ImageSource.gallery);
        },
      ),
    );
  }
}
