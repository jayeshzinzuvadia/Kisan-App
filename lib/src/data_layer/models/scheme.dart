import 'dart:io';

class Scheme {
  final String schemeId;
  String name;
  String provider;
  String details;
  String imageURL;
  String videoLink;
  String registrationLink;
  String author;
  File image;

  Scheme({
    this.schemeId,
    this.name,
    this.provider,
    this.details,
    this.imageURL,
    this.videoLink,
    this.registrationLink,
    this.author,
    this.image,
  });
}

class SchemeViewModel {
  String schemeId;
  String name;
  String provider;
  String imageURL;
  String videoLink;

  SchemeViewModel({
    this.schemeId,
    this.name,
    this.imageURL,
    this.provider,
    this.videoLink,
  });
}
