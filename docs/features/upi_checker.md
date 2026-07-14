# UPI Checker

## Status

IMPLEMENTED

## Features

- UPI payment-link validation
- VPA, amount, and INR currency checks
- Offline FraudEngine analysis
- Risk score, risk level, reasons, and advice
- UPI scan history persistence
- Copy and share result actions
- Clear-history control from Settings

## Supported input

```text
upi://pay?pa=merchant@upi&pn=Merchant&am=100&cu=INR
```

The checker does not initiate or open payments. It only validates and analyzes
the supplied payment link.
