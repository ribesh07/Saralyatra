"use client";
import React, { useState } from "react";
import {
  X,
  Plus,
  Clock,
  MapPin,
  Bus,
  User,
  Phone,
  DollarSign,
  Mail,
  BusFront,
} from "lucide-react";

import { db } from "@/components/db/firebase";
import { doc, updateDoc } from "firebase/firestore";

const UpdateModelDriver = ({ handleClose, initialData = {} }) => {
  const [formData, setFormData] = useState({
    username: initialData.username || "",
    contact: initialData.contact || "",
    busNumber: initialData.busNumber || "",
    balance: initialData.balance || "",
  });

  const [errors, setErrors] = useState({});
  const [isSubmitting, setIsSubmitting] = useState(false);

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData((prev) => ({
      ...prev,
      [name]: value,
    }));

    // Clear error when user starts typing
    if (errors[name]) {
      setErrors((prev) => ({
        ...prev,
        [name]: "",
      }));
    }
  };

  const validateForm = () => {
    const newErrors = {};

    if (!formData.username.trim()) {
      newErrors.username = "Username is required";
    }

    if (!formData.contact.trim()) {
      newErrors.contact = "Contact is required";
    } else if (!/^\d{7,15}$/.test(formData.contact)) {
      newErrors.contact = "Please enter a valid phone number";
    }

    if (!formData.busNumber.trim()) {
      newErrors.busNumber = "Bus number is required";
    } else if (!/^[A-Z]{2}-\d{2}-[A-Z]{2}-\d{4}$/.test(formData.busNumber)) {
      newErrors.busNumber =
        "Please enter a valid bus number (e.g., BA-12-PA-5024)";
    }

    if (!formData.balance.trim()) {
      newErrors.balance = "Balance is required";
    } else if (isNaN(formData.balance) || parseFloat(formData.balance) < 0) {
      newErrors.balance = "Please enter a valid balance amount";
    }

    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    console.log(formData);

    if (!validateForm()) {
      return;
    }

    setIsSubmitting(true);

    try {
      const userDocRef = doc(
        db,
        "saralyatra",
        "driverDetailsDatabase",
        "drivers",
        initialData.id
      );

      await updateDoc(userDocRef, formData);

      console.log(`✅ User ${initialData.id} updated with:`, formData);
      alert("User updated successfully!");

      // Simulate API call
      await new Promise((resolve) => setTimeout(resolve, 1000));

      // Here you would typically make an API call to update user details
      console.log("Updating user details:", formData);

      // Close modal on success
      handleClose();
    } catch (error) {
      console.error("Error updating user details:", error);
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <div className="fixed inset-0 bg-black/50 backdrop-blur-sm flex items-center justify-center z-50 p-4">
      <div className="bg-white rounded-lg max-w-md w-full max-h-[90vh] overflow-y-auto shadow-xl">
        <div className="p-6">
          {/* Header */}
          <div className="flex items-center justify-between mb-6">
            <h2 className="text-2xl font-semibold text-gray-800 flex items-center gap-2">
              <User className="w-6 h-6 text-blue-500" />
              Update User Details
            </h2>
            <button
              onClick={handleClose}
              className="p-2 hover:bg-gray-100 rounded-full transition-colors"
            >
              <X className="w-5 h-5 text-gray-500" />
            </button>
          </div>

          {/* Form */}
          <div className="space-y-4">
            {/* Username Field */}
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                <User className="w-4 h-4 inline mr-2" />
                Username
              </label>
              <input
                type="text"
                name="username"
                value={formData.username}
                onChange={handleChange}
                className={`w-full px-3 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 ${
                  errors.username ? "border-red-500" : "border-gray-300"
                }`}
                placeholder="Enter username"
              />
              {errors.username && (
                <p className="text-red-500 text-sm mt-1">{errors.username}</p>
              )}
            </div>

            {/* Contact Field */}
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                <Mail className="w-4 h-4 inline mr-2" />
                Contact Phone
              </label>
              <input
                type="phone"
                name="contact"
                value={formData.contact}
                onChange={handleChange}
                className={`w-full px-3 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 ${
                  errors.contact ? "border-red-500" : "border-gray-300"
                }`}
                placeholder="Enter email address"
              />
              {errors.contact && (
                <p className="text-red-500 text-sm mt-1">{errors.contact}</p>
              )}
            </div>

            {/* Phone Field */}
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                <BusFront className="w-4 h-4 inline mr-2" />
                Bus Number
              </label>
              <input
                type="text"
                name="busNumber"
                value={formData.busNumber}
                onChange={handleChange}
                className={`w-full px-3 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 ${
                  errors.phone ? "border-red-500" : "border-gray-300"
                }`}
                placeholder="Enter Bus number"
              />
              {errors.busNumber && (
                <p className="text-red-500 text-sm mt-1">{errors.phone}</p>
              )}
            </div>

            {/* Balance Field */}
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                {/* <DollarSign className="w-4 h-4 inline mr-2" /> */}
                Balance
              </label>
              <input
                type="number"
                name="balance"
                value={formData.balance}
                onChange={handleChange}
                step="0.01"
                min="0"
                className={`w-full px-3 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 ${
                  errors.balance ? "border-red-500" : "border-gray-300"
                }`}
                placeholder="Enter balance amount"
              />
              {errors.balance && (
                <p className="text-red-500 text-sm mt-1">{errors.balance}</p>
              )}
            </div>

            {/* Action Buttons */}
            <div className="flex gap-3 pt-4">
              <button
                type="button"
                onClick={handleClose}
                className="flex-1 px-4 py-2 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors"
              >
                Cancel
              </button>
              <button
                type="submit"
                disabled={isSubmitting}
                onClick={handleSubmit}
                className="flex-1 px-4 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600 disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
              >
                {isSubmitting ? "Updating..." : "Update Details"}
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default UpdateModelDriver;
