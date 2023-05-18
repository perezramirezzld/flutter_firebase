class Product {
  String? uid;
  String name;
  String description;
  int units;
  double cost;
  double price;
  double utility;

  Product({
    this.uid,
    required this.name,
    required this.description,
    required this.units,
    required this.cost,
    required this.price,
    required this.utility,
  });
}