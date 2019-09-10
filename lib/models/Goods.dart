class Goods {
  final String id;
  final String parent_id;
  final String name;
  final String unit;
  final double price;
  final double balance;
  final String brand;
  final bool isFolder;

  Goods(
      {
        this.id,
        this.parent_id,
        this.name,
        this.unit,
        this.price,
        this.balance,
        this.brand,
        this.isFolder
      }
      );

  factory Goods.fromJson(Map<String, dynamic> parsedJson) {

    return new Goods(
      id: parsedJson['id'],
      parent_id: parsedJson['parent_id'],
      name: parsedJson['name'],
      unit: parsedJson['unit'],
      price: parsedJson['price'],
      balance: parsedJson['balance'],
      brand: parsedJson['brand'],
        isFolder: parsedJson['isFolder'],
    );
  }
}