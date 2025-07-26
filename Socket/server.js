// // basic-server.js - Minimal WebSocket server for testing
// const WebSocket = require("ws");

// // Try different ports in case 10000 is blocked
// const PORTS_TO_TRY = [10000, 8080, 3000, 3001, 9000];
// let serverStarted = false;

// function tryStartServer(portIndex = 0) {
//   if (portIndex >= PORTS_TO_TRY.length) {
//     console.error("❌ Could not start server on any port");
//     process.exit(1);
//   }

//   const port = PORTS_TO_TRY[portIndex];
//   console.log(`🔄 Trying to start server on port ${port}...`);

//   const wss = new WebSocket.Server({ port });

//   wss.on("listening", () => {
//     console.log(`✅ WebSocket server started successfully!`);
//     console.log(`🌐 Server running on: ws://localhost:${port}`);
//     console.log(`📱 Connect your clients to: ws://localhost:${port}`);
//     console.log(`🔄 Waiting for connections...\n`);
//     serverStarted = true;

//     // Log server status every 10 seconds
//     setInterval(() => {
//       const clients = Array.from(wss.clients);
//       const activeClients = clients.filter(
//         (client) => client.readyState === WebSocket.OPEN
//       );
//       console.log(
//         `📊 Status: ${activeClients.length} active clients connected`
//       );
//     }, 10000);
//   });

//   wss.on("error", (error) => {
//     if (!serverStarted) {
//       console.log(`❌ Port ${port} failed: ${error.message}`);
//       if (error.code === "EADDRINUSE") {
//         console.log(`   Port ${port} is already in use`);
//       }
//       // Try next port
//       tryStartServer(portIndex + 1);
//     } else {
//       console.error("❌ Server error:", error);
//     }
//   });

//   wss.on("connection", (ws, req) => {
//     console.log(`🔗 New client connected from ${req.socket.remoteAddress}`);

//     // Send welcome message
//     const welcome = {
//       type: "HELLO",
//       message: "Connected to basic WebSocket server",
//       serverTime: new Date().toISOString(),
//       port: port,
//     };

//     ws.send(JSON.stringify(welcome));
//     console.log("📤 Sent welcome message");

//     ws.on("message", (message) => {
//       try {
//         const text = message.toString();
//         console.log(`📥 Received message (${text.length} chars):`, text);

//         // Try to parse as JSON
//         const data = JSON.parse(text);
//         console.log("📋 Parsed data:", data);

//         // Echo back the message with timestamp
//         const response = {
//           type: "ECHO",
//           originalMessage: data,
//           serverTime: new Date().toISOString(),
//           status: "Message received successfully",
//         };

//         ws.send(JSON.stringify(response));
//         console.log("📤 Sent echo response");
//       } catch (error) {
//         console.log("❌ Error parsing message:", error.message);
//         console.log("📄 Raw message:", message.toString());

//         // Send error response
//         ws.send(
//           JSON.stringify({
//             type: "ERROR",
//             message: "Could not parse message as JSON",
//             error: error.message,
//           })
//         );
//       }
//     });

//     ws.on("close", (code, reason) => {
//       console.log(
//         `🔌 Client disconnected. Code: ${code}, Reason: ${
//           reason || "No reason"
//         }`
//       );
//     });

//     ws.on("error", (error) => {
//       console.log("❌ Client connection error:", error.message);
//     });

//     // Send periodic ping to keep connection alive
//     const pingInterval = setInterval(() => {
//       if (ws.readyState === WebSocket.OPEN) {
//         ws.ping();
//       } else {
//         clearInterval(pingInterval);
//       }
//     }, 30000);
//   });
// }

// // Start the server
// console.log("🚀 Starting basic WebSocket server...");
// console.log("📋 This server will:");
// console.log("   - Accept connections on the first available port");
// console.log("   - Echo back any JSON messages it receives");
// console.log("   - Log all connection activity");
// console.log("");

// tryStartServer();

// // Handle graceful shutdown
// process.on("SIGINT", () => {
//   console.log("\n🛑 Shutting down server...");
//   process.exit(0);
// });

// // Keep process alive and show it's running
// setInterval(() => {
//   if (serverStarted) {
//     process.stdout.write(".");
//   }
// }, 5000);

// const http = require("http");
// const WebSocket = require("ws");

// const PORT = process.env.PORT || 10000;
// const wss = new WebSocket.Server({ port: PORT });
// let clients = [];
// let drivers = {};

