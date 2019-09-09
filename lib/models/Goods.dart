class Goods {
  final String id;
  final String name;
  final String unit;
  final double price;
  final double balance;
  final String brand;

  Goods(
      {
        this.id,
        this.name,
        this.unit,
        this.price,
        this.balance,
        this.brand
      }
      );

  factory Goods.fromJson(Map<String, dynamic> parsedJson) {

    return new Goods(
      id: parsedJson['id'],
      name: parsedJson['name'],
      unit: parsedJson['unit'],
      price: parsedJson['price'],
      balance: parsedJson['balance'],
      brand: parsedJson['brand'],
    );
  }
}