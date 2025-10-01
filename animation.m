clear all
close all

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
