
import AuthService from '../services/authServices.js';
import User from '../models/contact.js';
import Contact from '../models/contact.js';

class AuthController {
    // User sign-up
    static async Register(req, res) {
        try {
            const user = await AuthService.userRegister(req.body);
            res.status(201).json({ message: 'User registered successfully', user });
        } catch (error) {
            res.status(400).json({ error: error.message });
        }
    }

    // User login
    static async Login(req, res) {
        try {
            const { email, password } = req.body;
            const { user, token } = await AuthService.userLogin(email, password);
            res.status(200).json({ message: 'Login successful', user, token });
        } catch (error) {
            res.status(400).json({ error: error.message });
        }
    }

    // Update User profile
    static async updateProfile(req, res) {
        try {
            const userId = req.user.id;
            const updatedUser = await AuthService.updateUserProfile(userId, req.body);
            res.status(200).json({ message: 'User profile updated successfully', updatedUser });
        } catch (error) {
            res.status(500).json({ error: error.message });
        }
    }

    // Delete User profile
    static async deleteProfile(req, res) {
        try {
            const userId = req.user.id;
            await AuthService.deleteUserProfile(userId);
            res.status(200).json({ message: 'User profile deleted successfully' });
        } catch (error) {
            res.status(500).json({ error: error.message });
        }
    }

    // Send OTP for password reset
    static async sendResetOTP(req, res) {
        try {
            const { email } = req.body;
            const user = await AuthService.sendOTP(email);
            res.status(200).json({ message: 'OTP sent to your email', user });
        } catch (error) {
            res.status(400).json({ error: error.message });
        }
    }

    // Verify OTP
    static async verifyResetOTP(req, res) {
        try {
            const { email, otp } = req.body;
            const user = await AuthService.verifyOTP(email, otp);
            res.status(200).json({ message: 'OTP verified successfully', user });
        } catch (error) {
            res.status(400).json({ error: error.message });
        }
    }

    // // Reset password
    // static async resetPassword(req, res) {
    //     try {
    //         const { email, newPassword } = req.body;
    //         const user = await AuthService.resetPassword(email, newPassword);
    //         res.status(200).json({ message: 'Password reset successfully', user });
    //     } catch (error) {
    //         res.status(400).json({ error: error.message });
    //     }
    // }
    // Combined OTP verification and password reset in one API
static async resetPassword(req, res) {
    try {
        const { email, newPassword, otp } = req.body;

        if (!email || !newPassword || !otp) {
            return res.status(400).json({ error: 'Email, new password, and OTP are required' });
        }

        // Step 1: Verify OTP
        const user = await AuthService.verifyOTP(email, otp);

        // Step 2: Reset password
        user.password = newPassword;
        await user.save();

        return res.status(200).json({ message: 'Password reset successful', user });
    } catch (error) {
        console.error('Reset password failed:', error);
        return res.status(500).json({ error: error.message });
    }
}


    static async addMultipleContacts(req, res) {
        try {
            const { userId, contacts } = req.body;

            if (!contacts || contacts.length === 0) {
                return res.status(400).json({ message: 'No contacts provided' });
            }

            const user = await User.findById(userId);
            if (!user) {
                return res.status(404).json({ message: 'User not found' });
            }

            const savedContacts = [];
            for (const contact of contacts) {
                const phone = contact.phone.startsWith('+91 ') ? contact.phone : `+91 ${contact.phone}`;
                const newContact = new Contact({ userId, name: contact.name, phone });
                await newContact.save();
                savedContacts.push(newContact);
            }

            res.status(200).json({ message: 'Contacts added successfully', data: savedContacts });
        } catch (error) {
            if (error.code === 11000) {
                return res.status(400).json({ message: 'Phone number already exists for this user!' });
            }
            res.status(500).json({ message: 'Error adding contacts', error: error.message });
        }
    }

    // Fetch user contacts
    static async getContacts(req, res) {
        try {
            const userId = req.user.id;
            const contacts = await Contact.find({ userId });
            res.status(200).json({ contacts });
        } catch (error) {
            res.status(500).json({ error: error.message });
        }
    }

    // Update contact
    static async updateContact(req, res) {
        try {
            const userId = req.user.id;
            const { contactId, name, phone } = req.body;

            const contact = await Contact.findOne({ _id: contactId, userId });
            if (!contact) {
                return res.status(404).json({ message: 'Contact not found or not authorized!' });
            }

            contact.name = name || contact.name;
            contact.phone = phone ? (phone.startsWith('+91 ') ? phone : `+91 ${phone}`) : contact.phone;
            await contact.save();

            res.status(200).json({ message: 'Contact updated successfully', contact });
        } catch (error) {
            if (error.code === 11000) {
                return res.status(400).json({ message: 'Phone number already exists for this user!' });
            }
            res.status(500).json({ error: error.message });
        }
    }

    static async deleteContact(req, res) {
        try {
            const userId = req.user.id;
            const { contactId } = req.body;

            const contact = await Contact.findOneAndDelete({ _id: contactId, userId });
            if (!contact) {
                return res.status(404).json({ message: 'Contact not found or not authorized!' });
            }

            res.status(200).json({ message: 'Contact deleted successfully' });
        } catch (error) {
            res.status(500).json({ error: error.message });
        }
    }
}



export default AuthController;