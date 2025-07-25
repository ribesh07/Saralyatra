"use client";
import React, { useEffect, useState } from "react";
import { Users, Search, Plus, Phone, Edit, Trash2 } from "lucide-react";
import { db } from "@/components/db/firebase";
import { collection, getDocs } from "firebase/firestore";

const DriversPage = () => {
  const [searchTerm, setSearchTerm] = useState("");
  const [filterStatus, setFilterStatus] = useState("all");
  const [showAddModal, setShowAddModal] = useState(false);

  const [name, setName] = useState("");
  const [email, setEmail] = useState("");
  const [phone, setPhone] = useState("");
  const [location, setLocation] = useState("");
  const [drivers, setdrivers] = useState([]);

  useEffect(() => {
    const fetchUsers = async () => {
      try {
        const routeCollectionRef = collection(
          db,
          "saralyatra",
          "driverDetailsDatabase",
          "drivers"
        );
        const querySnapshot = await getDocs(routeCollectionRef);

        const driverss = querySnapshot.docs.map((docSnap) => ({
          id: docSnap.id,
          ...docSnap.data(),
        }));
        setdrivers(driverss);
        console.log("Fetched drivers:", driverss);
      } catch (error) {
        console.error("Error fetching users:", error);
      }
    };

    fetchUsers(); // Don't forget to call it!
  }, []);

  const handleSubmit = async (e) => {
    e.preventDefault();

    const driver = { name, email, phone, location };

    if (!name || !email || !phone || !location) {
      alert("Please fill in all fields.");
      return;
    }

    console.log("Submitting driver:", driver);

    try {
      const res = await fetch("/api/users", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify(driver),
      });

      const result = await res.json();
      console.log("API Response:", result);

      const newdriver = {
        id: `C${(drivers.length + 1).toString().padStart(3, "0")}`,
        name,
        email,
        phone,
        location,
        joinDate: new Date().toISOString().slice(0, 10),
        totalBookings: 0,
        totalSpent: 0,
        status: "active",
        lastBooking: "Not booked yet",
        avatar: name
          .split(" ")
          .map((n) => n[0])
          .join("")
          .toUpperCase(),
      };

      setdrivers([...drivers, newdriver]);
      if (!res.ok) {
        throw new Error(result.message || "Failed to add driver");
      }
      // drivers = [driver, ...drivers];
      setName("");
      setEmail("");
      setPhone("");
      setLocation("");

      setShowAddModal(false);
    } catch (err) {
      console.error("Failed to add driver", err);
    }
  };
  // const drivers = []

  const filtereddrivers = drivers.filter((driver) => {
    const name = driver.name || "";
    const email = driver.email || "";

    const matchesSearch =
      name.toLowerCase().includes(searchTerm.toLowerCase()) ||
      email.toLowerCase().includes(searchTerm.toLowerCase());

    const matchesFilter =
      filterStatus === "all" || driver.status === filterStatus;

    return matchesSearch && matchesFilter;
  });

  //  type StatCardProps = {
  //     title: string;
  //     value: string | number;
  //     change: number;
  //     icon: React.ComponentType<React.SVGProps<SVGSVGElement>>;
  //     color?: string;
  //   };
  const StatCard = ({ title, value, change, icon: Icon, color = "blue" }) => (
    <div className="bg-white rounded-lg border border-gray-200 p-6">
      <div className="flex items-center justify-between">
        <div>
          <p className="text-sm text-gray-600">{title}</p>
          <p className="text-2xl font-bold text-gray-800 mt-1">{value}</p>
        </div>
        <div className={`p-3 rounded-lg bg-${color}-50`}>
          <Icon className={`h-6 w-6 text-${color}-600`} />
        </div>
      </div>
      <div className="mt-4 flex items-center">
        <span
          className={`text-sm ${
            change >= 0 ? "text-green-600" : "text-red-600"
          }`}
        >
          {change >= 0 ? "+" : ""}
          {change}%
        </span>
        <span className="text-sm text-gray-500 ml-2">vs last month</span>
      </div>
    </div>
  );

  // type driver = {
  //   id: string;
  //   name: string;
  //   email: string;
  //   phone: string;
  //   location: string;
  //   joinDate: string;
  //   totalBookings: number;
  //   totalSpent: number;
  //   status: string;
  //   lastBooking: string;
  //   avatar: string;
  // };

  const handleupdate = (c) => {
    alert(`Update functionality for item ID: ${c.id}`);
  };

  const handleDelete = (id) => {
    // alert(`Delete functionality for item ID: ${id}`);
  };

  const DriverRow = ({ driver }) => (
    <tr className="hover:bg-gray-50">
      <td className="px-6 py-4 whitespace-nowrap">
        <div className="flex items-center">
          <div className="ml-4">
            <div className="text-sm font-medium text-gray-900">
              {driver.username}
            </div>
          </div>
        </div>
      </td>
      <td className="px-6 py-4 whitespace-nowrap">
        <div className="flex items-center text-sm text-gray-900">
          <Phone className="h-4 w-4 mr-2 text-gray-400" />
          {driver.contact}
        </div>
      </td>
      <td className="px-6 py-4 whitespace-nowrap">
        <div className="flex items-center text-sm text-gray-900">
          {/* <MapPin className="h-4 w-4 mr-2 text-gray-400" /> */}
          {driver.email}
        </div>
      </td>
      <td className="px-6 py-4 whitespace-nowrap">
        <div className="flex items-center text-sm text-gray-900">
          {/* <MapPin className="h-4 w-4 mr-2 text-gray-400" /> */}
          {driver.busNumber}
        </div>
      </td>
      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
        {driver.balance}
      </td>
      {/* <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
        {driver.role}
      </td> */}

      <td className="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
        <div className="flex items-center space-x-2">
          <button
            onClick={() => handleupdate(driver)}
            className="text-gray-600 hover:text-gray-900"
            title="Edit"
          >
            <Edit className="h-4 w-4" />
          </button>
          <button
            onClick={() => handleDelete(driver.id)}
            className="text-red-600 hover:text-red-900"
            title="Delete"
          >
            <Trash2 className="h-4 w-4" />
          </button>
        </div>
      </td>
    </tr>
  );

  return (
    <main className="flex-1 overflow-y-auto p-6">
      {/* Stats Cards */}
      {/* <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
        <StatCard
          title="Total drivers"
          value="1,342"
          change={-2}
          icon={Users}
          color="blue"
        />
        <StatCard
          title="Active drivers"
          value="1,124"
          change={5}
          icon={Activity}
          color="green"
        />
        <StatCard
          title="New This Month"
          value="48"
          change={12}
          icon={TrendingUp}
          color="purple"
        />
        <StatCard
          title="Total driver Value"
          value="$284,750"
          change={8}
          icon={DollarSign}
          color="orange"
        />
      </div> */}

      {/* Filters and Search */}
      <div className="bg-white rounded-lg border border-gray-200 p-6 mb-6">
        <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between space-y-4 sm:space-y-0">
          <div className="flex items-center space-x-4">
            <div className="relative">
              <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 h-4 w-4" />
              <input
                type="text"
                placeholder="Search drivers..."
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                className="pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 w-64"
              />
            </div>

            {/* <label htmlFor="filterStatus" className="sr-only">
              Filter by status
            </label>
            <select
              id="filterStatus"
              aria-label="Filter by status"
              value={filterStatus}
              onChange={(e) => setFilterStatus(e.target.value)}
              className="px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
            >
              <option value="all">All Status</option>
              <option value="active">Active</option>
              <option value="inactive">Inactive</option>
            </select> */}
          </div>

          <button
            onClick={() => setShowAddModal(true)}
            className="flex items-center space-x-2 bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 transition-colors"
          >
            <Plus className="h-4 w-4" />
            <span>Add driver</span>
          </button>
        </div>
      </div>

      {/* drivers Table */}
      <div className="bg-white rounded-lg border border-gray-200 overflow-hidden">
        <div className="px-6 py-4 border-b border-gray-200">
          <h3 className="text-lg font-semibold text-gray-800">driver List</h3>
          <p className="text-sm text-gray-600 mt-1">
            Showing {filtereddrivers.length} of {drivers.length} drivers
          </p>
        </div>

        <div className="overflow-x-auto">
          <table className="min-w-full divide-y divide-gray-200">
            <thead className="bg-gray-50">
              <tr>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Driver
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Phone
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Email
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Bus No
                </th>
                {/* <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Location
                </th> */}

                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Total Balance
                </th>

                <th className="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Actions
                </th>
              </tr>
            </thead>
            <tbody className="bg-white divide-y divide-gray-200">
              {filtereddrivers.map((driver) => (
                <DriverRow key={driver.id} driver={driver} />
              ))}
            </tbody>
          </table>
        </div>

        {/* Pagination */}
        <div className="px-6 py-4 border-t border-gray-200 flex items-center justify-between">
          <div className="text-sm text-gray-500">
            Showing 1 to {filtereddrivers.length} of {drivers.length} results
          </div>
        </div>
      </div>

      {/* driver Details Modal */}
      {showAddModal && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
          <div className="bg-white rounded-lg p-6 w-full max-w-md">
            <div className="flex items-center justify-between mb-4">
              <h3 className="text-lg font-semibold text-gray-800">
                Add New Driver
              </h3>
              <button
                onClick={() => {
                  setShowAddModal(false);
                  console.log("Modal closed");
                }}
                className="text-gray-400 hover:text-gray-600"
              >
                ×
              </button>
            </div>

            <form className="space-y-4" onSubmit={handleSubmit}>
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Full Name
                </label>
                <input
                  type="text"
                  value={name}
                  onChange={(e) => setName(e.target.value)}
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                  placeholder="Enter driver name"
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Email Address
                </label>
                <input
                  type="email"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                  placeholder="Enter email address"
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Phone Number
                </label>
                <input
                  type="tel"
                  value={phone}
                  onChange={(e) => setPhone(e.target.value)}
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                  placeholder="Enter phone number"
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Location
                </label>
                <input
                  type="text"
                  value={location}
                  onChange={(e) => setLocation(e.target.value)}
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                  placeholder="Enter location"
                />
              </div>

              <div className="flex space-x-3 pt-4">
                <button
                  type="button"
                  onClick={() => setShowAddModal(false)}
                  className="flex-1 px-4 py-2 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50"
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  className="flex-1 px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700"
                >
                  Add Driver
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </main>
  );
};

export default DriversPage;
