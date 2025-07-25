import React, { useState, useEffect } from "react";
import {
  User,
  Phone,
  Calendar,
  DollarSign,
  Check,
  X,
  Search,
} from "lucide-react";
import { db } from "@/components/db/firebase";
import { collection, getDocs, doc, updateDoc } from "firebase/firestore";

// interface Driver {
//   userName: string;
//   userId: string;
//   contact: string;
//   balance: number;
//   type: string;
//   date: string;
// }

// interface ProcessingState {
//   [key: string]: boolean;
// }

const DriverPaymentTable = () => {
  const [drivers, setdrivers] = useState([]);

  const [processingState, setProcessingState] = useState({});
  const [searchTerm, setSearchTerm] = useState("");

  const [withdrawData, setWithdrawData] = useState({});
  const [errors, setErrors] = useState({});
  const currentDate = new Date().toLocaleDateString("en-US", {
    year: "numeric",
    month: "short",
    day: "numeric",
  });

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
          // id: docSnap.id,
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

  const filteredDrivers = drivers.filter(
    (driver) =>
      (driver.username?.toLowerCase() || "").includes(
        searchTerm.toLowerCase()
      ) ||
      (driver.email?.toLowerCase() || "").includes(searchTerm.toLowerCase()) ||
      (driver.contact?.toLowerCase() || "").includes(searchTerm.toLowerCase())
  );

  const handleWithdrawChange = (driverID, value) => {
    if (value === "" || /^\d*\.?\d*$/.test(value)) {
      setWithdrawData((prev) => ({ ...prev, [driverID]: value }));
      setErrors((prev) => ({ ...prev, [driverID]: "" }));
    }
  };

  const validateWithdraw = (driverID, totalBalance) => {
    const amount = parseFloat(withdrawData[driverID] || "");

    if (!withdrawData[driverID] || isNaN(amount) || amount <= 0) {
      setErrors((prev) => ({
        ...prev,
        [driverID]: "Please enter a valid amount",
      }));
      return false;
    }

    if (amount > totalBalance) {
      setErrors((prev) => ({ ...prev, [driverID]: "Amount exceeds balance" }));
      return false;
    }

    return true;
  };

  const handleConfirm = async (driver) => {
    if (!validateWithdraw(driver.driverID, driver.totalBalance)) return;

    setProcessingState((prev) => ({ ...prev, [driver.driverID]: true }));

    // Simulate API call
    setTimeout(() => {
      alert(
        `Payment of ${parseFloat(
          withdrawData[driver.driverID]
        )} confirmed for ${driver.driverName}`
      );
      setProcessingState((prev) => ({ ...prev, [driver.driverID]: false }));
      setWithdrawData((prev) => ({ ...prev, [driver.driverID]: "" }));
    }, 1500);
  };

  const handleCancel = (driverID) => {
    setWithdrawData((prev) => ({ ...prev, [driverID]: "" }));
    setErrors((prev) => ({ ...prev, [driverID]: "" }));
  };

  return (
    <div className="min-h-screen bg-gray-50 p-4">
      <div className="max-w-7xl mx-auto">
        {/* Header */}
        <div className="mb-8">
          <h1 className="text-3xl font-bold text-gray-900 mb-2">
            Driver Payment Management
          </h1>
          <p className="text-gray-600">Process payments for multiple drivers</p>

          {/* Search Bar */}
          <div className="mt-6 relative max-w-md">
            <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
              <Search className="h-5 w-5 text-gray-400" />
            </div>
            <input
              type="text"
              placeholder="Search by name, ID, or phone..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              className="block w-full pl-10 pr-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            />
          </div>
        </div>

        {/* Table */}
        <div className="bg-white rounded-lg shadow-lg overflow-hidden">
          <div className="overflow-x-auto">
            <table className="min-w-full divide-y divide-gray-200">
              <thead className="bg-gray-50">
                <tr>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Driver Info
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Phone Number
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Date
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Bus Number
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Withdraw Amount
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Actions
                  </th>
                </tr>
              </thead>
              <tbody className="bg-white divide-y divide-gray-200">
                {filteredDrivers.map((driver) => (
                  <tr key={driver.driverID} className="hover:bg-gray-50">
                    {/* Driver Info */}
                    <td className="px-6 py-4 whitespace-nowrap">
                      <div className="flex items-center">
                        <div className="w-10 h-10 bg-blue-100 rounded-full flex items-center justify-center">
                          <User className="w-5 h-5 text-blue-600" />
                        </div>
                        <div className="ml-4">
                          <div className="text-sm font-medium text-gray-900">
                            {driver.username}
                          </div>
                          <div className="text-sm text-gray-500">
                            ID: {driver.email}
                          </div>
                        </div>
                      </div>
                    </td>

                    {/* Phone Number */}
                    <td className="px-6 py-4 whitespace-nowrap">
                      <div className="flex items-center">
                        <Phone className="w-4 h-4 text-gray-400 mr-2" />
                        <span className="text-sm text-gray-900">
                          {driver.contact}
                        </span>
                      </div>
                    </td>

                    {/* Date */}
                    <td className="px-6 py-4 whitespace-nowrap">
                      <div className="flex items-center">
                        <Calendar className="w-4 h-4 text-gray-400 mr-2" />
                        <span className="text-sm text-gray-900">
                          {currentDate}
                        </span>
                      </div>
                    </td>

                    {/* Total Balance */}
                    <td className="px-6 py-4 whitespace-nowrap">
                      <div className="flex items-center">
                        {/* <DollarSign className="w-4 h-4 text-green-500 mr-1" /> */}
                        <span className="text-sm font-semibold text-green-600">
                          NRs {driver.busNumber}
                        </span>
                      </div>
                    </td>

                    {/* Withdraw Amount */}
                    <td className="px-6 py-4 whitespace-nowrap">
                      <div className="flex items-center">
                        {/* <DollarSign className="w-4 h-4 text-blue-500 mr-1" /> */}
                        <span className="text-sm font-semibold text-blue-600">
                          NRs {driver.balance}
                        </span>
                      </div>
                    </td>

                    {/* Actions */}
                    <td className="px-6 py-4 whitespace-nowrap">
                      <div className="flex space-x-2">
                        <button
                          onClick={() => handleConfirm(driver)}
                          disabled={processingState[driver.driverID]}
                          className="inline-flex items-center px-3 py-1 border border-transparent text-xs font-medium rounded text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 disabled:bg-blue-300 disabled:cursor-not-allowed"
                        >
                          {processingState[driver.driverID] ? (
                            <>
                              <div className="w-3 h-3 border border-white border-t-transparent rounded-full animate-spin mr-1"></div>
                              Processing
                            </>
                          ) : (
                            <>
                              <Check className="w-3 h-3 mr-1" />
                              Confirm
                            </>
                          )}
                        </button>

                        <button
                          onClick={() => handleCancel(driver.driverID)}
                          className="inline-flex items-center text-xs font-medium text-red-600 hover:text-red-800 focus:outline-none"
                        >
                          <X className="w-3 h-3 mr-1" />
                          Cancel
                        </button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>

          {filteredDrivers.length === 0 && (
            <div className="text-center py-12">
              <div className="text-gray-500">
                <User className="w-12 h-12 mx-auto mb-4 opacity-50" />
                <p className="text-lg font-medium">No drivers found</p>
                <p className="text-sm">Try adjusting your search criteria</p>
              </div>
            </div>
          )}
        </div>

        {/* Summary */}
        <div className="mt-6 bg-white rounded-lg shadow p-6">
          <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
            <div className="text-center">
              <div className="text-2xl font-bold text-gray-900">
                {filteredDrivers.length}
              </div>
              <div className="text-sm text-gray-500">Total Drivers</div>
            </div>

            <div className="text-center">
              <div className="text-2xl font-bold text-blue-600">
                ${filteredDrivers.withdrawBalance}
              </div>
              <div className="text-sm text-gray-500">Total Withdrawals</div>
            </div>
            <div className="text-center">
              <div className="text-2xl font-bold text-purple-600">
                {
                  Object.keys(processingState).filter(
                    (key) => processingState[key]
                  ).length
                }
              </div>
              <div className="text-sm text-gray-500">Processing</div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default DriverPaymentTable;
