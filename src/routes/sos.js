
import express from 'express';
import twilio from 'twilio';
import dotenv from 'dotenv';
import Contact from '../models/contact.js';
import User from '../models/User.js';

dotenv.config();

const router = express.Router();

// Twilio setup
const accountSid = process.env.TWILIO_ACCOUNT_SID;
const authToken = process.env.TWILIO_AUTH_TOKEN;
const twilioPhoneNumber = process.env.TWILIO_PHONE_NUMBER;
if (!accountSid || !authToken || !twilioPhoneNumber) {
    console.error('Twilio credentials are not fully configured.');
}
const client = twilio(accountSid, authToken);

const validatePhoneNumber = (phone) => {
    const phoneRegex = /^\+91 \d{10}$/;
    return phoneRegex.test(phone);
};



router.post('/savecontacts', async (req, res) => {
    const { userId, contacts } = req.body;

    if (!Array.isArray(contacts) || contacts.length === 0) {
        return res.status(400).json({ message: 'Contacts array is empty or invalid!' });
    }

    try {
        const user = await User.findById(userId);
        if (!user) {
            return res.status(404).json({ message: 'User not found!' });
        }

        const savedContacts = [];
        for (const contact of contacts) {
            if (!validatePhoneNumber(contact.phone)) {
                return res.status(400).json({ message: `Invalid phone number format: ${contact.phone}` });
            }

            const newContact = new Contact({ userId, name: contact.name, phone: contact.phone });
            await newContact.save(); // Duplicate phone for same user will fail due to index
            savedContacts.push(newContact);
        }

        res.status(201).json({ message: 'Contacts saved successfully!', savedContacts });
    } catch (error) {
        console.error('Error saving contacts:', error.message);
        if (error.code === 11000) {
            return res.status(400).json({ message: 'Phone number already exists for this user!' });
        }
        res.status(500).json({ message: 'Error saving contacts!', error: error.message });
    }
});

// Send SOS
router.post('/sendsos', async (req, res) => {
    // const { userId, latitude, longitude } = req.body;
    const {
        userId,
        latitude,
        longitude,
        batteryLevel,
        chargingStatus,
        networkStatus,
        deviceModel,
        timestamp,
        ringerMode,
        SOSCode,
      } = req.body;
    if (!latitude || !longitude) {
        return res.status(400).json({ message: 'Location required!' });
    }
    try {
        const contacts = await Contact.find({ userId });
        if (contacts.length === 0) {
            return res.status(404).json({ message: 'No contacts found!' });
        }
        const locationLink = `https://maps.google.com/?q=${latitude},${longitude}`;
        // const messageBody = `EMERGENCY! SHIELD SISTER SOS TRIGGERED Location: https://maps.google.com/?q=19.57,79.18 Battery: ${batteryLevel} ${chargingStatus}: ${networkStatus} Device:${deviceModel} Time:${timestamp} Contact immediately.`;
        const messageBody = `EMERGENCY! SOS TRIGGERED\nLocation:${locationLink}\nSOSCode ${SOSCode}%\nTime: ${timestamp}\nCall now!`;

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
                messages.push({ phone: contact.phone, status: 'Failed', error: error.message });
            }
        }
        res.status(200).json({ message: 'SOS processed!', details: messages });
    } catch (error) {
        res.status(500).json({ message: 'Error sending SOS!', error: error.message });
    }
});

// Get contacts
router.get('/getcontacts', async (req, res) => {
    try {
        const userId = req.headers['userid'];
        if (!userId) {
            return res.status(400).json({ message: 'userId header is required' });
        }
        const contacts = await Contact.find({ userId });
        res.status(200).json({ contacts });
    } catch (error) {
        console.error('Error fetching contacts:', error.message);
        res.status(500).json({ message: 'Error fetching contacts!', error: error.message });
    }
});

// Add update and delete routes
router.post('/updatecontact', async (req, res) => {
    try {
        const { userId, contactId, name, phone } = req.body;
        const updatedContact = await Contact.findOneAndUpdate(
            { _id: contactId, userId },
            { name, phone: phone.startsWith('+91') ? phone : `+91${phone}` },
            { new: true }
        );
        if (!updatedContact) {
            return res.status(404).json({ message: 'Contact not found' });
        }
        res.status(200).json({ message: 'Contact updated successfully', contact: updatedContact });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

router.delete('/deletecontact', async (req, res) => {
    try {
        const { userId, contactId } = req.body;
        const deletedContact = await Contact.findOneAndDelete({ _id: contactId, userId });
        if (!deletedContact) {
            return res.status(404).json({ message: 'Contact not found' });
        }
        res.status(200).json({ message: 'Contact deleted successfully' });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

export default router;
