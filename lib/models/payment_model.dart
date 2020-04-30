class Payment {
//  final String id;
//  final String name;
//  final String address;
//  final double creditLimit;
//  final int creditTerm;
//  final List debtlist;

  Payment(
//      {
//        this.id,
//        this.name,
//        this.address,
//        this.creditLimit,
//        this.creditTerm,
//        this.debtlist
//      }
  );

  factory Payment.fromJson(Map<String, dynamic> parsedJson) {
    double sum = num.parse(parsedJson['credit_limit'].toString()).toDouble();
    return Payment(
//      id: parsedJson['id'],
//      name: parsedJson['name'],
//      address: parsedJson['address'],
//      creditLimit: sum,
//      creditTerm: parsedJson['credit_term'],
//      debtlist: parsedJson['debtlist'],

    );
  }
}