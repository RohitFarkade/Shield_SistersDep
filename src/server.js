// import express from 'express';
// import mongoose from 'mongoose';
// import cors from 'cors';
// import dotenv from 'dotenv';
// import userRoutes from './routes/userRoutes.js';
//  import sosRoutes from './routes/sos.js';
// dotenv.config();

// // Initialize the app
// const app = express();

// // Middleware
// app.use(cors());
// app.use(express.json()); // Parse incoming JSON requests

// // Connect to MongoDB
// const connectDB = async () => {
//     try {
//         await mongoose.connect(process.env.MONGO_URI, {
//             //useNewUrlParser: true,
//             //useUnifiedTopology: true,
//         });
//         console.log('MongoDB connected');
//     } catch (err) {
//         console.error('MongoDB connection error:', err);
//         process.exit(1);
//     }
// };

// connectDB();

// // Routes
// app.use('/api/users', userRoutes);
// app.use('/api/sos', sosRoutes);

// // Error handling middleware
// app.use((err, req, res, next) => {
//     console.error(err.stack);
//     res.status(500).json({ message: 'Internal Server Error' });
// });
// //added for testing
// app.get("/", (req, res) => {
//   res.send("Server is running on Vercel!");
// });

// module.exports = app;

// // Start the server
// const PORT = process.env.PORT || 5000;
// app.listen(PORT, () => {
//     console.log(`Server running on port ${PORT}`);
// });



import express from 'express';
import mongoose from 'mongoose';
import cors from 'cors';
import dotenv from 'dotenv';
import userRoutes from './routes/userRoutes.js';
import sosRoutes from './routes/sos.js';
dotenv.config();

const app = express();

app.use(cors());
app.use(express.json());

const connectDB = async () => {
    try {
        await mongoose.connect(process.env.MONGO_URI);
        console.log('MongoDB connected');
    } catch (err) {
        console.error('MongoDB connection error:', err);
        process.exit(1);
    }
};
connectDB();

app.use('/api/users', userRoutes);
app.use('/api/sos', sosRoutes);

app.use((err, req, res, next) => {
    console.error(err.stack);
    res.status(500).json({ message: 'Internal Server Error' });
});

app.get("/", (req, res) => {
    res.send("Server is running on Vercel!");
});

export default app; // Remove app.listen for Vercel