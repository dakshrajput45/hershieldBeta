import 'package:cloud_firestore/cloud_firestore.dart';

class HSUser {
  String? id;
  String? name;
  String? mobileNo;
  String? email;
  DateTime? dateOfBirth;
  //HSUserAddress? address;
  String? profileImage;
  String? fcmToken;
  String? aadharCard;
  HSUserLocation? userLocation;
  String? gender;
  List<String>? emergencyContact;

  HSUser({
    this.id,
    this.email,
    this.name,
   // this.address,
    this.dateOfBirth,
    this.profileImage,
    this.fcmToken,
    this.mobileNo,
    this.aadharCard,
    this.gender,
    this.userLocation,
    this.emergencyContact,
  });

  factory HSUser.fromJson({required Map<String, dynamic> json}) {

  return HSUser(
    id: json['id'],
    email: json['email'],
    name: json['name'],
    // address: json['address'] != null
    //     ? HSUserAddress.fromJson(json: json['address'])
    //     : null,
    dateOfBirth: (json['dateOfBirth'] != null)
        ? (json['dateOfBirth'] as Timestamp).toDate()
        : null,
    profileImage: json['profileImage'],
    fcmToken: json['fcmToken'],
    mobileNo: json['mobileNo'],
    aadharCard: json['aadharCard'],
    gender: json['gender'],
    userLocation: json['userLocation'] != null
        ? HSUserLocation.fromJson(json['userLocation'])
        : null,
    emergencyContact: json['emergencycontact'] != null &&
            json['emergencycontact'] is List
        ? List<String>.from(json['emergencycontact'])
        : null,
  );
}


  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (email != null) 'email': email,
      if (name != null) 'name': name,
      //if (address != null) 'address': address?.toJson(),
      if (dateOfBirth != null) 'dateOfBirth': Timestamp.fromDate(dateOfBirth!),
      if (profileImage != null) 'profileImage': profileImage,
      if (fcmToken != null) 'fcmToken': fcmToken,
      if (mobileNo != null) 'mobileNo': mobileNo,
      if (aadharCard != null) 'aadharCard': aadharCard,
      if (gender != null) 'gender': gender,
      if (userLocation != null) 'userLocation': userLocation,
      if (emergencyContact != null) 'emergencycontact': emergencyContact,
    };
  }
}

class HSUserAddress {
  String? country;
  String? state;
  String? city;

  HSUserAddress({
    this.country,
    this.state,
    this.city,
    String? profileImage,
  });

  factory HSUserAddress.fromJson({required Map<String, dynamic> json}) {
    return HSUserAddress(
      country: json['country'],
      state: json['state'],
      city: json['city'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (state != null) 'state': state,
      if (country != null) 'country': country,
      if (city != null) 'city': city,
    };
  }
}

class HSUserLocation {
  double? lat;
  double? long;
  String? geoHash;

  HSUserLocation({
    this.lat,
    this.long,
    this.geoHash,
  });

  factory HSUserLocation.fromJson(Map<String, dynamic> json) {
    return HSUserLocation(
      lat: json['lat'],
      long: json['long'],
      geoHash: json['geoHash'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (lat != null) 'lat': lat,
      if (long != null) 'long': long,
      if (geoHash != null) 'geoHash': geoHash,
    };
  }
}
