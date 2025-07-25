"use client";
import React, { use, useState , useEffect } from "react";
import { doc, setDoc , getDoc } from "firebase/firestore";
import { db } from "@/components/db/firebase"; // Adjust the import based on your project structure

const SeatSelection = ({ bus, onUpdateSeats, onClose }) => {
  const [seats, setSeats] = useState({});
  const [selectedSeats, setSelectedSeats] = useState([]);

  const toggleSeat = (seatId) => {
    const seatKey = `book${seatId}`;
    if (seats[seatKey]) return; // already booked

    if (selectedSeats.includes(seatId)) {
      setSelectedSeats((prev) => prev.filter((id) => id !== seatId));
    } else {
      setSelectedSeats((prev) => [...prev, seatId]);
    }
  };

  useEffect(() => {
    const fetchSeats = async () => {
    const busRef = doc(db,"saralyatra" ,"busTicketDetails", "buses" , bus.id); 
         const busSnap = await getDoc(busRef);

    if (busSnap.exists()) {
      const busData = busSnap.data();
      console.log("Fetched bus data:", busData);
      setSeats(busData); 
      // setSelectedSeats([]);
    } else {
      console.error("Bus document not found!");
    }

    }

    fetchSeats();
  }, []);
  const getSeatColor = (seatId) => {
    const seatKey = `book${seatId}`;
    const isBooked = seats[seatKey];
    const isSelected = selectedSeats.includes(seatId);

    if (isBooked) return "bg-gray-400";
    if (isSelected) return "bg-red-500";
    return "bg-white border-2 border-gray-300";
  };

  const getSeatIcon = (seatId) => {
    const seatKey = `book${seatId}`;
    const isBooked = seats[seatKey];
    const isSelected = selectedSeats.includes(seatId);

    const iconColor = isBooked
      ? "text-gray-800"
      : isSelected
      ? "text-white"
      : "text-gray-600";

    return (
      <svg className={`w-8 h-8 ${iconColor}`} fill="currentColor" viewBox="0 0 24 24">
        <path d="M7 13c1.66 0 3-1.34 3-3S8.66 7 7 7s-3 1.34-3 3 1.34 3 3 3zm12-6h-8v7H3V6H1v15h2v-3h18v3h2V10c0-2.21-1.79-4-4-4z" />
      </svg>
    );
  };

  const Seat = ({ id, label }) => (
    <div
      onClick={() => toggleSeat(id)}
      className={`w-16 h-16 rounded-xl flex flex-col items-center justify-center
        ${getSeatColor(id)}
        ${seats[`book${id}`] ? "cursor-not-allowed" : "cursor-pointer hover:opacity-80"}
        transition-all duration-200 shadow-sm`}
    >
      {getSeatIcon(id)}
      <span
        className={`text-xs font-medium mt-1 ${
          selectedSeats.includes(id) ? "text-white" : "text-gray-700"
        }`}
      >
        {label}
      </span>
    </div>
  );

  const handleBook = async () => {
    const updatedSeats = { ...seats };
    selectedSeats.forEach((seatId) => {
      updatedSeats[`book${seatId}`] = true;
    });

    const updatedBus = {
     updatedSeats
    };

    const busRef = doc(db, "saralyatra", "busTicketDetails","buses", bus.id);
    await setDoc(busRef, updatedSeats, { merge: true });

    const newSeatCount = bus.availableSeats - selectedSeats.length;
    onUpdateSeats(bus.id, newSeatCount);
    onClose();
  };

  const seatLayout = [
    ["L1", "L2", "R1", "R2"],
    ["L3", "L4", "R3", "R4"],
    ["L5", "L6", "R5", "R6"],
    ["L7", "L8", "R7", "R8"],
    ["L9", "L10", "R9", "R10"],
    ["L11", "L12", "R11", "R12"],
    ["L13", "L14", "C1", "R13", "R14"],
  ];

  return (
    <div className="fixed inset-0 bg-white/30 backdrop-blur-sm flex items-center justify-center z-50 p-4">
      <div className="bg-gray-100 rounded-lg max-w-md w-full max-h-[90vh] overflow-y-auto">
        {/* Header */}
        <div className="bg-blue-500 text-white p-4 flex items-center justify-between">
          <h1 className="text-xl font-semibold">Choose Seat</h1>
        </div>

        {/* Content */}
        <div className="p-4">
          {/* Legend */}
          <div className="flex justify-center items-center space-x-6 mb-6">
            <div className="flex items-center space-x-2">
              <div className="w-4 h-4 bg-white border-2 border-gray-300 rounded" />
              <span className="text-sm font-medium">Available</span>
            </div>
            <div className="flex items-center space-x-2">
              <div className="w-4 h-4 bg-gray-400 rounded" />
              <span className="text-sm font-medium">Booked</span>
            </div>
            <div className="flex items-center space-x-2">
              <div className="w-4 h-4 bg-red-500 rounded" />
              <span className="text-sm font-medium">Selected</span>
            </div>
          </div>

          {/* Seats */}
          <div className="space-y-4">
            {seatLayout.map((row, rowIndex) => (
              <div key={rowIndex} className="flex justify-center space-x-4">
                {row.map((seatId) => (
                  <Seat key={seatId} id={seatId} label={seatId} />
                ))}
              </div>
            ))}
          </div>

          {/* Selected Info */}
          {selectedSeats.length > 0 && (
            <div className="mt-8 p-4 bg-gray-50 rounded-2xl">
              <h3 className="font-semibold text-gray-800 mb-2">Selected Seats:</h3>
              <div className="flex flex-wrap gap-2">
                {selectedSeats.map((seatId) => (
                  <span
                    key={seatId}
                    className="bg-red-500 text-white px-3 py-1 rounded-full text-sm font-medium"
                  >
                    {seatId}
                  </span>
                ))}
              </div>
              <p className="text-sm text-gray-600 mt-2">
                Total seats: {selectedSeats.length}
              </p>
            </div>
          )}

          {/* Buttons */}
          <div className="mt-6 flex justify-between">
            <button
              onClick={onClose}
              className="mt-4 bg-gray-400 hover:bg-gray-500 text-white font-semibold py-2 px-4 rounded-full"
            >
              Close
            </button>
            <button
              onClick={handleBook}
              disabled={selectedSeats.length === 0}
              className="mt-4 bg-red-500 hover:bg-red-600 text-white font-semibold py-2 px-4 rounded-full disabled:opacity-50"
            >
              Book ({selectedSeats.length} seats)
            </button>
          </div>
        </div>
      </div>
    </div>
  );
};

export default SeatSelection;
