// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import '../classes/Config.dart';
import '../classes/Utils.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

//  The map stuff is from
//  https://www.youtube.com/watch?v=EYcslTjRqCY

class MapPage extends StatefulWidget {
  const MapPage({ super.key });

  @override
  State createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {

  _MapPageState() {
    Utils.log('<<< ( MapPage.dart ) init >>>', 2, true );
  }

  // (this page) variables
  static const String _fileName = 'MapPage.dart';
  // marker locations
  static const double y = 45.3166228;   // initial camera y position
  static const double x = -79.2299500;  // initial camera x position
  LatLng currentLocation = LatLng(y,x);
  LatLng currentLocation2 = LatLng(45.3366228,-79.2139500);
  LatLng currentLocation3 = LatLng(45.6574872,-81.9693919);
  // map stuff
  late GoogleMapController myMapController;
  final Map<String, Marker> _markers = {};
  final CameraPosition _defaultCamera = CameraPosition(
    target: LatLng(y,x),
    zoom: 13,
  );

  static const String mapStyleJSON = "[{\"elementType\":\"geometry\",\"stylers\":[{\"color\":\"#242f3e\"}]},{\"elementType\":\"labels.text.fill\",\"stylers\":[{\"color\":\"#746855\"}]},{\"elementType\":\"labels.text.stroke\",\"stylers\":[{\"color\":\"#242f3e\"}]},{\"featureType\":\"administrative.locality\",\"elementType\":\"labels.text.fill\",\"stylers\":[{\"color\":\"#d59563\"}]},{\"featureType\":\"poi\",\"elementType\":\"labels.text.fill\",\"stylers\":[{\"color\":\"#d59563\"}]},{\"featureType\":\"poi.park\",\"elementType\":\"geometry\",\"stylers\":[{\"color\":\"#263c3f\"}]},{\"featureType\":\"poi.park\",\"elementType\":\"labels.text.fill\",\"stylers\":[{\"color\":\"#6b9a76\"}]},{\"featureType\":\"road\",\"elementType\":\"geometry\",\"stylers\":[{\"color\":\"#38414e\"}]},{\"featureType\":\"road\",\"elementType\":\"geometry.stroke\",\"stylers\":[{\"color\":\"#212a37\"}]},{\"featureType\":\"road\",\"elementType\":\"labels.text.fill\",\"stylers\":[{\"color\":\"#9ca5b3\"}]},{\"featureType\":\"road.highway\",\"elementType\":\"geometry\",\"stylers\":[{\"color\":\"#746855\"}]},{\"featureType\":\"road.highway\",\"elementType\":\"geometry.stroke\",\"stylers\":[{\"color\":\"#1f2835\"}]},{\"featureType\":\"road.highway\",\"elementType\":\"labels.text.fill\",\"stylers\":[{\"color\":\"#f3d19c\"}]},{\"featureType\":\"transit\",\"elementType\":\"geometry\",\"stylers\":[{\"color\":\"#2f3948\"}]},{\"featureType\":\"transit.station\",\"elementType\":\"labels.text.fill\",\"stylers\":[{\"color\":\"#d59563\"}]},{\"featureType\":\"water\",\"elementType\":\"geometry\",\"stylers\":[{\"color\":\"#17263c\"}]},{\"featureType\":\"water\",\"elementType\":\"labels.text.fill\",\"stylers\":[{\"color\":\"#515c6d\"}]},{\"featureType\":\"water\",\"elementType\":\"labels.text.stroke\",\"stylers\":[{\"color\":\"#17263c\"}]}]";

  // (this page) init and dispose
  @override
  void initState() {
    super.initState();
    Utils.log('( $_fileName ) initState()');
    WidgetsBinding.instance.addPostFrameCallback((_) => _addPostFrameCallbackTriggered(context));
  }

  @override
  void dispose() {
    Utils.log('( $_fileName ) dispose()');
    super.dispose();
  }

  // (this page) methods
  void _buildTriggered() {
    Utils.log('( $_fileName ) _buildTriggered()');
  }

  
  void _addPostFrameCallbackTriggered( context ) {
    Utils.log('( $_fileName ) _addPostFrameCallbackTriggered()');
    // Utils.log (getUserCurrentLocation().toString());
    Timer.periodic( Duration(seconds: 2), (timer) {
      // debugPrint(timer.tick.toString());
      getUserCurrentLocation();
    });    
  }

  // created method for getting user current location
  Future<Position> getUserCurrentLocation() async {
    Utils.log('getUserCurrentLocation()');
    await Geolocator.requestPermission().then((value){
    }).onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      Utils.log( "ERROR$error" );
    });
    return await Geolocator.getCurrentPosition();
  }  

  void _addMarker( String id, LatLng location ) {
    var marker = Marker(
      markerId: MarkerId( id ),
      position: location, 
      infoWindow: InfoWindow(
        title: id.toString(),
        onTap: () {
          Utils.log('tapped infoWindow');
        }
        //snippet: '()',
      ), 
    );

    _markers[id] = marker;

  }

  Future<void> moveMap() async {
    Utils.log('moveMap()');
    const _newPosition = LatLng(45.6574872,-81.9693919);
    myMapController.animateCamera(CameraUpdate.newLatLng(_newPosition));
  }

  // (this page) build
  @override
  Widget build(BuildContext context) {

    _buildTriggered();

    return WillPopScope(
      onWillPop: () async {
        Utils.log('( $_fileName ) WillPopScope() triggered');
        return true;    // true allows back button (false denies)
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            // title: Text( _fileName ),
            title: Text( 'Map ${ Config.appVersion }' ),
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.navigation_rounded ,
                ),
                onPressed: () {
                  moveMap();
                },
              )
            ],            
          ),
          body: Column(
            children:  [
              Expanded(
                flex: 1,
                child: Center(
                  child: GoogleMap(
                    initialCameraPosition: _defaultCamera,
                    onMapCreated: ( controller ) {
                      myMapController = controller;
                      setState(() {
                      //_addMarker( 'Marker 1', currentLocation );
                      _addMarker( 'Marker 2', currentLocation2 );
                      _addMarker( 'Marker 3', currentLocation3 );                        
                      });
                      myMapController.setMapStyle( mapStyleJSON );                      
                    },
                    markers: _markers.values.toSet(),
                    mapToolbarEnabled: false,
                    //mapType: MapType.terrain,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    trafficEnabled: true,
                  ),
                ),
              ),  
            ],
          ),
        ),
      ),
    );
  }
}