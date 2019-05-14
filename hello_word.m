% ----- SETUP CONNECTION
clear all;
myrobot = legoev3('usb');

% ----- SETUP VARIABLES
whiteThreshold = 7;
distanceThreshold = 0.1;
normalSpeed = 25;
slowSpeed = 10;
fastSpeed = 40;

myUltrasonicSensor = sonicSensor(myrobot);
distance = readDistance(myUltrasonicSensor);

ColorSensorRight = colorSensor(myrobot, 3);
ColorSensorLeft = colorSensor(myrobot, 2);

% left is motor A, right is motor B
global motorLeft; 
motorLeft = motor(myrobot, 'A');
global motorRight;
motorRight = motor(myrobot, 'B');

motorLeft.Speed = 25;
motorRight.Speed = 25;
start(motorLeft);
start(motorRight);

% ----- PROGRAM START FROM HERE

% READING COLOR FOR FIRST TIME
colorRight = readLightIntensity(ColorSensorRight);
colorLeft = readLightIntensity(ColorSensorLeft);
distance = readDistance(myUltrasonicSensor);
reflectedRight =  readLightIntensity(ColorSensorRight, 'reflected');
reflectedLeft =  readLightIntensity(ColorSensorLeft, 'reflected');

% LOOP FOR ROBOT BEHAVIOUR
while( true )
    
    % sensor reading
    distance = readDistance(myUltrasonicSensor);    
    colorRight = readLightIntensity(ColorSensorRight);
    colorLeft = readLightIntensity(ColorSensorLeft);
    %reflectedRight =  readLightIntensity(ColorSensorRight, 'reflected');
    %reflectedLeft =  readLightIntensity(ColorSensorLeft, 'reflected');
    
    fprintf('colorLeft: %d colorRight: %d distance: %f\n', colorLeft, colorRight, distance);

    %print value
    fprintf('colorLeft: %d colorRight: %d\n', colorLeft, colorRight);
    
    %IF DISTANCE SENSOR DETECT OBSTACLE
    if (distance <distanceThreshold)
        stopMotors(motorLeft, motorRight);
        break;
    end
    
    % IF RIGHT SENSOR DETECT BLACK LINE
    if(colorRight <whiteThreshold)
        %turn right
        turn( 'right', motorLeft, motorRight, ColorSensorLeft, ColorSensorRight, whiteThreshold, normalSpeed)
    end
    
    % IF LEFT SENSOR DETECT BLACK LINE
    if(colorLeft <whiteThreshold)
        %turn left
        turn( 'left', motorLeft, motorRight, ColorSensorLeft, ColorSensorRight, whiteThreshold, normalSpeed)
    end
    
    %SETUP NORMAL SPEED
    motorLeft.Speed = 25;
    motorRight.Speed = 25;
    start(motorLeft);
    start(motorRight);
end

stopMotors(motorLeft, motorRight);
clear all;

% ---- Functions

function [] = turn( direction, motorLeft, motorRight, ColorSensorLeft, ColorSensorRight, whiteThreshold, normalSpeed)
disp('i am turn left');
   
    stopMotors(motorLeft, motorRight);
    motorLeft.Speed= 0;
    motorRight.Speed= 0;
    
    if(strcmp(direction, 'left')    )
        motorLeft.Speed = - normalSpeed;
    else 
        motorRight.Speed = -normalSpeed;
    end
    start(motorLeft);
    start(motorRight);
    
    pause( 0.35 );
    stopMotors(motorLeft, motorRight);
end

function [] = backUp( motorLeft, motorRight)
    disp('i am backing');
    motorLeft.Speed = -25;
    motorRight.Speed = -25;
    start(motorLeft);
    start(motorRight);
    pause( 0.25 );
    stop(motorLeft, 1);
    stop(motorRight, 1);
end

function [] = stopMotors(motorLeft, motorRight)
    stop(motorLeft, 1);
    stop(motorRight, 1);
end