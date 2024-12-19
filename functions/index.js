// Import necessary Firebase functions and admin SDK
const {onSchedule} = require("firebase-functions/v2/scheduler");
const {getFirestore} = require("firebase-admin/firestore");
const {initializeApp} = require("firebase-admin/app");

// Initialize Firebase Admin
initializeApp();
const db = getFirestore();

// Function to aggregate daily stats
exports.aggregateDailyStats = onSchedule("every 24 hours", async (event) => {
  const date = new Date();
  const formattedDate = `${date.getFullYear()}-${(date.getMonth() + 1)
      .toString()
      .padStart(2, "0")}-${date.getDate().toString().padStart(2, "0")}`;

  try {
    // Fetch all drivers
    const driversSnapshot = await db.collection("drivers").get();

    // Fetch all rides for the current day
    const ridesSnapshot = await db
        .collection("rides")
        .where("timestamp", ">=", new Date(formattedDate))
        .get();

    // Calculate stats
    const totalDrivers = driversSnapshot.size;
    const verifiedDrivers = driversSnapshot.docs.filter(
        (doc) => doc.data().status === "verified",
    ).length;
    const onlineDrivers = driversSnapshot.docs.filter(
        (doc) => doc.data().onlineStatus === "online",
    ).length;
    const totalRides = ridesSnapshot.size;
    const completedRides = ridesSnapshot.docs.filter(
        (doc) => doc.data().status === "completed",
    ).length;
    const cancelledRides = ridesSnapshot.docs.filter(
        (doc) => doc.data().status === "cancelled",
    ).length;

    // Save stats to Firestore
    await db.collection("stats").doc(formattedDate).set({
      date: formattedDate,
      totalDrivers,
      verifiedDrivers,
      onlineDrivers,
      totalRides,
      completedRides,
      cancelledRides,
      createdAt: new Date(),
    });

    console.log(`Daily stats for ${formattedDate} saved successfully.`);
  } catch (error) {
    console.error("Error aggregating daily stats: ", error);
  }
});
