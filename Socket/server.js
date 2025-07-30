
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
