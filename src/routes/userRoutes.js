import express from 'express';
import AuthController from '../controllers/authController.js';
import authMiddleware from '../middleware/authMiddleware.js'; // Import middleware

const router = express.Router();

// user routes
router.post('/signup', AuthController.Register);
router.post('/login', AuthController.Login);
router.put('/update', authMiddleware, AuthController.updateProfile); // Update user profile
router.delete('/delete', authMiddleware, AuthController.deleteProfile); // Delete user profile


router.post('/send-otp', AuthController.sendResetOTP);
router.post('/verify-otp', AuthController.verifyResetOTP);
router.post('/reset-password', AuthController.resetPassword);

export default router;