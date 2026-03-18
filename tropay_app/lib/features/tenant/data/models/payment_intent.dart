class PaymentIntent {
  final String paymentId;
  final String transactionId;
  final String payUrl;
  final String? deeplink;

  const PaymentIntent({
    required this.paymentId,
    required this.transactionId,
    required this.payUrl,
    this.deeplink,
  });

  bool get hasRedirect => payUrl.isNotEmpty;

  factory PaymentIntent.fromJson(Map<String, dynamic> json) {
    final payment = json['payment'] as Map<String, dynamic>? ?? {};
    final momo = json['momo'] as Map<String, dynamic>? ?? {};
    final metadata = payment['metadata'] as Map<String, dynamic>? ?? {};

    return PaymentIntent(
      paymentId: payment['id'] ?? payment['_id'] ?? '',
      transactionId: payment['transactionId'] ?? momo['orderId'] ?? '',
      payUrl: momo['payUrl'] ?? metadata['momoPayUrl'] ?? '',
      deeplink: momo['deeplink'] ?? metadata['momoDeeplink'],
    );
  }
}
