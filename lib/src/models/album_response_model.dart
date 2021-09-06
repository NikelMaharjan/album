class AlbumResponseModel {
  int? id;
  String? artist;
  String? image;
  String? thumbnail;
  String? title;
  String? url;

  //AlbumResponseModel(this.id, this.artist, this.image, this.thumbnail, this.title, this.url);
 AlbumResponseModel.fromJson(Map<String, dynamic>parsedMap)
 {
   id = parsedMap["id"];
   artist = parsedMap["artist"];
   image = parsedMap["image"];
   thumbnail = parsedMap["thumbnail"];
   title = parsedMap["title"];
   url = parsedMap["url"];
 }

}