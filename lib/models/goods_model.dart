class Goods {
  final String id;
  final String parentId;
  final int isFolder;
  final String name;
  final String unit;
  final double coef;
  final double price;
  final double balance;
  final String brand;

  Goods(
      {
        this.id,
        this.parentId,
        this.isFolder,
        this.name,
        this.unit,
        this.coef,
        this.price,
        this.balance,
        this.brand
      }
      );

  factory Goods.fromJson(Map<String, dynamic> parsedJson) {
    double price = num.parse(parsedJson['price'].toString()).toDouble();
    double coef = num.parse(parsedJson['coef'].toString()).toDouble();
    double balance = num.parse(parsedJson['balance'].toString()).toDouble();
    return Goods(
      id: parsedJson['id'],
      parentId: parsedJson['parent_id'],
      isFolder: parsedJson['is_folder'],
      name: parsedJson['name'],
      unit: parsedJson['unit'],
      price: price,
      coef: coef,
      balance:  balance,
      brand: parsedJson['brand'],
    );
  }
}