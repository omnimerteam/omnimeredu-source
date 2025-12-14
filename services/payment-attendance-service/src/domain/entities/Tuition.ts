export interface ExtraFeeDetail {
  feeId: string;
  feeCode?: string;
  feeName?: string;
  unitAmountSnapshot?: number;
  quantity: number;
  calculatedAmount: number;
}

export interface DiscountDetail {
  discountId: string;
  discountCode?: string;
  discountName?: string;
  kind?: "Percentage" | "Fixed";
  valueSnapshot?: number;
  appliedAmount: number;
}

export class Tuition {
  constructor(
    public id: string,
    public studentId: string,
    public schoolId: string,
    public classId: string,
    public baseFeeSnapshot: number,
    public totalAmount: number,
    public attendedDays: number,
    public status: "Draft" | "Pending" | "Paid" | "Cancelled" | "Failed",
    public currency: "VND" | "USD" = "VND",
    public periodStart?: Date,
    public periodEnd?: Date,
    public month?: string,
    public extraFeeDetails?: ExtraFeeDetail[],
    public discountDetails?: DiscountDetail[],
    public appliedRules?: any[],
    public calculationLog?: Record<string, any>,
    public createdBy?: string,
    public confirmedBy?: string,
    public confirmedAt?: Date,
    public paidAt?: Date,
    public invoiceId?: string,
    public dueDate?: Date,
    public meta?: Record<string, any>,
    public createdAt?: Date,
    public updatedAt?: Date
  ) {}
}
