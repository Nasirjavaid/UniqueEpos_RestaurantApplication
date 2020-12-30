class UserLogin {
  String status;
  int statusCode;
  String message;
  Data data;

  UserLogin({this.status, this.statusCode, this.message, this.data});

  UserLogin.fromJson(Map<String, dynamic> json) {
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
  
  String customerId;
  String cuntomerNo;
  String customerName ;
  String customerEmail;
  String password;
  String customerToken;
  String customerAddress;
  String customerPhone;
  String customerPicture;
  String favoriteDeliveryAddress;
  String isActive;
  String customerNote;
  String userPictureURL;

  Data(
      {this.customerId,
      this.cuntomerNo,
      this.customerName,
      this.customerEmail,
      this.password,
      this.customerAddress,
      this.customerPhone,
      this.customerPicture,
      this.favoriteDeliveryAddress,
      this.customerNote,
      this.isActive,
      this.customerToken,
      this.userPictureURL});

  Data.fromJson(Map<String, dynamic> json) {
    customerId = json['customer_id'];
    customerNote = json['customerNote'];
    cuntomerNo = json['cuntomer_no'];
    customerName = json['customer_name'];
    customerEmail = json['customer_email'];
    password = json['password'];
    customerToken = json['customer_token'];
    customerAddress = json['customer_address'];
    customerPhone = json['customer_phone'];
    customerPicture = json['customer_picture'];
    favoriteDeliveryAddress = json['favorite_delivery_address'];
    isActive = json['is_active'];
    userPictureURL = json['UserPictureURL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_id'] = this.customerId;
    data['customerNote'] = this.customerNote;
    data['cuntomer_no'] = this.cuntomerNo;
    data['customer_name'] = this.customerName;
    data['customer_email'] = this.customerEmail;
    data['password'] = this.password;
    data['customer_token'] = this.customerToken;
    data['customer_address'] = this.customerAddress;
    data['customer_phone'] = this.customerPhone;
    data['customer_picture'] = this.customerPicture;
    data['favorite_delivery_address'] = this.favoriteDeliveryAddress;
    data['is_active'] = this.isActive;
    data['UserPictureURL'] = this.userPictureURL;
    return data;
  }

  bool checkIfAnyIsNull() {
    if ([customerId].contains(null)) {
      return true;
    }
    return false;
  }
}
