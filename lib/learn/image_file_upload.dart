import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

import '../database/db_provider.dart';
import '../utils/components/app_url.dart';
import '../utils/exports.dart';

class ImageFileUploadScreen extends StatefulWidget {
  const ImageFileUploadScreen({super.key});

  @override
  State<ImageFileUploadScreen> createState() => _ImageFileUploadScreenState();
}

class _ImageFileUploadScreenState extends State<ImageFileUploadScreen> {

   final dio = Dio();
  
  Future uploadImage() async {
    // print(AppUrl.registrationUri);
    final token = await DatabaseProvider().getToken();
    final userId = await DatabaseProvider().getUserId();
    
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    {if(result != null ){
      File file = File(result.files.single.path ?? "") ;
      String filename = file.path.split("/").last;
      String filepath = file.path;
    

    final body = {
      'name': 'Narayan.jpg',
      'photo': await MultipartFile.fromFile(filepath, filename: filename),
      'user_id': userId,
    };
   
      final response = await dio.post(AppUrl.addJobUri,
          data: body,
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          }));
          if (kDebugMode) {
            print(response.data);
          }

    }else{
      if (kDebugMode) {
        print("Result is null");
      }
    }      
  
  }
  }

  @override
  Widget build(BuildContext context) {
   return  Scaffold(
      appBar: AppBar(
        title: const Text("Upload Image and file"),
      ),
      body: ListView(
        children: [
          Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 100,
                  decoration: const BoxDecoration(
                   ),
                  child: Center(
                    child: IconButton(
                      onPressed: (){
                        uploadImage();
                      }, 
                      icon: const Icon(Icons.image, size: 50, color: Colors.black,)),
                  ),
              
                ),
              ),
        ],
      ),
    );
  }
}