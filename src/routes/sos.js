

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
//                     return res.status(400).json({ message: `Phone number already exists for this user: ${contact.phone}` });
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

// // Get all contacts for a user
// router.get('/getcontacts', async (req, res) => {
//     try {
//         const userId = req.headers['userid']; // Get userId from header
//         if (!userId) {
//             return res.status(400).json({ message: 'userId header is required' });
//         }

//         // Find all contacts for the user
//         const contacts = await Contact.find({ userId });
//         res.status(200).json({ contacts: contacts });
//     } catch (error) {
//         console.error('Error fetching contacts:', error.message);
//         res.status(500).json({ message: 'Error fetching contacts!', error: error.message });
//     }
// });

// export default router;



// import express from 'express';
// import twilio from 'twilio';
// import dotenv from 'dotenv';
// import Contact from '../models/contact.js';
// import User from '../models/User.js';

// dotenv.config();

// const router = express.Router();

// // Twilio setup
// const accountSid = process.env.TWILIO_ACCOUNT_SID;
// const authToken = process.env.TWILIO_AUTH_TOKEN;
// const twilioPhoneNumber = process.env.TWILIO_PHONE_NUMBER;
// if (!accountSid || !authToken || !twilioPhoneNumber) {
//     console.error('Twilio credentials are not fully configured.');
// }
// const client = twilio(accountSid, authToken);

// const validatePhoneNumber = (phone) => {
//     const phoneRegex = /^\+91 \d{10}$/;
//     return phoneRegex.test(phone);
// };

// // Save contacts
// router.post('/savecontacts', async (req, res) => {
//     const { userId, contacts } = req.body;
//     if (!Array.isArray(contacts) || contacts.length === 0) {
//         return res.status(400).json({ message: 'Contacts array is empty or invalid!' });
//     }
//     try {
//         const user = await User.findById(userId);
//         if (!user) {
//             return res.status(404).json({ message: 'User not found!' });
//         }
//         const savedContacts = [];
//         for (const contact of contacts) {
//             if (!validatePhoneNumber(contact.phone)) {
//                 return res.status(400).json({ message: `Invalid phone number format: ${contact.phone}` });
//             }
//             const newContact = new Contact({ userId, name: contact.name, phone: contact.phone });
//             await newContact.save();
//             savedContacts.push(newContact);
//         }
//         res.status(201).json({ message: 'Contacts saved successfully!', savedContacts });
//     } catch (error) {
//         console.error('Error saving contacts:', error.message);
//         res.status(500).json({ message: 'Error saving contacts!', error: error.message });
//     }
// });

// // Send SOS
// router.post('/sendsos', async (req, res) => {
//     const { userId, latitude, longitude } = req.body;
//     if (!latitude || !longitude) {
//         return res.status(400).json({ message: 'Location required!' });
//     }
//     try {
//         const contacts = await Contact.find({ userId });
//         if (contacts.length === 0) {
//             return res.status(404).json({ message: 'No contacts found!' });
//         }
//         const locationLink = `https://maps.google.com/?q=${latitude},${longitude}`;
//         const messageBody = `SOS! Location: ${locationLink}. Help!`;
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
//                 messages.push({ phone: contact.phone, status: 'Failed', error: error.message });
//             }
//         }
//         res.status(200).json({ message: 'SOS processed!', details: messages });
//     } catch (error) {
//         res.status(500).json({ message: 'Error sending SOS!', error: error.message });
//     }
// });

// // Get contacts
// router.get('/getcontacts', async (req, res) => {
//     try {
//         const userId = req.headers['userid'];
//         if (!userId) {
//             return res.status(400).json({ message: 'userId header is required' });
//         }
//         const contacts = await Contact.find({ userId });
//         res.status(200).json({ contacts });
//     } catch (error) {
//         console.error('Error fetching contacts:', error.message);
//         res.status(500).json({ message: 'Error fetching contacts!', error: error.message });
//     }
// });

// // Add update and delete routes
// router.put('/updatecontact', async (req, res) => {
//     try {
//         const { userId, contactId, name, phone } = req.body;
//         const updatedContact = await Contact.findOneAndUpdate(
//             { _id: contactId, userId },
//             { name, phone: phone.startsWith('+91') ? phone : `+91${phone}` },
//             { new: true }
//         );
//         if (!updatedContact) {
//             return res.status(404).json({ message: 'Contact not found' });
//         }
//         res.status(200).json({ message: 'Contact updated successfully', contact: updatedContact });
//     } catch (error) {
//         res.status(500).json({ error: error.message });
//     }
// });

