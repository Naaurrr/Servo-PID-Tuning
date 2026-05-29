#include <Servo.h>

Servo myServo;
const int servoPin = 9;
const int potPin = A0;

unsigned long t = 0;
int pwmUs = 1000;       // Start at 1000 µs (0°)
int pwmEnd = 2000;      // End at 2000 µs (180°)
int pwmStep = 7;        // Increment per sample (~7 µs matches your data spacing)

void setup() {
  Serial.begin(115200);
  myServo.attach(servoPin);
}

void loop() {
  t = millis();

  myServo.writeMicroseconds(pwmUs);

  int raw = analogRead(potPin);
  int angle = map(raw, 0, 1023, 0, 180);  // Map pot to degrees

  Serial.print(t);
  Serial.print(",");
  Serial.print(pwmUs);
  Serial.print(",");
  Serial.println(angle);

  pwmUs += pwmStep;
  if (pwmUs > pwmEnd) pwmUs = pwmEnd;  // Clamp at max

  delay(20);  // 50 Hz
}