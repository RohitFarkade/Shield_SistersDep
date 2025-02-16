const UserServices = require("../services/user.services");

exports.register = async (req, res, next) => {
    try {
        console.log("---req body---", req.body);
        const {email, password} = req.body;
        const duplicate = await UserServices.checkuser(email);
        if (duplicate) {
            throw new Error(`UserName ${email}, Already Registered`)
        }
        const response = await UserServices.registerUser(email, password);
        res.json({status:true , success:"User Registered Succesfully"});
        // res.json(status:true,success:"User Registered Succesfully");
    } catch (err) {
        console.log("--->error-->",err);
        throw err;
    }
}

exports.login = async (req, res, next) => {
    try {
        const {email, password} = req.body;
        const user = await UserServices.checkuser(email);
        if (!user) {
            throw new Error("User Not Found");
        }
        const isMatch = await user.comparePassword(password);
        if (!isMatch) {
            throw new Error("Wrong Password");
        }
        let tokenData = {_id: user._id,email: user.email};
        const token = await UserServices.generateAccessToken(tokenData,"secretKey","1h");
        res.status(200).json({status:true,token:token});
    } catch (error) {
        throw error;
    }
}