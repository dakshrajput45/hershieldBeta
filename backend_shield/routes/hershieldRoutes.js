const express = require("express");
const router = express.Router();

const { updateLocation } = require("../controllers/updateLocationController");
router.put("/update-location",updateLocation);

module.exports = router;