class Client {
  final String id;
  final String name;
  final String address;
  final double creditLimit;
  final int creditTerm;
  final List debtlist;

  Client(
      {
        this.id,
        this.name,
        this.address,
        this.creditLimit,
        this.creditTerm,
        this.debtlist
      }
  );

  factory Client.fromJson(Map<String, dynamic> parsedJson) {
    double creditLimit = num.parse(parsedJson['credit_limit'].toString()).toDouble();
    return Client(
      id: parsedJson['id'],
      name: parsedJson['name'],
      address: parsedJson['address'],
      creditLimit: creditLimit,
      creditTerm: parsedJson['credit_term'],
      debtlist: parsedJson['debtlist'],

    );
  }
}