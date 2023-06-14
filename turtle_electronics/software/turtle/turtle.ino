#include <SPI.h>
#include <WiFiNINA.h>
//#include <Effortless_SPIFFS.h>
#include <ArduinoJson.h>
#include <Ethernet.h>
#include <ArduinoBLE.h>
#include <FlashStorage.h>
#include <Arduino_JSON.h>
#include "utility/wifi_drv.h"

BLEStringCharacteristic  testWifiCharacteristic("0de42c08-4f89-11eb-ae93-0242ac130023", BLEWrite,200);
BLEStringCharacteristic  resultWifiCharacteristic("0de42c08-4f89-11eb-ae93-0242ac130024", BLERead | BLENotify,200);
BLEStringCharacteristic configCharacteristic("0de42c08-4f89-11eb-ae93-0242ac130002", BLEWrite,200);
BLEService turtleService("0d153e08-c941-11ea-87d0-0242ac130003");  // User defined service
const int buttonPin = 5;
const int ledPin =  15;  
int status = WL_IDLE_STATUS;
int buttonState = 0; 
WiFiClient client;
boolean waitForUp = false;
unsigned long upButton;
unsigned long downButton;
int configSet = 0;
 
struct Config{
  boolean valid;
  char ssid[32];
  char pswd[63];
  char ipBox[16];
  char id[37];
} ; 

Config config;
FlashStorage(my_flash_store, Config);

void setup() {
  //set led output
  pinMode(ledPin, OUTPUT);
  // initialize the pushbutton pin as an input:
  pinMode(buttonPin, INPUT);
  //config 
  // Read the content of "my_flash_store" into the "owner" variable
  config = my_flash_store.read();
  if(config.valid == false){
    //if no config so start bluetooth
     startBLE();
   }else{
    
    configSet = 3;
   }
}

/**
 * Start Bluetooth
 * start all bluetooth services and characteristics
 * and advertise
 */
void startBLE(){
      BLE.begin();
      BLE.setLocalName("Turtle");  // Set name for connection
      BLE.setAdvertisedService(turtleService); // Advertise service
      turtleService.addCharacteristic(testWifiCharacteristic);
      turtleService.addCharacteristic(configCharacteristic);
      turtleService.addCharacteristic(resultWifiCharacteristic);
      configCharacteristic.setEventHandler(BLEWritten, configCharacteristicWritten);
      testWifiCharacteristic.setEventHandler(BLEWritten,testWifiCharacteristicWritten);
      BLE.addService(turtleService); // Add service
      BLE.advertise();  // Start advertising
}

/**
 * Wifi characteristic
 * get password and ssid of wifi
 */
void testWifiCharacteristicWritten(BLEDevice central, BLECharacteristic characteristic) {
  String configFromPhone = testWifiCharacteristic.value();
  DynamicJsonDocument doc(200);
  auto error = deserializeJson(doc, configFromPhone);
  if (error) {
    // Serial.print(F("deserializeJson() failed with code "));
    //Serial.println(error.c_str());
    return;
 }
 strcpy(config.ssid,  doc["ssid"]);
 strcpy(config.pswd,  doc["pswd"]);
 configSet=1;
}

/**
 * Config characteristic 
 * get all config to connect to server
 * save config in flash 
 * 
 */
void configCharacteristicWritten(BLEDevice central, BLECharacteristic characteristic) {
  String configFromPhone = configCharacteristic.value();
  DynamicJsonDocument doc(200);
  auto error = deserializeJson(doc, configFromPhone);
  if (error) {
    //Serial.print("Error ");
    return;
  }
  config.valid = true;
  strcpy(config.id,  doc["id"]);
  strcpy(config.ssid,  doc["ssid"]);
  strcpy(config.pswd,  doc["pswd"]);
  strcpy(config.ipBox,  doc["ipBox"]);
  my_flash_store.write(config);
  configSet = 2; 
}

/**
 * connect to wifi  
 * with ssid and password
 * and return false (0) or true (1)
 */
