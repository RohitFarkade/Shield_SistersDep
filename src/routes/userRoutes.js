
// export default router;
import express from 'express';
import AuthController from '../controllers/authController.js';
import authMiddleware from '../middleware/authMiddleware.js'; 

const router = express.Router();

// user routes
router.post('/signup', AuthController.Register);
router.post('/login', AuthController.Login);
router.put('/update', AuthController.updateProfile); // Update user profile
router.post('/delete', AuthController.deleteProfile); // Delete user profile
router.post('/send-registration-otp', AuthController.sendRegistrationOTP);
router.post('/verify-registration-otp', AuthController.verifyRegistrationOTP);

router.post('/send-otp', AuthController.sendResetOTP);
router.post('/verify-otp', AuthController.verifyResetOTP);
router.post('/reset-password', AuthController.resetPassword);
router.get('/api/sos/getcontacts', AuthController.getContacts);
// router.get('/getcontacts', AuthController.getContacts);
// router.put('/updatecontact', AuthController.updateContact);
// router.delete('/deletecontact', AuthController.deleteContact);

export default router;