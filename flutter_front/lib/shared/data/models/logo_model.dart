class LogoModel {
  final String logo;
  LogoModel({required this.logo});
  factory LogoModel.fromJson(Map<String, dynamic> json) {
    return LogoModel(
      logo: json["logo"]
    );
  }
}