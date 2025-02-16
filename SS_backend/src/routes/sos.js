// import express from 'express';
// import twilio from 'twilio';
// import dotenv from 'dotenv';
// import Contact from '../models/contact.js'; // Your Contact model
// import User from '../models/User.js'; // Your User model

// dotenv.config(); // Load environment variables

// const router = express.Router();

// // Twilio credentials from environment variables
// const accountSid = process.env.TWILIO_ACCOUNT_SID;
// const authToken = process.env.TWILIO_AUTH_TOKEN;
// const twilioPhoneNumber = process.env.TWILIO_PHONE_NUMBER;

// // Ensure Twilio credentials are loaded
// if (!accountSid || !authToken || !twilioPhoneNumber) {
//     console.error('Twilio credentials are not fully configured. Please check your environment variables.');
// }

// const client = twilio(accountSid, authToken);

// // Helper: Validate phone number format (+91 xxxxxxxxx)
// const validatePhoneNumber = (phone) => {
//     const phoneRegex = /^\+91 \d{10}$/; // Matches +91 followed by space and exactly 10 digits
//     return phoneRegex.test(phone);
// };

// // Save contacts for a user
// router.post('/savecontacts', async (req, res) => {
//     const { userId, contacts } = req.body; // 'contacts' is an array of objects: [{ name, phone }]

//     if (!Array.isArray(contacts) || contacts.length === 0) {
//         return res.status(400).json({ message: 'Contacts array is empty or invalid!' });
//     }

//     try {
//         // Check if user exists
//         const user = await User.findById(userId);
//         if (!user) {
//             return res.status(404).json({ message: 'User not found!' });
//         }

//         // Validate and save each contact
//         const savedContacts = [];
//         for (const contact of contacts) {
//             if (!validatePhoneNumber(contact.phone)) {
//                 return res.status(400).json({ message: `Invalid phone number format: ${contact.phone}` });
//             }

//             const newContact = new Contact({ userId, name: contact.name, phone: contact.phone });
//             try {
//                 await newContact.save();
//                 savedContacts.push(newContact);
//             } catch (error) {
//                 if (error.code === 11000) {
//                     return res.status(400).json({ message: `Phone number already exists: ${contact.phone}` });
//                 }
//                 throw error;
//             }
//         }

//         res.status(201).json({ message: 'Contacts saved successfully!', savedContacts });
//     } catch (error) {
//         console.error('Error saving contacts:', error.message);
//         res.status(500).json({ message: 'Error saving contacts!', error: error.message });
//     }
// });

// // Send SOS to all contacts
// router.post('/sendsos', async (req, res) => {
//     const { userId, latitude, longitude } = req.body;

//     if (!latitude || !longitude) {
//         return res.status(400).json({ message: 'Location (latitude and longitude) is required!' });
//     }

//     if (!twilioPhoneNumber) {
//         console.error('Twilio phone number is not set in environment variables.');
//         return res.status(500).json({ message: 'Twilio phone number is not configured!' });
//     }

//     try {
//         // Find all contacts for the user
//         const contacts = await Contact.find({ userId });
//         if (contacts.length === 0) {
//             return res.status(404).json({ message: 'No contacts found for the user!' });
//         }

//         // Prepare the location link
//         const locationLink = `https://maps.google.com/?q=${latitude},${longitude}`;
//         const messageBody = `SOS! The person is at location: ${locationLink}. Please help!`;

//         // Send SOS to all contacts
//         const messages = [];
//         for (const contact of contacts) {
//             try {
//                 const message = await client.messages.create({
//                     body: messageBody,
//                     from: twilioPhoneNumber,
//                     to: contact.phone,
//                 });
//                 messages.push({ phone: contact.phone, status: 'Sent', sid: message.sid });
//             } catch (error) {
//                 console.error(`Failed to send message to ${contact.phone}:`, error.message);
//                 messages.push({ phone: contact.phone, status: 'Failed', error: error.message });
//             }
//         }

