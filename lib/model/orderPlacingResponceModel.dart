class OrderPlacingResponceModel {
  String status;
  int statusCode;
  String message;
  Data data;

  OrderPlacingResponceModel(
      {this.status, this.statusCode, this.message, this.data});

  OrderPlacingResponceModel.fromJson(Map<String, dynamic> json) {
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
  String payType;
  int orderid;
  String customerName;
  String amount;
  int orderID;
  String email;
  String phone;
  String address;
  String customer_id;

  Data(
      {this.payType,
      this.orderid,
      this.customerName,
      this.amount,
      this.orderID,
      this.email,
      this.phone,
      this.address,
      this.customer_id});

  Data.fromJson(Map<String, dynamic> json) {
    payType = json['Pay_type'];
    orderid = json['Orderid'];
    customerName = json['CustomerName'];
    amount = json['amount'];
    orderID = json['OrderID'];
    email = json['email'];
    phone = json['phone'];
    address = json['address'];
    customer_id = json['customer_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Pay_type'] = this.payType;
    data['Orderid'] = this.orderid;
    data['CustomerName'] = this.customerName;
    data['amount'] = this.amount;
    data['OrderID'] = this.orderID;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['customer_id'] = this.customer_id;
    return data;
  }
}
