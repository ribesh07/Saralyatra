"use client";
import React, { useState, useEffect, useRef } from "react";
import {
  Send,
  Users,
  MessageCircle,
  Trash2,
  Circle,
  Bus,
  ChevronDown,
} from "lucide-react";
import Link from "next/link";
import { db } from "@/components/db/firebase";
import {
  collection,
  getDocs,
  onSnapshot,
  addDoc,
  serverTimestamp,
  query,
  orderBy,
  deleteDoc,
  doc,
} from "firebase/firestore";
// import { time } from "console";

const AdminChat = () => {
  const admin = { id: 1, name: "Admin", role: "admin", avatar: "👨‍💼" };

  const [users, setUsers] = useState([]);
  const [loadingUsers, setLoadingUsers] = useState(true);
  const [conversations, setConversations] = useState({});
  const [selectedUser, setSelectedUser] = useState(null);
  const [newMessage, setNewMessage] = useState("");
  const [messagesLoading, setMessagesLoading] = useState(false);
  const messagesEndRef = useRef(null);

  // Fetch agents (users)
  useEffect(() => {
    const fetchAgents = async () => {
      setLoadingUsers(true);
      const chatroomsRef = collection(db, "chatrooms");
      const chatroomsSnap = await getDocs(chatroomsRef);
      const agents = chatroomsSnap.docs.map(docSnap => ({
        id: docSnap.id,
        name: docSnap.id, // Or use a field if you have one
        avatar: "👤",
        online: true, // You can add online status logic if you want
        unread: 0,
        lastMessageTime: 0,
      }));
      setUsers(agents);
      setLoadingUsers(false);
      if (agents.length > 0 && !selectedUser) setSelectedUser(agents[0]);
    };
    fetchAgents();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  // Fetch messages for selected user
  useEffect(() => {
    if (!selectedUser) return;
    setMessagesLoading(true);
    const messagesRef = collection(db, "chatrooms", selectedUser.id, "chats");
    const q = query(messagesRef, orderBy("time", "asc"));
    const unsubscribe = onSnapshot(q, (snapshot) => {
      const msgs = snapshot.docs.map(doc => ({
        id: doc.id,
        ...doc.data(),
      }));
      setConversations(prev => ({
        ...prev,
        [selectedUser.id]: msgs,
      }));
      setMessagesLoading(false);
    });
    return () => unsubscribe();
  }, [selectedUser]);

  // Scroll to bottom on new messages
  const scrollToBottom = () => {
    messagesEndRef.current?.scrollIntoView({ behavior: "smooth" });
  };
  useEffect(() => {
    scrollToBottom();
  }, [conversations, selectedUser]);

  // Send message to Firestore
  const sendMessage = async () => {
    if (!newMessage.trim() || !selectedUser) return;
    const messagesRef = collection(db, "chatrooms", selectedUser.id, "chats");
    await addDoc(messagesRef, {
      Data: 'Message',
      message: newMessage,
      SendBy: 'Agent',
      ts: new Date().toLocaleTimeString(),
      time: serverTimestamp(),
    });
    setNewMessage("");
  };

  // Delete message from Firestore
  const deleteMessage = async (messageId) => {
    if (!selectedUser) return;
    const messageDocRef = doc(db, "chatrooms", selectedUser.id, "chats", messageId);
    await deleteDoc(messageDocRef);
  };

  const formatTime = (timestamp) => {
    if (!timestamp) return "";
    try {
      if (timestamp.seconds) {
        return new Date(timestamp.seconds * 1000).toLocaleTimeString([], {
          hour: "2-digit",
          minute: "2-digit",
        });
      }
      return new Date(timestamp).toLocaleTimeString([], {
        hour: "2-digit",
        minute: "2-digit",
      });
    } catch {
      return "";
    }
  };

  const getLastMessage = (userId) => {
    const userMessages = conversations[userId] || [];
    return userMessages[userMessages.length - 1];
  };

  return (
    <>
      <header className="fixed top-0 left-0 right-0 h-16 bg-white shadow-sm border-b border-gray-200 z-40">
        <div className="flex items-center justify-between h-16 px-6">
          {/* Left side */}
          <Link href="/">
            <div className="flex items-center space-x-2">
              <Bus className="h-8 w-8 text-blue-600" />
              <span className="text-xl font-bold text-gray-900">BusAdmin</span>
            </div>
          </Link>

          {/* Right side */}
          <div className="flex items-center space-x-4">
            <div className="flex items-center space-x-3">
              <div className="text-right">
                <p className="text-sm font-medium text-gray-900">Admin User</p>
                <p className="text-xs text-gray-500">
                  admin@saralyatra.com
                </p>
              </div>
              <div className="h-8 w-8 rounded-full bg-blue-600 flex items-center justify-center">
                <span className="text-white text-sm font-medium">A</span>
              </div>
              <ChevronDown className="h-4 w-4 text-gray-400" />
            </div>
          </div>
        </div>
      </header>
      <div className="fixed right-0 left-0 top-1 bottom-0 flex mt-16 p-4 h-screen bg-gray-50">
        {/* Users Sidebar */}
        <div className="w-80 bg-white border-r border-gray-200 flex flex-col">
          {/* Users List Header */}
          <div className="p-4 border-b border-gray-200">
            <div className="flex items-center space-x-2 text-gray-700">
              <Users size={18} />
              <span className="font-medium">Active Conversations</span>
              <span className="bg-gray-100 text-gray-600 text-xs px-2 py-1 rounded-full">
                {loadingUsers ? "..." : users.length}
              </span>
            </div>
          </div>

          {/* Users List */}
          <div className="flex-1 overflow-y-auto">
            {loadingUsers ? (
              <div className="p-4 text-gray-400">Loading users...</div>
            ) : users.length === 0 ? (
              <div className="p-4 text-gray-400">No users found.</div>
            ) : (
              users
                .sort((a, b) => {
                  const aTime = getLastMessage(a.id)?.time?.seconds || 0;
                  const bTime = getLastMessage(b.id)?.time?.seconds || 0;
                  return bTime - aTime;
                })
                .map((user) => {
                  const lastMessage = getLastMessage(user.id);
                  return (
                    <div
                      key={user.id}
                      onClick={() => setSelectedUser(user)}
                      className={`p-4 border-b border-gray-100 cursor-pointer transition-colors hover:bg-gray-50 ${
                        selectedUser?.id === user.id
                          ? "bg-indigo-50 border-l-4 border-l-indigo-500"
                          : ""
                      }`}
                    >
                      <div className="flex items-center space-x-3">
                        <div className="relative">
                          <span className="text-xl border rounded-full bg-blue-100 p-2">{user.avatar}</span>
                          {/* <div
                            className={`absolute -bottom-1 -right-1 w-3 h-3 rounded-full border-2 border-white ${
                              user.online ? "bg-green-400" : "bg-gray-400"
                            }`}
                          ></div> */}
                        </div>
                        <div className="flex-1 min-w-0">
                          <div className="flex items-center justify-between">
                            <span className="font-medium text-gray-900 truncate">
                              {user.name}
                            </span>
                          </div>
                          <div className="flex items-center text-sm text-gray-500">
                            {/* <Circle
                              size={8}
                              className={`mr-2 ${
                                user.online ? "text-green-400" : "text-gray-400"
                              } fill-current`}
                            /> */}
                            {/* {user.online ? "Online" : "Offline"} */}
                          </div>
                          {lastMessage && (
                            <p className="text-sm text-gray-600 truncate mt-1">
                              {lastMessage.SendBy === admin.name ? "You: " : ""}
                              {lastMessage.Message || lastMessage.message}
                            </p>
                          )}
                        </div>
                      </div>
                    </div>
                  );
                })
            )}
          </div>
        </div>

        {/* Chat Area */}
        <div className="flex-1 flex flex-col">
          {selectedUser ? (
            <>
              {/* Chat Header */}
              <div className="p-4 bg-white border-b border-gray-200 shadow-sm">
                <div className="flex items-center space-x-3">
                  <div className="relative">
                    <span className="text-2xl">{selectedUser.avatar}</span>
                    {/* <div
                      className={`absolute -bottom-1 -right-1 w-4 h-4 rounded-full border-2 border-white ${
                        selectedUser.online ? "bg-green-400" : "bg-gray-400"
                      }`}
                    ></div> */}
                  </div>
                  <div>
                    <h2 className="text-lg font-semibold text-gray-800">
                      {selectedUser.name}
                    </h2>
                    {/* <p className="text-sm text-gray-500">
                      {selectedUser.online
                        ? "Online now"
                        : "Last seen recently"}
                    </p> */}
                  </div>
                </div>
              </div>

              {/* Messages */}
              <div className="flex-1 overflow-y-auto p-4 space-y-4 bg-gray-50">
                {messagesLoading ? (
                  <div className="text-center text-gray-400">Loading messages...</div>
                ) : (conversations[selectedUser.id] || []).length === 0 ? (
                  <div className="text-center text-gray-400">No messages yet.</div>
                ) : (
                  (conversations[selectedUser.id] || []).map((message) => (
                    <div
                      key={message.id}
                      className={`flex group ${
                        message.SendBy === 'Agent'
                          ? "justify-end"
                          : "justify-start"
                      }`}
                    >
                      <div
                        className={`max-w-xs lg:max-w-md px-4 py-2 rounded-2xl relative ${
                          message.SendBy === 'Agent'
                            ? "bg-indigo-600 text-white rounded-br-md"
                            : "bg-white text-gray-800 rounded-bl-md shadow-sm border border-gray-100"
                        }`}
                      >
                        <div className="text-sm leading-relaxed">
                          {message.message}
                        </div>
                        <div
                          className={`text-xs mt-1 ${
                            message.SendBy === 'Agent'
                              ? "text-indigo-200"
                              : "text-gray-500"
                          }`}
                        >
                          {formatTime(message.time) || message.ts}
                        </div>
                        {message.SendBy === 'Agent' && (
                          <button
                            onClick={() => deleteMessage(message.id)}
                            className="absolute -top-2 -left-2 opacity-0 group-hover:opacity-100 transition-opacity bg-red-500 text-white rounded-full p-1 hover:bg-red-600"
                          >
                            <Trash2 size={12} />
                          </button>
                        )}
                      </div>
                    </div>
                  ))
                )}
                <div ref={messagesEndRef} />
              </div>

              {/* Message Input */}
              <div className="p-4 mb-10 bg-white border-t border-gray-200">
                <div className="flex space-x-3 items-end">
                  <div className="flex-1">
                    <textarea
                      value={newMessage}
                      onChange={(e) => setNewMessage(e.target.value)}
                      onKeyPress={(e) => {
                        if (e.key === "Enter" && !e.shiftKey) {
                          e.preventDefault();
                          sendMessage();
                        }
                      }}
                      placeholder={`Message ${selectedUser.name}...`}
                      className="w-full p-3 border border-gray-300 rounded-2xl focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 resize-none"
                      rows="1"
                      style={{ minHeight: "44px", maxHeight: "120px" }}
                    />
                  </div>
                  <button
                    onClick={sendMessage}
                    disabled={!newMessage.trim()}
                    className="p-3 mb-2 bg-indigo-600 text-white rounded-2xl hover:bg-indigo-700 disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
                  >
                    <Send size={20} />
                  </button>
                </div>
              </div>
            </>
          ) : (
            <div className="flex-1 flex items-center justify-center bg-gray-50">
              <div className="text-center">
                <MessageCircle
                  size={48}
                  className="mx-auto text-gray-400 mb-4"
                />
                <h3 className="text-lg font-medium text-gray-600 mb-2">
                  Select a conversation
                </h3>
                <p className="text-gray-500">
                  Choose a user from the sidebar to start chatting
                </p>
              </div>
            </div>
          )}
        </div>
      </div>
    </>
  );
};

export default AdminChat;
