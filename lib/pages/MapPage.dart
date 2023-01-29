// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
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

enum MapTypeEnum { normal, terrain, satellite, hybrid }

class _MapPageState extends State<MapPage> {

  _MapPageState() {
    Utils.log('<<< ( MapPage.dart ) init >>>', 2, true );
  }

  // (this page) variables
  static const String _fileName = 'MapPage.dart';
  //
  List<String> _colorValue = [ 'black','yellow','green','pink','blue','orange'];
  List<String> _textValue = [ 'white','black','white','black','white','white'];
  List<String> _terr = ['none''normal','terrain','satellite','hybrid'];
  List<String> _boolColorValue = [ 'white','black''white','black'];

  bool _trafficFlag = false;
  int _trafficInt = 1;
    int _terrIndex = 1;
  MapType _currentMapType = MapType.normal;

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
    zoom: 15,
  );

  //static const String mapStyleJSON = "[{\"featureType\":\"administrative.land_parcel\",\"elementType\":\"labels\",\"stylers\":[{\"visibility\":\"off\"}]},{\"featureType\":\"poi\",\"elementType\":\"labels.text\",\"stylers\":[{\"visibility\":\"off\"}]},{\"featureType\":\"poi.business\",\"stylers\":[{\"visibility\":\"off\"}]},{\"featureType\":\"road\",\"elementType\":\"labels.icon\",\"stylers\":[{\"visibility\":\"off\"}]},{\"featureType\":\"road.local\",\"elementType\":\"labels\",\"stylers\":[{\"visibility\":\"off\"}]},{\"featureType\":\"transit\",\"stylers\":[{\"visibility\":\"off\"}]}]";
  //static const String mapStyleJSON = "[{\"featureType\":\"administrative.land_parcel\",\"stylers\":[{\"visibility\":\"off\"}]},{\"featureType\":\"administrative.neighborhood\",\"stylers\":[{\"visibility\":\"off\"}]},{\"featureType\":\"poi\",\"elementType\":\"labels.text\",\"stylers\":[{\"visibility\":\"off\"}]},{\"featureType\":\"poi.business\",\"stylers\":[{\"visibility\":\"off\"}]},{\"featureType\":\"road\",\"elementType\":\"labels\",\"stylers\":[{\"visibility\":\"off\"}]},{\"featureType\":\"road\",\"elementType\":\"labels.icon\",\"stylers\":[{\"visibility\":\"off\"}]},{\"featureType\":\"transit\",\"stylers\":[{\"visibility\":\"off\"}]},{\"featureType\":\"water\",\"elementType\":\"labels.text\",\"stylers\":[{\"visibility\":\"off\"}]}]";
  static const String mapStyleJSON = "[{\"featureType\":\"administrative\",\"elementType\":\"geometry\",\"stylers\":[{\"visibility\":\"off\"}]},{\"featureType\":\"poi\",\"stylers\":[{\"visibility\":\"off\"}]},{\"featureType\":\"road\",\"elementType\":\"labels.icon\",\"stylers\":[{\"visibility\":\"off\"}]},{\"featureType\":\"transit\",\"stylers\":[{\"visibility\":\"off\"}]}]";
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

  void _tapMapType() {
    if (_terrIndex == 4) {
      _terrIndex = 0;
    }

    setState(() {
      _terrIndex++;
      _currentMapType = MapType.values[_terrIndex];
    });
  }

  void _tapTraffic() {
   // _trafficFlag ? !_trafficFlag : _trafficFlag;

    setState(() {
      _trafficFlag == true ? _trafficFlag = false : _trafficFlag = true;
      _trafficFlag == true ? _trafficInt = 0 : _trafficInt = 1;
    });
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
          body: Stack(
            children:  [ 
              GoogleMap(
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
                mapType: _currentMapType, 
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                trafficEnabled: _trafficFlag,
              ),
              Positioned(
                child: Container(child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children : [ 
                        ElevatedButton(
                          child: Text('START'),
                          onPressed: () {},
                        ),                        
                        ElevatedButton(
                          child: Text( MapType.values[_terrIndex].toString() ),
                          onPressed: () {
                            _tapMapType();
                          },
                        ),                         
                        ElevatedButton(
                          child: Text( 'Traffic.' + _trafficFlag.toString() ),
                          onPressed: () {
                            _tapTraffic();
                          },
                        ),                       

                    ]
                    ),
                  ),
                ))),
               
            ],
          ),
        ),
      ),
    );
  }
}