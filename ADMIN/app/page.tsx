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
// import Analytics from "@/components/Analytics";

const DashboardPage = () => {
  const [activeTab, setActiveTab] = useState("dashboard");

  const renderContent = () => {
    switch (activeTab) {
      case "users":
        return <UsersPage />;
      case "dashboard":
        return < Dashboard />;
      case "bookings":
        return <Bookings />;
      case "settings":
        return <Settings />;
      case "buses":
        return <Buses />;
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
    <div className="min-h-screen bg-gray-100 flex">
      {/* Fixed Sidebar */}
      < Sidebar onSelect={setActiveTab}/>

      <div className="flex-1 flex flex-col">
        {/* Header */}
       < Header />
        
        {/* Page Content */}
        <main className="flex-1 p-6">
          
          {renderContent()}
        </main>
      </div>
    </div>
    </>
  );
};

export default DashboardPage;
