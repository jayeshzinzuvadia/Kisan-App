import 'dart:io';

class Article {
  final String articleId;
  String imageURL;
  String title;
  String content;
  String videoLink;
  String author;
  File image;

  Article({
    this.articleId,
    this.imageURL,
    this.title,
    this.content,
    this.videoLink,
    this.author,
    this.image,
  });
}
