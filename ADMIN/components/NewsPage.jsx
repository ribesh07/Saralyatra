"use client";
import React, { useState, useEffect } from "react";
import { db } from "@/components/db/firebase";
import { collection, getDocs, doc, deleteDoc } from "firebase/firestore";
import { Plus, Loader2, Upload, Edit, Trash2 } from "lucide-react";
import AddNews from "./AddNews";
import AddNewsUpdate from "./AddNewsUpdate";

export default function NewsPage() {
  const [news, setnews] = useState([]);
  const [enabled, setenabled] = useState(false);

  const [Loading, setLoading] = useState(false);
  const fetchPackageDocs = async () => {
    try {
      const packageCollectionRef = collection(
        db,
        "uploads",
        "newsDetails",
        "news"
      );

      const querySnapshot = await getDocs(packageCollectionRef);

      const newsdata = querySnapshot.docs.map((docSnap) => ({
        id: docSnap.id,
        ...docSnap.data(),
      }));

      console.log("Fetched packages:", newsdata);
      return newsdata;
    } catch (error) {
      console.error("Error fetching package docs:", error);
      return [];
    }
  };

  useEffect(() => {
    fetchPackageDocs().then((newsdata) => {
      setnews(newsdata);
    });
  }, []);
  const [enabledupdate, setenabledupdate] = useState(false);
  const handleClose = () => {
    setenabled(false);
    setenabledupdate(false);
    fetchPackageDocs().then((newsdata) => {
      setnews(newsdata);
    });
  };

  const handleOpen = () => {
    setenabled(true);
  };

  const handleDelete = async (id) => {
    console.log("Attempting to delete document with ID:", id);
    setLoading(true);
    try {
      const docRef = doc(db, "uploads", "newsDetails", "news", id);
      await deleteDoc(docRef);
      console.log("Document deleted successfully!");
    } catch (error) {
      console.error("Error deleting document:", error);
    } finally {
      setLoading(false);
      fetchPackageDocs().then((blogsData) => {
        setnews(blogsData);
      });
    }
  };

  const [selectedItem, setSelectedItem] = useState(null);
  const handleUpdate = (id) => {
    setSelectedItem(id);
    setenabledupdate(true);
    // setenabled(true);/
    // alert(`Update functionality for item ID: ${id}`);
  };

  const handleAddNew = () => {
    setenabled(true);
  };

  if (Loading) {
    return (
      <div className="text-center justify-center self-center w-full h-full">
        <Loader2 className="animate-spin" />
      </div>
    );
  }
  return (
    <div>
      <div className="flex justify-start mb-6">
        <button
          onClick={handleAddNew}
          className="bg-blue-600 hover:bg-blue-700 text-white px-6 py-3 rounded-lg flex items-center gap-2 font-medium transition-colors"
        >
          <Plus size={20} />
          Add News
        </button>
      </div>
      {enabled && <AddNews onClose={handleClose} />}
      {enabledupdate && (
        <AddNewsUpdate onClose={handleClose} item={selectedItem} />
      )}
      <div className="bg-white rounded-lg shadow-sm overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full">
            <thead className="bg-gray-50 border-b border-gray-200">
              <tr>
                <th className="px-6 py-4 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Image
                </th>
                <th className="px-6 py-4 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Title
                </th>
                <th className="px-6 py-4 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Description
                </th>
                <th className="px-6 py-4 text-xs font-medium text-gray-500 uppercase tracking-wider text-center">
                  Actions
                </th>
              </tr>
            </thead>

            <tbody className="bg-white divide-y divide-gray-200">
              {news.map((item) => (
                <tr key={item.id} className="hover:bg-gray-50">
                  <td className="px-6 py-4 whitespace-nowrap">
                    <div className="flex items-center">
                      {item.imageUrl ? (
                        <img
                          src={item.imageUrl}
                          alt={item.title}
                          className="h-12 w-12 rounded-lg object-cover"
                        />
                      ) : (
                        <div className="h-12 w-12 bg-gray-200 rounded-lg flex items-center justify-center">
                          <Upload size={16} className="text-gray-400" />
                        </div>
                      )}
                    </div>
                  </td>
                  <td className="px-6 py-4">
                    <div className="text-sm font-medium text-gray-900">
                      {item.title}
                    </div>
                  </td>
                  <td className="px-6 py-4">
                    <div className="text-sm text-gray-500 max-w-xs truncate">
                      {item.description}
                    </div>
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap text-sm font-medium">
                    <div className="flex justify-center align-center items-center gap-2">
                      <button
                        onClick={() => handleUpdate(item)}
                        className="text-blue-600 hover:text-blue-700 p-1 rounded transition-colors"
                        title="Update"
                        type="button"
                      >
                        <Edit size={16} />
                      </button>
                      <button
                        onClick={() => handleDelete(item.id)}
                        className="text-red-600 hover:text-red-700 p-1 rounded transition-colors"
                        title="Delete"
                        type="button"
                      >
                        <Trash2 size={16} />
                      </button>
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}
