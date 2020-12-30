class MyOrdersModel {
  String status;
  int statusCode;
  String message;
  Data data;

  MyOrdersModel({this.status, this.statusCode, this.message, this.data});

  MyOrdersModel.fromJson(Map<String, dynamic> json) {
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
  String currency;
  String currencyIcon;
  String restaurantvat;
  List<Orderinfo> orderinfo;

  Data({this.currency, this.currencyIcon, this.restaurantvat, this.orderinfo});

  Data.fromJson(Map<String, dynamic> json) {
    currency = json['Currency'];
    currencyIcon = json['CurrencyIcon'];
    restaurantvat = json['Restaurantvat'];
    if (json['orderinfo'] != null) {
      orderinfo = new List<Orderinfo>();
      json['orderinfo'].forEach((v) {
        orderinfo.add(new Orderinfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Currency'] = this.currency;
    data['CurrencyIcon'] = this.currencyIcon;
    data['Restaurantvat'] = this.restaurantvat;
    if (this.orderinfo != null) {
      data['orderinfo'] = this.orderinfo.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Orderinfo {
  String saleinvoice;
  String orderamount;
  String orderdate;
  String discount;
  String servicecharge;
  String vAT;
  String cancelreason;
  String status;
  List<Foodlist> foodlist;

  Orderinfo(
      {this.saleinvoice,
      this.orderamount,
      this.orderdate,
      this.discount,
      this.servicecharge,
      this.vAT,
      this.cancelreason,
      this.status,
      this.foodlist});

  Orderinfo.fromJson(Map<String, dynamic> json) {
    saleinvoice = json['saleinvoice'];
    orderamount = json['Orderamount'];
    orderdate = json['orderdate'];
    discount = json['discount'];
    servicecharge = json['servicecharge'];
    vAT = json['VAT'];
    cancelreason = json['cancelreason'];
    status = json['status'];
    if (json['foodlist'] != null) {
      foodlist = new List<Foodlist>();
      json['foodlist'].forEach((v) {
        foodlist.add(new Foodlist.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['saleinvoice'] = this.saleinvoice;
    data['Orderamount'] = this.orderamount;
    data['orderdate'] = this.orderdate;
    data['discount'] = this.discount;
    data['servicecharge'] = this.servicecharge;
    data['VAT'] = this.vAT;
    data['cancelreason'] = this.cancelreason;
    data['status'] = this.status;
    if (this.foodlist != null) {
      data['foodlist'] = this.foodlist.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Foodlist {
  String productName;
  String qty;
  String variantName;
  String variantPrice;
  int addons;

  Foodlist(
      {this.productName,
      this.qty,
      this.variantName,
      this.variantPrice,
      this.addons});

  Foodlist.fromJson(Map<String, dynamic> json) {
    productName = json['ProductName'];
    qty = json['qty'];
    variantName = json['variantName'];
    variantPrice = json['variantPrice'];
    addons = json['addons'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ProductName'] = this.productName;
    data['qty'] = this.qty;
    data['variantName'] = this.variantName;
    data['variantPrice'] = this.variantPrice;
    data['addons'] = this.addons;
    return data;
  }
}