class MyReserveListModel {
  String status;
  int statusCode;
  String message;
  Data data;

  MyReserveListModel({this.status, this.statusCode, this.message, this.data});

  MyReserveListModel.fromJson(Map<String, dynamic> json) {
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
  List<Reserveinfo> reserveinfo;

  Data({this.reserveinfo});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['reserveinfo'] != null) {
      reserveinfo = new List<Reserveinfo>();
      json['reserveinfo'].forEach((v) {
        reserveinfo.add(new Reserveinfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.reserveinfo != null) {
      data['reserveinfo'] = this.reserveinfo.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Reserveinfo {
  String tableName;
  String capacity;
  String formtime;
  String totime;
  String reserveday;
  String status;

  Reserveinfo(
      {this.tableName,
      this.capacity,
      this.formtime,
      this.totime,
      this.reserveday,
      this.status});

  Reserveinfo.fromJson(Map<String, dynamic> json) {
    tableName = json['TableName'];
    capacity = json['Capacity'];
    formtime = json['formtime'];
    totime = json['totime'];
    reserveday = json['reserveday'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TableName'] = this.tableName;
    data['Capacity'] = this.capacity;
    data['formtime'] = this.formtime;
    data['totime'] = this.totime;
    data['reserveday'] = this.reserveday;
    data['status'] = this.status;
    return data;
  }
}