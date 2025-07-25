"use client";
import React, { useState, useEffect } from "react";
import { db } from "@/components/db/firebase";
import { User, Phone, Calendar, DollarSign } from "lucide-react";
import { collection, getDocs } from "firebase/firestore";

const PaymentHistory = () => {
  const [activeTab, setActiveTab] = useState("night");

  const tabbs = ["night", "local"];
  const [paymetHistory, setPaymentHistory] = useState([]);

  // type StatCardProps = {
  //   title: string;
  //   value: string | number;
  //   change: number;
  //   icon: React.ComponentType<React.SVGProps<SVGSVGElement>>;
  //   color?: string;
  // };

  useEffect(() => {
    const fetchAllDriverPayments = async () => {
      try {
        const driverWithdrawRef = collection(
          db,
          "saralyatra",
          "paymentDetails",
          "userLocalPaymentHistory"
        );

        const driverDocsSnap = await getDocs(driverWithdrawRef);

        const allPayments = [];

        for (const driverDoc of driverDocsSnap.docs) {
          const driverID = driverDoc.id;

          const paymentsRef = collection(
            db,
            "saralyatra",
            "paymentDetails",
            "userLocalPaymentHistory",
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

        setPaymentHistory(allPayments); // or setDriverPayments if it's payment-specific
        console.log("Fetched all users local payments:", allPayments);
      } catch (err) {
        console.error("Error fetching nested driver payments:", err);
      }
    };

    fetchAllDriverPayments();
  }, []);

  const [nightPaymentHistory, setNightPaymentHistory] = useState([]);

  useEffect(() => {
    const fetchAllDriverPaymentss = async () => {
      try {
        const driverWithdrawRef = collection(
          db,
          "history",
          "upcomingHistoryDetails",
          "busSeat"
        );

        const driverDocsSnap = await getDocs(driverWithdrawRef);
        const datas = driverDocsSnap.docs.map((doc) => ({
          id: doc.id,
          ...doc.data(),
        }));

        setNightPaymentHistory(datas); // or setDriverPayments if it's payment-specific
        console.log("Fetched all users night payments:", datas);
      } catch (err) {
        console.error("Error fetching nested driver payments:", err);
      }
    };

    fetchAllDriverPaymentss();
  }, []);

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

  return (
    <main className="flex-1 overflow-y-auto p-6">
      <div className="p-6 bg-white rounded-lg shadow-sm">
        <h2 className="text-2xl font-semibold text-gray-800 mb-4">
          Payment History
        </h2>
        <p className="text-gray-600">Payment history of users.</p>
        {/* Payment history content goes here */}
      </div>
      {/* Tabs */}
      <div className="mb-6">
        <div className="border-b border-gray-200">
          <nav className="-mb-px flex space-x-8">
            {tabbs.map((tab) => (
              <button
                key={tab}
                onClick={() => setActiveTab(tab)}
                className={`py-2 px-1 border-b-2 font-medium text-sm capitalize ${
                  activeTab === tab
                    ? "border-blue-500 text-blue-600"
                    : "border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300"
                }`}
              >
                {tab}
              </button>
            ))}
          </nav>
        </div>
      </div>

      {activeTab === "night" && (
        <>
          <div className="p-6 bg-white rounded-lg shadow-sm">
            <h2 className="text-2xl font-semibold text-gray-800 mb-4">
              Night Bus
            </h2>

            {/* Payment history content goes here */}
            <div className="bg-white rounded-lg shadow-lg overflow-hidden">
              <div className="overflow-x-auto">
                <table className="min-w-full divide-y divide-gray-200">
                  <thead className="bg-gray-50">
                    <tr>
                      <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        User Info
                      </th>
                      <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        Phone Number
                      </th>
                      <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        Date
                      </th>
                      <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        TransactionID
                      </th>
                      <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        Seats
                      </th>

                      <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        Payment
                      </th>
                    </tr>
                  </thead>
                  <tbody className="bg-white divide-y divide-gray-200">
                    {nightPaymentHistory.map((driver) => (
                      <tr
                        key={driver.userID + driver.date}
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
                                ID: {driver.userID}
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
                              {driver.date}
                            </span>
                          </div>
                        </td>

                        {/* Total Balance */}
                        <td className="px-6 py-4 whitespace-nowrap">
                          <div className="flex items-center">
                            {/* <DollarSign className="w-4 h-4 text-green-500 mr-1" /> */}
                            <span className="text-sm font-semibold text-green-600">
                              NRs {driver.txnRefId}
                            </span>
                          </div>
                        </td>

                        <td className="px-6 py-4 whitespace-nowrap">
                          <div className="flex items-center gap-1 justify-between">
                            {/* <DollarSign className="w-4 h-4 text-green-500 mr-1" /> */}
                            {driver.selectedList.map((seat, index) => (
                              <span
                                key={index}
                                className="text-sm font-semibold text-green-600"
                              >
                                [{seat}]
                              </span>
                            ))}
                          </div>
                        </td>

                        {/* Withdraw Amount */}
                        <td className="px-6 py-4 whitespace-nowrap">
                          <div className="flex items-center">
                            {/* <DollarSign className="w-4 h-4 text-blue-500 mr-1" /> */}
                            <span className="text-sm font-semibold text-blue-600">
                              NRs {driver.price}
                            </span>
                          </div>
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>
          </div>
        </>
      )}

      {activeTab === "local" && (
        <>
          <div className="p-6 bg-white rounded-lg shadow-sm">
            <h2 className="text-2xl font-semibold text-gray-800 mb-4">
              Local Bus
            </h2>

            {/* Payment history content goes here */}
            <div className="bg-white rounded-lg shadow-lg overflow-hidden">
              <div className="overflow-x-auto">
                <table className="min-w-full divide-y divide-gray-200">
                  <thead className="bg-gray-50">
                    <tr>
                      <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        User Info
                      </th>
                      <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        Phone Number
                      </th>
                      <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        Date
                      </th>
                      <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        TransactionID
                      </th>

                      <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        Payment
                      </th>
                    </tr>
                  </thead>
                  <tbody className="bg-white divide-y divide-gray-200">
                    {paymetHistory.map((driver) => (
                      <tr
                        key={driver.userID + driver.date}
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
                                ID: {driver.userID}
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
                              {driver.date}
                            </span>
                          </div>
                        </td>

                        {/* Total Balance */}
                        <td className="px-6 py-4 whitespace-nowrap">
                          <div className="flex items-center">
                            {/* <DollarSign className="w-4 h-4 text-green-500 mr-1" /> */}
                            <span className="text-sm font-semibold text-green-600">
                              NRs {driver.txnRefId}
                            </span>
                          </div>
                        </td>

                        {/* Withdraw Amount */}
                        <td className="px-6 py-4 whitespace-nowrap">
                          <div className="flex items-center">
                            {/* <DollarSign className="w-4 h-4 text-blue-500 mr-1" /> */}
                            <span className="text-sm font-semibold text-blue-600">
                              NRs {driver.price}
                            </span>
                          </div>
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>
          </div>
        </>
      )}
    </main>
  );
};

export default PaymentHistory;
