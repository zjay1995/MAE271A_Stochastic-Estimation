function [] = plotP(P_avg,tg)

for i = 1:151
P11(i)     = P_avg(1,1,i);
P12(i)     = P_avg(1,2,i);
P13(i)     = P_avg(1,3,i);
P21(i)     = P_avg(2,1,i);
P22(i)     = P_avg(2,2,i);
P23(i)     = P_avg(2,3,i);
P31(i)     = P_avg(3,1,i);
P32(i)     = P_avg(3,2,i);
P33(i)     = P_avg(3,3,i);
end
figure
subplot(3,3,1)
plot(tg,P11,'.')
grid on
title ('P11')
xlim([0 30])


subplot(3,3,2)
plot(tg,P12,'.')
grid on
title ('P12')
xlim([0 30])


subplot(3,3,3)
plot(tg,P13,'.')
grid on
title ('P13')
xlim([0 30])

subplot(3,3,4)
plot(tg,P21,'.')
grid on
title ('P21')
xlim([0 30])

subplot(3,3,5)
plot(tg,P22,'.')
grid on
title ('P22')
xlim([0 30])

subplot(3,3,6)
plot(tg,P23,'.')
grid on
title ('P23')
xlim([0 30])

subplot(3,3,7)
plot(tg,P31,'.')
grid on
title ('P31')
xlim([0 30])

subplot(3,3,8)
plot(tg,P32,'.')
grid on
title ('P32')
xlim([0 30])

subplot(3,3,9)
plot(tg,P33,'.')
grid on
title ('P33')
xlim([0 30])

end 