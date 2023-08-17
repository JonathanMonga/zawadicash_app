class SignUpBody {
  String? fName;
  String? lName;
  String? email;
  String? phone;
  String? password;
  String? otp;
  String? gender;
  String? occupation;
  String? dialCountryCode;

  SignUpBody({
    required this.fName,
    required this.lName,
    required this.phone,
    this.email,
    required this.password,
    this.otp,
    required this.gender,
    required this.occupation,
    required this.dialCountryCode,
  });

  SignUpBody.fromJson(Map<String, dynamic> json) {
    fName = json['f_name'];
    lName = json['l_name'];
    phone = json['phone'];
    email = json['email'];
    password = json['password'];
    otp = json['otp'];
    gender = json['gender'];
    occupation = json['occupation'];
    dialCountryCode = json['dial_country_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['f_name'] = fName;
    data['l_name'] = lName;
    data['phone'] = phone;
    data['email'] = email;
    data['password'] = password;
    data['otp'] = otp;
    data['gender'] = gender;
    data['occupation'] = occupation;
    data['dial_country_code'] = dialCountryCode;
    return data;
  }
}
