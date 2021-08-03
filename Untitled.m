clear all
% Read the distance matrix
aaa = xlsread('sss.xlsx');
% Apply MDS algorithm to reconstruct the map
XX = mdscale(aaa,2);
label = linspace(1,26,26)';
new_map = zeros(26,3);
new_map(:,1) = XX(:,1);
new_map(:,2) = -XX(:,2);
new_map(:,3) = label;

b=new_map(2,:);
new_map(2,:) = new_map(1,:);
new_map(1,:) = b;
s.xy = new_map(:,1:2);
jud=0;
% Set up parameters
salesmen_num = 1; % set the number of salesman to 1 at first
max_dist = 30; % set the maximum distance for each subtour
s.minTour     = 3; % minimum number of suburbs in one tour
s.popSize     = 80; % population size
s.numIter     = 7e3; % number of iteration
s.showProg    = true;
s.showResult  = true;
s.showWaitbar = false;
while jud==0
    s.nSalesmen   = salesmen_num;
    varargout = mtspf_ga_new(s);
    route=varargout.optRoute;
    breakpoint=varargout.optBreak;
    route_num=length(breakpoint)+1;%5
    full_br=[0,[breakpoint],25];%6
    all_route=zeros(route_num,27);

    for i=1:length(full_br)-1
        single=route(full_br(i)+1:full_br(i+1));
        all_route(i,1:length(single))=single;
    end

    all_route=[ones(route_num,1),all_route];
    all_route(all_route==0) = 1;

    [x,y]=size(all_route);
    for i=1:x
        for j=1:y
            index=all_route(i,j);
            all_route(i,j)=new_map(index,3);
        end
    end
    distance=zeros(route_num,1);
    sum=0;
    for i=1:route_num
        sum=0;
        for j=1:length(all_route)-1
            x_c= all_route(i,j);
            y_c= all_route(i,j+1);
            sum=sum+aaa(x_c,y_c);
        end
        distance(i,1)=sum;
    end
    jud = all(distance(:) <= max_dist);
    salesmen_num = salesmen_num+1;
end

[~,name]=xlsread('name.xlsx');
[row,col]=size(all_route);
name_route={};
for i=1:row
    for j=1:col
        name_route(i,j)=name(all_route(i,j));
    end
end

for i=1:row
    time=0;
    for j=1:col
        if isequal(name_route(i,j),{'Belconnen Town Centre'})
            time=time+1;
        end
        if time>2 && isequal(name_route(i,j),{'Belconnen Town Centre'})
        name_route(i,j)={[]};
        end
    end
end