import 'dart:async';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../utils/exports.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class AddAddressView extends StatefulWidget {
  
  String latitudeValue; String longitudeValue;
  final Function(String) onAddressSelected; // Callback function

  AddAddressView({super.key, required this.latitudeValue,
   required this.longitudeValue,
   required this.onAddressSelected,
   });

  @override
  State<AddAddressView> createState() => _AddAddressViewState();
}

class _AddAddressViewState extends State<AddAddressView> {
  String streetAddress = '';
  String? latitudeData;
  String? longitudeData;

  LatLng? selectedLatLng;

  
  TextEditingController _searchController = TextEditingController();
  var uuid = Uuid();
  String _sessionToken = '1239832';
  List<dynamic> _placesList = [];
  Timer? _debounce; 
  bool isAddressListVisible = true; // Add this flag

  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();

    static CameraPosition initialCameraPosition = CameraPosition(
      target: LatLng(20.5937, 78.9629),
      zoom: 14.4746,
    );

  final List<Marker> _markers = <Marker>[
   Marker(
      markerId: MarkerId("_kGooglePlex"),
      position: LatLng(20.5937, 78.9629),
      infoWindow: InfoWindow(title: "Google Plex"),
    )
  ];

  @override
  void initState() {
    super.initState();
    latitudeData = widget.latitudeValue;
    longitudeData = widget.longitudeValue;
    print("My lat long data");
    print(latitudeData.toString() + " " + longitudeData.toString());

    _searchController.addListener(() {
       onChangePlace(); 
    });

  }
 

  void onChangePlace() {
  if (_debounce?.isActive ?? false) _debounce!.cancel();
  _debounce = Timer(const Duration(milliseconds: 3000), () {
    if (_sessionToken == null) {
      setState(() {
        _sessionToken = uuid.v4();
      });
    }
    getSuggestion(_searchController.text);
     // Set isAddressListVisible to true whenever the user types in the search box
      setState(() {
        isAddressListVisible = true;
      });
  });
}


  void getSuggestion(String input)async{
    String kplacesApiKey = "AIzaSyBgcejM6KxDF1mfBl6icxy2WlZ84WR1shs";
    String baseURL = "https://maps.googleapis.com/maps/api/place/autocomplete/json";
    String request = '$baseURL?input=$input&key=$kplacesApiKey&sessiontoken=$_sessionToken';

    var response = await http.get(Uri.parse(request));
    var data = response.body.toString();
    print(data);
    if(response.statusCode == 200){
      setState(() {
        _placesList = jsonDecode(response.body.toString()) ['predictions'];
      });
    }else{
      throw Exception('Faild to load data');
    }

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _searchController.dispose();
  }
      
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Google Maps"),
      ),
      body: ListView(
        children: [
          Column(
            children: [
              TextFormField(
               controller: _searchController,
               decoration: const InputDecoration(  
                 hintText: "Search your place"
                 ),
               ),
          
               SizedBox(
                height: 200,
                 child: isAddressListVisible // Use the flag to conditionally show/hide the address list
                    ?
                 
                 ListView.separated(
                  itemCount: _placesList.length,
                   separatorBuilder: (context, index) => Divider(), 
                  itemBuilder: (context, index){
                     return ListTile(
                      onTap: () async {
                        List<Location> locations = await locationFromAddress(_placesList[index]['description']);
                        setState(() {
                          selectedLatLng = LatLng(locations.last.latitude, locations.last.longitude);
                        });

                        // Move the camera to the selected location
                        final GoogleMapController controller = await _controller.future;
                        controller.animateCamera(CameraUpdate.newLatLng(selectedLatLng!));

                        // Update the marker position on the map
                        setState(() {
                          _markers.removeWhere((marker) => marker.markerId.value == "selectedMarker");
                          _markers.add(Marker(
                            markerId: MarkerId("selectedMarker"),
                            position: selectedLatLng!,
                            infoWindow: InfoWindow(title: "Selected Location"),
                          ));
                        });
                        _searchController.text = _placesList[index]['description'];
                        setState(() {
                                isAddressListVisible = false;
                              });
                      },
                      
                      title: Text(_placesList[index]['description']),
                       
                    );
                    
                 }
                 )
                   : SizedBox(),


               ),
          
              SizedBox(
                height: 300,
                child: GoogleMap(
                  mapType: MapType.normal,
                  markers: Set<Marker>.of(_markers),
                  initialCameraPosition: initialCameraPosition,
                  
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
     

   floatingActionButton: FloatingActionButton.extended(
    onPressed: () async {
       // Create a new Marker with the user's current position
        Marker newMarker = Marker(
          markerId: MarkerId("userMarker"),
          position: LatLng(double.parse(latitudeData!), double.parse(longitudeData!)),
          infoWindow: InfoWindow(title: "My current location"),
        );
        // Add the new marker to the list of markers
        setState(() {
      _markers.add(newMarker);
        });

         // Animate the camera to the new marker's position
    CameraPosition cameraPosition = CameraPosition(
      zoom: 14,
      target: LatLng(double.parse(latitudeData!), double.parse(longitudeData!)),
    );
     final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

      // Get the placemarks for the user's current location
    List<Placemark> placemarks = await placemarkFromCoordinates(double.parse(latitudeData!), double.parse(longitudeData!));

    // Extract relevant information from the placemark
    
    // String street = placemarks.first.street ?? "";
    String locality = placemarks.first.locality ?? "";
    String subAdministrativeArea = placemarks.first.subAdministrativeArea ?? "";
    String state = placemarks.first.administrativeArea ?? "";
    String postalCode = placemarks.first.postalCode ?? "";
    String country = placemarks.first.country ?? "";
    // Construct the address string
    String address = "$locality $subAdministrativeArea $state $postalCode $country";
    

    // Update the UI
    setState(() {
      streetAddress = address;
      print("My current address");
      print(streetAddress);
    });
     // Use Navigator.pop to pass the streetAddress back to the previous screen (HomeView)
    widget.onAddressSelected(streetAddress);
    Future.delayed(const Duration(seconds: 2), () async {
      Navigator.pop(context);
     });
    
    
    },
  label: const Text('Get Address!'),
  icon: const Icon(Icons.place_outlined),
),

      
    );
  }
}