import mongoose from 'mongoose';
import dotenv from 'dotenv';
dotenv.config();

import Role from '../models/Role';
import PaymentMethod from '../models/PaymentMethod';
import VipPackage from '../models/VipPackage';

async function runSeeder() {
  try {
    const dbUri = process.env.MONGODB_URI;

    if (!dbUri) {
      throw new Error('❌ MONGODB_URI is not defined in .env');
    }

    await mongoose.connect(dbUri);
    console.log('✅ Connected to MongoDB');

    // 🧩 Seed Roles
    const roles = ['SuperAdmin', 'SchoolAdmin', 'Teacher', 'Student', 'CanteenStaff', 'Nurse', 'Security'];
    for (const roleName of roles) {
      const result = await Role.updateOne(
        { name: roleName },
        {
          $setOnInsert: {
            _id: new mongoose.Types.ObjectId(),
            name: roleName
          }
        },
        { upsert: true }
      );
      if (result.upsertedId) console.log(`🟢 Inserted role: ${roleName}`);
    }
    console.log('✅ Seeded roles');

    // 💳 Seed Payment Methods
    const methods = ['Momo', 'ZaloPay', 'Bank', 'QRCode'];
    for (const name of methods) {
      const result = await PaymentMethod.updateOne(
        { name },
        {
          $setOnInsert: {
            _id: new mongoose.Types.ObjectId(),
            name
          }
        },
        { upsert: true }
      );
      if (result.upsertedId) console.log(`🟢 Inserted payment method: ${name}`);
    }
    console.log('✅ Seeded payment methods');

    // 💼 Seed VIP Packages
    const vipPackages = [
      {
        name: 'Basic',
        price: 500000,
        maxStudents: 100,
        maxInvoices: 200,
        features: ['Basic reporting', '5 news posts/month']
      },
      {
        name: 'Pro',
        price: 1000000,
        maxStudents: 300,
        maxInvoices: 500,
        features: ['All Basic features', 'Custom theme', '20 news posts/month']
      },
      {
        name: 'Enterprise',
        price: 3000000,
        maxStudents: 1000,
        maxInvoices: 2000,
        features: ['All Pro features', 'Unlimited support', 'Unlimited news']
      }
    ];

    for (const pack of vipPackages) {
      const result = await VipPackage.updateOne(
        { name: pack.name },
        {
          $setOnInsert: {
            _id: new mongoose.Types.ObjectId(),
            ...pack
          }
        },
        { upsert: true }
      );
      if (result.upsertedId) console.log(`🟢 Inserted VIP package: ${pack.name}`);
    }

    console.log('🌱 All seeding completed successfully!');
    process.exit(0);
  } catch (error) {
    console.error('❌ Seeder failed:', error);
    process.exit(1);
  }
}

runSeeder();
