const WebSocket = require("ws");

const PORT = process.env.PORT || 10000;
const wss = new WebSocket.Server({ port: PORT });
let clients = [];
let drivers = {};

wss.on("connection", (ws) => {
  clients.push(ws);
  console.log("Client connected");
  ws.send(
    JSON.stringify({
      type: "HELLO",
      message: "Identify as DRIVER or MOBILE",
      command: "PING",
    })
  );

  ws.on("message", (message) => {
     const text = message.toString();  
      const data = JSON.parse(text);
      console.log(`[>] ${data.role}`);
      if (data.role === 'Driver') {
        const { phone, latitude, longitude , username } = data;
        // Store or update the driver's location
        drivers[phone] = { phone, latitude, longitude , username };
        ws.phone = phone;
        console.log('Driver updated:', drivers[phone]);
      }

    // Relay the message to all other clients
    // clients.forEach((client) => {
    //   if (client !== ws && client.readyState === WebSocket.OPEN) {
    //     client.send(text);
    //   }
    // });
  });

  ws.on("close", () => {
    console.log("Client disconnected");
    clients = clients.filter((client) => client !== ws);

    // Remove driver from drivers list if it had a phone
    if (ws.phone && drivers[ws.phone]) {
      delete drivers[ws.phone];
      console.log(`Removed offline driver: ${ws.phone}`);
    }
  });
});

setInterval(() => {
  // Send all drivers’ info to all clients every 5 seconds
  const driversList = Object.values(drivers);
  const payload = JSON.stringify({
    type: 'DRIVER_LIST',
    drivers: driversList
  });
  console.log(driversList);
  console.log(payload);
  clients.forEach((client) => {
    if (client.readyState === WebSocket.OPEN) {
      client.send(payload);
    }
  });
}, 1000); // send every 5 seconds

console.log("WebSocket server is running on ws://localhost:" + PORT);
