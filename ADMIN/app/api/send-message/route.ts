import { NextResponse } from "next/server";
import { db } from "@/components/db/firebase";
import { collection, addDoc, serverTimestamp } from "firebase/firestore";

export async function POST(req: any) {
  try {
    const body = await req.json();
    const { chatRoomId, messageInfoMap } = body;

    if (!chatRoomId || !messageInfoMap) {
      return NextResponse.json({ error: "Missing fields" }, { status: 400 });
    }

    // Override or add the timestamp from server
    messageInfoMap.time = serverTimestamp();

    const chatRef = collection(db, "chatrooms", chatRoomId, "chats");
    await addDoc(chatRef, messageInfoMap);

    return NextResponse.json({ success: true });
  } catch (error) {
    console.error("Error sending message:", error);
    return NextResponse.json({ error: "Server error" }, { status: 500 });
  }
}
