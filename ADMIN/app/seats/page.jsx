"use client"
import React, { useState } from 'react';
import { ArrowLeft } from 'lucide-react';

const SeatSelection = () => {
  // Initialize seat layout with status
  const [seats, setSeats] = useState({
    // Left side seats
    L1: 'booked', L2: 'booked', L3: 'booked', L4: 'booked',
    L5: 'booked', L6: 'booked', L7: 'available', L8: 'available',
    L9: 'available', L10: 'selected', L11: 'selected', L12: 'booked',
    L13: 'selected', L14: 'booked',
    
    // Right side seats
    R1: 'available', R2: 'booked', R3: 'booked', R4: 'booked',
    R5: 'booked', R6: 'booked', R7: 'available', R8: 'booked',
    R9: 'booked', R10: 'booked', R11: 'booked', R12: 'booked',
    R13: 'booked', R14: 'booked',
    
    // Center seat
    C1: 'booked'
  });

  const [selectedSeats, setSelectedSeats] = useState(['L10', 'L11', 'L13']);

  const toggleSeat = (seatId) => {
  if (seats[seatId] === 'booked') return;

  const newStatus = seats[seatId] === 'selected' ? 'available' : 'selected';
  const newSeats = { ...seats, [seatId]: newStatus };
  setSeats(newSeats);

  if (newStatus === 'selected') {
    setSelectedSeats(prev => [...prev, seatId]);
  } else {
    setSelectedSeats(prev => prev.filter(id => id !== seatId));
  }
};


  const getSeatColor = (status) => {
    switch (status) {
      case 'available':
        return 'bg-white border-2 border-gray-300';
      case 'booked':
        return 'bg-gray-400';
      case 'selected':
        return 'bg-red-500';
      default:
        return 'bg-white border-2 border-gray-300';
    }
  };

  const getSeatIcon = (status) => {
    const iconColor = status === 'available' ? 'text-gray-600' : 
                     status === 'selected' ? 'text-white' : 'text-gray-800';
    
    return (
      <svg 
        className={`w-8 h-8 ${iconColor}`} 
        fill="currentColor" 
        viewBox="0 0 24 24"
      >
        <path d="M7 13c1.66 0 3-1.34 3-3S8.66 7 7 7s-3 1.34-3 3 1.34 3 3 3zm12-6h-8v7H3V6H1v15h2v-3h18v3h2V10c0-2.21-1.79-4-4-4z"/>
      </svg>
    );
  };

  const Seat = ({ id, status, label }) => (
    <div
      onClick={() => toggleSeat(id)}
      className={`
        w-16 h-16 rounded-xl flex flex-col items-center justify-center
        ${getSeatColor(status)}
        ${status !== 'booked' ? 'cursor-pointer hover:opacity-80' : 'cursor-not-allowed'}
        transition-all duration-200 shadow-sm
      `}
    >
      {getSeatIcon(status)}
      <span className={`text-xs font-medium mt-1 ${
        status === 'selected' ? 'text-white' : 'text-gray-700'
      }`}>
        {label}
      </span>
    </div>
  );

  return (
    <div className="min-h-screen bg-gradient-to-b from-blue-400 to-blue-600">
      {/* Header */}
      <div className="bg-blue-500 text-white p-4 flex items-center">
        <ArrowLeft className="mr-4" size={24} />
        <h1 className="text-xl font-semibold">Choose Seat</h1>
      </div>

      {/* Main Content */}
      <div className="p-4">
        <div className="bg-white rounded-3xl p-6 mx-auto max-w-md">
          {/* Legend */}
          <div className="flex justify-center items-center space-x-6 mb-8">
            <div className="flex items-center space-x-2">
              <div className="w-4 h-4 bg-white border-2 border-gray-300 rounded"></div>
              <span className="text-sm font-medium">Available:</span>
            </div>
            <div className="flex items-center space-x-2">
              <div className="w-4 h-4 bg-gray-400 rounded"></div>
              <span className="text-sm font-medium">Booked:</span>
            </div>
            <div className="flex items-center space-x-2">
              <div className="w-4 h-4 bg-red-500 rounded"></div>
              <span className="text-sm font-medium">Selected:</span>
            </div>
          </div>

          {/* Seat Layout */}
          <div className="space-y-4">
            {/* Row 1 */}
            <div className="flex justify-between items-center">
              <div className="flex space-x-4">
                <Seat id="L1" status={seats.L1} label="L1" />
                <Seat id="L2" status={seats.L2} label="L2" />
              </div>
              <div className="flex space-x-4">
                <Seat id="R1" status={seats.R1} label="R1" />
                <Seat id="R2" status={seats.R2} label="R2" />
              </div>
            </div>

            {/* Row 2 */}
            <div className="flex justify-between items-center">
              <div className="flex space-x-4">
                <Seat id="L3" status={seats.L3} label="L3" />
                <Seat id="L4" status={seats.L4} label="L4" />
              </div>
              <div className="flex space-x-4">
                <Seat id="R3" status={seats.R3} label="R3" />
                <Seat id="R4" status={seats.R4} label="R4" />
              </div>
            </div>

            {/* Row 3 */}
            <div className="flex justify-between items-center">
              <div className="flex space-x-4">
                <Seat id="L5" status={seats.L5} label="L5" />
                <Seat id="L6" status={seats.L6} label="L6" />
              </div>
              <div className="flex space-x-4">
                <Seat id="R5" status={seats.R5} label="R5" />
                <Seat id="R6" status={seats.R6} label="R6" />
              </div>
            </div>

            {/* Row 4 */}
            <div className="flex justify-between items-center">
              <div className="flex space-x-4">
                <Seat id="L7" status={seats.L7} label="L7" />
                <Seat id="L8" status={seats.L8} label="L8" />
              </div>
              <div className="flex space-x-4">
                <Seat id="R7" status={seats.R7} label="R7" />
                <Seat id="R8" status={seats.R8} label="R8" />
              </div>
            </div>

            {/* Row 5 */}
            <div className="flex justify-between items-center">
              <div className="flex space-x-4">
                <Seat id="L9" status={seats.L9} label="L9" />
                <Seat id="L10" status={seats.L10} label="L10" />
              </div>
              <div className="flex space-x-4">
                <Seat id="R9" status={seats.R9} label="R9" />
                <Seat id="R10" status={seats.R10} label="R10" />
              </div>
            </div>

            {/* Row 6 */}
            <div className="flex justify-between items-center">
              <div className="flex space-x-4">
                <Seat id="L11" status={seats.L11} label="L11" />
                <Seat id="L12" status={seats.L12} label="L12" />
              </div>
              <div className="flex space-x-4">
                <Seat id="R11" status={seats.R11} label="R11" />
                <Seat id="R12" status={seats.R12} label="R12" />
              </div>
            </div>

            {/* Row 7 - Bottom row with center seat */}
            <div className="flex justify-center items-center space-x-4">
              <Seat id="L13" status={seats.L13} label="L13" />
              <Seat id="L14" status={seats.L14} label="L14" />
              <Seat id="C1" status={seats.C1} label="C1" />
              <Seat id="R13" status={seats.R13} label="R13" />
              <Seat id="R14" status={seats.R14} label="R14" />
            </div>
          </div>

          {/* Selected Seats Info */}
          {selectedSeats.length > 0 && (
            <div className="mt-8 p-4 bg-gray-50 rounded-2xl">
              <h3 className="font-semibold text-gray-800 mb-2">Selected Seats:</h3>
              <div className="flex flex-wrap gap-2">
                {selectedSeats.map(seatId => (
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

          {/* Book Button */}
          <button 
            className={`
              w-full mt-8 py-4 px-6 rounded-2xl font-semibold text-lg
              ${selectedSeats.length > 0 
                ? 'bg-blue-500 text-white hover:bg-blue-600' 
                : 'bg-gray-300 text-gray-500 cursor-not-allowed'
              }
              transition-colors duration-200
            `}
            disabled={selectedSeats.length === 0}
          >
            Book {selectedSeats.length > 0 ? `(${selectedSeats.length} seats)` : ''}
          </button>
        </div>
      </div>
    </div>
  );
};

export default SeatSelection;