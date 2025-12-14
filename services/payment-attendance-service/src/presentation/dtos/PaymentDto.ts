export class CreatePaymentDto {
  studentId!: string;
  tuitionId!: string;
  paymentMethodId!: string;
  amount!: number;
  transactionId!: string;
  status!: "Success" | "Failed";
  paidAt!: Date;
}

export class PaymentCallbackDto {
  transactionId!: string;
  status!: "Success" | "Failed";
  amount?: number;
  metadata?: Record<string, any>;
}
