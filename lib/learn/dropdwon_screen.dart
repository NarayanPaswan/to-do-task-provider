import 'package:dio/dio.dart';
import 'package:todotaskprovider/model/country_list_model.dart';
import 'package:todotaskprovider/utils/exports.dart';

import '../database/db_provider.dart';
import '../model/state_model.dart';
import '../utils/components/app_url.dart';

class DropdwonScreen extends StatefulWidget {
  const DropdwonScreen({super.key});

  @override
  State<DropdwonScreen> createState() => _DropdwonScreenState();
}

class _DropdwonScreenState extends State<DropdwonScreen> {
  
  List<Data> countries = [];
  int? valueChooseMapFromApiWithModel;

  List<StateData> states = [];
  int? valueChooseStateModel;

  int? valueChooseMapFromApi;
  var listMapItemsApi = [];

  int? valueChooseGetCountry;
  List countryList = [];

  int? valueChooseGetState;
  List stateList = [];

  int? valueChooseGetCity;
  List cityList = [];

  final dio = Dio();

  @override
  void initState() {
  
    super.initState();
      getCountry();
      fetchCountry();
      //it run the loop from model and in countries and fill data in countries empty array.
      // fetchCountryWithModel().then((value) {
      //   setState(() {
      //     countries = value;
      //     // print(countries.toString());
      //   });
      // });  
       fetchCountryWithModel();
      
  }
  // Get Country information by API
 Future<void> getCountry() async {
  
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
      setState(() {
      // Update the state with the fetched data
      countryList = response.data['data'];
    });
 
  }

    // Get State information by API

    Future<void> getState(countryId) async {
    final token = await DatabaseProvider().getToken();
    final urlStateList = '${AppUrl.stateFromCountryUri}?country_id=$countryId';
    
    final response = await dio.get(
      urlStateList,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );
    
    // print(response.data['data']);
      setState(() {
      // Update the state with the fetched data
      stateList = response.data['data'];
    });
 
  } 
  
   // Get State information by API

    Future<void> getCity(stateId) async {
    final token = await DatabaseProvider().getToken();
    final urlCityList = '${AppUrl.cityFromStateUri}?state_id=$stateId';
    
    final response = await dio.get(
      urlCityList,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );
    // print(response.data['data']);
      setState(() {
      // Update the state with the fetched data
      cityList = response.data['data'];
    });
 
  } 

  
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
      setState(() {
      // Update the state with the fetched data
      listMapItemsApi = response.data['data'];
    });
 
  }

  //  Future<List<Data>> fetchCountryWithModel() async {
   Future<void> fetchCountryWithModel() async { 
  
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
    
    // return CountryListModel.fromJson(response.data);
      final countryListModel = CountryListModel.fromJson(response.data);
     setState(() {
      countries = countryListModel.data ?? [];
      });

      // return countryListModel.data ?? [];
    

      // print(countryListModel.data!.length);
      
           
      /*
      //it will print data with model name

      countryListModel.data?.map((e){
        print(e.countryName);
        
      }).toList();
      */
      
      /*
      //if i want to store only one single value in a list variable 
      var newContryData =  countryListModel.data?.map((e){
        return e.countryName;
        
      }).toList();

      print(newContryData);
      */
    
    /*
    //we can print data using for loop and can store in another list
    for(int i=0; i<countryListModel.data!.length; i++){
      // print(countryListModel.data![i].countryName);
      var narayan =countryListModel.data![i].countryName;
      print(narayan);
      
    }
   */
  //Must know dart list map time 24:36
  

   
 
  }

   Future<void> fetchStateWithModel(countryId) async {
  
    final token = await DatabaseProvider().getToken();
    final urlState = '${AppUrl.stateFromCountryUri}?country_id=$countryId';
    
    final response = await dio.get(
      urlState,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );
    
    
     final stateListModel = StateModel.fromJson(response.data);
     setState(() {
       states = stateListModel.data ?? [];
     });
      
 
  }
   
 int? valueChooseMap;
 List listMapItems = [
  {"title": "India", "id": 1},
  {"title": "Nepal", "id": 2},
  {"title": "Bhutan", "id": 3},
  {"title": "Bangladesh", "id": 4}
 ];

String? valueChoose;

