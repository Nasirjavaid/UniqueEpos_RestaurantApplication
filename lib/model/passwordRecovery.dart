class PasswordRecovery {
  String status;
  int statusCode;
  String message;
 

  PasswordRecovery({this.status, this.statusCode, this.message});

  PasswordRecovery.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['status_code'] = this.statusCode;
    data['message'] = this.message;
   
    return data;
  }
}