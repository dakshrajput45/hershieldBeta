const express = require('express');
require("dotenv").config();
const app = express();
app.use(express.json());

const PORT = process.env.PORT || 3000;

const firebaseAdmin = require('./config/firebaseConnect'); 
const herShieldRoutes = require("./routes/hershieldRoutes");

app.use('/api/hershield',herShieldRoutes);

app.get("/",(req,res)=> {
    res.send("Jai Shree Ram");
})

app.listen(PORT,()=>{
    console.log("Hershield Backend is working");
    console.log("Backend is working on http://localhost:3000/");
})