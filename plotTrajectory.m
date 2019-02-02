clear all;clc; clearvars; close all

S1 = load('Image1.mat');
S2 = load('Image2.mat');
S3 = load('Image3_v2.mat');
S4 = load('Image3_v3.mat');
close all;

Trajectory1 = S1.loc_arr;
Trajectory2 = S2.Location;
Trajectory3 = S3.locations;
Trajectory4 = S4.locations;

figure
subplot(1,2,1)
hold on 
plot3(-Trajectory1(:,1), zeros(size(Trajectory1,1),1), Trajectory1(:,2),'Color','r','LineWidth',2)
plot3(-Trajectory2(1,:), zeros(length(Trajectory2(1,:)),1), -Trajectory2(3,:),'Color','b','LineWidth',2);
hold off
xlabel('X (m)'); ylabel('Y (m)'); zlabel('Z (m)');
view([0 0]); grid on
legend('Without builtin functions','With builtin functions','Location','northeastoutside')
set(gca,'fontsize',14);
set(gca,'Xdir','reverse'); set(gca,'Zdir','reverse');

subplot(1,2,2)
hold on
plot3(-Trajectory1(:,1), zeros(size(Trajectory1,1),1), Trajectory1(:,2),'Color','r','LineWidth',2)
plot3(Trajectory3(:,1),zeros(size(Trajectory3,1),1),Trajectory3(:,3),'Color','k','LineWidth',2)
hold off
xlabel('X (m)'); ylabel('Y (m)'); zlabel('Z (m)');
view([0 0]); grid on
legend('Without builtin functions','A hybrid code','Location','northeastoutside')
set(gca,'Xdir','reverse'); set(gca,'Zdir','reverse');
set(gca,'fontsize',14);

figure
hold on
plot3(-Trajectory1(:,1), zeros(size(Trajectory1,1),1), Trajectory1(:,2),'Color','r','LineWidth',2)
plot3(-Trajectory2(1,:), zeros(length(Trajectory2(1,:)),1), -Trajectory2(3,:),'Color','b','LineWidth',2);
plot3(Trajectory4(:,1),zeros(size(Trajectory4,1),1),Trajectory4(:,3),'Color','k','LineWidth',2)
hold off
xlabel('X (m)'); ylabel('Y (m)'); zlabel('Z (m)');
view([0 0]); grid on
legend('Without builtin functions','With builtin functions','A hybrid code','Location','northeast')
set(gca,'Xdir','reverse'); set(gca,'Zdir','reverse');
set(gca,'fontsize',14);