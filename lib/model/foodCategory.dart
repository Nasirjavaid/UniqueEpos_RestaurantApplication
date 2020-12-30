class FoodCategory {
  String status;
  int statusCode;
  String message;
  Data data;

  FoodCategory({this.status, this.statusCode, this.message, this.data});

  FoodCategory.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['status_code'] = this.statusCode;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  List<Sliderinfo> sliderinfo;
  List<Category> category;

  Data({this.sliderinfo, this.category});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['sliderinfo'] != null) {
      sliderinfo = new List<Sliderinfo>();
      json['sliderinfo'].forEach((v) {
        sliderinfo.add(new Sliderinfo.fromJson(v));
      });
    }
    if (json['Category'] != null) {
      category = new List<Category>();
      json['Category'].forEach((v) {
        category.add(new Category.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.sliderinfo != null) {
      data['sliderinfo'] = this.sliderinfo.map((v) => v.toJson()).toList();
    }
    if (this.category != null) {
      data['Category'] = this.category.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Sliderinfo {
  String title;
  String subtitle;
  String link;
  String sliderimage;

  Sliderinfo({this.title, this.subtitle, this.link, this.sliderimage});

  Sliderinfo.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    subtitle = json['subtitle'];
    link = json['link'];
    sliderimage = json['sliderimage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['subtitle'] = this.subtitle;
    data['link'] = this.link;
    data['sliderimage'] = this.sliderimage;
    return data;
  }
}

class Category {
  String categoryID;
  String name;
  String categoryimage;

  Category({this.categoryID, this.name, this.categoryimage});

  Category.fromJson(Map<String, dynamic> json) {
    categoryID = json['CategoryID'];
    name = json['Name'];
    categoryimage = json['categoryimage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CategoryID'] = this.categoryID;
    data['Name'] = this.name;
    data['categoryimage'] = this.categoryimage;
    return data;
  }
}