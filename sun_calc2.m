figure('Name','Sun animation','NumberTitle','off');
y_sun = [linspace(-1,1) linspace(1, -1)];
x_sun = zeros(1,length(y_sun));
for i=1:length(y_sun)
    pause(0.001);
    plot(x_sun(i),y_sun(i),'yo','Markersize',70,'MarkerFaceColor','y');%yo means circle
    set(gca,'Color','c');
    x = [-2 -2 2 2];
    y = [0 -2 -2 0];
    patch(x,y,[0.4660 0.6740 0.1880])
    axis([-2 2 -2 2]);
end





latitude=46.77;
longitude=23.58;%coordinates of Cluj Napoca
today = datetime("today","TimeZone","UTC");%gets the current date
first_midnight = dateshift(today,"start","year");%the first midnight of the year
first_midnight_next_year = dateshift(today,"start","year","next");%first midnight of the next year
middays = (first_midnight+hours(12)):caldays(1):first_midnight_next_year;%sets date to the midday of every day of the year

%Those dates and times are needed for the calculations next

y = 360*(day(middays,'dayofyear')-81)/365;%this is the formula for the solar declination
eq_of_time = minutes(9.87*sind(2*y) - 7.53*cosd(y) - 1.5*sind(y));%this is the value in minutes for the equation of time, plotted below
%figure(1);
%figure('Name','The value of the equation of time','NumberTitle','off');
%plot(middays,eq_of_time, "LineWidth", 2);%plot showing how the value of the equation of time changes around the year
%hold on;
%xlabel('Date')
%ylabel('Equation of time')
%line(middays,minutes(zeros(size(middays))),'Color','r');


year_fraction = (middays - first_midnight) ./ (first_midnight_next_year - first_midnight);%year fraction at midday every day around the year
gamma = 2*3.1415*year_fraction;%transformed in radians
solar_decl = 0.006918-0.399912*cos(gamma)+0.070257*sin(gamma)-0.006758*cos(2*gamma)+0.000907*sin(2*gamma)-0.002697*cos(3*gamma)+0.00148*sin(3*gamma);
hour_angle = acosd((cosd(90.833)./(cosd(latitude).*cos(solar_decl))) - tand(latitude).*tan(solar_decl));%for the special case of sunrise or sunset, the zenith is set to 90.833 


%sunrise = middays - minutes(4*(longitude + hour_angle)) - eq_of_time;
%sunset  = middays - minutes(4*(longitude - hour_angle)) - eq_of_time;%all 4 of these calculations are from the PDF with solar equations provided in the documentation
time_zone="+03:00";
sunrise.TimeZone = time_zone;
sunset.TimeZone = time_zone;%we adjust the timezone to Romania's timezone which is GMT+2, but because of daylight saving time, used ...
%between March and October, we use +3 for accurate earliest sunrise and latest sunset
%figure(2);
%figure('Name','The sunset and sunrise around the year','NumberTitle','off');
%plot(middays,timeofday(sunrise),middays,timeofday(sunset), "LineWidth", 3);%plot showing how the sunrise and sunset times vary around the year with error of about 20 minutes
%hold off;
%title("Sunrise and Sunset")
%xlabel("Date"); ylabel("Hours of the day")
%ylim(hours([0 24]));

Fig=figure('Name','Project',...
'Units','normalized',...
'NumberTitle','off',...
'Position',[0.1 0.1 0.8 0.8],...
'Color',[204 153 255]./255);
h = uimenu('Label','User Menu');
%creates the menu item that displays the JPG image for LPF
%with accelerator Ctrl+L
uimenu(h,'Label','Geospatial data','Callback','geospatialdata' ,...
 'Accelerator','L');
uimenu(h,'Label','Documentation','Callback','docu' ,...
 'Accelerator','D');
%creates the menu item that closes the window
%with accelerator Ctrl+Q
uimenu(h,'Label','Save','Callback','save');
uimenu(h,'Label','Close','Callback','close',...
 'Separator','on','Accelerator','Q');

% button indicating default values
% if the initial values are changed, the text in this button
% should be modified too!!!
str = "Default values: Latitude=46.77";
str2="!!Small disclaimer: In reality, latitude coordinates go from -90 to 90, but because these calculations are not 100% accurate and have an error of maximum 20 minutes, please only enter latitudes between -65 and 65, or else the program won't work :)"
str=str+"                             Longitude=23.58";
str=str+newline+"                          Time zone=+03:00";
str2=str2+newline+"!!Also, when changing coordinates and the time zone, please click outside of the edit box first for the value to be modified and only then modify another value :)";
%str = str + newline + "A stately pleasure-dome decree"
uicontrol('Style','text',...
'Units','normalized',...
'Position',[0.55 0.83 0.24 .12],...
'Backgroundcolor',[204 153 255]./255,...
'FontName','Arial',...
'FontWeight','bold',...
'FontSize',16,...
'String',str);
uicontrol('Style','text',...
'Units','normalized',...
'Position',[0.55 0.08 0.29 .1],...
'Backgroundcolor',[204 153 255]./255,...
'FontName','Arial',...
'FontWeight','bold',...
'FontSize',8,...
'String',str2);
%call of the function file creating the graphics objects
%inside the interface


interfata(latitude,longitude,time_zone);