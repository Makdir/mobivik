class Client {
  final String id;
  final String name;
  final String address;
  final List debt;

  Client(
      {
        this.id,
        this.name,
        this.address,
        this.debt
      }
      );

  factory Client.fromJson(Map<String, dynamic> parsedJson) {

    return new Client(
      id: parsedJson['id'],
      name: parsedJson['name'],
      address: parsedJson['address'],
      debt: parsedJson['debt'],
    );
  }
}