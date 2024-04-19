import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:weather/weather.dart';

class Findweather extends StatefulWidget {
  const Findweather({super.key});
  

  @override
  State<Findweather> createState() => _FindweatherState();
}

WeatherFactory wf = new WeatherFactory("ad66c8f6ca3c12ac704dc2d1e4dd026b");
Weather? w;
LatLng? latlng;
Position? position;
String? _currentAddress;
String? currentlocality;
String? currentsubadmin;
String?country;
Position? _currentPosition;

var inp = TextEditingController();

class _FindweatherState extends State<Findweather> {

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


 void getweather(String city)async{
  try{
    w = await wf.currentWeatherByCityName(city);
  }
  catch(e){
    QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Error',
          text: 'No City Found!',
          backgroundColor: Colors.black,
          titleColor: Colors.white,
          textColor: Colors.white,
        );
  }
    
    setState(() {
      
    });
 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hikers Watch", style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/bg.jpg"),
          fit: BoxFit.cover,
          ),
        ),
        constraints: BoxConstraints.expand(),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text("Get Weather", style: TextStyle(fontSize: 30, color: Colors.white),),
                  Gap(50),
                  TextField(
                    controller: inp,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("City"),
                    ),
                  ),
                  Gap(12),
                  ElevatedButton(
                    onPressed: (){
                      getweather(inp.text);
                    }, 
                    child: Text("Get Weather")
                  ),
                  Gap(40),
                    
                  // Text('Weather: ${w?.weatherMain ?? ""}'),
                  // Text('Temperature: ${w?.temperature ?? ""}'),
                  w != null ? Text("Weather: ${w}", textAlign: TextAlign.center,) : Text(""),  
                ],
              ),
            ),
          ),
        ),
        ),
    );
  }
}