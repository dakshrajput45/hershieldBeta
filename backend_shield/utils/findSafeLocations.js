require("dotenv").config();
const axios = require("axios");
const haversine = require("haversine-distance");

async function findSafeLocations({ lat, long }) {
    try {
        const OVERPASS_API_URL = process.env.OVERPASS_API_URL;

        const searchRadius = {
            police: process.env.POLICE_RADIUS || 3000,
            hospital: process.env.HOSPITAL_RADIUS || 2000,
            fire_station: process.env.FIRE_STATION_RADIUS || 3000,
            cafe: process.env.CAFE_RADIUS || 1000,
            library: process.env.LIBRARY_RADIUS || 1500,
            station: process.env.TRANSPORT_RADIUS || 2500,
            women_shelter: process.env.WOMEN_SHELTER_RADIUS || 5000,
        };

        const query = `[out:json];(
            node["amenity"="police"](around:${searchRadius.police},${lat},${long});
            node["amenity"="hospital"](around:${searchRadius.hospital},${lat},${long});
            node["amenity"="fire_station"](around:${searchRadius.fire_station},${lat},${long});
            node["amenity"="cafe"](around:${searchRadius.cafe},${lat},${long});
            node["amenity"="library"](around:${searchRadius.library},${lat},${long});
            node["public_transport"="station"](around:${searchRadius.station},${lat},${long});
            node["social_facility"="women_shelter"](around:${searchRadius.women_shelter},${lat},${long});
        );out;`;

        const response = await axios.get(`${OVERPASS_API_URL}?data=${encodeURIComponent(query)}`);

        if (response.data && response.data.elements.length > 0) {
            let locations = response.data.elements.map((place) => {
                const userLocation = { latitude: parseFloat(lat), longitude: parseFloat(long) };
                const placeLocation = { latitude: place.lat, longitude: place.lon };
                const distance = haversine(userLocation, placeLocation) / 1000; // Convert to km

                return {
                    name: place.tags?.name || null, // Set `null` instead of "Unknown Place"
                    lat: place.lat,
                    lon: place.lon,
                    type: place.tags?.amenity || place.tags?.public_transport || place.tags?.social_facility || "unknown",
                    distance: parseFloat(distance.toFixed(2)),
                    maps_url: `https://www.google.com/maps/search/?api=1&query=${place.lat},${place.lon}`,
                };
            });

            // 📌 Filter out places with `null` name (i.e., "Unknown Place")
            locations = locations.filter(place => place.name !== null);

            // 📌 Sort by distance (nearest first)
            locations.sort((a, b) => a.distance - b.distance);

            // 📌 Get top 5 locations
            const topLocations = locations.slice(0, 4);

            // 📌 Construct Google Maps Directions URL
            let directionsUrl = `https://www.google.com/maps/dir/?api=1&origin=${lat},${long}`;

            if (topLocations.length > 0) {
                directionsUrl += `&destination=${topLocations[topLocations.length - 1].lat},${topLocations[topLocations.length - 1].lon}`;

                if (topLocations.length > 1) {
                    const waypoints = topLocations
                        .slice(0, topLocations.length - 1)
                        .map(place => `${place.lat},${place.lon}`)
                        .join('|');

                    directionsUrl += `&waypoints=${waypoints}`;
                }
            }

            return { locations: topLocations, directionsUrl };
        } else {
            return { locations: [], directionsUrl: null };
        }
    } catch (error) {
        console.error("Error fetching locations:", error);
        return { locations: [], directionsUrl: null };
    }
}

module.exports = { findSafeLocations };
