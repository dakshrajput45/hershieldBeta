const { db } = require("../config/firebaseConnect");
const haversine = require("haversine-distance");
const geofire = require("geofire-common");
const collection = "userDetails";
const radiusInMeters = Number(process.env.radiusInMeters)
exports.findNearByUser = async(req,res)=> {
    try{
        const {uid} = req.query;

        if (!uid) {
            return res.status(400).json({ success: false, 
                                        message: "User ID is required" });
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
        const center = [latitude, longitude];
        //geo fire
        const bounds = geofire.geohashQueryBounds(center, radiusInMeters);

        console.log(`📌 Geohash Bounds:`, bounds);

        let nearbyUsers = [];

        const promises = bounds.map(([start, end]) => {
            return db.collection(collection)
                .where("location.geohash", ">=", start)
                .where("location.geohash", "<=", end)
                .get();
        });

        const snapshots = await Promise.all(promises);

        snapshots.forEach(snapshot=> {
            snapshot.docs.forEach(doc=>{
                const user = doc.data();
            
                if(user.id !== uid) {
                    const userLat = user.location.coordinates.latitude;
                    const userLong = user.location.coordinates.longitude;

                    const distance = haversine({ latitude, longitude }, { latitude: userLat, longitude: userLong });

                    if (distance <= radiusInMeters) {
                        nearbyUsers.push({
                            uid: user.uid,
                            name: `${user.firstName} ${user.lastName}` || "Unknown",
                            fcmToken: user.fcmToken || "",
                            distance: distance.toFixed(2),
                            latitude: userLat,
                            longitude: userLong,
                        });
                    }
                }
            })
        })
        
        console.log(`✅ Found ${nearbyUsers.length} nearby users`);
        return res.status(200).json({ success: true, nearbyUsers });
    } catch (error) {
        console.error("Error updating location:", error.message);
        return res.status(500).json({ success: false, error: error.message, message: "Location update failed" });
    }
};