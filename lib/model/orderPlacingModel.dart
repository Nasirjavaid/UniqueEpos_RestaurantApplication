class OrderPlacingModel {
  int productsID;
  int count;
  String variantid;
  int addons;
  String menu_options;
  List<AddonsinfoOrderPlacingModel> addonsinfo;

  OrderPlacingModel(
      {this.productsID,
      this.count,
      this.variantid,
      this.addons,
      this.addonsinfo,this.menu_options});

  OrderPlacingModel.fromJson(Map<String, dynamic> json) {
    productsID = json['ProductsID'];
    count = json['count'];
    variantid = json['variantid'];
    addons = json['addons'];
    menu_options = json['menu_options'];
    if (json['addonsinfo'] != null) {
      addonsinfo = new List<AddonsinfoOrderPlacingModel>();
      json['addonsinfo'].forEach((v) {
        addonsinfo.add(new AddonsinfoOrderPlacingModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ProductsID'] = this.productsID;
    data['count'] = this.count;
    data['variantid'] = this.variantid;
    data['addons'] = this.addons;
    data['menu_options'] = this.menu_options;
    if (this.addonsinfo != null) {
      data['addonsinfo'] = this.addonsinfo.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AddonsinfoOrderPlacingModel {
  String addonsid;
  //String addonsprice;
  int count;

  AddonsinfoOrderPlacingModel({this.addonsid,  this.count});

  AddonsinfoOrderPlacingModel.fromJson(Map<String, dynamic> json) {
    addonsid = json['addonsid'];
   // addonsprice = json['addonsprice'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['addonsid'] = this.addonsid;
   // data['addonsprice'] = this.addonsprice;
    data['count'] = this.count;
    return data;
  }
}