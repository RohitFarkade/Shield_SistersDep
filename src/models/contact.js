import mongoose from 'mongoose';

const contactSchema = new mongoose.Schema({
    userId: [{ type: mongoose.Schema.Types.ObjectId, ref: 'User' }],
    name: { type: String, required: true },
    phone: { type: String, required: true, unique: true },
});
contactSchema.index({ userId: 1, phone: 1 });
const Contact = mongoose.model('Contact', contactSchema);
export default Contact;
