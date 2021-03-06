clear all;
clc;	
%% simulated experiment 2
% ----------------------------load image-----------------------------------
load simu_indian
Ohsi       = simu_indian;           
noiselevel = 0.1*ones(1,224); 

% ------------------------ Simulation experiment --------------------------
Nhsi      = Ohsi;
[M,N,p]   = size(Ohsi);
%% Gaussian noise
for i = 1:p
     Nhsi(:,:,i)=Ohsi(:,:,i)  + noiselevel(i)*randn(M,N);
end
%% dead line 
for i=91:130
    indp=randperm(10,1)+2;
    ind=randperm(N-1,indp);
    an=funrand(2,length(ind));
    % searching the location of an which value is 1,2,3
    loc1=find(an==1);loc2=find(an==2);loc3=find(an==3);
    Nhsi(:,ind(loc1),i)=0; 
    Nhsi(:,ind(loc2):ind(loc2)+1,i)=0;
    Nhsi(:,ind(loc3)-1:ind(loc3)+1,i)=0;
end  
%% TV sparsity denoising
%% TV sparsity denoising
%output_image = EnhancedRPCA(Nhsi);
% D = reshape(Nhsi,[M*N,p]);
% [A_hat,E_hat,iter] = inexact_alm_rpca(D);
% output_image = reshape(A_hat,[M,N,p]);
output_image = SGSPCA(Nhsi);
[mpsnr,mssim,ergas]=msqia(Ohsi,output_image);
