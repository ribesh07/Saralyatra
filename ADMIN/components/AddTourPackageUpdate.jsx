"use client";
import React from "react";

export default function AddTourPackageUpdate({ onClose, item }) {
  console.log(item);
  return (
    <div className="fixed inset-0 bg-white/30 backdrop-blur-sm flex items-center justify-center z-50 p-4">
      <div className="bg-gray-100 rounded-lg max-w-md w-4xl max-h-[90vh] hide-scrollbar overflow-y-auto">
        <h1 className="text-3xl font-bold underline">
          Add Tour Package {item.id}
        </h1>
        <button onClick={onClose}>Close</button>
      </div>
    </div>
  );
}
