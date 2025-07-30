
# 🚍 Saralyatra – Smart Bus Reservation & Local Transit System

**Saralyatra** is a smart mobile application that simplifies the public transport experience in Nepal by offering real-time seat booking, card-based payments, live bus tracking, and vehicle reservation. Designed for both night and local buses, the app integrates digital ticketing with smart card top-ups to reduce operational inefficiencies and improve rider safety and convenience.

---

## ✨ Features

- 🔎 **Search & Book Buses** — View real-time routes and book seats directly from your phone.
- 💳 **Smart Card Top-Up** — Recharge your transit card using online payments (eSewa/Khalti).
- 📍 **Live Tracking** — Know exactly where your bus is using GPS-based live location.
- 🚌 **Vehicle Reservation** — Reserve an entire vehicle for private/group travel.
- 📦 **Tour Package Booking** — Browse and book curated travel packages.
- 💬 **Real-Time Chat Support** — In-app support for users and drivers.
- 🧾 **Admin Dashboard** — Backend interface to manage routes, users, buses, and revenue.

---

## 🛠️ Tech Stack

- **Frontend**: Flutter (Dart)
- **Backend**: Node.js, NestJS (with WebSocket support for real-time features)
- **Database**: Firebase Firestore
- **Authentication & Storage**: Firebase Auth, Firebase Storage
- **Mapping**: Mapbox for route visualizations and live bus tracking
- **Hosting**: Render (Socket server + backend APIs)
- **Hardware (Optional)**: ESP32 + RFID RC522 for smart card reading on buses

---

## 💸 Services & Cost Overview

| Service     | Use                             | Est. Monthly Cost |
|-------------|----------------------------------|-------------------|
| Mapbox      | Bus tracking & route maps       | $10–50            |
| Render      | Hosting real-time socket server | ~$8 (Rs. 1,000)   |
| Firebase    | Firestore, Storage, Auth        | Rs. 1,500–3,000   |

---

## 📱 How It Works

1. Users can sign in, browse local or night buses, and book seats or packages.
2. Smart cards can be recharged in-app and used for local travel.
3. Drivers and admins get separate dashboards to track rides, revenue, and passenger data.
4. Chat functionality is available for real-time support between users and the system.

---

## 🚀 Future Enhancements

- Loyalty rewards and referral system  
- Multi-language support (Nepali, English)  
- Emergency alert feature during night travel  
- Dynamic pricing based on demand

---

## 🤝 Contributing

We're open to contributions! To get started:

1. Fork this repository  
2. Clone the repo: `git clone https://github.com/your-username/saralyatra.git`  
3. Follow the setup instructions in the README  
4. Submit a PR with detailed explanation

---

## 📄 License

This project is open-source and available under the [MIT License](LICENSE).
