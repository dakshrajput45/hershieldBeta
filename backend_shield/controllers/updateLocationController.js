const { db } = require("../config/firebaseConnect");
const haversine = require("haversine-distance");
const geofire = require("geofire-common");  // Import geofire-common
const admin = require("firebase-admin");
require("dotenv").config();

const collection = "userDetails";
const radius = Number(process.env.geoFenceRadius); // Default 100 meters if not set

exports.updateLocation = async (req, res) => {
    try {
        const { lat, long, uid } = req.body;
        console.log(`lat: ${lat}, long: ${long}, uid: ${uid}`);

        const userRef = db.collection(collection).doc(uid);
        const userDoc = await userRef.get();

        if (!userDoc.exists) {
            return res.status(404).json({ success: false, message: "User not found" });
        }

        const userData = userDoc.data();
        let distance = 0;
        let firstTime = false;

        // Convert lat & long to numbers
        const newLat = Number(lat);
        const newLong = Number(long);
        const newGeohash = geofire.geohashForLocation([newLat, newLong]); // Generate geohash

        if (!userData.location || !userData.location.coordinates) {
            firstTime = true;
        } else {
            const oldLat = Number(userData.location.coordinates.latitude);
            const oldLong = Number(userData.location.coordinates.longitude);

            console.log(`New Location: ${JSON.stringify({ latitude: newLat, longitude: newLong })}`);
            console.log(`Old Location: ${JSON.stringify({ latitude: oldLat, longitude: oldLong })}`);

            distance = haversine({ latitude: newLat, longitude: newLong }, { latitude: oldLat, longitude: oldLong });
            console.log(`Calculated Distance: ${distance} meters`);
        }

        if (distance > radius || firstTime) {
            await userRef.update({
                'location.coordinates.latitude': newLat,  
                'location.coordinates.longitude': newLong, 
                'location.geohash': newGeohash,  // Store geohash
                'location.updatedAt': admin.firestore.FieldValue.serverTimestamp()
            });

            return res.status(200).json({ success: true, message: "Location updated successfully" });
        }

        return res.status(201).json({ success: true, message: "Fence is not passed" });

    } catch (error) {
        console.error("Error updating location:", error.message);
        return res.status(500).json({ success: false, error: error.message, message: "Location update failed" });
    }
};
