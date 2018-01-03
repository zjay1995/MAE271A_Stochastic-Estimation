function [] = plotE(P_avg,tg)

for i = 1:151
E11(i)     = P_avg(1,1,i);
E12(i)     = P_avg(1,2,i);
E13(i)     = P_avg(1,3,i);
E21(i)     = P_avg(2,1,i);
E22(i)     = P_avg(2,2,i);
E23(i)     = P_avg(2,3,i);
E31(i)     = P_avg(3,1,i);
E32(i)     = P_avg(3,2,i);
E33(i)     = P_avg(3,3,i);
end
figure
subplot(3,3,1)
plot(tg,E11,'.')
grid on
title ('E11')
xlim([0 30])



subplot(3,3,2)
plot(tg,E12,'.')
grid on
title ('E12')
xlim([0 30])

subplot(3,3,3)
plot(tg,E13,'.')
grid on
title ('E13')
xlim([0 30])

subplot(3,3,4)
plot(tg,E21,'.')
grid on
title ('E21')
xlim([0 30])

subplot(3,3,5)
plot(tg,E22,'.')
grid on
title ('E22')
xlim([0 30])

subplot(3,3,6)
plot(tg,E23,'.')
grid on
title ('E23')
xlim([0 30])

subplot(3,3,7)
plot(tg,E31,'.')
grid on
title ('E31')
xlim([0 30])

subplot(3,3,8)
plot(tg,E32,'.')
grid on
title ('E32')
xlim([0 30])

subplot(3,3,9)
plot(tg,E33,'.')
grid on
title ('E33')
xlim([0 30])

end 