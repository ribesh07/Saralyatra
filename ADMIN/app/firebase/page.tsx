"use client";
import { useEffect } from "react";
import { addUserToFirestore, getUsersFromFirestore } from '../../components/db/firebaseDB';
import { writeUserData, readUserData } from "@/components/db/firebaseDB";

export default function FirebaseDemo() {
  useEffect(() => {
    addUserToFirestore({ name: "sma", age: 21 });

    getUsersFromFirestore().then(console.log);

    writeUserData("user_test", { name: "ribesh", age: 22 });

    readUserData("user_test").then(console.log);
  }, []);

  return <div>Firebase Functions Demo</div>;
}
