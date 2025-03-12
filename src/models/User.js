// import mongoose from 'mongoose';
// import bcrypt from 'bcrypt';

// const userSchema = new mongoose.Schema({
//     fullname: { type: String, required: true },
//     email: { type: String, required: true, unique: true },
//     phone: {
//         type: String,
//     },
//     address: {
//         type: String,
//     },
//     password: { type: String, required: true },
//     otp: { type: String, default: null },
//     otpExpiry: { type: Date, default: null },
// });

// // Hash the password before saving
// userSchema.pre('save', async function (next) {
//     if (this.isModified('password')) {
//         this.password = await bcrypt.hash(this.password, 10);
//     }
//     next();
// });

// // Method to compare password
// userSchema.methods.comparePassword = function (password) {
//     return bcrypt.compare(password, this.password);
// };


// const User = mongoose.model('User', userSchema);
// export default User;



import mongoose from 'mongoose';
import bcrypt from 'bcrypt';

const userSchema = new mongoose.Schema({
    userId: { type: String, required: true, unique: true }, 
    fullname: { type: String, required: true },
    email: { type: String, required: true, unique: true },
    phone: { type: String },
    address: { type: String },
    password: { type: String, required: true },
    otp: { type: String, default: null },
    otpExpiry: { type: Date, default: null },
    sharedWith: [{ type: String }], // List of userIds allowed to see live location
    contacts: [{
        name: { type: String, required: true },
        phone: { type: String, required: true }
    }] // Store contacts properly
});

// Hash the password before saving
userSchema.pre('save', async function (next) {
    if (this.isModified('password')) {
        this.password = await bcrypt.hash(this.password, 10);
    }
    next();
});

// Method to compare password
userSchema.methods.comparePassword = function (password) {
    return bcrypt.compare(password, this.password);
};

const User = mongoose.model('User', userSchema);
export default User;
