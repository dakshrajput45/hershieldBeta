
const { db } = require("../config/firebaseConnect");
const { findSafeLocations } = require("../utils/findSafeLocations");
const collection = "userDetails";


exports.findNearBySafePlacesController = async (req, res) => {
    try {
        const { uid } = req.query;
        console.log("uid:-", uid);

        if (!uid) {
            return res.status(400).json({
                success: false,
                message: "User ID is required"
            });
        }

        const userRef = db.collection(collection).doc(uid);
        const userDoc = await userRef.get();

        if (!userDoc.exists) {
            return res.status(404).json({ success: false, message: "User not found" });
        }

        const userData = userDoc.data();
        if (!userData.location || !userData.location.coordinates) {
            return res.status(400).json({ success: false, message: "User location not available" });
        }

        const { latitude, longitude } = userData.location.coordinates;

        const { locations, directionsUrl } = await findSafeLocations({
            lat: latitude.toString(),
            long: longitude.toString()
        });

        console.log("safe places", locations);

        return res.status(200).json({
            success: true,
            safePlaces: locations, 
            directionsUrl: directionsUrl, 
            message: `Nearest safe places near you`,
        },);

    } catch (error) {
        console.error("Error Finding near by safe places location:", error.message);
        return res.status(500).json({ success: false, error: error.message, message: "Finding near by safe places failed" });
    }
}