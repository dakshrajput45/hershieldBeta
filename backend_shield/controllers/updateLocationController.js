const { db } = require("../config/firebaseConnect");
const haversine = require("haversine-distance");
const admin = require("firebase-admin"); 
require("dotenv").config();
const collection = "userDetails";


exports.updateLocation = async (req, res) => {
    try {
        const { lat, long, uid } = req.body;
        console.log(`lat:-${lat}`);
        console.log(`long:-${long}`);
        console.log(`uid:-${uid}`);

        // Reference to the user document
        const userRef = db.collection(collection).doc(uid);
        const userDoc = await userRef.get();

        // Check if user exists
        if (!userDoc.exists) {
            return res.status(404).json({
                success: false,
                message: "User not found",
            });
        }
        console.log(userDoc.data());

        //const oldLoc = userDoc.data().location.coordinates;
        const radius = process.env.geoFenceRadius;

        const userLoc = { latitude: 40.748817, longitude: -73.985428 };
        const oldLoc = { latitude: 34.052235, longitude: -118.243683 };
        const distance = haversine(oldLoc, userLoc);    //geo fence check
        console.log(`distance :- ${distance}`);
        if (distance > radius) {
            // Update user location
            await userRef.update({
                'location.coordinates.latitude': lat,  // Update the latitude in the coordinates field
                'location.coordinates.longitude': long, // Update the longitude in the coordinates field
                'location.updatedAt': admin.firestore.FieldValue.serverTimestamp()  // Update the timestamp with the server time
            });

            return res.status(200).json({
                success: true,
                message: "Location updated successfully",
            });
        }
        return res.status(201).json({
            success: true,
            message: "Fence is not passed",
        });

    } catch (e) {
        console.log(e.message);
        return res.status(500).json({
            success: false,
            error: e,
            message: 'User can not be registered'
        });
    }
}
