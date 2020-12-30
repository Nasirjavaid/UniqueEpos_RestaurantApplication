class TableInfoModel {
  String status;
  int statusCode;
  String message;
  Data data;

  TableInfoModel({this.status, this.statusCode, this.message, this.data});

  TableInfoModel.fromJson(Map<String, dynamic> json) {
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
  List<Tableinfo> tableinfo;

  Data({this.tableinfo});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['tableinfo'] != null) {
      tableinfo = new List<Tableinfo>();
      json['tableinfo'].forEach((v) {
        tableinfo.add(new Tableinfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.tableinfo != null) {
      data['tableinfo'] = this.tableinfo.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Tableinfo {
  String tableID;
  String tableName;
  String capacity;
  String tableImage;
  String reserveDate;
  String reserveTime;

  Tableinfo(
      {this.tableID,
      this.tableName,
      this.capacity,
      this.tableImage,
      this.reserveDate,
      this.reserveTime});

  Tableinfo.fromJson(Map<String, dynamic> json) {
    tableID = json['TableID'];
    tableName = json['TableName'];
    capacity = json['Capacity'];
    tableImage = json['TableImage'];
    reserveDate = json['reserveDate'];
    reserveTime = json['reserveTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TableID'] = this.tableID;
    data['TableName'] = this.tableName;
    data['Capacity'] = this.capacity;
    data['TableImage'] = this.tableImage;
    data['reserveDate'] = this.reserveDate;
    data['reserveTime'] = this.reserveTime;
    return data;
  }
}
