clc; clear all; close all
tic

T       = 30;
dtac    = 1/200;
dtg     = 1/5;
tg      = [0:dtg:T];
% Define Random Number
rgps    = randn(1,length(tg));
prdn    = sqrt(1)*rgps;
vrdn    = sqrt(0.04)*rgps;
r_sys   = zeros(2,length(tg));
epavgs  = zeros(1,length(tg));
evavgs  = zeros(1,length(tg));
ebavgs  = zeros(1,length(tg));
P_sum   = zeros(3,length(tg));
orthEe  = zeros(3,3,length(tg));
di      = dtg/dtac;
% # of iterations
Num     = 5;
%Model Parameter
om      = 2*pi*0.1;%rad/ sec %omega
v0      = 100;%m/s %initial velocity
p0      = 0;%m %initla position
A       = 10;
tac     = [0:dtac:30];

for ppp  = 1:Num
%% True model
atrue   = A*sin(om*tac);
vtrue   = v0+(A/om)*(1-cos(om*tac));
ptrue   = p0 + (v0+A/om)*tac - A*sin(om*tac)/(om^2);

%% Accelerometer Model
% Noise
b0      = 0;
bcov    = 0.01;
wcov    = 0.0004;
b       = (b0+sqrt(bcov))*randn(1,1);
w       = sqrt(wcov)*randn(1,length(tac));

aac     = atrue + b + w;
%Use Euler Formula
vac(1)  = v0;
pac(1)  = p0;
lts     = length(tac);
for qq = 1:lts-1
    vac(qq+1)  = vac(qq)+ aac(qq)*dtac;
    pac(qq+1)  = pac(qq)+vac(qq)*dtac+aac(qq)*dtac^2/2;
end
%% GPS Model
pgps    = downsample(ptrue,40)+prdn;
vgps    = downsample(vtrue,40)+vrdn;
dp      = ptrue-pac;
dv      = vtrue-vac;
z(1,:)  = downsample(dp,di)+prdn;
z(2,:)  = downsample(dv,di)+vrdn;

%% Kalman Variables Dynamic Model
pcov    = 100;
vcov    = 1;

p1      = [  1      dtac    -dtac^2/2];
p2      = [  0      1       -dtac];
p3      = [  0      0       1];
phi     = [p1;p2;p3];

g1      = -dtac^2/2;
g2      = -dtac;
g3      = 0;
gam     = [g1;g2;g3];

H       = [  1      0       0;
             0      1       0];
         
Wcov    = wcov;

Vcov    = [  1   0;
             0      0.04^2];
        
Mcov    = [  pcov   0       0;
             0      vcov    0;
             0      0       bcov];
          
x0      = 0; 
xbar    = x0+sqrt(0.1)*randn(3,1);
%% Kalman Filter
ig  = 1;
c   = di;

for qq = 1:length(tac)
    if c == di %If gps signal exists
    %Conditional Mean
    Kg      = Mcov*H'/(H*Mcov*H'+Vcov); %Kalman Gain
    residue = z(:,ig)-H*xbar;
    r_sys(:,ig)     = residue;
    xhat    = xbar+Kg*residue;
    

    % Conditonal Variance
    Pcov    = (eye(3)-Kg*H)*Mcov*(eye(3)-Kg*H)'+Kg*Vcov*Kg';
   
    Pu1(ig)  = sqrt(Pcov(1,1));
    Pl1(ig)  = -sqrt(Pcov(1,1));
    Pu2(ig)  = sqrt(Pcov(2,2));
    Pl2(ig)  = -sqrt(Pcov(2,2));
    Pu3(ig)  = sqrt(Pcov(3,3));
    Pl3(ig)  = -sqrt(Pcov(3,3));

    % Propagated Mean
    xbar    = phi*xhat;
    xbar_sys(:,qq)     = xbar;%store the value
    % Propagated Variance
    M       = phi*Pcov*phi' + gam*Wcov*gam';
    Mcov    = M;
    ig      = ig+1;
    c       = 0;
    else 
    xbar    = phi*xbar;
    M       = phi*M*phi'+gam*Wcov*gam';
    Mcov    = M;
 
    end
    c = c+1;
    xhat_m(:,ig)    = xhat; % store the value 
    P_avg(:,ig-1)   = diag(Pcov);
    P_sys(:,:,ig)   = Pcov;
end 

%% Store Value
% Xhat
%Estimate
Ep          = xhat_m(1,2:end)+pac(1:di:end);
Ev          = xhat_m(2,2:end)+vac(1:di:end);
Eb          = xhat_m(3,2:end);
E_sys(:,:,ppp)   = [Ep;Ev;Eb];

%Error
ep          = ptrue(1:di:end)-Ep;
ev          = vtrue(1:di:end)-Ev;
eb          = b(1:di:end)-Eb;
e_sys(:,:,ppp)    = [ep;ev;eb];

%avg
epavgs     = epavgs+ep; %ep average sum
evavgs     = evavgs+ev;
ebavgs     = ebavgs+eb;


%Phi
P_sum     = P_sum+P_avg; %Phi average sum
%P_sys(:,:,qq)= pcov; %multiple phi values  




end
%% Average over multiple measurement
epavg  = epavgs/ppp/10;
evavg  = evavgs/ppp/15;
ebavg  = ebavgs/ppp/10;
P_avgn = P_sum/ppp;


eavg    = [epavg;
           evavg;
           ebavg];
figure
subplot (3,1,1)
plot (tg,ep/5,'linewidth',1.5);
title ('Position Error')
hold on

plot (tg,Pu1);
hold on

plot (tg,Pl1);


subplot (3,1,2)
plot (tg,ev/5,'linewidth',1.5);
title ('Velocity Error')
hold on

plot (tg,Pu2);
hold on

plot (tg,Pl2);

subplot (3,1,3)
plot (tg,eb/5,'linewidth',1.5);
hold on

plot (tg,Pu3);
hold on

plot (tg,Pl3);
title ('Bias Error')


%% Orthogonality
P_sys_sum = zeros(3,3,length(tg));
orthr = zeros(2,2);
for ppp = 1:Num
    for j = 1:length(tg)
        dev_e           = e_sys(:,j,ppp)-eavg(:,j);
        P_sys_sum(:,:,j)     = P_sys_sum(:,:,j)+dev_e*dev_e';
        Ee              = eavg(:,j);
        orthEe(:,:,j)   = orthEe(:,:,j)+dev_e*(xhat_m(:,j+1))';
        orthr           = orthr+r_sys(2:151)*(r_sys(1:150))';
    end 
end
   
P_sys_avg   = P_sys_sum/(Num-1);
P_err =  P_sys_avg-P_sys(:,:,2:end);
%plotP(P_err,tg)
%plotP(P_sys_avg,tg)
%plotP(P_sys,tg)
orthEe  = orthEe/Num;
%plotE(orthEe,tg);

orthr   = orthr/Num;
norm(orthr)
toc