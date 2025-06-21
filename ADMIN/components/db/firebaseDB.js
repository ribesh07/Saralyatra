import { db } from "./firebase";
import { collection, addDoc, getDocs } from "firebase/firestore";
import { rtdb } from "./firebase";
import { ref, set, get } from "firebase/database";

//Write a function to add a user to Firestore
export async function addUserToFirestore(user) {
  try {
    const docRef = await addDoc(collection(db, "users"), user);
    console.log("User added with ID:", docRef.id);
  } catch (error) {
    console.error("Error adding user:", error);
  }
}

//Write a function to get users from Firestore
export async function getUsersFromFirestore() {
  try {
    const querySnapshot = await getDocs(collection(db, "users"));
    const users = querySnapshot.docs.map((doc) => ({
      id: doc.id,
      ...doc.data(),
    }));
    return users;
  } catch (error) {
    console.error("Error fetching users:", error);
    return [];
  }
}

//write for realtime database

export async function writeUserData(uid, user) {
  try {
    await set(ref(rtdb, `users/${uid}`), user);
    console.log("User data written");
  } catch (error) {
    console.error("Error writing user data:", error);
  }
}

//read from realtime database

export async function readUserData(uid) {
  try {
    const snapshot = await get(ref(rtdb, `users/${uid}`));
    if (snapshot.exists()) {
      return snapshot.val();
    } else {
      console.log("No data available");
      return null;
    }
  } catch (error) {
    console.error("Error reading user data:", error);
    return null;
  }
}
