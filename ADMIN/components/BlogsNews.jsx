import React, { useState, ChangeEvent, useEffect } from "react";
import { Plus, Edit, Trash2, Upload, Loader2 } from "lucide-react";
import { collection, doc, getDocs, deleteDoc } from "firebase/firestore";
import { db } from "@/components/db/firebase";

// interface TourPackage {
//   id: number;
//   title: string;
//   description: string;
//   image: string | null;
//   price: string;
//   duration: string;
// }

const BlogsNews = () => {
  const [blogs, setblogs] = useState([]);
  const [enabled, setenabled] = useState(false);

  const [Loading, setLoading] = useState(false);
  const fetchPackageDocs = async () => {
    try {
      const packageCollectionRef = collection(
        db,
        "uploads",
        "blogDetails",
        "blogs"
      );

      const querySnapshot = await getDocs(packageCollectionRef);

      const blogsData = querySnapshot.docs.map((docSnap) => ({
        id: docSnap.id,
        ...docSnap.data(),
      }));

      console.log("Fetched packages:", blogsData);
      return blogsData;
    } catch (error) {
      console.error("Error fetching package docs:", error);
      return [];
    }
  };

  useEffect(() => {
    fetchPackageDocs().then((blogsData) => {
      setblogs(blogsData);
    });
  }, []);
  const [enabledupdate, setenabledupdate] = useState(false);
  const handleClose = () => {
    setenabled(false);
    setenabledupdate(false);
    fetchPackageDocs().then((blogsData) => {
      setToursPackages(blogsData);
    });
  };

  const handleOpen = () => {
    setenabled(true);
  };

  const handleDelete = async (id) => {
    console.log("Attempting to delete document with ID:", id);
    setLoading(true);
    try {
      const docRef = doc(db, "uploads", "blogDetails", "blogs", id);
      await deleteDoc(docRef);
      console.log("Document deleted successfully!");
    } catch (error) {
      console.error("Error deleting document:", error);
    } finally {
      setLoading(false);
      fetchPackageDocs().then((blogsData) => {
        setToursPackages(blogsData);
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
    <div className="min-h-screen bg-gray-50 p-6">
      <div className="max-w-7xl mx-auto">
        <div className="bg-white rounded-lg shadow-sm p-6 mb-6">
          <h1 className="text-3xl font-bold text-gray-900 mb-2">
            News & Blogs Management
          </h1>
          <p className="text-gray-600">
            Manage your blogs and news efficiently
          </p>
        </div>

        <div className="flex justify-start mb-6">
          <button
            onClick={handleAddNew}
            className="bg-blue-600 hover:bg-blue-700 text-white px-6 py-3 rounded-lg flex items-center gap-2 font-medium transition-colors"
          >
            <Plus size={20} />
            Add Blogs
          </button>
        </div>
        {enabled && <AddBlogs onClose={handleClose} />}
        {enabledupdate && (
          <AddBlogsUpdate onClose={handleClose} item={selectedItem} />
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
                {blogs.map((item) => (
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
    </div>
  );
};

export default ToursPackagesPage;
