% ----- SETUP CONNECTION
clear all;
myrobot = legoev3('usb');

% ----- SETUP VARIABLES
blackThreshold = 15;
nonBlackThreshold = 27;
distanceThreshold = 0.1;
reflectivenessThreshold = 90;   % to distinguis between track and tape patches areas

normalSpeed = 25;
slowSpeed = 10;
fastSpeed = 40;
reachedParkingArea = false;
oldSpeed = normalSpeed;
speed = normalSpeed;

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

%{
    % START ON BLACK T-MARK: go straight until sensors are both white
        motorLeft.Speed = normalSpeed;
        motorLeft.Speed = normalSpeed;
        start(motorLeft);
        start(motorRight);
    while( reflectedRight <=blackThreshold && reflectedLeft <=blackThreshold)
        reflectedRight =  readLightIntensity(ColorSensorRight, 'reflected');
        reflectedLeft =  readLightIntensity(ColorSensorLeft, 'reflected');
    end
%}

% LOOP FOR ROBOT BEHAVIOUR
while( true )
    
    % sensor reading
    distance = readDistance(myUltrasonicSensor);
    reflectedRight =  readLightIntensity(ColorSensorRight, 'reflected');
    reflectedLeft =  readLightIntensity(ColorSensorLeft, 'reflected');
    avg = (reflectedLeft + reflectedRight)/2;
    
    fprintf('reflectedLeft: %d reflectedRight: %d distance: %f speed: %d avg %d\n', reflectedLeft, reflectedRight, distance, speed, avg);
    
    %CHECK OBSTACLE
    if (distance <distanceThreshold)
        stopMotors(motorLeft, motorRight);
        break;  % this is just for testing porposes,  TO DELETE
        % stay still until obstacle detected
        %{
            while(distance <distanceThreshold)
            distance = readDistance(myUltrasonicSensor);
         end
        %}        
    end
   
    % IF RIGHT SENSOR DETECT BLACK LINE
    if(reflectedRight <blackThreshold)
        turn( 'right', motorLeft, motorRight, normalSpeed)
    end

    % IF LEFT SENSOR DETECT BLACK LINE
    if(reflectedLeft <blackThreshold)
        turn( 'left', motorLeft, motorRight, normalSpeed)
    end
   
    % SETUP SPEED    
    oldSpeed = speed;
    if((reflectedLeft >=nonBlackThreshold) && (reflectedRight >=nonBlackThreshold))
        speed = getSpeedByColor(reflectedRight, reflectedLeft, normalSpeed, slowSpeed, fastSpeed, oldSpeed);
    end
    %{
    % DETECT PARKING AREA
    if(isReflectivePurple(color))
        reachedParkingArea = true;
        % maybe also stop and check color  before start parking
        %break to go into parking procedure
    end
    %}
    motorLeft.Speed = speed;
    motorRight.Speed = speed;
    start(motorLeft);
    start(motorRight);
end

% parking procedure


stopMotors(motorLeft, motorRight);
clear all;

% ---- Functions

function [] = turn( direction, motorLeft, motorRight, normalSpeed)
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
    
    pause( 0.45 );
    stopMotors(motorLeft, motorRight);
end

function [] = stopMotors(motorLeft, motorRight)
    stop(motorLeft, 1);
    stop(motorRight, 1);
end

function speed = getSpeedByColor(reflectedRight, reflectedLeft, normalSpeed, slowSpeed, fastSpeed, oldSpeed)
    
    delta = reflectedRight - reflectedLeft;
    if(delta <0)
        delta= delta*-1;
    end
    if(delta > 15)
        speed = oldSpeed;
        return;
    end
    
    color = (reflectedRight + reflectedLeft)/2;
    
    if(isReflectiveWhite(color))
        speed = normalSpeed;
        return;
    end
    
    if(isReflectiveRed(color))
        speed = fastSpeed;
        return;
    end
    
    if(isReflectiveGrey(color))
        speed = slowSpeed;
        return;
    end
    
    speed = oldSpeed;
end

function boolean = isReflectiveWhite(color)
    boolean = (color >= 80);
end

function boolean = isReflectiveRed(color)
    boolean = (color >= 65 && color <= 75);
end

function boolean = isReflectivePurple(color)
    boolean = (color >= 40 && color <= 45);
end

function boolean = isReflectiveGrey(color)
    boolean = (color >= 20 && color <= 34);
end