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
    return new Client(
      id: parsedJson['id'],
      name: parsedJson['name'],
      address: parsedJson['address'],
      creditLimit: parsedJson['credit_limit'],
      creditTerm: parsedJson['credit_term'],
      debtlist: parsedJson['debtlist'],

    );
  }
}