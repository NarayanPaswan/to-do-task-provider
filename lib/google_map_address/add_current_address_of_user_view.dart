import 'dart:async';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../utils/exports.dart';


// ignore: must_be_immutable
class AddCurrentAddressOfUserView extends StatefulWidget {
  
  String latitudeValue; String longitudeValue;
  final Function(String) onAddressSelected; // Callback function

  AddCurrentAddressOfUserView({super.key, required this.latitudeValue,
   required this.longitudeValue,
   required this.onAddressSelected,
   });

  @override
  State<AddCurrentAddressOfUserView> createState() => _AddCurrentAddressOfUserViewState();
}

class _AddCurrentAddressOfUserViewState extends State<AddCurrentAddressOfUserView> {
  String streetAddress = '';
  String? latitudeData;
  String? longitudeData;
  
  
  TextEditingController _searchController = TextEditingController();
 
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

   
  }
     
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Google Maps"),
      ),
      body: Column(
        children: [
          TextFormField(
           controller: _searchController,
           decoration: const InputDecoration(  
             hintText: "Search by city"
             ),
             onChanged: (value){
              //  print(value);
             },
           ),

          Expanded(
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