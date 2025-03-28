const express = require("express");
const router = express.Router();

const { updateLocation } = require("../controllers/updateLocationController");
const { findNearByUser } = require("../controllers/findNearByUserController");
const { findNearBySafePlacesController } = require("../controllers/findNearBySafePlacesController");

router.post("/update-location",updateLocation);
router.get("/find-nearby-users",findNearByUser);
router.get("/find-nearby-safe-places",findNearBySafePlacesController);
module.exports = router;