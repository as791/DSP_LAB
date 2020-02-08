float x[]={-87.17307638,-109.5495333,11.00037444,163.4286511,199.1497693,123.5660003,56.25558579,11.87495703,-18.97729813,-42.98507139,-49.50432452,-44.95819516,-33.93206642,-28.58275615,-31.58109989,-41.0802992,-54.49307368,-68.26273259,-80.63560247,-89.53265601,-97.96825536,-104.8688265,-109.0354357,-55.42792547,102.4289065,215.9352907,173.6592794,95.27713062,38.69934301,2.586699113,-27.11808597,-41.50592056,-38.88116345,-27.52106187,-19.43972127,-21.31888102,-29.19861314,-42.08703327,-57.83191118,-69.53303635,-80.46281953,-88.35226795,-94.97094082,-102.2065852,-97.71319214,4.172319927,174.7275931,221.5697151,147.842936,75.61863429,28.48903346,-4.64088307,-29.76995187,-35.85962812,-27.26819387,-12.26373734,-5.602559446,-9.189517172,-21.48116953,-38.07938735,-52.01784737,-63.35879895,-71.93471855,-79.04261272,-85.4265121,-86.88364206,-9.984335526,167.9810654,251.6113399,182.1367896,108.0062751,59.54909365,24.89964724,-5.472668004,-17.77934267
};
const int n = 75;
const float pi = 3.14;
const float Fs = 25.0;
void moving_average(float* x, float* y)
{
  int l=8;  //window size for moving average.
  for(int i=0;i<n;i++)
  {
    for(int j=0;j<l;j++)
    {
      if(i>=j)
        y[i]+=x[i-j];
    }
    y[i]/=l;
  }
}
void acf(float* x,float* R){
  float R0 = 0;
  for(int i=0;i<n;i++)
  {
    R0+= x[i]*x[i];
  }
  for(int i=0;i<n;i++)
  {
    for(int j=0;j<n-i;j++)
    {
      R[i]+=x[j]*x[j+i];
    }
    R[i]/=R0;
  }
}
float dft(float* x, float* X_mag)
{
  float real[n]={0};
  float imag[n]={0};
  for(int i=0;i<n;i++)
  {
     for(int j=0;j<n;j++)
     {
       float cosine = cos(2*pi*i*j/n);
       float sine  = sin(2*pi*i*j/n);
       real[i]+=x[j]*cosine;
       imag[i]+=x[j]*sine;
     }
  }
  for(int i=0;i<n;i++)
  {
    X_mag[i]=sqrt(pow(real[i],2)+pow(imag[i],2));
  }
}
void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
}

void loop() {
  // put your main code here, to run repeatedly:
  float filtered_x[n]={0};
  moving_average(x,filtered_x);
  float mean = 0;
  for(int i=0;i<n;i++)
  {
    mean+=filtered_x[i];
  }
  mean = mean/n;

  for(int i=0;i<n;i++)
  {
    filtered_x[i] = filtered_x[i] - mean;
  }
  
  //Autocorrelation Method
  float R[n] = {0};
  acf(filtered_x,R);
  int fzcp =0;
  for(int i=1;i<n-1;i++)
  {
    if(R[i-1]>0&&R[i+1]<0)
      {
        fzcp = i;
        break;
      }
  }
  int lmax = 0;
  float max_= 0;
  for(int i=fzcp;i<n;i++)
  {
    if(max_<R[i])
      {
        max_ = R[i];
        lmax = i;
      }
  }
  float period_time = lmax/Fs; // Fs=100;
  float pulse_rate = 60.0/period_time;

 
 //DFT Method
 float X_mag[n]={0};
 dft(filtered_x,X_mag);
 int kmax=0;
 float peak=0;
 for(int i=0;i<n/2;i++)
 {
   if(peak<X_mag[i])
   {
     peak=X_mag[i];
     kmax=i+1;
   }
 }
 float pulse_rate_1=60.0*(kmax*Fs)/n;

 Serial.print("Autocorrelation Method:- ");
 Serial.println(pulse_rate);
 Serial.print("DFT Method:- ");
 Serial.println(pulse_rate_1);
 
//  for(int i=0;i<n;i++)
//  {
//    Serial.print(x[i]);
//    Serial.print(",");
//    Serial.print(filtered_x[i]+250);
//    Serial.print(",");
//    Serial.print(R[i]*200+500);
//    Serial.print(",");
//    Serial.println(X_mag[i]+750);
//  }
}
