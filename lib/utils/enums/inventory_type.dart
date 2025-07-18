enum InventoryType {
  high,
  low,
  medium;

  String toStr() => switch (this) {
        InventoryType.high => 'High',
        InventoryType.medium => 'Medium',
        InventoryType.low => 'Low'
      };
}