int connectToAP(char* ssid, char* pswd) {
  if(WiFi.status() == WL_CONNECTED) return 1;
    status = WiFi.begin(ssid, pswd);
    // wait 1 second for connection:
    delay(1000);
    if(status !=WL_CONNECTED) return 0;
    else return 1;
}



/**
 * verify if button is pressed
 * 
 */
int checkPressButton(){
  buttonState = digitalRead(buttonPin);
  if (waitForUp && buttonState == LOW) {
      upButton = millis();
      waitForUp = false;
  }
  if (buttonState == HIGH && !waitForUp) {
        downButton = millis();
        waitForUp = true;
       
  }
  int result = upButton - downButton;
  if(upButton == 0 || downButton == 0) return 0;
  //15s == reset
  else if( result> 15000){
    downButton = 0;
    upButton = 0;
    reset();
  }
  //just a press button
  else if(result > 600){
    downButton = 0;
    upButton = 0;
    sendTapToBox();
    return 2;
  }
}
/**
 * reset arduino
 */
void(* resetFunc) (void) = 0; 

/**
 * reset all
 * clear all config
 */
void reset(){
  config.valid = false;
  my_flash_store.write(config);
  //tell user reset is OK and we restart turtle
  digitalWrite(ledPin, HIGH);
  delay(2000);
  // wait for 2 second
  digitalWrite(ledPin, LOW);
  resetFunc();  //call reset
}

/**
 * send id to server
 */
void sendID(){
  char jsonToSend[128];
  StaticJsonDocument<128> doc;
  doc["action"] = "id";
  doc["type"] = "remote-turtle";
  doc["id"] = config.id;
  if (serializeJson(doc, jsonToSend) == 0) {
  }
  else {
    if(client.connected())
      client.print(jsonToSend);
    }
}

/**
 * send tap to server
 */
void sendTapToBox(){
  char jsonToSend[128];
  StaticJsonDocument<128> doc;
  doc["action"] = "TURTLE_TAP";
  doc["id"] = config.id;
  if (serializeJson(doc, jsonToSend) == 0) {
  }
  else {
    if(client.connected())
      client.print(jsonToSend);
  }
}

/**
 * Main loop 
 * 
 */
void loop() {
  if(configSet == 2 || configSet == 3){
    if(configSet == 2){
      delay(1000);
      Serial.print("disconnect ble");
      BLE.disconnect();
      BLE.end();
    }
    connectToAP(config.ssid, config.pswd);
    if(client.connect(config.ipBox, 8585)){
        //Serial.print("connect to ip box"); 
        sendID();
        if(configSet ==2){
          //blink led to tell everything is OK
          digitalWrite(ledPin, HIGH);
          delay(2000);
          // wait for a second
          digitalWrite(ledPin, LOW);
          configSet = 3;
        }
        while(client.connected()){
        //check if data arrived
        if (client.available()) {
          DynamicJsonDocument doc(200);
          auto error = deserializeJson(doc, client);
          if (error) Serial.println(error.f_str());
          else if(doc["action"]=="NEW_MESSAGES"){
              //blink led
                while(checkPressButton()== 0){
                  digitalWrite(ledPin, HIGH);
                  delay(1000);
                  // wait for a second
                  digitalWrite(ledPin, LOW);
                  delay(1000);
                }
            }  
        }else {
           checkPressButton();
         }
        }
         //wait 1 min before reconnection
         delay(6000);
    }
  }else if(configSet == 1){
    //stop bluetooth
    delay(1000);
    BLE.disconnect();
    BLE.end();
    int result = connectToAP(config.ssid, config.pswd);
    if(result == 1){
      resultWifiCharacteristic.writeValue("OK");
    }else{
      resultWifiCharacteristic.writeValue("ERROR");
    }
    WiFi.disconnect();
    WiFi.end();
    BLE.begin();
    // Add service
    BLE.addService(turtleService);
    BLE.advertise(); 
    configSet=0;
  }
  else{
     BLE.poll();
  }
}
