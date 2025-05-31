class PhoneModel {
  String? status;
  String? message;
  List<Phone>? data;

  PhoneModel({this.status, this.message, this.data});

  PhoneModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Phone>[];
      json['data'].forEach((v) {
        data!.add(new Phone.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Phone {
  int? id;
  String? model;
  String? brand;
  double? price;
  String? imageUrl;
  int? ram;
  int? storage;
  String? websiteUrl;

  Phone({
    this.id,
    this.model,
    this.brand,
    this.price,
    this.imageUrl,
    this.ram,
    this.storage,
    this.websiteUrl,
  });

  Phone.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    model = json['model'];
    brand = json['brand'];
    price =
        json['price'].toString() != 'null'
            ? double.parse(json['price'].toString())
            : null;
    ;
    imageUrl = json['imageUrl'];
    ram = json['ram'];
    storage = json['storage'];
    websiteUrl = json['websiteUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['model'] = this.model;
    data['brand'] = this.brand;
    data['price'] = this.price;
    data['imageUrl'] = this.imageUrl;
    data['ram'] = this.ram;
    data['storage'] = this.storage;
    data['websiteUrl'] = this.websiteUrl;
    return data;
  }
}
