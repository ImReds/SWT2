% ----- SETUP CONNECTION
clear all;
myrobot = legoev3('usb');

% ----- SETUP VARIABLES
whiteThreshold = 5;
distanceThreshold = 0.1;

myUltrasonicSensor = sonicSensor(myrobot);
distance = readDistance(myUltrasonicSensor);

ColorSensorRight = colorSensor(myrobot, 3);
ColorSensorLeft = colorSensor(myrobot, 2);
reflectedRight =  readLightIntensity(ColorSensorRight, 'reflected');
reflectedLeft =  readLightIntensity(ColorSensorLeft, 'reflected');

% left is motor A, right is motor B
global motorLeft; 
motorLeft = motor(myrobot, 'A');
global motorRight;
motorRight = motor(myrobot, 'B');

motorLeft.Speed = 25;
motorRight.Speed = 25;


% ----- PROGRAM START FROM HERE

% READING COLOR FOR FIRST TIME
colorRight = readLightIntensity(ColorSensorRight);
colorLeft = readLightIntensity(ColorSensorLeft);
distance = readDistance(myUltrasonicSensor);

% LOOP FOR ROBOT BEHAVIOUR
while( true )
    
    % sensor reading
    distance = readDistance(myUltrasonicSensor);    
    %colorRight = readLightIntensity(ColorSensorRight);
    %colorLeft = readLightIntensity(ColorSensorLeft);
    reflectedRight =  readLightIntensity(ColorSensorRight, 'reflected');
    reflectedLeft =  readLightIntensity(ColorSensorLeft, 'reflected');
    avg = (reflectedLeft + reflectedRight)/2;
    %print value
    fprintf('colorLeft: %d colorRight: %d distance: %f, reflectedLeft: %d reflectedRight: %d avg:%d\n', colorLeft, colorRight, distance, reflectedLeft, reflectedRight, avg);
    
    % IF LEFT SENSOR DETECT BLACK LINE
    if(colorLeft <whiteThreshold)
        %turn left
        %fprintf('turn left');
    end
    
    % IF RIGHT SENSOR DETECT BLACK LINE
    if(colorRight <whiteThreshold)
        %turn right
        %fprintf('turn right');
    end
    
    %IF DISTANCE SENSOR DETECT OBSTACLE
    if (distance <0.1)
        stopMotors(motorLeft, motorRight);
        break;
    end
   
end

stopMotors(motorLeft, motorRight);
clear all;

% ---- Functions

function [] = stopMotors(motorLeft, motorRight)
    stop(motorLeft, 1);
    stop(motorRight, 1);
end