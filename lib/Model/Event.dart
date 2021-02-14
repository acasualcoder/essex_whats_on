class Event {
  String time;
  String location;
  String description;
  String title;
  String imgPath;

  void setImgPath(rawImage) {
    imgPath = 'https://www.essexstudent.com' + rawImage;
  }

  String toString() {
    return {
      "title": title,
      "time": time,
      "location": location,
      "description": description,
      "imgPath": imgPath,
    }.toString();
  }

}
