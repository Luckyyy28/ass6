import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:medrano_ass6/findweather.dart';
import 'package:weather/weather.dart';

class ass6_screen extends StatefulWidget {
  ass6_screen({super.key});
  

  @override
  State<ass6_screen> createState() => _ass6_screenState();
}

//ad66c8f6ca3c12ac704dc2d1e4dd026b

WeatherFactory wf = new WeatherFactory("ad66c8f6ca3c12ac704dc2d1e4dd026b");
Weather? w;
LatLng? latlng;
Position? position;
String? _currentAddress;
String? currentlocality;
String? currentsubadmin;
String?country;
Position? _currentPosition;

class _ass6_screenState extends State<ass6_screen> {

  void getPosition() async{
    position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  Future<bool> _handleLocationPermission() async {
  bool serviceEnabled;
  LocationPermission permission;
  
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Location services are disabled. Please enable the services')));
    return false;
  }
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {   
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are denied')));
      return false;
    }
  }
  if (permission == LocationPermission.deniedForever) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Location permissions are permanently denied, we cannot request permissions.')));
    return false;
  }
  return true;
}

  Future<void> _getCurrentPosition() async {
  final hasPermission = await _handleLocationPermission();
  if (!hasPermission) return;
  await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high)
      .then((Position position) {
    setState(() => _currentPosition = position);
    _getAddressFromLatLng(_currentPosition!);
  }).catchError((e) {
    debugPrint(e);
  });
}

Future<void> _getAddressFromLatLng(Position position) async {
  await placemarkFromCoordinates(
          _currentPosition!.latitude, _currentPosition!.longitude)
      .then((List<Placemark> placemarks) {
    Placemark place = placemarks[0];
    setState((){
      latlng = LatLng(_currentPosition!.latitude, _currentPosition!.longitude);
      _currentAddress ='${place.locality},${place.subAdministrativeArea}, ${place.country}';
      currentlocality = place.locality.toString();
      currentsubadmin = place.subAdministrativeArea.toString();
      country = place.country.toString();
    }); getweather();
  }).catchError((e) {
    debugPrint(e);
  });
 }

 void getweather()async{
    w = await wf.currentWeatherByLocation(latlng!.latitude, latlng!.longitude);
    setState(() {
      
    });
 }

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Hiker's Watch", style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage("assets/bg.jpg"),
            fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Column(
                    children: [
                      Gap(12),
                      Text("Current Location", style: TextStyle(fontSize: 30),),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Gap(100),
                      Text('LAT: ${_currentPosition?.latitude ?? ""}'),
                      Text('LNG: ${_currentPosition?.longitude ?? ""}'),
                      Gap(12),
                      // Text('Address: ${_currentAddress ?? ""}'),
                      Text('Locality: ${currentlocality}'),
                      Text('Province: ${currentsubadmin}'),
                      Text('Country: ${country}'),
                      Gap(12),
                      Text('Weather: ${w?.weatherMain ?? ""}'),
                      Text('Temperature: ${w?.temperature ?? ""}'),
                      Gap(50),
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => Findweather())), 
                        child: Text("Get Weather"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}