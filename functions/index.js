const functions = require("firebase-functions/v1");
const admin = require("firebase-admin");
admin.initializeApp();

exports.sendNewPlaceNotification = functions.firestore
    .document('places/{docId}') 
    .onCreate(async (snap, context) => {
      
      const newData = snap.data();

      const namaTempat = newData.name || newData.nama || "Tempat Baru";
      const kategori = newData.category || newData.kategori || "Update"; 

      const judulKategori = kategori.charAt(0).toUpperCase() + kategori.slice(1);

      const payload = {
        notification: {
          title: `Ada ${judulKategori} Baru di Jokka!`,
          body: `Yuk cek ${namaTempat} sekarang.`,
        },
        topic: 'info_jokka'
      };

      return admin.messaging().send(payload)
        .then((response) => {
          console.log('Notifikasi sukses:', response);
        })
        .catch((error) => {
          console.log('Error kirim notif:', error);
        });
    });