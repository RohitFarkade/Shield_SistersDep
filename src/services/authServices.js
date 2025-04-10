// import nodemailer from 'nodemailer';
// import otpGenerator from 'otp-generator';
// import jwt from 'jsonwebtoken';
// import User from '../models/User.js';

// const JWT_SECRET = 'your_jwt_secret'; // Use a secure key in a real application
// const OTP_EXPIRY = 5 * 60 * 1000; // 5 minutes

// class AuthService {
//     // Register student
//     static async userRegister(data) {
//         const user = new User(data);
//         await user.save();
//         return user;
//     }

//     // userLogin logic for students
//     static async userLogin(email, password) {
//         const user = await User.findOne({ email });
//         if (!user) {
//             throw new Error('User not found');
//         }
//         const isMatch = await user.comparePassword(password);
//         if (!isMatch) {
//             throw new Error('Invalid password');
//         }

//         // Generate JWT token
//         const token = jwt.sign({ id: user._id, email: user.email }, JWT_SECRET, { expiresIn: '1h' });

//         return { user, token };
//     }

 
//     // Update profile
//     static async updateUserProfile(userId, data) {
//         const updatedUser = await User.findByIdAndUpdate(userId, data, { new: true });
//         if (!updatedUser) {
//             throw new Error('User not found');
//         }
//         return updatedUser;
//     }

//     // Delete profile
//     static async deleteUserProfile(userId) {
//         const user = await User.findByIdAndDelete(userId);
//         if (!user) {
//             throw new Error('User not found');
//         }
//         return;
//     }

//       // Generate and send OTP
//       static async sendOTP(email) {
       
//         const otp = otpGenerator.generate(6, {
//             digits: true,
//             lowerCaseAlphabets: false,
//             upperCaseAlphabets: false,
//             specialChars: false
//           });
          
//         // otpGenerator.generate(6, { upperCase: false, specialChars: false });
//         console.log('Generated OTP:', otp); // Log the generated OTP for debugging
//         // Save OTP and its expiry in user record
//         const user = await User.findOneAndUpdate(
//             { email },
//             { otp, otpExpiry: Date.now() + OTP_EXPIRY },
//             { new: true }
//         );

//         if (!user) {
//             throw new Error('User not found');
//         }

//         // Configure the email transport
//         const transporter = nodemailer.createTransport({
//             service: 'Gmail', // Use your email service
//             auth: {
//                 user: 'shieldsister.app@gmail.com', // Your email
//                 pass: 'ejllcrcpcdkhxmrp', // Your email password or app-specific password
//             },
//         });

//         // Send the OTP via email
//         await transporter.sendMail({
//             from: '"ShieldSister"<shieldsister.app@gmail.com>',
//             to: user.email,
//             subject: 'Your OTP Code',
//             text: `Your OTP code is ${otp}. It is valid for 5 minutes.`,
//         });

//         return user; // Return user for further operations if needed
//     }

//     // Verify OTP
//     static async verifyOTP(email, otp) {
//         const user = await User.findOne({ email });

//         if (!user) {
//             throw new Error('User not found');
//         }

//         if (user.otp !== otp || Date.now() > user.otpExpiry) {
//             throw new Error('Invalid or expired OTP');
//         }

//         // Clear OTP after successful verification
//         user.otp = null;
//         user.otpExpiry = null;
//         await user.save();

//         return user;
//     }

//     // Reset password
//     static async resetPassword(email, newPassword) {
//         const user = await User.findOne({ email });

//         if (!user) {
//             throw new Error('User not found');
//         }

//         user.password = newPassword; // This will trigger password hashing in the pre-save hook
//         await user.save();

//         return user;
//     }
// }

// export default AuthService;




// --- In authServices.js ---

import nodemailer from 'nodemailer';
import otpGenerator from 'otp-generator';
import jwt from 'jsonwebtoken';
import User from '../models/User.js'; // Make sure this path is correct

const JWT_SECRET = 'your_jwt_secret'; // Use a secure key
const OTP_EXPIRY = 5 * 60 * 1000; // 5 minutes

// Simple in-memory cache for registration OTPs (Replace with Redis/etc. in production)
const registrationOtpCache = {};

class AuthService {
    // ... (userLogin, updateUserProfile, deleteUserProfile remain the same) ...

    // --- NEW: Send OTP specifically for registration ---
    static async sendRegistrationOTP(email) {
        // 1. Check if user already exists
        const existingUser = await User.findOne({ email });
        if (existingUser) {
            throw new Error('Email is already registered.');
        }

        // 2. Generate OTP
        const otp = otpGenerator.generate(6, {
            digits: true, lowerCaseAlphabets: false, upperCaseAlphabets: false, specialChars: false
        });
        console.log('Generated Registration OTP:', otp, 'for email:', email);

        // 3. Store OTP temporarily
        registrationOtpCache[email] = {
            otp: otp,
            expiry: Date.now() + OTP_EXPIRY,
        };
        console.log('Current OTP Cache:', registrationOtpCache); // For debugging

        // 4. Configure email transport (ensure credentials are secure)
        const transporter = nodemailer.createTransport({
            service: 'Gmail',
            auth: {
                user: 'shieldsister.app@gmail.com', // Your email
                pass: 'ejllcrcpcdkhxmrp', // Your app password
            },
        });

        // 5. Send OTP via email
        try {
            await transporter.sendMail({
                from: '"ShieldSister"<shieldsister.app@gmail.com>',
                to: email,
                subject: 'Your ShieldSister Registration OTP Code',
                text: `Your OTP code for registration is ${otp}. It is valid for 5 minutes.`,
            });
             // Clean up expired OTPs periodically (optional, better with TTL in Redis)
             this.cleanupExpiredOtps();

        } catch (emailError) {
            console.error("Failed to send registration OTP email:", emailError);
            // Clean up the potentially stored OTP if email fails
            delete registrationOtpCache[email];
            throw new Error('Failed to send OTP email. Please try again.');
        }

        // Don't return user here, as they don't exist yet
        return { message: 'OTP sent to your email for registration.' };
    }