//         res.status(200).json({ message: 'SOS messages processed!', details: messages });
//     } catch (error) {
//         console.error('Error sending SOS messages:', error.message);
//         res.status(500).json({ message: 'Error sending SOS messages!', error: error.message });
//     }
// });

// export default router;



import express from 'express';
import twilio from 'twilio';
import dotenv from 'dotenv';
import Contact from '../models/contact.js'; // Your Contact model
import User from '../models/User.js'; // Your User model

dotenv.config(); // Load environment variables

const router = express.Router();

// Twilio credentials from environment variables
const accountSid = process.env.TWILIO_ACCOUNT_SID;
const authToken = process.env.TWILIO_AUTH_TOKEN;
const twilioPhoneNumber = process.env.TWILIO_PHONE_NUMBER;

// Ensure Twilio credentials are loaded
if (!accountSid || !authToken || !twilioPhoneNumber) {
    console.error('Twilio credentials are not fully configured. Please check your environment variables.');
}

const client = twilio(accountSid, authToken);

// Helper: Validate phone number format (+91 xxxxxxxxx)
const validatePhoneNumber = (phone) => {
    const phoneRegex = /^\+91 \d{10}$/; // Matches +91 followed by space and exactly 10 digits
    return phoneRegex.test(phone);
};

// Save contacts for a user
router.post('/savecontacts', async (req, res) => {
    const { userId, contacts } = req.body; // 'contacts' is an array of objects: [{ name, phone }]

    if (!Array.isArray(contacts) || contacts.length === 0) {
        return res.status(400).json({ message: 'Contacts array is empty or invalid!' });
    }

    try {
        // Check if user exists
        const user = await User.findById(userId);
        if (!user) {
            return res.status(404).json({ message: 'User not found!' });
        }

        // Validate and save each contact
        const savedContacts = [];
        for (const contact of contacts) {
            if (!validatePhoneNumber(contact.phone)) {
                return res.status(400).json({ message: `Invalid phone number format: ${contact.phone}` });
            }

            const newContact = new Contact({ userId, name: contact.name, phone: contact.phone });
            try {
                await newContact.save();
                savedContacts.push(newContact);
            } catch (error) {
                if (error.code === 11000) {
                    return res.status(400).json({ message: `Phone number already exists for this user: ${contact.phone}` });
                }
                throw error;
            }
        }

        res.status(201).json({ message: 'Contacts saved successfully!', savedContacts });
    } catch (error) {
        console.error('Error saving contacts:', error.message);
        res.status(500).json({ message: 'Error saving contacts!', error: error.message });
    }
});

// Send SOS to all contacts
router.post('/sendsos', async (req, res) => {
    const { userId, latitude, longitude } = req.body;

    if (!latitude || !longitude) {
        return res.status(400).json({ message: 'Location (latitude and longitude) is required!' });
    }

    if (!twilioPhoneNumber) {
        console.error('Twilio phone number is not set in environment variables.');
        return res.status(500).json({ message: 'Twilio phone number is not configured!' });
    }

    try {
        // Find all contacts for the user
        const contacts = await Contact.find({ userId });
        if (contacts.length === 0) {
            return res.status(404).json({ message: 'No contacts found for the user!' });
        }

        // Prepare the location link
        const locationLink = `https://maps.google.com/?q=${latitude},${longitude}`;
        const messageBody = `SOS! The person is at location: ${locationLink}. Please help!`;

        // Send SOS to all contacts
        const messages = [];
        for (const contact of contacts) {
            try {
                const message = await client.messages.create({
                    body: messageBody,
                    from: twilioPhoneNumber,
                    to: contact.phone,
                });
                messages.push({ phone: contact.phone, status: 'Sent', sid: message.sid });
            } catch (error) {
                console.error(`Failed to send message to ${contact.phone}:`, error.message);
                messages.push({ phone: contact.phone, status: 'Failed', error: error.message });
            }
        }

        res.status(200).json({ message: 'SOS messages processed!', details: messages });
    } catch (error) {
        console.error('Error sending SOS messages:', error.message);
        res.status(500).json({ message: 'Error sending SOS messages!', error: error.message });
    }
});

export default router;