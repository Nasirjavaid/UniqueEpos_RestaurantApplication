class TableBookingModel {
  String status;
  int statusCode;
  String message;
  Data data;

  TableBookingModel({this.status, this.statusCode, this.message, this.data});

  TableBookingModel.fromJson(Map<String, dynamic> json) {
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
  String tableID;
  String tableName;
  String capacity;
  String reservedate;
  String starttime;
  String endtime;
  String customerNotes;

  Data(
      {this.tableID,
      this.tableName,
      this.capacity,
      this.reservedate,
      this.starttime,
      this.endtime,
      this.customerNotes});

  Data.fromJson(Map<String, dynamic> json) {
    tableID = json['TableID'];
    tableName = json['TableName'];
    capacity = json['Capacity'];
    reservedate = json['Reservedate'];
    starttime = json['Starttime'];
    endtime = json['Endtime'];
    customerNotes = json['customer_notes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TableID'] = this.tableID;
    data['TableName'] = this.tableName;
    data['Capacity'] = this.capacity;
    data['Reservedate'] = this.reservedate;
    data['Starttime'] = this.starttime;
    data['Endtime'] = this.endtime;
    data['customer_notes'] = this.customerNotes;
    return data;
  }
}