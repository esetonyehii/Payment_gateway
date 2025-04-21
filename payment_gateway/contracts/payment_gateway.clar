(define-public (process-payment
                (amount uint)
                (payment-token (optional (string-ascii 64)))
                (customer-id (string-ascii 64))
                (payment-method (string-ascii 16)))
  (let
    (
      ;; Configuration for payment gateway
      (api-key "YOUR_PAYMENT_GATEWAY_API_KEY")
      (api-endpoint "https://api.payment-provider.com/v1/transactions")
      (merchant-id "YOUR_MERCHANT_ID")
      
      ;; Generate a unique transaction ID
      (tx-id (concat (unwrap-panic (get-block-info? time u0)) "-" customer-id))
    )
    
    ;; Validate payment amount
    (asserts! (> amount u0) (err u400))
    
    ;; Validate payment method
    (asserts! (or
              (is-eq payment-method "credit")
              (is-eq payment-method "debit")
              (is-eq payment-method "crypto"))
             (err u401))
    
    ;; Process the payment based on payment method
    (if (is-eq payment-method "crypto")
        ;; Handle crypto payment
        (process-crypto-payment amount customer-id tx-id)
        ;; Handle traditional payment
        (process-traditional-payment amount payment-method customer-id tx-id)
    )
  )
)
