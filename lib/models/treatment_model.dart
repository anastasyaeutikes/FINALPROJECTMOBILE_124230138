class Treatment {
  final String name;
  final int price;
  bool isSelected;

  Treatment({
    required this.name,
    required this.price,
    this.isSelected = false,
  });
}
