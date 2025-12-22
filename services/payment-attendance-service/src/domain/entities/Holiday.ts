export class Holiday {
  constructor(
    public id: string,
    public name: string,
    public date: Date,
    public isRecurring: boolean,
    public type: "national" | "school",
    public schoolId?: string,
    public createdAt?: Date,
    public updatedAt?: Date
  ) {}
}
