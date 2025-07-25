"use client";
import React, { useState } from "react";
import { X, Plus, Clock, MapPin, Bus } from "lucide-react";

const AddBus = ({ onClose }) => {
  const [busData, setBusData] = useState({
    location: "",
    busName: "",
    price: "",
    shift: "Morning",
    busNumber: "",
    busType: "AC Deluxe",
    depTimeMin: "00",
    depTimeHr: "06",
    arrTimeMin: "00",
    arrTimeHr: "08",
    availableSeat: 29,
    reservedSeat: 1,
    date: '', // Default date
  });

  const [isSubmitting, setIsSubmitting] = useState(false);

  const busTypes = ["AC Deluxe", "AC Standard", "Non-AC", "Sleeper"];
  const shifts = ["Morning", "Afternoon", "Evening", "Night"];
  const busesRoutes = [
    "JKR-POK",
      "POK-JKR",
      "KTM-JKR",
      "JKR-KTM",
      "KTM-POK",
      "POK-KTM",
  ]
  
  // Generate time options
  const hours = Array.from({ length: 24 }, (_, i) => 
    i.toString().padStart(2, '0')
  );
  const minutes = ['00', '15', '30', '45'];

  const handleChange = (e) => {
    const { name, value, type } = e.target;
    setBusData(prev => ({
      ...prev,
      [name]: type === 'number' ? parseInt(value) || 0 : value
    }));
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setIsSubmitting(true);

    try {
      // Simulate API call
      console.log("Submitting bus data:", busData);
      
      // Here you would make your actual API call
      await fetch('/api/add-bus', { method: 'POST', body: JSON.stringify(busData) });
      
      // Simulate delay
      await new Promise(resolve => setTimeout(resolve, 1000));
      
      alert("Bus added successfully!");
      onClose();
    } catch (error) {
      console.error("Error adding bus:", error);
      alert("Error adding bus. Please try again.");
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <div className="fixed inset-0 bg-gray-900 bg-opacity-75 flex items-center justify-center z-50 p-4">
      <div className="bg-white rounded-xl shadow-2xl w-full max-w-5xl max-h-[95vh] overflow-y-auto">
        {/* Header */}
        <div className="bg-gradient-to-r from-blue-600 to-blue-700 text-white p-6 rounded-t-xl">
          <div className="flex items-center justify-between">
            <div className="flex items-center space-x-3">
              <div className="bg-white bg-opacity-20 rounded-lg p-2">
                <Bus size={24} />
              </div>
              <div>
                <h2 className="text-2xl font-bold">Add New Bus</h2>
                <p className="text-blue-100">Fill in the bus details below</p>
              </div>
            </div>
            <button
              onClick={onClose}
              className="bg-white bg-opacity-20 hover:bg-opacity-30 rounded-lg p-2 transition-all"
            >
              <X size={20} />
            </button>
          </div>
        </div>

        {/* Form */}
        <form onSubmit={handleSubmit} className="p-6 space-y-8">
          {/* Basic Information */}
          <div className="bg-gray-50 rounded-lg p-6">
            <h3 className="text-lg font-semibold text-gray-800 mb-4 flex items-center">
              <MapPin size={20} className="mr-2 text-blue-600" />
              Basic Information
            </h3>
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Location
                </label>
                <select
                  name="location"
                  value={busData.location}
                  onChange={handleChange}
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                >
                  {busesRoutes.map(type => (
                    <option key={type} value={type}>{type}</option>
                  ))}
                </select>
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Bus Name
                </label>
                <input
                  type="text"
                  name="busName"
                  value={busData.busName}
                  onChange={handleChange}
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  placeholder="Enter bus name"
                  required
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Bus Number
                </label>
                <input
                  type="text"
                  name="busNumber"
                  value={busData.busNumber}
                  onChange={handleChange}
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  placeholder="BA-1-CHA-1234"
                  required
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Bus Type
                </label>
                <select
                  name="busType"
                  value={busData.busType}
                  onChange={handleChange}
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                >
                  {busTypes.map(type => (
                    <option key={type} value={type}>{type}</option>
                  ))}
                </select>
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Shift
                </label>
                <select
                  name="shift"
                  value={busData.shift}
                  onChange={handleChange}
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                >
                  {shifts.map(shift => (
                    <option key={shift} value={shift}>{shift}</option>
                  ))}
                </select>
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Price (NRs)
                </label>
                <input
                  type="number"
                  name="price"
                  value={busData.price}
                  onChange={handleChange}
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  placeholder="500"
                  min="1"
                  required
                />
              </div>
            </div>
          </div>

          {/* Schedule */}
          <div className="bg-gray-50 rounded-lg p-6">
            <h3 className="text-lg font-semibold text-gray-800 mb-4 flex items-center">
              <Clock size={20} className="mr-2 text-blue-600" />
              Schedule
            </h3>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
              {/* Departure Time */}
              <div className="bg-white p-4 rounded-lg border">
                <h4 className="font-medium text-gray-700 mb-3">Departure Time</h4>
                <div className="flex space-x-2">
                  <div className="flex-1">
                    <label className="block text-xs font-medium text-gray-600 mb-1">Hour</label>
                    <select
                      name="depTimeHr"
                      value={busData.depTimeHr}
                      onChange={handleChange}
                      className="w-full px-3 py-2 border border-gray-300 rounded focus:ring-2 focus:ring-blue-500"
                    >
                      {hours.map(hour => (
                        <option key={hour} value={hour}>{hour}</option>
                      ))}
                    </select>
                  </div>
                  <div className="flex items-end pb-2">
                    <span className="text-xl font-bold text-gray-400">:</span>
                  </div>
                  <div className="flex-1">
                    <label className="block text-xs font-medium text-gray-600 mb-1">Minute</label>
                    <select
                      name="depTimeMin"
                      value={busData.depTimeMin}
                      onChange={handleChange}
                      className="w-full px-3 py-2 border border-gray-300 rounded focus:ring-2 focus:ring-blue-500"
                    >
                      {minutes.map(minute => (
                        <option key={minute} value={minute}>{minute}</option>
                      ))}
                    </select>
                  </div>
                </div>
              </div>

              {/* Arrival Time */}
              <div className="bg-white p-4 rounded-lg border">
                <h4 className="font-medium text-gray-700 mb-3">Arrival Time</h4>
                <div className="flex space-x-2">
                  <div className="flex-1">
                    <label className="block text-xs font-medium text-gray-600 mb-1">Hour</label>
                    <select
                      name="arrTimeHr"
                      value={busData.arrTimeHr}
                      onChange={handleChange}
                      className="w-full px-3 py-2 border border-gray-300 rounded focus:ring-2 focus:ring-blue-500"
                    >
                      {hours.map(hour => (
                        <option key={hour} value={hour}>{hour}</option>
                      ))}
                    </select>
                  </div>
                  <div className="flex items-end pb-2">
                    <span className="text-xl font-bold text-gray-400">:</span>
                  </div>
                  <div className="flex-1">
                    <label className="block text-xs font-medium text-gray-600 mb-1">Minute</label>
                    <select
                      name="arrTimeMin"
                      value={busData.arrTimeMin}
                      onChange={handleChange}
                      className="w-full px-3 py-2 border border-gray-300 rounded focus:ring-2 focus:ring-blue-500"
                    >
                      {minutes.map(minute => (
                        <option key={minute} value={minute}>{minute}</option>
                      ))}
                    </select>
                  </div>
                </div>
              </div>
            </div>
            <div className="mt-4">
              <label className="block text-sm font-medium text-gray-700 mb-1">
                Date of Journey
              </label>
              <input
                type="date"
                name="date"
                value={busData.date}
                onChange={handleChange}
                className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                required
              />
              <p className="text-xs text-gray-500 mt-1">Select the date of the bus journey</p>
              </div>

          </div>

          {/* Seating */}
          <div className="bg-gray-50 rounded-lg p-6">
            <h3 className="text-lg font-semibold text-gray-800 mb-4 flex items-center">
              <Bus size={20} className="mr-2 text-blue-600" />
              Seating Configuration
            </h3>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div className="bg-white p-4 rounded-lg border">
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Available Seats
                </label>
                <input
                  type="number"
                  name="availableSeat"

                  value={busData.availableSeat}
                  onChange={handleChange}
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  min="1"
                  max="30"
                  required
                />
                <p className="text-xs text-gray-500 mt-1">Maximum 30 seats</p>
              </div>

              <div className="bg-white p-4 rounded-lg border">
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Reserved Seats
                </label>
                <input
                  type="number"
                  name="reservedSeat"
                  value={busData.reservedSeat}
                  onChange={handleChange}
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  min="0"
                />
                <p className="text-xs text-gray-500 mt-1">Pre-reserved seats</p>
              </div>
            </div>

            {/* Total Seats Display */}
            <div className="mt-4 p-3 bg-blue-50 rounded-lg">
              <div className="flex justify-between items-center">
                <span className="text-sm font-medium text-gray-700">Total Capacity:</span>
                <span className="text-lg font-bold text-blue-600">
                  {(busData.availableSeat || 0) + (busData.reservedSeat || 0)} seats
                </span>
              </div>
            </div>
          </div>

          {/* Action Buttons */}
          <div className="flex justify-end space-x-4 pt-6 border-t">
            <button
              type="button"
              onClick={onClose}
              className="px-6 py-2 text-gray-600 bg-gray-100 rounded-lg hover:bg-gray-200 transition-colors"
            >
              Cancel
            </button>
            <button
              type="submit"
              disabled={isSubmitting}
              className="px-6 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed transition-colors flex items-center space-x-2"
            >
              {isSubmitting ? (
                <>
                  <div className="animate-spin rounded-full h-4 w-4 border-b-2 border-white"></div>
                  <span>Adding...</span>
                </>
              ) : (
                <>
                  <Plus size={16} />
                  <span>Add Bus</span>
                </>
              )}
            </button>
          </div>
        </form>
      </div>
    </div>
  );
};

export default AddBus;