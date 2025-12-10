export class Payment {
  constructor(
    public id: string,
    public studentId: string,
    public tuitionId: string,
    public paymentMethodId: string,
    public amount: number,
    public transactionId: string,
    public status: "Success" | "Failed",
    public paidAt: Date,
    public createdAt?: Date,
    public updatedAt?: Date
  ) {}
}