     // --- NEW: Verify the temporarily stored registration OTP ---
     static async verifyRegistrationOTP(email, otp) {
        const cachedData = registrationOtpCache[email];
        console.log('Verifying OTP for:', email, 'Received OTP:', otp, 'Cached Data:', cachedData); // Debugging

        if (!cachedData) {
            throw new Error('OTP not found or never sent. Please request OTP again.');
        }

        if (Date.now() > cachedData.expiry) {
            delete registrationOtpCache[email]; // Clean up expired OTP
            throw new Error('OTP has expired. Please request a new one.');
        }

        if (cachedData.otp !== otp) {
            throw new Error('Invalid OTP provided.');
        }

        // OTP is valid, clear it from cache immediately after verification
        delete registrationOtpCache[email];
        return true; // Indicate successful verification
    }

     // --- Helper to cleanup expired OTPs from cache (Simple version) ---
     static cleanupExpiredOtps() {
         const now = Date.now();
         for (const email in registrationOtpCache) {
             if (registrationOtpCache[email].expiry < now) {
                 console.log('Cleaning up expired OTP for:', email);
                 delete registrationOtpCache[email];
             }
         }
     }


    // --- MODIFIED: User Registration - Now verifies OTP first ---
    static async userRegister(data, otp) { // Accept OTP here
        const { email } = data;

        if (!otp) {
             throw new Error('OTP is required for registration.');
        }

        // 1. Verify the registration OTP using the new method
        await this.verifyRegistrationOTP(email, otp); // Throws error if invalid/expired

        // 2. If OTP verification passed, proceed to create the user
        const existingUser = await User.findOne({ email }); // Double check just in case
         if (existingUser) {
             // This case should ideally be caught by sendRegistrationOTP, but good to double-check
             throw new Error('Email is already registered.');
         }

        const user = new User(data);
        await user.save();
        return user; // Return the newly created user
    }

    // --- Password Reset Flow (uses OTP stored ON the user document) ---
    // sendOTP for password reset (renamed for clarity, or keep as is if used elsewhere)
    static async sendPasswordResetOTP(email) {
        const otp = otpGenerator.generate(6, { /* ... options ... */ });
        console.log('Generated Password Reset OTP:', otp);

        const user = await User.findOneAndUpdate(
            { email },
            { otp, otpExpiry: Date.now() + OTP_EXPIRY },
            { new: true, upsert: false } // Ensure upsert is false or default
        );

        if (!user) {
            throw new Error('User not found for password reset.'); // Specific error
        }

        // Configure transporter and send email as before...
         const transporter = nodemailer.createTransport({ /* ... config ... */ });
         await transporter.sendMail({ /* ... mail options ... */ });


        return user;
    }

    // verifyOTP for password reset (renamed for clarity)
    static async verifyPasswordResetOTP(email, otp) {
        const user = await User.findOne({ email });

        if (!user) {
            throw new Error('User not found.');
        }
        // Verify OTP stored ON the user document
        if (user.otp !== otp || !user.otpExpiry || Date.now() > user.otpExpiry) {
             // Clear invalid/expired OTP from user doc as well
             user.otp = undefined; // Use undefined for Mongoose
             user.otpExpiry = undefined;
             await user.save();
            throw new Error('Invalid or expired password reset OTP.');
        }

        // Clear OTP after successful verification
        user.otp = undefined;
        user.otpExpiry = undefined;
        await user.save();

        return user;
    }

    // resetPassword - Can use verifyPasswordResetOTP internally or keep combined logic
    static async resetPassword(email, newPassword, otp) {
        // Option 1: Use the dedicated verification function
         await this.verifyPasswordResetOTP(email, otp); // Verify first
         const user = await User.findOne({ email }); // Refetch user (or use returned user from verify)
         if (!user) throw new Error('User not found after OTP verification.'); // Should not happen
         user.password = newPassword;
         await user.save();
         return user;

        // Option 2: Keep combined logic (as you had before, but ensure it uses user.otp)
        /*
        const user = await User.findOne({ email });
        if (!user) throw new Error('User not found.');
        if (user.otp !== otp || !user.otpExpiry || Date.now() > user.otpExpiry) {
             user.otp = undefined; user.otpExpiry = undefined; await user.save(); // Clear
             throw new Error('Invalid or expired password reset OTP.');
        }
        user.otp = undefined; user.otpExpiry = undefined; // Clear OTP
        user.password = newPassword;
        await user.save();
        return user;
        */
    }

    // ... (rest of the service: addMultipleContacts, etc. - assuming they belong elsewhere,
    //      as AuthService should ideally focus only on Auth)
}

export default AuthService;