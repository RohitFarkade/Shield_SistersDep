

import nodemailer from 'nodemailer';
import otpGenerator from 'otp-generator';
import jwt from 'jsonwebtoken';
import User from '../models/User.js';
import TempRegistration from '../models/TempRegistration.js';

const JWT_SECRET = 'your_jwt_secret'; // Use a secure key in a real application
const OTP_EXPIRY = 5 * 60 * 1000; // 5 minutes

class AuthService {
    // Register student
    // static async userRegister(data) {
    //     const user = new User(data);
    //     await user.save();
    //     return user;
    // }
    // static async userRegister(data) {
    //     const { email, fullname, password, phone } = data;

    //     // Check if user already exists
    //     const existingUser = await User.findOne({ email });
    //     if (existingUser) {
    //         throw new Error('User already exists');
    //     }

    //     // Check if OTP was verified in TempRegistration

    //     // Create new user
    //     const user = new User({ email, fullname, password, phone });
    //     await user.save();

    //     // Delete temporary registration record
    //     await TempRegistration.deleteOne({ email });

    //     return user;
    // }

    // static async sendRegistrationOTP(email, fullname, phone) {
    //     const otp = otpGenerator.generate(6, {
    //         digits: true,
    //         lowerCaseAlphabets: false,
    //         upperCaseAlphabets: false,
    //         specialChars: false,
    //     });
    //     console.log('Generated Registration OTP:', otp); // Log for debugging

    //     // Check if email is already in use
    //     const existingUser = await User.findOne({ email });
    //     if (existingUser) {
    //         throw new Error('Email already registered');
    //     }

    //     // Store or update temporary registration record
    //     await TempRegistration.findOneAndUpdate(
    //         { email },
    //         {
    //             email,
    //             otp,
    //             otpExpiry: Date.now() + OTP_EXPIRY,
    //             fullname,
    //             phone,
    //         },
    //         { upsert: true, new: true }
    //     );

        // Configure email transport
    //     const transporter = nodemailer.createTransport({
    //         service: 'Gmail',
    //         auth: {
    //             user: 'shieldsister.app@gmail.com',
    //             pass: 'ejllcrcpcdkhxmrp',
    //         },
    //     });

    //     // Send OTP email
    //     await transporter.sendMail({
    //         from: '"ShieldSister" <shieldsister.app@gmail.com>',
    //         to: email,
    //         subject: 'Your OTP Code for Registration',
    //         text: `Your OTP code is ${otp}. It is valid for 5 minutes.`,
    //     });

    //     return { email };
    // }
    // static async verifyRegistrationOTP(email, otp) {
    //     const tempReg = await TempRegistration.findOne({ email });
    //     console.log('Stored OTP:', tempReg?.otp, 'Received OTP:', otp);
    //     console.log('Current Time:', new Date(Date.now()), 'Expiry:', new Date(tempReg?.otpExpiry));
    
    //     if (!tempReg) {
    //         throw new Error('No registration request found');
    //     }
    //     if (tempReg.otp !== String(otp) || Date.now() > tempReg.otpExpiry) {
    //         throw new Error('Invalid or expired OTP');
    //     }
    
    //     // Delete the document instead of setting otp to null
    //     await TempRegistration.deleteOne({ _id: tempReg._id });
    //     return { email };
    // }
    static async sendRegistrationOTP(email, fullname, phone) {
        const otp = otpGenerator.generate(6, { digits: true, lowerCaseAlphabets: false, upperCaseAlphabets: false, specialChars: false });
        console.log('Generated OTP:', otp);
        const normalizedEmail = email.toLowerCase();
    
        const existingUser = await User.findOne({ email: normalizedEmail });
        if (existingUser) throw new Error('Email already registered');
    
        const expiry = Date.now() + OTP_EXPIRY;
        await TempRegistration.findOneAndUpdate(
            { email: normalizedEmail },
            { email: normalizedEmail, otp, otpExpiry: expiry, fullname, phone },
            { upsert: true, new: true }
        );
    
        const transporter = nodemailer.createTransport({
            service: 'Gmail',
            auth: { user: 'shieldsister.app@gmail.com', pass: 'ejllcrcpcdkhxmrp' },
        });
        await transporter.sendMail({
            from: '"ShieldSister" <shieldsister.app@gmail.com>',
            to: normalizedEmail,
            subject: 'Your OTP Code for Registration',
            text: `Your OTP code is ${otp}. Valid for 5 minutes.`,
        });
    
        return { email: normalizedEmail };
    }
    
