import 'dart:io';
import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kisan_app/src/data_layer/models/article.dart';
import 'package:kisan_app/src/data_layer/models/scheme.dart';
import 'constants.dart';

// This class provides the methods for Article and Scheme collection
class DatabaseService {
  // Collection Reference for Article Collection
  final CollectionReference _articleCollection =
      FirebaseFirestore.instance.collection(DbConstant.ARTICLE_COLLECTION);

  // Code taken from stackoverflow
  String getRandomDocumentId() {
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz0123456789';
    Random _rnd = Random();
    int length = 28;
    return String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }

  // write / update article
  Future<void> writeArticle(Article article) async {
    String articleId = article.articleId;
    if (articleId == null || articleId == "") {
      articleId = getRandomDocumentId();
      print('Writing article : ' + articleId);
    } else {
      print("Updating article : " + articleId);
    }
    // If image is uploaded from the gallery then imageUrl will be null
    if (article.imageURL == null) {
      article.imageURL = await uploadImageToFirebaseStorage(
          article.image, DbConstant.ARTICLE_FOLDER, articleId);
    }
    return await _articleCollection.doc(articleId).set({
      'Title': article.title,
      'ImageURL': article.imageURL,
      'Content': article.content,
      'VideoLink': article.videoLink,
      'Author': article.author,
    });
  }

  // get article object from DocumentSnapshot
  Article _articleFromSnapshot(DocumentSnapshot snapshot) {
    var article = Article(
      articleId: snapshot.id,
      title: snapshot.data()['Title'],
      imageURL: snapshot.data()['ImageURL'],
      content: snapshot.data()['Content'],
      videoLink: snapshot.data()['VideoLink'],
      author: snapshot.data()['Author'],
    );
    print("Article object " + article.toString());
    return article;
  }

  // read article information
  Future<Article> readArticle(String articleId) async {
    DocumentSnapshot snapshot = await _articleCollection.doc(articleId).get();
    print("Article snapshot : " + snapshot.toString());
    return _articleFromSnapshot(snapshot);
  }

  // used for displaying article list
  List<Article> _articleListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Article(
        articleId: doc.id,
        title: doc.data()['Title'] ?? '',
        imageURL: doc.data()['ImageURL'] ?? '',
        author: doc.data()['Author'] ?? '',
        content: doc.data()['Content'] ?? '',
        videoLink: doc.data()['VideoLink'] ?? '',
      );
    }).toList();
  }

  // get article list
  Future<List<Article>> get articleList async {
    return _articleListFromSnapshot(await _articleCollection.get());
  }

  // delete article
  void deleteArticle(String articleId) {
    try {
      var obj = _articleCollection.doc(articleId);
      if (articleId != "article.png") {
        deleteImageFromFirebaseStorage(DbConstant.ARTICLE_FOLDER, articleId);
      }
      if (obj != null) {
        obj.delete();
        print('Article ' + articleId + ' deleted');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // Upload Image to firebase storage
  Future<String> uploadImageToFirebaseStorage(
      File file, String folder, String fileName) async {
    final _storage = FirebaseStorage.instance;
    if (file != null) {
      var snapshot =
          await _storage.ref().child(folder + fileName).putFile(file);
      return await snapshot.ref.getDownloadURL();
    } else {
      // Default image
      return (folder == DbConstant.SCHEME_FOLDER)
          ? URLConstant.SCHEME_IMAGE_URL // Default scheme image is returned
          : URLConstant.ARTICLE_IMAGE_URL; // Default article image is returned
    }
  }

  // Delete image from firebase storage
  deleteImageFromFirebaseStorage(String folder, String fileName) async {
    final _storage = FirebaseStorage.instance;
    print("File name is " + fileName);
    if (fileName != null) {
      var snapshot = await _storage.ref().child(folder + fileName).delete();
      return snapshot;
    }
  }

  // Collection Reference for Scheme Collection
  final CollectionReference _schemeCollection =
      FirebaseFirestore.instance.collection(DbConstant.SCHEME_COLLECTION);

  // write / update scheme
  Future<void> writeScheme(Scheme scheme) async {
    String schemeId = scheme.schemeId;
    if (schemeId == null || schemeId == "") {
      schemeId = getRandomDocumentId();
      print('Writing Scheme : ' + schemeId);
    } else {
      print("Updating Scheme : " + schemeId);
    }
    // If image is uploaded from the gallery then imageUrl will be null
    if (scheme.imageURL == null) {
      scheme.imageURL = await uploadImageToFirebaseStorage(
          scheme.image, DbConstant.SCHEME_FOLDER, schemeId);
    }
    return await _schemeCollection.doc(schemeId).set({
      'Name': scheme.name,
      'Provider': scheme.provider,
      'ImageURL': scheme.imageURL,
      'Details': scheme.details,
      'VideoLink': scheme.videoLink,
      'RegistrationLink': scheme.registrationLink,
      'Author': scheme.author,
    });
  }

  // get article object from DocumentSnapshot
  Scheme _schemeFromSnapshot(DocumentSnapshot snapshot) {
    var scheme = Scheme(
      schemeId: snapshot.id,
      name: snapshot.data()['Name'],
      provider: snapshot.data()['Provider'],
      imageURL: snapshot.data()['ImageURL'],
      details: snapshot.data()['Details'],
      videoLink: snapshot.data()['VideoLink'],
      registrationLink: snapshot.data()['RegistrationLink'],
      author: snapshot.data()['Author'],
    );
    print("Scheme object " + scheme.toString());
    return scheme;
  }

  // read scheme information
  Future<Scheme> readScheme(String schemeId) async {
    DocumentSnapshot snapshot = await _schemeCollection.doc(schemeId).get();
    print("Scheme snapshot " + snapshot.toString());
    return _schemeFromSnapshot(snapshot);
  }

  // used for displaying scheme list
  List<SchemeViewModel> _schemeListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return SchemeViewModel(
        schemeId: doc.id,
        name: doc.data()['Name'] ?? '',
        imageURL: doc.data()['ImageURL'] ?? '',
        provider: doc.data()['Provider'] ?? '',
        videoLink: doc.data()['VideoLink'] ?? '',
      );
    }).toList();
  }

  // get scheme list
  Future<List<SchemeViewModel>> get schemeList async {
    return _schemeListFromSnapshot(await _schemeCollection.get());
  }

  // delete scheme
  void deleteScheme(String schemeId) {
    try {
      var obj = _schemeCollection.doc(schemeId);
      if (schemeId != "scheme.png") {
        deleteImageFromFirebaseStorage(DbConstant.SCHEME_FOLDER, schemeId);
      }
      if (obj != null) {
        obj.delete();
        print('Scheme ' + schemeId + ' deleted');
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
