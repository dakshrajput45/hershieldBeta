const express = require("express");
const router = express.Router();

const { updateLocation } = require("../controllers/updateLocationController");
const { findNearByUser } = require("../controllers/findNearByUserController");

router.post("/update-location",updateLocation);
router.get("/find-nearby-users",findNearByUser);
module.exports = router;