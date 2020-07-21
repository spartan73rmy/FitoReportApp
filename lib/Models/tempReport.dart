import 'package:LikeApp/Models/product.dart';
import 'package:LikeApp/Models/reportData.dart';

class TempReport {
  ReportData report;
  List<Product> products;

  TempReport({this.products, this.report});

  factory TempReport.fromJsonF(Map<String, dynamic> json) {
    return TempReport(
        products: json["products"] as List, report: json["report"]);
  }

  TempReport.fromJson(Map<String, dynamic> json)
      : report = json['report'],
        products = json['products'];

  Map<String, dynamic> toJson() => {
        'products': products,
        'report': report,
      };
}
