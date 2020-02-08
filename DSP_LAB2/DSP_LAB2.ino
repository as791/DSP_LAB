////////////////////////////////////////////////////////////////////////////// Experiment-1 Lab - 2 /////////////////////////////////////////////////////////////////////////////////////////////

int pinNo = A0; // This is the signal pin on the arduino board.
void moving_average(float* x, float* y)
{
  int l=8;  //window size for moving average.
  for(int i=0;i<500;i++)
  {
    for(int j=0;j<l;j++)
    {
      if(i>=j)
        y[i]+=x[i-j];
    }
    y[i]/=l;
  }
}
void first_order_derivative(float* x,float* y){
  for(int i=1;i<500;i++)
  {
    y[i]=x[i]-x[i-1];
  }
}
void three_point_central(float* x,float* y){
  for(int i=2;i<500;i++)
  {
    y[i]=x[i]-x[i-2]; 
  }
  
}
void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600); // Serial Initializer 
}

void loop() {
  // put your main code here, to run repeatedly:
  float sensorValue[500]={0};
  float filteredValue[500]={0};
  float filteredValue1[500]={0};
  float filteredValue2[500]={0};
  //Loop to take 500 samples of live analog PPG signal with Ts=0.01sec.
  for(int i=0;i<500;i++)
  {
    sensorValue[i] = analogRead(pinNo);
    delay(10);
  }
  three_point_central(sensorValue,filteredValue);
  first_order_derivative(sensorValue,filteredValue1);
  moving_average(filteredValue1,filteredValue2);

  for(int i=0;i<500;i++)
  {
    Serial.print(sensorValue[i]);         //live PPG signal visualization
    Serial.print(",");
    Serial.print(filteredValue2[i]+700); //moving average filter output
    Serial.print(",");
    Serial.print(filteredValue1[i]+500); //first order derivative filter output
    Serial.print(",");
    Serial.println(filteredValue[i]+300); //three point central difference filter output.
  }
}
