<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

// Razorpay API credentials
$razorpay_key_id = "YOUR_RAZORPAY_KEY_ID"; // Replace with your actual key
$razorpay_key_secret = "YOUR_RAZORPAY_KEY_SECRET"; // Replace with your actual secret

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    try {
        // Get POST data
        $amount = isset($_POST['amount']) ? intval($_POST['amount']) : 0;
        $currency = isset($_POST['currency']) ? $_POST['currency'] : 'INR';
        $receipt = isset($_POST['receipt']) ? $_POST['receipt'] : 'receipt_' . time();
        $payment_capture = isset($_POST['payment_capture']) ? intval($_POST['payment_capture']) : 1;
        
        if ($amount <= 0) {
            echo json_encode([
                'success' => false,
                'message' => 'Invalid amount'
            ]);
            exit;
        }
        
        // Prepare order data
        $order_data = [
            'amount' => $amount, // Amount in paise
            'currency' => $currency,
            'receipt' => $receipt,
            'payment_capture' => $payment_capture
        ];
        
        // Create cURL request to Razorpay
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, 'https://api.razorpay.com/v1/orders');
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($order_data));
        curl_setopt($ch, CURLOPT_HTTPHEADER, [
            'Content-Type: application/json',
            'Authorization: Basic ' . base64_encode($razorpay_key_id . ':' . $razorpay_key_secret)
        ]);
        
        $response = curl_exec($ch);
        $http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        curl_close($ch);
        
        if ($http_code == 200) {
            $order_response = json_decode($response, true);
            
            echo json_encode([
                'success' => true,
                'order_id' => $order_response['id'],
                'amount' => $order_response['amount'],
                'currency' => $order_response['currency'],
                'status' => $order_response['status']
            ]);
        } else {
            $error_response = json_decode($response, true);
            echo json_encode([
                'success' => false,
                'message' => isset($error_response['error']['description']) 
                    ? $error_response['error']['description'] 
                    : 'Failed to create Razorpay order'
            ]);
        }
        
    } catch (Exception $e) {
        echo json_encode([
            'success' => false,
            'message' => 'Server error: ' . $e->getMessage()
        ]);
    }
} else {
    echo json_encode([
        'success' => false,
        'message' => 'Only POST method allowed'
    ]);
}
?>
