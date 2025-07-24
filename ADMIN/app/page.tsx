"use client";

import { useState } from "react";
import Sidebar from "@/components/Sidebar";
import Buses from "@/components/Buses";
import Settings from "@/components/Settings";
import Header from "@/components/Header";
import Dashboard from "@/components/Dashboard";
import Bookings from "@/components/Bookings";
import BusRoutes from "@/components/BusRoutes";
import Analytics from "@/components/Analytics";
import UsersPage from "@/components/Users";
import ChatButton from "@/components/ChatButton";
import DriversPage from "@/components/Drivers";
import ToursPackagesPage from "@/components/ToursPackages";
import PaymentHistory from "@/components/PaymentHistory";
import BlogsHistory from "@/components/BlogsNews";
// import Analytics from "@/components/Analytics";

const DashboardPage = () => {
  const [activeTab, setActiveTab] = useState("dashboard");

  const renderContent = () => {
    switch (activeTab) {
      case "users":
        return <UsersPage />;
      case "dashboard":
        return < Dashboard />;
      case "drivers":
        return <DriversPage />;
      case "bookings":
        return <Bookings />;
      case "settings":
        return <Settings />;
      case "buses":
        return <Buses />;
      case "tours&packages":
        return <ToursPackagesPage />;
         case "payment-history":
        return <PaymentHistory />;
      case "blogs&news":
        return <BlogsHistory />;
      case "routes":
        return <BusRoutes />;
      case "analytics":
        return <Analytics />;
      default:
        return <Dashboard />;
    }
  };

  return (
    <>
      {/* Main Content Area */}
      <div className="min-h-screen bg-gray-100 flex overflow-auto">
        {/* Fixed Sidebar */}
        < Sidebar onSelect={setActiveTab} />

        <div className="flex-1 flex flex-col">
          {/* Header */}
          < Header />

          {/* Page Content */}
          <main className="flex-1 ml-60 mt-16 overflow-auto">
            <ChatButton />
            {renderContent()}
          </main>
        </div>
      </div>
    </>
  );
};

export default DashboardPage;
