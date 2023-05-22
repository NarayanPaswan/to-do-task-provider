import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:todotaskprovider/model/student_model.dart';
import 'package:todotaskprovider/screens/students/add_student.dart';
import '../../database/db_provider.dart';
import '../../utils/components/routers.dart';
import '../authentication/login_screen.dart';

class HomePaginationWithModal extends StatefulWidget {
  const HomePaginationWithModal({super.key});

  @override
  State<HomePaginationWithModal> createState() => _HomePaginationWithModalState();
}

class _HomePaginationWithModalState extends State<HomePaginationWithModal> {
  final scrollController = ScrollController();
  int pageNo = 1;
  bool isLoadingMore = false;
  List students = [];
  bool hasMoreData = true;
  
  @override
  void initState() {
    scrollController.addListener(_scrollListener);
    fetchAllStudents();
    super.initState();

  }
  
  final dio = Dio();
  Future<void> fetchAllStudents() async {
    final token = await DatabaseProvider().getToken();
    final url = 'http://192.168.16.104:8000/api/auth/all-students?page=$pageNo';
    // print(url);
    final response = await dio.get(
      url,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );

    final studentsModel = StudentsModel.fromJson(response.data);
     setState(() {
    if (pageNo == 1) {
      students = studentsModel.data?.data ?? []; // Clear the list for the first page
    } else {
      students.addAll(studentsModel.data?.data ?? []); // Add data to the list for subsequent pages
    }
    hasMoreData = studentsModel.data?.nextPageUrl != null;
  });
  }

 
 
  @override
  
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: const Text("Home Page"),
          actions: [
          IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () async{
                ///logout
                DatabaseProvider().logOut();
                PageNavigator(ctx: context).nextPageOnly(page: const LoginScreen());
              }
              
              ),
        ],
      ),
      body:
      Column(
        children: [
          Expanded(
            child: students.isNotEmpty ?
            ListView.builder(
              controller: scrollController,
              itemCount: isLoadingMore ? students.length + 1 : students.length,
              itemBuilder: (context, index){
                if(index< students.length){
                   return Padding(
                     padding: const EdgeInsets.all(12.0),
                     child: Card(
                       child: ListTile(
                        leading: CircleAvatar(
                          child: Text("${index +1 }"),
                        ),
                       title: Text(students[index].name.toString()),
                       ),
                     ),
                   );
                }else{
                return  const Center(child: CircularProgressIndicator());
                }
                
              }
              ): const Center(child: CircularProgressIndicator()),
          ),
          if (!hasMoreData)
            const Text("No more data available")
        ],
      ),
        

      floatingActionButton: FloatingActionButton(
        mini: true,
        onPressed: (){
           PageNavigator(ctx: context).nextPage(page: const AddStudentScreen());
        },
        child: const Icon(Icons.add),
        ),
    );
  }

 Future<void> _scrollListener() async{
   if (isLoadingMore || !hasMoreData) return;
   if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
    setState(() {
      isLoadingMore = true;
    });
        pageNo = pageNo + 1;
        if (kDebugMode) {
          print("scrolling called");
        }
       await fetchAllStudents();
      
      setState(() {
      isLoadingMore = false;
      });

        }
  
  }
}