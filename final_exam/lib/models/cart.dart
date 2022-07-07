class Cart {
  String? cartid;
  String? subject_id;
  String? subject_name;
  String? subject_price;
  String? cart_qty;
  String? pricetotal;

  Cart(
      {this.cartid,
      this.subject_id,
      this.subject_name,
      this.subject_price,
      this.cart_qty,
      this.pricetotal});

  Cart.fromJson(Map<String, dynamic> json) {
    cartid = json['cartid'];
    subject_id = json['subject_id'];
    subject_name = json['subject_name'];
    subject_price = json['subject_price'];
    cart_qty = json['cart_qty'];
    pricetotal = json['price_total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cartid'] = cartid;
    data['subject_id'] = subject_id;
    data['subject_name'] = subject_name;
    data['subject_price'] = subject_price;
    data['cart_qty'] = cart_qty;
    data['price_total'] = pricetotal;
    return data;
  }
}
