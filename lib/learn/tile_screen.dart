import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../database/db_provider.dart';
import '../utils/components/app_url.dart';

class TileScreen extends StatefulWidget {
  const TileScreen({super.key});

  @override
  State<TileScreen> createState() => _TileScreenState();
}

class _TileScreenState extends State<TileScreen> {
  @override
  void initState() {
    fetchCountry();
    super.initState();
  }
   final dio = Dio();
  List? user;
  // Future<CountryListModel>fetchCountry() async {
    fetchCountry() async {
  
    final token = await DatabaseProvider().getToken();
    const urlCountry = AppUrl.allCountriesUri;
    // print(urlCountry);

    final response = await dio.get(
      urlCountry,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );

    print(response.data['data'][0]['country_name']);
    // print(user) ;
 
}
  
  @override
  Widget build(BuildContext context) {
    fetchCountry();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Json Learning"),
      ),
      body: ListView.builder(
          itemCount: 10,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
                leading: const Icon(Icons.list),
                trailing: const Text(
                  "GFG",
                  style: TextStyle(color: Colors.green, fontSize: 15),
                ),
                title: Text("List item $index"),
                // subtitle: Text(user![index].country_name),
                );
                
          }),
      
    );
  }
}