// // Create an HTTP server
// const server = http.createServer((req, res) => {
//   if (req.method === "GET" && req.url === "/drivers") {
//     res.writeHead(200, { "Content-Type": "application/json" });
//     res.end(JSON.stringify({ drivers: Object.values(drivers) }));
//   } else {
//     res.writeHead(404);
//     res.end("Not Found");
//   }
// });

// wss.on("connection", (ws) => {
//   clients.push(ws);
//   console.log("Client connected");
//   ws.send(
//     JSON.stringify({
//       type: "HELLO",
//       message: "Identify as DRIVER or MOBILE",
//       command: "PING",
//     })
//   );

//   ws.on("message", (message) => {
//     const text = message.toString();
//     const data = JSON.parse(text);
//     console.log(`[>] ${data.role}`);
//     console.log(data);
//     if (data.role === "Driver") {
//       const { uid, latitude, longitude, username } = data;
//       // Store or update the driver's location
//       drivers[uid] = { uid, latitude, longitude, username };
//       ws.uid = uid;
//       console.log("Driver updated:", drivers[uid]);
//     }

//     // Relay the message to all other clients
//     // clients.forEach((client) => {
//     //   if (client !== ws && client.readyState === WebSocket.OPEN) {
//     //     client.send(text);
//     //   }
//     // });
//   });

//   ws.on("close", () => {
//     console.log("Client disconnected");
//     clients = clients.filter((client) => client !== ws);

//     // Remove driver from drivers list if it had a uid
//     if (ws.uid && drivers[ws.uid]) {
//       delete drivers[ws.uid];
//       console.log(`Removed offline driver: ${ws.uid}`);
//     }
//   });
// });

// setInterval(() => {
//   // Send all drivers’ info to all clients every 5 seconds
//   const driversList = Object.values(drivers);
//   const payload = JSON.stringify({
//     type: "DRIVER_LIST",
//     drivers: driversList,
//   });
//   console.log(driversList);
//   console.log(payload);
//   clients.forEach((client) => {
//     if (client.readyState === WebSocket.OPEN) {
//       client.send(payload);
//     }
//   });
// }, 1000); // send every 5 seconds

// console.log("WebSocket server is running on ws://localhost:" + PORT);

const http = require("http");
const WebSocket = require("ws");

const PORT = process.env.PORT || 10000;

let clients = [];
let drivers = {};

// Create HTTP server to respond to REST GET /drivers
const server = http.createServer((req, res) => {
  if (req.method === "GET" && req.url === "/drivers") {
    res.writeHead(200, { "Content-Type": "application/json" });
    res.end(JSON.stringify({ drivers: Object.values(drivers) }));
  } else {
    res.writeHead(404);
    res.end("Not Found");
  }
});

// Attach WebSocket server to HTTP server
const wss = new WebSocket.Server({ server });

wss.on("connection", (ws) => {
  clients.push(ws);
  console.log("Client connected");

  // Send initial hello message
  ws.send(
    JSON.stringify({
      type: "HELLO",
      message: "Identify as DRIVER or MOBILE",
      command: "PING",
    })
  );

  ws.on("message", (message) => {
    try {
      const text = message.toString();
      const data = JSON.parse(text);
      console.log(`[>] Role: ${data.role}`, data);

      if (data.role === "Driver") {
        const { uid, latitude, longitude, username } = data;
        drivers[uid] = { uid, latitude, longitude, username };
        ws.uid = uid;
        console.log("Driver updated:", drivers[uid]);
      }

      // Optional: relay messages to other clients
      // clients.forEach((client) => {
      //   if (client !== ws && client.readyState === WebSocket.OPEN) {
      //     client.send(text);
      //   }
      // });
    } catch (err) {
      console.error("Invalid message received:", err.message);
    }
  });

  ws.on("close", () => {
    console.log("Client disconnected");
    clients = clients.filter((client) => client !== ws);

    if (ws.uid && drivers[ws.uid]) {
      delete drivers[ws.uid];
      console.log(`Removed offline driver: ${ws.uid}`);
    }
  });
});

// Broadcast updated driver list every 1 second
setInterval(() => {
  const driversList = Object.values(drivers);
  const payload = JSON.stringify({
    type: "DRIVER_LIST",
    drivers: driversList,
  });

  // Log current state
  if (driversList.length > 0) {
    console.log("Broadcasting drivers:", driversList);
  }

  clients.forEach((client) => {
    if (client.readyState === WebSocket.OPEN) {
      client.send(payload);
    }
  });
}, 1000);

// Start the server
server.listen(PORT, () => {
  console.log(`WebSocket + HTTP server is running at http://localhost:${PORT}`);
});
