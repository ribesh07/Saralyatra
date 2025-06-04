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

const AdminChat = () => {
  const admin = { id: 1, name: "Admin", role: "admin", avatar: "👨‍💼" };

  const [users, setUsers] = useState([
    {
      id: 2,
      name: "Alice Johnson",
      role: "user",
      avatar: "👩",
      online: true,
      unread: 2,
      lastMessageTime: Date.now() - 180000,
    },
    {
      id: 3,
      name: "Bob Smith",
      role: "user",
      avatar: "👨",
      online: true,
      unread: 0,
      lastMessageTime: Date.now() - 120000,
    },
    {
      id: 4,
      name: "Carol Davis",
      role: "user",
      avatar: "👩‍🦱",
      online: false,
      unread: 1,
      lastMessageTime: Date.now() - 60000,
    },
    {
      id: 5,
      name: "David Wilson",
      role: "user",
      avatar: "👨‍🦲",
      online: true,
      unread: 0,
      lastMessageTime: 0,
    },
    {
      id: 6,
      name: "Emma Brown",
      role: "user",
      avatar: "👩‍🦰",
      online: true,
      unread: 3,
      lastMessageTime: Date.now() - 390000,
    },
  ]);

  const [conversations, setConversations] = useState({
    2: [
      {
        id: 1,
        senderId: 2,
        senderName: "Alice Johnson",
        text: "Hi! I need help with my account settings.",
        timestamp: Date.now() - 300000,
      },
      {
        id: 2,
        senderId: 1,
        senderName: "Admin",
        text: "Hello Alice! I'd be happy to help you with your account. What specifically do you need assistance with?",
        timestamp: Date.now() - 240000,
      },
      {
        id: 3,
        senderId: 2,
        senderName: "Alice Johnson",
        text: "I can't seem to update my profile picture. It keeps giving me an error.",
        timestamp: Date.now() - 180000,
      },
    ],
    3: [
      {
        id: 4,
        senderId: 3,
        senderName: "Bob Smith",
        text: "Thanks for the quick response earlier!",
        timestamp: Date.now() - 120000,
      },
    ],
    4: [
      {
        id: 5,
        senderId: 4,
        senderName: "Carol Davis",
        text: "Is the maintenance scheduled for tonight still happening?",
        timestamp: Date.now() - 60000,
      },
    ],
    5: [],
    6: [
      {
        id: 6,
        senderId: 6,
        senderName: "Emma Brown",
        text: "Hi there!",
        timestamp: Date.now() - 400000,
      },
      {
        id: 7,
        senderId: 6,
        senderName: "Emma Brown",
        text: "I have a billing question",
        timestamp: Date.now() - 395000,
      },
      {
        id: 8,
        senderId: 6,
        senderName: "Emma Brown",
        text: "Could you help me understand the recent charges?",
        timestamp: Date.now() - 390000,
      },
    ],
  });

  const [selectedUser, setSelectedUser] = useState(users[0]);
  const [newMessage, setNewMessage] = useState("");
  const messagesEndRef = useRef(null);

  const scrollToBottom = () => {
    messagesEndRef.current?.scrollIntoView({ behavior: "smooth" });
  };

  useEffect(() => {
    scrollToBottom();
  }, [conversations, selectedUser]);

  const sendMessage = () => {
    if (!newMessage.trim() || !selectedUser) return;

    const message = {
      id: Date.now(),
      senderId: admin.id,
      senderName: admin.name,
      text: newMessage,
      timestamp: Date.now(),
    };

    setConversations((prev) => ({
      ...prev,
      [selectedUser.id]: [...(prev[selectedUser.id] || []), message],
    }));

    // Update user's last message time and move to top
    setUsers((prev) =>
      prev
        .map((user) =>
          user.id === selectedUser.id
            ? { ...user, lastMessageTime: Date.now() }
            : user
        )
        .sort((a, b) => b.lastMessageTime - a.lastMessageTime)
    );

    setNewMessage("");
  };

  const deleteMessage = (messageId) => {
    setConversations((prev) => ({
      ...prev,
      [selectedUser.id]: prev[selectedUser.id].filter(
        (msg) => msg.id !== messageId
      ),
    }));
  };

  const formatTime = (timestamp) => {
    return new Date(timestamp).toLocaleTimeString([], {
      hour: "2-digit",
      minute: "2-digit",
    });
  };

  const getLastMessage = (userId) => {
    const userMessages = conversations[userId] || [];
    return userMessages[userMessages.length - 1];
  };

  const markAsRead = (userId) => {
    // In a real app, this would update the unread count
    // console.log(Marked conversation with user ${userId} as read);
  };

  useEffect(() => {
    if (selectedUser) {
      markAsRead(selectedUser.id);
    }
  }, [selectedUser]);

  return (
    <>
      <header className="fixed top-0 left-0 right-0 h-16 bg-white shadow-sm border-b border-gray-200 z-40">
        <div className="flex items-center justify-between h-16 px-6">
          {/* Left side */}
          <Link href="/">
            <div className="flex items-center space-x-2">
              <Bus className="h-8 w-8 text-blue-600" />
              <span className="text-xl font-bold text-gray-900">
                Admin Chat
              </span>
            </div>
          </Link>

          {/* Right side */}
          <div className="flex items-center space-x-4">
            <div className="flex items-center space-x-3">
              <div className="text-right">
                <p className="text-sm font-medium text-gray-900">Admin User</p>
                <p className="text-xs text-gray-500">
                  admin@busreservation.com
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
          {/* Admin Header */}

          {/* Users List Header */}
          <div className="p-4 border-b border-gray-200">
            <div className="flex items-center space-x-2 text-gray-700">
              <Users size={18} />
              <span className="font-medium">Active Conversations</span>
              <span className="bg-gray-100 text-gray-600 text-xs px-2 py-1 rounded-full">
                {users.length}
              </span>
            </div>
          </div>

          {/* Users List */}
          <div className="flex-1 overflow-y-auto">
            {users
              .sort((a, b) => b.lastMessageTime - a.lastMessageTime)
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
                        <span className="text-xl">{user.avatar}</span>
                        <div
                          className={`absolute -bottom-1 -right-1 w-3 h-3 rounded-full border-2 border-white ${
                            user.online ? "bg-green-400" : "bg-gray-400"
                          }`}
                        ></div>
                      </div>
                      <div className="flex-1 min-w-0">
                        <div className="flex items-center justify-between">
                          <span className="font-medium text-gray-900 truncate">
                            {user.name}
                          </span>
                          {user.unread > 0 && (
                            <span className="bg-red-500 text-white text-xs rounded-full px-2 py-1 min-w-5 text-center">
                              {user.unread}
                            </span>
                          )}
                        </div>
                        <div className="flex items-center text-sm text-gray-500">
                          <Circle
                            size={8}
                            className={`mr-2 ${
                              user.online ? "text-green-400" : "text-gray-400"
                            } fill-current`}
                          />
                          {user.online ? "Online" : "Offline"}
                        </div>
                        {lastMessage && (
                          <p className="text-sm text-gray-600 truncate mt-1">
                            {lastMessage.senderId === admin.id ? "You: " : ""}
                            {lastMessage.text}
                          </p>
                        )}
                      </div>
                    </div>
                  </div>
                );
              })}
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
                    <div
                      className={`absolute -bottom-1 -right-1 w-4 h-4 rounded-full border-2 border-white ${
                        selectedUser.online ? "bg-green-400" : "bg-gray-400"
                      }`}
                    ></div>
                  </div>
                  <div>
                    <h2 className="text-lg font-semibold text-gray-800">
                      {selectedUser.name}
                    </h2>
                    <p className="text-sm text-gray-500">
                      {selectedUser.online
                        ? "Online now"
                        : "Last seen recently"}
                    </p>
                  </div>
                </div>
              </div>

              {/* Messages */}
              <div className="flex-1 overflow-y-auto p-4 space-y-4 bg-gray-50">
                {(conversations[selectedUser.id] || []).map((message) => (
                  <div
                    key={message.id}
                    className={`flex group ${
                      message.senderId === admin.id
                        ? "justify-end"
                        : "justify-start"
                    }`}
                  >
                    <div
                      className={`max-w-xs lg:max-w-md px-4 py-2 rounded-2xl relative ${
                        message.senderId === admin.id
                          ? "bg-indigo-600 text-white rounded-br-md"
                          : "bg-white text-gray-800 rounded-bl-md shadow-sm border border-gray-100"
                      }`}
                    >
                      <div className="text-sm leading-relaxed">
                        {message.text}
                      </div>
                      <div
                        className={`text-xs mt-1 ${
                          message.senderId === admin.id
                            ? "text-indigo-200"
                            : "text-gray-500"
                        }`}
                      >
                        {formatTime(message.timestamp)}
                      </div>
                      {message.senderId === admin.id && (
                        <button
                          onClick={() => deleteMessage(message.id)}
                          className="absolute -top-2 -left-2 opacity-0 group-hover:opacity-100 transition-opacity bg-red-500 text-white rounded-full p-1 hover:bg-red-600"
                        >
                          <Trash2 size={12} />
                        </button>
                      )}
                    </div>
                  </div>
                ))}
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