// router.delete('/deletecontact', async (req, res) => {
//     try {
//         const { userId, contactId } = req.body;
//         const deletedContact = await Contact.findOneAndDelete({ _id: contactId, userId });
//         if (!deletedContact) {
//             return res.status(404).json({ message: 'Contact not found' });
//         }
//         res.status(200).json({ message: 'Contact deleted successfully' });
//     } catch (error) {
//         res.status(500).json({ error: error.message });
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
    const { userId, contacts } = req.body; // contacts: [{ name, phone }]

    if (!Array.isArray(contacts) || contacts.length === 0) {
        return res.status(400).json({ message: 'Contacts array is empty or invalid!' });
    }

    try {
        // Check if user exists
        const user = await User.findById(userId);
        if (!user) {
            return res.status(404).json({ message: 'User not found!' });
        }

        const savedContacts = [];
        for (const contact of contacts) {
            let existingContact = await Contact.findOne({ phone: contact.phone });

            if (existingContact) {
                // If contact exists, add the userId to userIds array if not already present
                if (!existingContact.userIds.includes(userId)) {
                    existingContact.userIds.push(userId);
                    await existingContact.save();
                }
            } else {
                // If contact doesn't exist, create a new one
                existingContact = new Contact({ userIds: [userId], name: contact.name, phone: contact.phone });
                await existingContact.save();
            }

            savedContacts.push(existingContact);
        }

        res.status(201).json({ message: 'Contacts saved successfully!', savedContacts });
    } catch (error) {
        console.error('Error saving contacts:', error.message);
        res.status(500).json({ message: 'Error saving contacts!', error: error.message });
    }
});

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
//                 return res.status(400).json({ message: Invalid phone number format: ${contact.phone} });
//             }

//             const newContact = new Contact({ userId, name: contact.name, phone: contact.phone });
//             try {
//                 await newContact.save();
//                 savedContacts.push(newContact);
//             } catch (error) {
//                 if (error.code === 11000) {
//                     return res.status(400).json({ message: Phone number already exists: ${contact.phone} });
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

// Send SOS to all contacts
router.post('/sendsos', async (req, res) => {
    const { userId, latitude, longitude } = req.body;

    if (!latitude || !longitude) {
        return res.status(400).json({ message: 'Location (latitude and longitude) is required!' });
    }

    try {
        // Find all contacts linked to the userId
        const contacts = await Contact.find({ userIds: userId });

        if (contacts.length === 0) {
            return res.status(404).json({ message: 'No contacts found for the user!' });
        }

        const locationLink = 'https://maps.google.com/?q=${latitude},${longitude}';
        const messageBody = 'SOS! The person is at location: ${locationLink}. Please help!';

        const messages = [];
        for (const contact of contacts) {
            try {
                const message = await client.messages.create({
                    body: messageBody,
                    from: process.env.TWILIO_PHONE_NUMBER,
                    to: contact.phone,
                });
                messages.push({ phone: contact.phone, status: 'Sent', sid: message.sid });
            } catch (error) {
                messages.push({ phone: contact.phone, status: 'Failed', error: error.message });
            }
        }

        res.status(200).json({ message: 'SOS messages processed!', details: messages });
    } catch (error) {
        console.error('Error sending SOS messages:', error.message);
        res.status(500).json({ message: 'Error sending SOS messages!', error: error.message });
    }
});

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
//         const locationLink = https://maps.google.com/?q=${latitude},${longitude};
//         const messageBody = SOS! The person is at location: ${locationLink}. Please help!;

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
//                 console.error(Failed to send message to ${contact.phone}:, error.message);
//                 messages.push({ phone: contact.phone, status: 'Failed', error: error.message });
//             }
//         }

//         res.status(200).json({ message: 'SOS messages processed!', details: messages });
//     } catch (error) {
//         console.error('Error sending SOS messages:', error.message);
//         res.status(500).json({ message: 'Error sending SOS messages!', error: error.message });
//     }
// });

// Delete contact for a user
router.delete('/deletecontact', async (req, res) => {
    const { userId, phone } = req.body;

    if (!userId || !phone) {
        return res.status(400).json({ message: 'User ID and phone number are required!' });
    }

    try {
        // Check if user exists
        const user = await User.findById(userId);
        if (!user) {
            return res.status(404).json({ message: 'User not found!' });
        }

        // Delete the contact with the given phone number for the user
        const deletedContact = await Contact.findOneAndDelete({ userId, phone });
        if (!deletedContact) {
            return res.status(404).json({ message: 'Contact not found!' });
        }

        res.status(200).json({ message: 'Contact deleted successfully!', deletedContact });
    } catch (error) {
        console.error('Error deleting contact:', error.message);
        res.status(500).json({ message: 'Error deleting contact!', error: error.message });
    }
});

// Show multiple contacts for a particular user
router.get('/getcontacts', async (req, res) => {
    const { userId } = req.body; // Get userId from the request body

    if (!userId) {
        return res.status(400).json({ message: 'User ID is required!' });
    }

    try {
        // Check if user exists
        const user = await User.findById(userId);
        if (!user) {
            return res.status(404).json({ message: 'User not found!' });
        }

        // Find all contacts for the user
        const contacts = await Contact.find({ userId });

        if (contacts.length === 0) {
            return res.status(404).json({ message: 'No contacts found for the user!' });
        }

        res.status(200).json({ message: 'Contacts retrieved successfully!', contacts });
    } catch (error) {
        console.error('Error retrieving contacts:', error.message);
        res.status(500).json({ message: 'Error retrieving contacts!', error: error.message });
    }
});



export default router;