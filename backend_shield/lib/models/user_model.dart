import 'package:cloud_firestore/cloud_firestore.dart';

class HSUser {
  String? id;
  String? firstName;
  String? lastName;
  String? mobileNo;
  String? email;
  DateTime? dateOfBirth;
  HSUserAddress? address;
  String? profileImage;
  String? fcmToken;
  String? aadharCard;
  HSUserLocation? userLocation;
  String? gender;
  List<String>? emergencyContact;

  HSUser({
    this.id,
    this.email,
    this.firstName,
    this.lastName,
    this.address,
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
    String? mobileNo = json['mobileNo'];
    if (mobileNo != null && mobileNo.length != 10) {
      throw const FormatException('Mobile number must be 10 digits.');
    }

    String? aadharCard = json['aadharCard'];
    if (aadharCard != null && aadharCard.length != 12) {
      throw const FormatException('Aadhar card must be 12 digits.');
    }

    return HSUser(
      id: json['id'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      address: json['address'] != null
          ? HSUserAddress.fromJson(json: json['address'])
          : null,
      dateOfBirth: (json['dateOfBirth'] != null)
          ? (json['dateOfBirth'] as Timestamp).toDate()
          : null,
      profileImage: json['profileImage'],
      fcmToken: json['fcmToken'],
      mobileNo: mobileNo,
      aadharCard: aadharCard,
      gender: json['gender'],
      userLocation: json['userLocation'] != null
          ? HSUserLocation.fromJson(json['userLocation'])
          : null,
      emergencyContact: json['emergencycontact'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'address': address?.toJson(),
      if (dateOfBirth != null) 'dateOfBirth': Timestamp.fromDate(dateOfBirth!),
      'profileImage': profileImage,
      'fcmToken': fcmToken,
      'mobileNo': mobileNo,
      'aadharCard': aadharCard,
      'gender': gender,
      'userLocation': userLocation,
      'emergencycontact' : emergencyContact
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
      'lat': lat,
      'long': long,
      'geoHash': geoHash,
    };
  }
}
