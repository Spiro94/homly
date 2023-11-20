import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homly/config/providers.dart';
import 'package:homly/features/common/domain/entities/property.dart';
import 'package:uuid/uuid.dart';

class PropertyRepository {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _firebaseStorage;

  PropertyRepository(this._firestore, this._firebaseStorage);

  Future<List<Property>> getUserProperties(String? email) async {
    final doc = await _firestore.collection('users').doc(email).get();

    final map = doc.data()!['properties'] as List<dynamic>?;
    final properties = <Property>[];
    if (map != null) {
      for (final element in map) {
        final result = await (element as DocumentReference).get();

        log('Property ${result.data()}');

        properties
            .add(Property.fromJson(result.data() as Map<String, dynamic>));
      }
    }

    return properties;
  }

  Future<List<Property>> getProperties() async {
    final doc = await _firestore.collection('properties').get();

    final properties = <Property>[];

    for (final document in doc.docs) {
      final result = Property.fromJson(document.data());
      properties.add(result);
    }

    return properties;
  }

  Future<Property> getProperty(String id) async {
    final doc = await _firestore.collection('properties').get();

    return Property.fromJson(
        doc.docs.firstWhere((element) => element['id'] == id).data());
  }

  Future<Unit> createProperty(Property property) async {
    final docRef = _firestore.collection('properties').doc(property.id);
    final userRef = _firestore.collection('users').doc(property.addedBy);

    await docRef.set(property.toJson());
    await userRef.update({
      'properties': FieldValue.arrayUnion([docRef])
    });

    return unit;
  }

//Function to save images to firebase storage
  Future<String> saveImageToFirebaseStorage(
    String propertyId,
    Uint8List data,
  ) async {
    final ref = _firebaseStorage
        .ref()
        .child('properties')
        .child(propertyId)
        .child('${const Uuid().v4()}.jpg');
    final uploadTask = ref.putData(
      data,
      SettableMetadata(
        contentType: 'image/jpeg',
      ),
    );
    final snapshot = await uploadTask.whenComplete(() => null);
    final url = await snapshot.ref.getDownloadURL();
    return url;
  }
}

final propertyRepositoryProvider = Provider<PropertyRepository>((ref) {
  return PropertyRepository(
    ref.watch(firestoreProvider),
    ref.watch(firebaseStorageProvider),
  );
});
