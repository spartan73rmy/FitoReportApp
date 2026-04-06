import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapArea extends StatefulWidget {
  final LatLng point;
  MapArea(this.point, {super.key});

  @override
  _MapAreaState createState() => _MapAreaState();
}

class _MapAreaState extends State<MapArea> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      height: MediaQuery.of(context).size.height * 0.35,
      child: FlutterMap(
        options: MapOptions(
          initialCenter: widget.point,
          initialZoom: 15.0,
        ),
        children: [
          TileLayer(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: const ['a', 'b', 'c']),
          MarkerLayer(
            markers: [
              Marker(
                width: 40.0,
                height: 40.0,
                point: widget.point,
                child: const FlutterLogo(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
