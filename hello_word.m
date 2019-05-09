%{
function tilt = average(x)
if ~isvector(x)
    error('Input must be a vector')
end
y = sum(x)/length(x); 
end

%}
myrobot = legoev3('usb');

myUltrasonicSensor = sonicSensor(myrobot);
val = readDistance(myUltrasonicSensor);

ColorSensorRight = colorSensor(myrobot, 3);
ColorSensorLeft = colorSensor(myrobot, 2);

% left is motor A, right is motor B
motorLeft = motor(myrobot, 'A');
motorRight = motor(myrobot, 'B');

motorLeft.Speed = 25;
motorRight.Speed = 25;

start(motorLeft);
start(motorRight);
colorRight = readLightIntensity(ColorSensorRight);
colorLeft = readLightIntensity(ColorSensorLeft);

while(colorRight >7) && (colorLeft >7)
    val = readDistance(myUltrasonicSensor);    
    colorRight = readLightIntensity(ColorSensorRight);
    colorLeft = readLightIntensity(ColorSensorLeft);
    display(colorRight);
end

stop(motorLeft, 1);
stop(motorRight, 1);



%{

while val<2

    val = readDistance(myUltrasonicSensor);    
    ambient = readLightIntensity(myColourSensor);
    display(ambient);
    
    %reflected = readLightIntensity(myColourSensor, 'reflected');
    %display(reflected);
    %display(val);
end
%}

clear all;