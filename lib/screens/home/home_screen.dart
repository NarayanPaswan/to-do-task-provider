import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:todotaskprovider/model/student_model.dart';
import 'package:todotaskprovider/screens/students/add_student.dart';
import '../../database/db_provider.dart';
import '../../learn/dropdwon_screen.dart';
import '../../learn/image_file_upload.dart';
import '../../learn/tile_screen.dart';
import '../../provider/student_provider.dart';
import '../../utils/components/routers.dart';
import '../../utils/style/app_colors.dart';
import '../authentication/login_screen.dart';
import '../students/update_student.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
    int _selectedIndex = 0;
   void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  final scrollController = ScrollController();
  int pageNo = 1;
  bool isLoadingMore = false;
  List<StudentData> students = [];
  bool hasMoreData = true;
  
  @override
  void initState() {
    scrollController.addListener(_scrollListener);
    fetchAllStudents();
  
    super.initState();

  }
  final studentTaskProvider = StudentTaskProvider();
  
  Future<void> fetchAllStudents() async {
    final fetchedStudents = await studentTaskProvider.getAllStudents(pageNo);

    setState(() {
      if (pageNo == 1) {
        students = fetchedStudents; // Clear the list for the first page
      } else {
        students.addAll(fetchedStudents); // Add data to the list for subsequent pages
      }
      hasMoreData = fetchedStudents.isNotEmpty;
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
          students.isNotEmpty ?
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
                     trailing: GestureDetector(
                      onTap: (){
                        showModalBottomSheet(
                          backgroundColor: Theme.of(context).primaryColor,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            )
                          ),
                          context: context, 
                          builder: (BuildContext context) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                 GestureDetector(
                                 onTap: ()async{
                                 Navigator.pop(context); 
                                await PageNavigator(ctx: context).nextPage(page: UpdateStudentScreen(
                                  id: students[index].id!.toInt(),
                                  studenName: students[index].name.toString(),
                                  contactNumber: students[index].contactNumber ?? '',
                                  dateOfBirth: students[index].dateOfBirth ?? '',
                                  countryId: students[index].countryId.toString(),
                                  stateId : students[index].stateId.toString(),
                                 ));
                                  },

                                   child: const ListTile(
                                    leading: Icon(Icons.edit, color: Colors.white,),
                                    title: Text("Edit", style: TextStyle(color: Colors.white),
                                  ),),),
   
                                  GestureDetector(
                                   onTap: ()async{
                                    Navigator.pop(context); 
                                   await studentTaskProvider.deleteJob(
                                      id: students[index].id!.toInt(),
                                      context: context
                                      );
                                    await fetchAllStudents(); 
                                  },
                                   child: const ListTile(
                                    leading: Icon(Icons.delete, color: Colors.white,),
                                    title: Text("Delete", style: TextStyle(color: Colors.white),
                                  ),),),
                            
                              ],
                            );
                          });
                      },
                      child: const Icon(Icons.more_vert, color: Colors.black,)
                      ),
                     ),
                   ),
                 );
              }
              
              else{
              return  const Center(child: CircularProgressIndicator());
              }
              
            }
            ):  const Padding(
              padding: EdgeInsets.only(top:10.0, bottom: 40.0),
              child: Center(child: CircularProgressIndicator()),
            ),
          if (!hasMoreData)
             const Padding(
               padding: EdgeInsets.only(top: 30.0, bottom: 30.0),
               child: Center(child: 
               Text("You have fetched all of the content")),
             ),
                 
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        items: [
           BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: 'Home',
            backgroundColor: AppColors.primaryColor,
          ),
        BottomNavigationBarItem(
            icon: IconButton(
                onPressed: (){
                PageNavigator(ctx: context).nextPage(page: const TileScreen());
              },
              icon: const Icon(Icons.business)),
            label: 'Business',
            backgroundColor: AppColors.primaryColor,
          ),
           BottomNavigationBarItem(
            icon: IconButton(
               onPressed: (){
                PageNavigator(ctx: context).nextPage(page: const DropdwonScreen());
              },
              icon: const Icon(Icons.school)),
            label: 'Dropdwon',
            backgroundColor: AppColors.primaryColor
          ),
           BottomNavigationBarItem(
            icon: IconButton(
               onPressed: (){
                PageNavigator(ctx: context).nextPage(page: const ImageFileUploadScreen());
              },
              icon: const Icon(Icons.image)),
            label: 'Upload',
            backgroundColor: AppColors.primaryColor,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        onTap: _onItemTapped,
        ),
        

      floatingActionButton: FloatingActionButton(
        mini: true,
        onPressed: (){
           PageNavigator(ctx: context).nextPage(page: const AddStudentScreen());
          // PageNavigator(ctx: context).nextPage(page: const TileScreen());
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