// import AuthService from '../services/authServices.js';
// import User from '../models/contact.js';
// class AuthController {
//     // User sign-up
//     static async Register(req, res) {
//         try {
//             const user = await AuthService.userRegister(req.body);
//             res.status(201).json({ message: 'User registered successfully', user });
//         } catch (error) {
//             res.status(400).json({ error: error.message });
//         }
//     }

//     // User login
//     static async Login(req, res) {
//         try {
//             const { email, password } = req.body;
//             const { user, token } = await AuthService.userLogin(email, password);
//             res.status(200).json({ message: 'Login successful', user, token });
//         } catch (error) {
//             res.status(400).json({ error: error.message });
//         }
//     }


//     // Update User profile
//     static async updateProfile(req, res) {
//         try {
//             const userId = req.user.id;
//             const updatedUser = await AuthService.updateUserProfile(userId, req.body);
//             res.status(200).json({ message: 'User profile updated successfully', updatedUser });
//         } catch (error) {
//             res.status(500).json({ error: error.message });
//         }
//     }

//     // Delete User profile
//     static async deleteProfile(req, res) {
//         try {
//             const userId = req.user.id;
//             await AuthService.deleteUserProfile(userId);
//             res.status(200).json({ message: 'User profile deleted successfully' });
//         } catch (error) {
//             res.status(500).json({ error: error.message });
//         }
//     }

 
//       // Send OTP for password reset
//       static async sendResetOTP(req, res) {
//         try {
//             const { email } = req.body;
//             const user = await AuthService.sendOTP(email);
//             res.status(200).json({ message: 'OTP sent to your email', user });
//         } catch (error) {
//             res.status(400).json({ error: error.message });
//         }
//     }

//     // Verify OTP
//     static async verifyResetOTP(req, res) {
//         try {
//             const { email, otp } = req.body;
//             const user = await AuthService.verifyOTP(email, otp);
//             res.status(200).json({ message: 'OTP verified successfully', user });
//         } catch (error) {
//             res.status(400).json({ error: error.message });
//         }
//     }

//     // Reset password
//     static async resetPassword(req, res) {
//         try {
//             const { email, newPassword } = req.body;
//             const user = await AuthService.resetPassword(email, newPassword);
//             res.status(200).json({ message: 'Password reset successfully', user });
//         } catch (error) {
//             res.status(400).json({ error: error.message });
//         }
//     }
//     static async addMultipleContacts(req, res) {
//         try {
//             const { userId, contacts } = req.body;

//             if (!contacts || contacts.length === 0) {
//                 return res.status(400).json({ message: 'No contacts provided' });
//             }

//             const user = await User.findById(userId);

//             if (!user) {
//                 return res.status(404).json({ message: 'User not found' });
//             }

//             // Add contacts to the user's contacts array
//             user.contacts.push(...contacts);

//             // Save updated user document
//             await user.save();

//             res.status(200).json({ message: 'Contacts added successfully', data: user.contacts });
//         } catch (error) {
//             res.status(500).json({ message: 'Error adding contacts', error: error.message });
//         }
//     }
// }
    


// export default AuthController;


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

    // Reset password
    static async resetPassword(req, res) {
        try {
            const { email, newPassword } = req.body;
            const user = await AuthService.resetPassword(email, newPassword);
            res.status(200).json({ message: 'Password reset successfully', user });
        } catch (error) {
            res.status(400).json({ error: error.message });
        }
    }

    // Add multiple contacts
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

            // Prefix "+91" to phone numbers if not already present
            const updatedContacts = contacts.map(contact => ({
                name: contact.name,
                phone: contact.phone.startsWith('+91') ? contact.phone : `+91${contact.phone}`,
            }));

            user.contacts.push(...updatedContacts);
            await user.save();

            res.status(200).json({ message: 'Contacts added successfully', data: user.contacts });
        } catch (error) {
            res.status(500).json({ message: 'Error adding contacts', error: error.message });
        }
    }

    // Fetch user contacts
    static async getContacts(req, res) {
        try {
          const userId = req.headers['userid']; // Get userId from header (case-insensitive)
          if (!userId) {
            return res.status(400).json({ message: 'userId header is required' });
          }
          const contacts = await Contact.find({ userId: userId });
          res.status(200).json({ contacts: contacts });
        } catch (error) {
          res.status(500).json({ error: error.message });
        }
      }

    // Update contact
    static async updateContact(req, res) {
        try {
            const userId = req.user.id;
            const { contactId, name, phone } = req.body;
            const user = await User.findById(userId);
            if (!user) {
                return res.status(404).json({ message: 'User not found' });
            }
            const contact = user.contacts.id(contactId);
            if (!contact) {
                return res.status(404).json({ message: 'Contact not found' });
            }
            contact.name = name;
            contact.phone = phone.startsWith('+91') ? phone : `+91${phone}`;
            await user.save();
            res.status(200).json({ message: 'Contact updated successfully', contact });
        } catch (error) {
            res.status(500).json({ error: error.message });
        }
    }

    // Delete contact
    static async deleteContact(req, res) {
        try {
            const userId = req.user.id;
            const { contactId } = req.body;
            const user = await User.findById(userId);
            if (!user) {
                return res.status(404).json({ message: 'User not found' });
            }
            user.contacts.id(contactId).remove();
            await user.save();
            res.status(200).json({ message: 'Contact deleted successfully' });
        } catch (error) {
            res.status(500).json({ error: error.message });
        }
    }
}

export default AuthController;