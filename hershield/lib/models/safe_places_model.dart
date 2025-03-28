class HSSafePlace {
  final String? name;
  final double? lat;
  final double? lon;
  final String? type;
  final double? distance;
  final String? mapsUrl;

  HSSafePlace({
    this.name,
    this.lat,
    this.lon,
    this.type,
    this.distance,
    this.mapsUrl,
  });

  // Convert JSON to SafePlace object
  factory HSSafePlace.fromJson(Map<String, dynamic> json) {
    return HSSafePlace(
      name: json['name'] ?? "Unknown Place",
      lat: _parseDouble(json['lat']),
      lon: _parseDouble(json['lon']),
      type: json['type'] ?? "unknown",
      distance: _parseDouble(json['distance']),
      mapsUrl: json['maps_url'] ?? "",
    );
  }

  // Convert SafePlace object to JSON
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "lat": lat,
      "lon": lon,
      "type": type,
      "distance": distance,
      "maps_url": mapsUrl,
    };
  }

  // Helper function to parse lat/lon/distance safely
  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}


class SafePlacesResult {
  final List<HSSafePlace>? places;
  final String? directionsUrl;

  SafePlacesResult({this.places, this.directionsUrl});
}
