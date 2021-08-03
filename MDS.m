
aaa=xlsread('sss.xlsx');
[~,name]=xlsread('name.xlsx');
XX=mdscale(aaa,2);
label = linspace(1,26,26)';
new_map=zeros(26,3);
new_map(:,1)=XX(:,1);
new_map(:,2)=-XX(:,2);
new_map(:,3)=label;
scatter(new_map(:,1),new_map(:,2),'*','r');
text(new_map(:,1),new_map(:,2),name,'FontSize',16,'HorizontalAlignment','center')
title('Reconstructed map','FontSize',18);
grid on