"use client";
import React, { useState } from "react";

export default function AddTourPackageForm({ onClose }) {
  return (
    <div className="fixed inset-0 bg-white/30 backdrop-blur-sm flex items-center justify-center z-50 p-4">
      <div className="bg-gray-100 rounded-lg max-w-md w-4xl max-h-[90vh] hide-scrollbar overflow-y-auto">
        <div className="relative max-w-md w-full">
          <h2 className="text-2xl font-semibold text-gray-800 mb-4">
            Add Tour Package
          </h2>
          <button
            onClick={onClose}
            className="bg-blue-500  text-white py-2 px-4 rounded  hover:border  hover:border-blue-500 hover:bg-white hover:text-blue-500 transition duration-300 "
          >
            Button
          </button>
        </div>
      </div>
      {/* Add tour package form goes here */}
    </div>
  );
}
