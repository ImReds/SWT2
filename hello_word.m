clear all;
myrobot = legoev3('usb');

whiteThreshold = 12;

myUltrasonicSensor = sonicSensor(myrobot);
val = readDistance(myUltrasonicSensor);

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

colorRight = readLightIntensity(ColorSensorRight);
colorLeft = readLightIntensity(ColorSensorLeft);

while( (colorRight >whiteThreshold) || (colorLeft >whiteThreshold) )
    motorLeft.Speed = 25;
    motorRight.Speed = 25;
    start(motorLeft);
    start(motorRight);
    
    fprintf('colorLeft: %d colorRight: %d\n', colorLeft, colorRight);
    
    if(colorRight <whiteThreshold)
        %turn right
        break;
    end
    
    if(colorLeft <whiteThreshold)
        turnLeft(motorLeft, motorRight, ColorSensorLeft, ColorSensorRight, whiteThreshold)
        %turn left
        break;
    end
    
    %val = readDistance(myUltrasonicSensor);    
    colorRight = readLightIntensity(ColorSensorRight);
    colorLeft = readLightIntensity(ColorSensorLeft);
end

% stop function

stop(motorLeft, 1);
stop(motorRight, 1);
clear all;

function [] = turnLeft( motorLeft, motorRight, ColorSensorLeft, ColorSensorRight, whiteThreshold)
    disp('i am turn');
    motorLeft.Speed = -25;
    motorRight.Speed = 25;
    start(motorLeft);
    start(motorRight);
    
    while true
        colorRight = readLightIntensity(ColorSensorRight);
        colorLeft = readLightIntensity(ColorSensorLeft);
        
        if(colorRight< whiteThreshold) 
            break;
        end
    end
    
    fprintf('inside turn: colorLeft: %d colorRight: %d\n', colorLeft, colorRight);
    %{
    pause( 0.4 );
    stop(motorLeft, 1);
    stop(motorRight, 1);
    %}
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