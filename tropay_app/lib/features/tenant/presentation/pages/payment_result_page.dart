import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tropay_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:tropay_app/routes/app_router.dart';
import '../providers/tenant_provider.dart';

class PaymentResultPage extends StatefulWidget {
  final String paymentId;
  final String? orderId;
  final String? resultCode;
  final String? transId;
  final String? status;
  final String? message;

  const PaymentResultPage({
    super.key,
    required this.paymentId,
    this.orderId,
    this.resultCode,
    this.transId,
    this.status,
    this.message,
  });

  @override
  State<PaymentResultPage> createState() => _PaymentResultPageState();
}

class _PaymentResultPageState extends State<PaymentResultPage> {
  late Future<Map<String, dynamic>> _paymentCheckFuture;

  @override
  void initState() {
    super.initState();
    _paymentCheckFuture = _checkPaymentStatus();
  }

  Future<Map<String, dynamic>> _checkPaymentStatus() async {
    try {
      String finalPaymentId = widget.paymentId;

      // If paymentId is actually a MoMo orderId, handle manual update first
      if (widget.paymentId.startsWith('MOMO-') && widget.orderId != null && widget.resultCode != null) {
        // Manual update payment status from MoMo redirect (for local testing)
        try {
          final updateResult = await context.read<TenantProvider>().manualUpdateMomoPayment(
            orderId: widget.orderId!,
            resultCode: widget.resultCode!,
            transId: widget.transId,
            message: widget.message,
          );

          // Get the real paymentId from update result
          finalPaymentId = updateResult['paymentId'] as String? ?? widget.paymentId;
        } catch (e) {
          print('Manual update error: $e');
          // Continue with sync fallback
        }
      }

      // If we still have a MOMO- orderId, try sync to get real paymentId
      if (finalPaymentId.startsWith('MOMO-')) {
        final realPaymentId = await context.read<TenantProvider>().syncMomoPaymentStatus(finalPaymentId);
        if (realPaymentId != null && realPaymentId.isNotEmpty) {
          finalPaymentId = realPaymentId;
        } else {
          return {'success': false, 'message': 'Không tìm thấy thông tin thanh toán với mã giao dịch $finalPaymentId'};
        }
      }

      final payment = await context.read<TenantProvider>().refreshPaymentStatus(finalPaymentId);
      if (payment) {
        return {'success': true, 'message': 'Thanh toán thành công!'};
      } else {
        return {'success': false, 'message': 'Thanh toán chưa được xác nhận. Vui lòng thử lại sau.'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Lỗi kiểm tra thanh toán: $e'};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<Map<String, dynamic>>(
          future: _paymentCheckFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Đang kiểm tra thanh toán...'),
                ],
              );
            }

            if (snapshot.hasError) {
              return _buildErrorWidget(context, 'Có lỗi xảy ra: ${snapshot.error}');
            }

            final data = snapshot.data ?? {};
            final isSuccess = data['success'] as bool? ?? false;
            final message = data['message'] as String? ?? 'Không rõ trạng thái';

            if (isSuccess) {
              return _buildSuccessWidget(context, message);
            } else {
              return _buildErrorWidget(context, message);
            }
          },
        ),
      ),
    );
  }

  Widget _buildSuccessWidget(BuildContext context, String message) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.check_circle, size: 80, color: Colors.green),
        const SizedBox(height: 24),
        const Text(
          'Thanh toán thành công!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          message,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.green,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        FilledButton.icon(
          onPressed: () {
            final authProvider = context.read<AuthProvider>();
            String targetRoute = AppRouter.login;

            if (authProvider.isAuthenticated && authProvider.currentUser != null) {
              targetRoute = authProvider.currentUser!.role == 'owner'
                  ? AppRouter.ownerHome
                  : AppRouter.tenantHome;
            }

            Navigator.of(context).pushNamedAndRemoveUntil(
              targetRoute,
              (route) => false,
            );
          },
          icon: const Icon(Icons.home),
          label: const Text('Quay lại trang chủ'),
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorWidget(BuildContext context, String message) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.error_outline, size: 80, color: Colors.orange),
        const SizedBox(height: 24),
        const Text(
          'Thanh toán chưa được xác nhận',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            message,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.orange,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
              label: const Text('Quay lại'),
            ),
            const SizedBox(width: 12),
            FilledButton.icon(
              onPressed: () {
                setState(() {
                  _paymentCheckFuture = _checkPaymentStatus();
                });
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Kiểm tra lại'),
            ),
          ],
        ),
      ],
    );
  }
}
