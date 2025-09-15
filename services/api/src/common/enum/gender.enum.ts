export enum GenderEnum {
  Male = "Male",
  Female = "Female",
  Other = "Other",
}

// Tuple tự động từ enum TS
export const GenderTuple = Object.values(GenderEnum) as [
  GenderEnum,
  ...GenderEnum[]
];
