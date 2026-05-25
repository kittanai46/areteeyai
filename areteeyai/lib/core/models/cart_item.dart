import 'package:equatable/equatable.dart';
import 'product.dart';

class CartItem extends Equatable {
  final Product product;
  final int quantity;
  final String note;

  const CartItem({
    required this.product,
    required this.quantity,
    this.note = '',
  });

  double get subtotal => product.price * quantity;

  CartItem copyWith({int? quantity, String? note}) {
    return CartItem(
      product: product,
      quantity: quantity ?? this.quantity,
      note: note ?? this.note,
    );
  }

  @override
  List<Object?> get props => [product.id, quantity, note];
}
