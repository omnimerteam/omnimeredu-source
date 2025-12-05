export class Account {
  constructor(
    public id: string,
    public userId: string, // Reference to User Entity
    public email: string, // Login email
    public passwordHash: string,
    public uid: string, // External/Unique ID
    public isActive: boolean = true,
    public lastLogin?: Date
  ) {}
}
