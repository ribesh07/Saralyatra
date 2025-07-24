"use client";
import React, { useState } from "react";
import { Edit, Save, X, Trash2 } from "lucide-react";
import SeatSelection from "@/app/seats/page";

const BusDashboard = () => {
  const initialBuses = [
    {
      id: "BUS001",
      name: "City Express",
      routes: "Downtown - Airport - Mall",
      type: "AC Deluxe",
      availableSeats: 45,
    },
    {
      id: "BUS002",
      name: "Metro Liner",
      routes: "Central Station - University - Hospital",
      type: "Non-AC",
      availableSeats: 32,
    },
    {
      id: "BUS003",
      name: "Rapid Transit",
      routes: "North Zone - South Zone - East Plaza",
      type: "AC Standard",
      availableSeats: 28,
    },
    {
      id: "BUS004",
      name: "Highway Cruiser",
      routes: "City Center - Suburb A - Suburb B",
      type: "AC Deluxe",
      availableSeats: 52,
    },
    {
      id: "BUS005",
      name: "Local Shuttle",
      routes: "Market Square - Residential Area - School",
      type: "Non-AC",
      availableSeats: 15,
    },
  ];

  const [buses, setBuses] = useState(initialBuses);
  const [editingId, setEditingId] = useState(null);
  const [editForm, setEditForm] = useState({});
  const [seatsenabled, setseatsenabled] = useState(false);

  const busTypes = ["AC Deluxe", "AC Standard", "Non-AC", "Sleeper"];

  const [selectedBus, setSelectedBus] = useState(null);

  const handleOpenSeats = (bus) => {
    setSelectedBus(bus);
    setseatsenabled(true);
  };

  const handleCloseSeats = () => {
    setseatsenabled(false);
    setSelectedBus(null);
  };

  const handleUpdateSeats = (busId, newAvailableSeats) => {
    setBuses((prevBuses) =>
      prevBuses.map((bus) =>
        bus.id === busId ? { ...bus, availableSeats: newAvailableSeats } : bus
      )
    );
  };

  const handleEdit = (bus) => {
    setEditingId(bus.id);
    setEditForm({ ...bus });
  };

  const handleSave = () => {
    setBuses(buses.map((bus) => (bus.id === editingId ? editForm : bus)));
    setEditingId(null);
    setEditForm({});
  };

  const handleCancel = () => {
    setEditingId(null);
    setEditForm({});
  };

  const handleDelete = (busId) => {
    if (window.confirm("Are you sure you want to delete this bus?")) {
      setBuses(buses.filter((bus) => bus.id !== busId));
    }
  };

  const getSeatStatus = (seats) => {
    if (seats > 40) return "text-green-600 bg-green-50";
    if (seats > 20) return "text-yellow-600 bg-yellow-50";
    return "text-red-600 bg-red-50";
  };

  return (
    <div className="p-6 max-w-7xl mx-auto bg-gray-50 min-h-screen">
      <div className="bg-white rounded-lg shadow-sm">
        <div className="px-6 py-4 border-b border-gray-200 px">
          <h1 className="text-2xl font-bold text-gray-900 ">Routes</h1>
        </div>

        <div className="overflow-x-auto">
          <table className="w-full">
            <thead className="bg-gray-50">
              <tr>
                <th className="px-6 py-3 text-centre text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Bus ID
                </th>
                <th className="px-6 py-3 text-centre text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Bus Name
                </th>
                <th className="px-6 py-3 text-centre text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Routes
                </th>
                <th className="px-6 py-3 text-centre text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Bus Type
                </th>
                <th className="px-6 py-3 text-centre text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Available Seats
                </th>
                <th className="px-6 py-3 text-centre text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Actions
                </th>
              </tr>
            </thead>
            <tbody className="bg-white divide-y divide-gray-200">
              {buses.map((bus) => (
                <tr key={bus.id} className="hover:bg-gray-50 transition-colors">
                  <td className="px-6 py-4 whitespace-nowrap">
                    {editingId === bus.id ? (
                      <input
                        type="text"
                        value={editForm.id}
                        onChange={(e) =>
                          setEditForm({ ...editForm, id: e.target.value })
                        }
                        className="w-full px-2 py-1 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500"
                      />
                    ) : (
                      <span className="font-mono text-sm font-semibold text-gray-900">
                        {bus.id}
                      </span>
                    )}
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap">
                    {editingId === bus.id ? (
                      <input
                        type="text"
                        value={editForm.name}
                        onChange={(e) =>
                          setEditForm({ ...editForm, name: e.target.value })
                        }
                        className="w-full px-2 py-1 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500"
                      />
                    ) : (
                      <span className="text-sm font-medium text-gray-900">
                        {bus.name}
                      </span>
                    )}
                  </td>
                  <td className="px-6 py-4">
                    {editingId === bus.id ? (
                      <input
                        type="text"
                        value={editForm.routes}
                        onChange={(e) =>
                          setEditForm({ ...editForm, routes: e.target.value })
                        }
                        className="w-full px-2 py-1 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500"
                      />
                    ) : (
                      <span className="text-sm text-gray-600">
                        {bus.routes}
                      </span>
                    )}
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap">
                    {editingId === bus.id ? (
                      <select
                        value={editForm.type}
                        onChange={(e) =>
                          setEditForm({ ...editForm, type: e.target.value })
                        }
                        className="w-full px-2 py-1 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500"
                      >
                        {busTypes.map((type) => (
                          <option key={type} value={type}>
                            {type}
                          </option>
                        ))}
                      </select>
                    ) : (
                      <span className="inline-flex px-2 py-1 text-xs font-semibold rounded-full bg-blue-100 text-blue-800">
                        {bus.type}
                      </span>
                    )}
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap">
                    {editingId === bus.id ? (
                      <button
                        onClick={() => handleOpenSeats(bus)}
                        className="text-blue-600 bg-gray-100 p-1 m-1 hover:bg-gray-200 border border-gray-300 rounded semibold  hover:text-blue-900 flex items-center justify-center align-center gap-1 transition-colors" // Add this line to style the button className="w-20 px-2 py-1 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500"
                      >
                        Seats : {bus.availableSeats}
                      </button>
                    ) : (
                      <span
                        className={`inline-flex px-2 py-1 text-xs font-semibold rounded-full ${getSeatStatus(
                          bus.availableSeats
                        )}`}
                      >
                        {bus.availableSeats} seats
                      </span>
                    )}
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap text-sm font-medium">
                    {editingId === bus.id ? (
                      <div className="flex space-x-2">
                        <button
                          onClick={handleSave}
                          className="text-green-600 hover:text-green-900 flex items-center gap-1 transition-colors"
                        >
                          <Save size={16} />
                          Save
                        </button>
                        <button
                          onClick={handleCancel}
                          className="text-gray-600 hover:text-gray-900 flex items-center gap-1 transition-colors"
                        >
                          <X size={16} />
                          Cancel
                        </button>
                      </div>
                    ) : (
                      <div className="flex space-x-2">
                        <button
                          onClick={() => handleEdit(bus)}
                          className="text-blue-600 hover:text-blue-900 flex items-center gap-1 transition-colors"
                        >
                          <Edit size={16} />
                          Update
                        </button>
                        <button
                          onClick={() => handleDelete(bus.id)}
                          className="text-red-600 hover:text-red-900 flex items-center gap-1 transition-colors"
                        >
                          <Trash2 size={16} />
                          Delete
                        </button>
                      </div>
                    )}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>

        {buses.length === 0 && (
          <div className="text-center py-12">
            <p className="text-gray-500 text-lg">
              No buses found. Add a new bus to get started.
            </p>
          </div>
        )}

        <div className="px-6 py-4 bg-gray-50 border-t border-gray-200">
          <div className="flex justify-between items-center text-sm text-gray-600">
            <span>Total Buses: {buses.length}</span>
          </div>
        </div>
      </div>

      {seatsenabled && selectedBus && (
        <SeatSelection
          bus={selectedBus}
          onClose={handleCloseSeats}
          onUpdateSeats={handleUpdateSeats}
        />
      )}
    </div>
  );
};

export default BusDashboard;
