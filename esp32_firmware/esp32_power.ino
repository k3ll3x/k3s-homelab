#include <WiFi.h>
#include <WebServer.h>

const char* ssid = "YOUR_WIFI_SSID";
const char* password = "YOUR_WIFI_PASSWORD";

WebServer server(80);
const int relayPin = 5; // Relay pin

void handlePower() {
  String nodeId = server.pathArg(0);
  String state = server.arg("state");
  
  if (state == "on") digitalWrite(relayPin, HIGH);
  else if (state == "off") digitalWrite(relayPin, LOW);
  
  server.send(200, "text/plain", "Node " + nodeId + " set to " + state);
}

void setup() {
  pinMode(relayPin, OUTPUT);
  WiFi.begin(ssid, password);
  server.on(UriBraces("/node/{}"), HTTP_POST, handlePower);
  server.begin();
}

void loop() { server.handleClient(); }