    static async verifyRegistrationOTP(email, otp) {
        const normalizedEmail = email.toLowerCase();
        const tempReg = await TempRegistration.findOne({ email: normalizedEmail });
        console.log('Stored OTP:', tempReg?.otp, 'Received OTP:', otp);
        console.log('Current Time:', new Date(Date.now()), 'Expiry:', new Date(tempReg?.otpExpiry));
    
        if (!tempReg) {
            throw new Error('No registration request found');
        }
        if (tempReg.otp !== String(otp) || Date.now() > tempReg.otpExpiry) {
            throw new Error('Invalid or expired OTP');
        }
    
        await TempRegistration.deleteOne({ _id: tempReg._id });
        return { email: normalizedEmail };
    }
    
    static async userRegister(data) {
        const { email, fullname, password, phone } = data;
        const normalizedEmail = email.toLowerCase();
    
        const existingUser = await User.findOne({ email: normalizedEmail });
        if (existingUser) {
            throw new Error('User already exists');
        }
    
        // Check if OTP was verified (document should be deleted)
        const tempReg = await TempRegistration.findOne({ email: normalizedEmail });
        if (tempReg) {
            throw new Error('Please verify your email with OTP');
        }
    
        const user = new User({ email: normalizedEmail, fullname, password, phone });
        await user.save();
        return user;
    }


    // userLogin logic for students
    static async userLogin(email, password) {
        const user = await User.findOne({ email });
        if (!user) {
            throw new Error('User not found');
        }
        const isMatch = await user.comparePassword(password);
        if (!isMatch) {
            throw new Error('Invalid password');
        }

        // Generate JWT token
        const token = jwt.sign({ id: user._id, email: user.email }, JWT_SECRET, { expiresIn: '1h' });

        return { user, token };
    }

 
    // Update profile
    static async updateUserProfile(userId, data) {
        const updatedUser = await User.findByIdAndUpdate(userId, data, { new: true });
        if (!updatedUser) {
            throw new Error('User not found');
        }
        return updatedUser;
    }

    // Delete profile
    static async deleteUserProfile(userId) {
        const user = await User.findByIdAndDelete(userId);
        if (!user) {
            throw new Error('User not found');
        }
        return;
    }

      // Generate and send OTP
      static async sendOTP(email) {
       
        const otp = otpGenerator.generate(6, {
            digits: true,
            lowerCaseAlphabets: false,
            upperCaseAlphabets: false,
            specialChars: false
          });
          
        // otpGenerator.generate(6, { upperCase: false, specialChars: false });
        console.log('Generated OTP:', otp); // Log the generated OTP for debugging
        // Save OTP and its expiry in user record
        const user = await User.findOneAndUpdate(
            { email },
            { otp, otpExpiry: Date.now() + OTP_EXPIRY },
            { new: true }
        );

        if (!user) {
            throw new Error('User not found');
        }

        // Configure the email transport
        const transporter = nodemailer.createTransport({
            service: 'Gmail', // Use your email service
            auth: {
                user: 'shieldsister.app@gmail.com', // Your email
                pass: 'ejllcrcpcdkhxmrp', // Your email password or app-specific password
            },
        });

        // Send the OTP via email
        await transporter.sendMail({
            from: '"ShieldSister"<shieldsister.app@gmail.com>',
            to: user.email,
            subject: 'Your OTP Code',
            text: `Your OTP code is ${otp}. It is valid for 5 minutes.`,
        });

        return user; // Return user for further operations if needed
    }

    // Verify OTP
    static async verifyOTP(email, otp) {
        const user = await User.findOne({ email });

        if (!user) {
            throw new Error('User not found');
        }

        if (user.otp !== otp || Date.now() > user.otpExpiry) {
            throw new Error('Invalid or expired OTP');
        }

        // Clear OTP after successful verification
        user.otp = null;
        user.otpExpiry = null;
        await user.save();

        return user;
    }

    // Reset password
    static async resetPassword(email, newPassword) {
        const user = await User.findOne({ email });

        if (!user) {
            throw new Error('User not found');
        }

        user.password = newPassword; // This will trigger password hashing in the pre-save hook
        await user.save();

        return user;
    }
}

export default AuthService;