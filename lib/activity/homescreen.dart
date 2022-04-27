import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error("Location services are disabled.");
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          "Location permissions are permanantly denied. we cannot request permissions.");
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            "Location permissions are denied (actual value: $permission).");
      }
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Get Current Location"),
      ),
      body: Center(
        child: FutureBuilder(
          future: _determinePosition(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final Position position = snapshot.data as Position;
              getAddress(position);

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("EmployeeName : $_empName"),
                  Text("Lat : ${position.latitude}"),
                  Text("Lng : ${position.longitude}"),
                  Text("Address : $_address"),
                ],
              );
            } else if (snapshot.hasError) {
              /*  Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(
                    snapshot.error.toString(),
                  )));*/
              return Text(snapshot.error.toString());
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  late String _address;
  late String _empName;

  Future<void> getAddress(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Placemark place = placemarks[0];
    String address = place.name! +
        " " +
        place.locality! +
        " " +
        place.subLocality! +
        " " +
        place.administrativeArea! +
        " " +
        place.postalCode!;
    setState(() {
      _address = address;
      _empName=prefs.getString("NAME")!;
    });
  }
}
