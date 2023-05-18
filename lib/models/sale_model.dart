class Sale {
  String? uid;
  String name;
  String idProduct;
  String idClient;
  int pieces;
  double subtotal;
  double total;

  Sale(
    {
      this.uid,
      required this.name,
      required this.idProduct,
      required this.idClient,
      required this.pieces,
      required this.subtotal,
      required this.total,
    }
  );
}