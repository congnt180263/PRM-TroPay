# Hướng dẫn Momo Deep Link Integration

## Overview
Khi user thanh toán xong trên Momo, app sẽ tự động mở payment result page thông qua deep link callback.

## Deep Link Scheme
- **Scheme**: `prm://`
- **Host**: `payment`
- **Path**: `/result`
- **URL Format**: `prm://payment/result?paymentId={paymentId}&status={status}&message={message}`

## Backend API Configuration

### 1. Update Momo Payment Creation API
Khi backend tạo payment intent cho Momo, nó cần cấu hình return URL:

```javascript
// Backend API (Node.js example)
async function createMomoPayment(invoiceId, amount) {
  const orderId = generateOrderId();
  const momoPartnerCode = process.env.MOMO_PARTNER_CODE;
  const momoAccessKey = process.env.MOMO_ACCESS_KEY;
  const momoSecretKey = process.env.MOMO_SECRET_KEY;

  // IMPORTANT: Set returnUrl for Momo to call when payment completes
  const returnUrl = `prm://payment/result?paymentId=${payment._id}&status=success`;
  const notifyUrl = `${process.env.API_BASE_URL}/api/payments/momo-callback`;

  const requestBody = {
    partnerCode: momoPartnerCode,
    partnerName: 'TroPay',
    partnerTransactionId: orderId,
    requestId: orderId,
    notifyUrl: notifyUrl,
    returnUrl: returnUrl,  // This is the key!
    redirectUrl: returnUrl, // Some Momo versions use this
    orderInfo: `Payment for invoice ${invoiceId}`,
    requestType: 'captureMoMoWallet',
    amount: amount,
    orderExpireTime: 15,
    autoCapture: true,
    lang: 'vi',
    signature: generateSignature(...)
  };

  // Call Momo API
  const momoResponse = await axios.post(
    'https://test-payment.momo.vn/v3/gateway/api/create',
    requestBody
  );

  return {
    paymentId: payment._id,
    transactionId: orderId,
    payUrl: momoResponse.data.payUrl,
    deeplink: momoResponse.data.deeplink
  };
}
```

### 2. Momo Webhook Callback (Optional)
Backend cũng cần handle webhook khi Momo gọi lại để confirm payment:

```javascript
app.post('/api/payments/momo-callback', async (req, res) => {
  const { orderId, transId, resultCode, message, amount } = req.body;

  if (resultCode === 0) {
    // Payment successful
    const payment = await Payment.findOne({ transactionId: orderId });
    payment.status = 'success';
    payment.momoTransactionId = transId;
    await payment.save();

    // Update invoice status
    const invoice = await Invoice.findById(payment.invoiceId);
    invoice.status = 'paid';
    await invoice.save();

    res.json({ resultCode: 0, message: 'Success', return_data: null });
  } else {
    // Payment failed
    const payment = await Payment.findOne({ transactionId: orderId });
    payment.status = 'failed';
    payment.errorMessage = message;
    await payment.save();

    res.json({ resultCode: 0, message: 'Webhook received' });
  }
});
```

### 3. Environment Variables
Backend cần các environment variables:

```bash
# .env
MOMO_PARTNER_CODE=xxxxx
MOMO_ACCESS_KEY=xxxxx
MOMO_SECRET_KEY=xxxxx
MOMO_PUBLIC_KEY=xxxxx
API_BASE_URL=http://localhost:3000
```

## Testing locally

### Option 1: Using ngrok to expose localhost
```bash
# Terminal 1: Run backend on port 3000
npm start

# Terminal 2: Expose localhost to internet
ngrok http 3000

# Update notifyUrl in code to use ngrok URL:
# https://your-ngrok-url.ngrok.io/api/payments/momo-callback
```

### Option 2: Testing on real device
1. Build app in debug mode
2. Android device cắm USB debugging
3. Run: `flutter run`
4. Open invoice và click "Thanh toán"
5. Momo app sẽ mở
6. Thanh toán (fake payment in Momo sandbox)
7. Momo sẽ redirect về app qua deep link

## Deep Link Testing

### Test deep link manually (Android):
```bash
# Open Payment Result page with deep link
adb shell am start -W -a android.intent.action.VIEW \
  -d "prm://payment/result?paymentId=123&status=success&message=Payment%20successful"
```

## Important Notes

1. **Deep Link must have paymentId** - Without paymentId, app won't navigate to payment result page
2. **Test with Sandbox first** - Use Momo sandbox environment before going to production
3. **Local testing** - For localhost testing (172.20.10.2:3000), you may need to:
   - Use ngrok to expose localhost to internet
   - Or test on a network where device can reach backend directly
4. **Return URL format** - Make sure returnUrl is URL-encoded properly when sending to Momo

## Troubleshooting

### App doesn't open after Momo payment
- Check logcat: `adb logcat | grep momo`
- Verify AndroidManifest.xml has deep link intent filter
- Ensure paymentId parameter is passed in URL
- Check that app router has paymentResult route

### Momo doesn't call backend webhook
- Verify notifyUrl is accessible from internet
- Check firewall settings
- Use ngrok if testing locally
- Verify Momo settings in MoMo merchant dashboard

### Payment status not updating
- Check backend logs for webhook calls
- Verify payment status check in app side
- May need to manually refresh payment status
