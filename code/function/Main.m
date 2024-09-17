clear
clc
tic
clear
load('.\data.mat');
data = data';
target = labels';
original_target = original_target(:,2)';
[full_index]=find(sum(data)==size(data,1));
data(:,full_index)=[];

oldOptmParameter=struct('alpha_searchrange',[0.001,0.01,0.1,1,10],'beta_searchrange',[0.001,1,10],'gamma_searchrange',[10,100],...
    'lambda_searchrange',[100],'miu_searchrange',[1],'maxIter',100,'minimumLossMargin',0.01,'outputtempresult',0,'drawConvergence',0,'bQuiet',0);
TSKoptions=struct('k_searchrange',[2],'h_searchrange',[0.1,1,10,100,1000]);

[ Result ] = adaptive_validate( data, target,original_target, oldOptmParameter,TSKoptions);
toc


