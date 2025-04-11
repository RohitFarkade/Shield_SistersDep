import mongoose from 'mongoose';

const tempRegistrationSchema = new mongoose.Schema({
    email: { type: String, required: true, unique: true },
    otp: { type: String, required: true },
    otpExpiry: { type: Number, required: true },
    fullname: { type: String }, // Optional: Store for registration
    phone: { type: String }, // Optional: Store for registration
    createdAt: { type: Date, default: Date.now, expires: '10m' }, // Auto-delete after 10 minutes
});

export default mongoose.model('TempRegistration', tempRegistrationSchema);