const mongoose = require("mongoose");
const connection = mongoose.createConnection("mongodb+srv://farkaderohit2003:sC6GmCbDqN6XGp6D@cluster0.dqyil.mongodb.net/testdatabase?retryWrites=true&w=majority&appName=Cluster0").on("connected", () => {
    console.log("MongoDB connected successfully");
}).on("error", (error) => {
    console.log("MongoDB connection failed: ", error);
});
module.exports = connection;