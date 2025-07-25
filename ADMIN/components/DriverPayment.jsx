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

  const fetchAllDriverPayments = async () => {
    try {
      const driverWithdrawRef = collection(
        db,
        "saralyatra",
        "paymentDetails",
        "driverWithdrawHistory"
      );

      const driverDocsSnap = await getDocs(driverWithdrawRef);

      const allPayments = [];

      for (const driverDoc of driverDocsSnap.docs) {
        const driverID = driverDoc.id;

        const paymentsRef = collection(
          db,
          "saralyatra",
          "paymentDetails",
          "driverWithdrawHistory",
          driverID,
          "payments" // the subcollection
        );

        const paymentsSnap = await getDocs(paymentsRef);

        paymentsSnap.forEach((paymentDoc) => {
          allPayments.push({
            driverID,
            paymentID: paymentDoc.id,
            ...paymentDoc.data(),
          });
        });
      }

      setdrivers(allPayments); // or setDriverPayments if it's payment-specific
      console.log("Fetched all driver payments:", allPayments);
    } catch (err) {
      console.error("Error fetching nested driver payments:", err);
    }
  };
  useEffect(() => {
    fetchAllDriverPayments();
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
    // if (!validateWithdraw(driver.driverID, driver.totalBalance)) return;
    try {
      const driverDocRef = doc(
        db,
        "saralyatra",
        "paymentDetails",
        "driverWithdrawHistory",
        driver.driverID,
        "payments",
        driver.paymentID
      );
      await updateDoc(driverDocRef, {
        status: "confirmed",
      });
      fetchAllDriverPayments();
    } catch (err) {
      console.log(err);
    }
    setProcessingState((prev) => ({ ...prev, [driver.driverID]: true }));
    console.log(driver.driverID);
    console.log(driver);
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

  const handleCancel = async (driver) => {
    console.log(driver);
    console.log("Inside handle cancel");
    const driverDocRef = doc(
      db,
      "saralyatra",
      "paymentDetails",
      "driverWithdrawHistory",
      driver.driverID,
      "payments",
      driver.paymentID
    );
    await updateDoc(driverDocRef, {
      status: "cancelled",
    });
    setWithdrawData((prev) => ({ ...prev, [driver.driverID]: "" }));
    setErrors((prev) => ({ ...prev, [driver.driverID]: "" }));
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
                    Withdraw Amount
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Actions
                  </th>
                </tr>
              </thead>
              <tbody className="bg-white divide-y divide-gray-200">
                {filteredDrivers.map((driver) => (
                  <tr
                    key={driver.driverID + driver.date}
                    className="hover:bg-gray-50"
                  >
                    {/* Driver Info */}
                    <td className="px-6 py-4 whitespace-nowrap">
                      <div className="flex items-center">
                        <div className="w-10 h-10 bg-blue-100 rounded-full flex items-center justify-center">
                          <User className="w-5 h-5 text-blue-600" />
                        </div>
                        <div className="ml-4">
                          <div className="text-sm font-medium text-gray-900">
                            {driver.userName}
                          </div>
                          <div className="text-sm text-gray-500">
                            ID: {driver.driverID}
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
                          {driver.date.toDate().toISOString().split("T")[0]}
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
                        {driver.status !== "confirmed" && (
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
                        )}
                        {driver.status === "confirmed" && (
                          <span className="text-xs font-medium text-green-600">
                            Confirmed
                          </span>
                        )}

                        {/* <button
                          onClick={() => handleCancel(driver)}
                          className="inline-flex items-center text-xs font-medium text-red-600 hover:text-red-800 focus:outline-none"
                        >
                          <X className="w-3 h-3 mr-1" />
                          Cancel
                        </button> */}
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
      </div>
    </div>
  );
};

export default DriverPaymentTable;