List listItem = ["Item-1","Item-2","Item-3","Item-4","Item-5"];

  @override
  Widget build(BuildContext context) {
    // fetchCountryWithModel();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dropdwon List"),
      ),
      body: ListView(
          children: [
             const Padding(
               padding:  EdgeInsets.all(8.0),
               child:  Text("Only Single List Item"),
             ),
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: DropdownButton<String>(
                value: valueChoose,
                onChanged: (newValue){
                  setState(() {
                    valueChoose = newValue;
                    // print("Selected value $newValue");
                  });
                  
                },
                isExpanded: true,
                menuMaxHeight: 350,
                items: listItem.map((newValueItem) {
                  return DropdownMenuItem<String>(
                    value: newValueItem,
                    child: Text(newValueItem),
                    );
                }).toList(),
                
                ),
             ),

              const Padding(
               padding:  EdgeInsets.all(8.0),
               child:  Text("List with map Items"),
             ),
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: DropdownButton<int>(
                value: valueChooseMap,
                onChanged: (newValueMap){
                  setState(() {
                    valueChooseMap = newValueMap;
                    // print("Selected value $newValueMap");
                  });
                  
                },
                isExpanded: true,
                menuMaxHeight: 350,
                items: listMapItems.map((newValueMapData) {
                  return DropdownMenuItem<int>(
                    value: newValueMapData['id'],
                    child: Text(newValueMapData['title']),
                    );
                }).toList(),
                
                ),
             ),

              const Padding(
               padding:  EdgeInsets.all(8.0),
               child:  Text("List with map Items from api"),
             ),
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: DropdownButton<int>(
                value: valueChooseMapFromApi,
                onChanged: (newValueMapApi){
                  setState(() {
                    valueChooseMapFromApi = newValueMapApi;
                    // print("Selected value $valueChooseMapFromApi");
                  });
                  
                },
                isExpanded: true,
                menuMaxHeight: 350,
                items: listMapItemsApi.map((newValueMapApiData) {
                  return DropdownMenuItem<int>(
                    value: newValueMapApiData['id'],
                    child: Text(newValueMapApiData['country_name']),
                    );
                }).toList(),
                
                ),
             ),


            const SizedBox(height: 10,),
            const Divider(color: Colors.red,),
            const Padding(
               padding:  EdgeInsets.all(8.0),
               child:  Text("Country, State and City", style: TextStyle(fontWeight: FontWeight.bold),),
             ),
            const Padding(
               padding:  EdgeInsets.all(8.0),
               child:  Text("All Country"),
             ),

              Padding(
               padding: const EdgeInsets.all(8.0),
               child: DropdownButton<int>(
                hint: const Text('Select Country'),
                value: valueChooseGetCountry,
                onChanged: (newValueGetCountry)async{
                  setState(() {
                    valueChooseGetCountry = newValueGetCountry;
                    valueChooseGetState = null;
                    // print("Selected value $valueChooseGetCountry");
                    
                  });
                   getState(newValueGetCountry);
                  
                },
                isExpanded: true,
                menuMaxHeight: 350,
               
                items: countryList.map((newCountryList) {
                  return DropdownMenuItem<int>(
                    value: newCountryList['id'],
                    child: Text(newCountryList["country_name"] ?? ''),
                    );
                }).toList(),
                
                ),
             ),

             const Padding(
               padding:  EdgeInsets.all(8.0),
               child:  Text("All States"),
             ),

              Padding(
               padding: const EdgeInsets.all(8.0),
               child: DropdownButton<int>(
                hint: const Text('Select State'),
                value: valueChooseGetState,
                onChanged: (newValueGetState)async{
                  setState(() {
                    valueChooseGetState = newValueGetState;
                    valueChooseGetCity = null;
                    // print("Selected value $valueChooseGetState");
                    
                  });
                  getCity(valueChooseGetState);
                  
                },
                isExpanded: true,
                menuMaxHeight: 350,
                items: stateList.map((newStateList) {
                  return DropdownMenuItem<int>(
                    value: newStateList['id'],
                    child: Text(newStateList["state_name"] ?? ''),
                    );
                }).toList(),
                
                ),
             ),

              const Padding(
               padding:  EdgeInsets.all(8.0),
               child:  Text("All City"),
             ),

              Padding(
               padding: const EdgeInsets.all(8.0),
               child: DropdownButton<int>(
                hint: const Text('Select City'),
                value: valueChooseGetCity,
                onChanged: (newValueGetCity)async{
                  setState(() {
                    valueChooseGetCity = newValueGetCity;
                    // print("Selected value $valueChooseGetCity");
                    
                  });
                  
                  
                },
                isExpanded: true,
                menuMaxHeight: 350,
                items: cityList.map((newCityList) {
                  return DropdownMenuItem<int>(
                    value: newCityList['id'],
                    child: Text(newCityList["city_name"] ?? ''),
                    );
                }).toList(),
                
                ),
             ),

            const SizedBox(height: 10,),
            const Divider(color: Colors.green,),

             const Padding(
               padding:  EdgeInsets.all(8.0),
               child:  Text("Country, State and City with model", style: TextStyle(fontWeight: FontWeight.bold),),
             ),

              const Padding(
               padding:  EdgeInsets.all(8.0),
               child:  Text("Country"),
             ),

              Padding(
               padding: const EdgeInsets.all(8.0),
               child: DropdownButton<int>(
                value: valueChooseMapFromApiWithModel,
                onChanged: (newValueMapApiModel){
                  setState(() {
                    valueChooseMapFromApiWithModel = newValueMapApiModel;
                     valueChooseStateModel = null;
                    // print("Selected value $valueChooseMapFromApiWithModel");
                  });
                  fetchStateWithModel(valueChooseMapFromApiWithModel);
                  
                },
                isExpanded: true,
                menuMaxHeight: 350,
                items: countries.map((newValueMapApiData) {
                  return DropdownMenuItem<int>(
                    value: newValueMapApiData.id,
                    child: Text(newValueMapApiData.countryName ?? ''),
                    );
                }).toList(),
                
                ),
             ),

               const Padding(
               padding:  EdgeInsets.all(8.0),
               child:  Text("States"),
             ),

              Padding(
               padding: const EdgeInsets.all(8.0),
               child: DropdownButton<int>(
                value: valueChooseStateModel,
                onChanged: (newValueStateModel)async{
                  setState(() {
                    valueChooseStateModel = newValueStateModel;
                    // print("Selected value $valueChooseStateModel");
                  });
                  
                },
                isExpanded: true,
                menuMaxHeight: 350,
                items: states.map((newValueState) {
                  return DropdownMenuItem<int>(
                    value: newValueState.id,
                    child: Text(newValueState.stateName ?? ''),
                    );
                }).toList(),
                
                ),
             ),           



          ],
      ),
    );
  }
}