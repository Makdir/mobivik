class Goods {
  final String id;
  final String parent_id;
  final String name;
  final String unit;
  final double coef;
  final double price;
  final double balance;
  final String brand;

  Goods(
      {
        this.id,
        this.parent_id,
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
    return new Goods(
      id: parsedJson['id'],
      parent_id: parsedJson['parent_id'],
      name: parsedJson['name'],
      unit: parsedJson['unit'],
      price: price,
      coef: coef,
      balance:  balance,
      brand: parsedJson['brand'],
    );
  }
}