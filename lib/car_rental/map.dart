import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;

class CarMap extends StatefulWidget {
  final String carId;
  CarMap(this.carId);
  @override
  _CarMapState createState() => _CarMapState();
}

class _CarMapState extends State<CarMap> {
  final loc.Location location = loc.Location();
  late GoogleMapController _controller;
  bool _added = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('CarLocation').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (_added) {
              mymap(snapshot);
            }
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            return GoogleMap(
              mapType: MapType.normal,
              markers: {
                Marker(
                    position: LatLng(
                      snapshot.data!.docs.singleWhere(
                              (element) => element.id == widget.carId)['latitude'],
                      snapshot.data!.docs.singleWhere(
                              (element) => element.id == widget.carId)['longitude'],
                    ),
                    markerId: MarkerId('id'),
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueMagenta)),
              },
              initialCameraPosition: CameraPosition(
                  target: LatLng(
                    snapshot.data!.docs.singleWhere(
                            (element) => element.id == widget.carId)['latitude'],
                    snapshot.data!.docs.singleWhere(
                            (element) => element.id == widget.carId)['longitude'],
                  ),
                  zoom: 14.47),
              onMapCreated: (GoogleMapController controller) async {
                setState(() {
                  _controller = controller;
                  _added = true;
                });
              },
            );
          },
        ));
  }

  Future<void> mymap(AsyncSnapshot<QuerySnapshot> snapshot) async {
    await _controller
        .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(
          snapshot.data!.docs.singleWhere(
                  (element) => element.id == widget.carId)['latitude'],
          snapshot.data!.docs.singleWhere(
                  (element) => element.id == widget.carId)['longitude'],
        ),
        zoom: 30)));
  }
}
