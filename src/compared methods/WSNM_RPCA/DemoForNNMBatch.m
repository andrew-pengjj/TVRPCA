%%������ֵʵ�飬��WNNM��RPCA���ȥ��RPCA�Ա�
%%
clc
clear
addpath exact_alm_rpca inexact_alm_rpca
m=400;

%num=5;
Accur_NNM=0;rank_NNM=0;E_NNM_0=0;

pr = [0.01:0.01:0.5];
ps = [0.01:0.01:0.5];
error_mat = zeros(length(pr), length(ps));
rank_mat  = zeros(length(pr), length(ps));
sparse_num = zeros(length(pr), length(ps));
for i=20:length(pr)
    for j=30:length(ps)
        r=round(pr(i)*m);
        EL0=round(m*m*ps(j));
        
        %construct low rank matrix for recovering
        U=normrnd(0,1,m,r);V=normrnd(0,1,m,r);
        A0=U*V';
        E=zeros(m,m);
        Ind = randperm(m*m);
        % �ڵ��Ⱦ����ϼ���ϡ������
        E(Ind(1:EL0))=1000*rand(1,EL0)-500;
        D=A0+E;
        
        %perform RPCA
        fprintf('----pr=%3f--------ps=%3f------\n', pr(i), ps(j));
        [A_NNM E_NNM ]=exact_alm_rpca(D,1 / sqrt(m));
        Accur_NNM=(sum(sum((A_NNM-A0).^2))).^0.5/(sum(sum(A0.^2))).^0.5;
        rank_NNM=rank(A_NNM);
        E_NNM_0=length(find(abs(E_NNM)>0));
        disp(['NNM����:  ' num2str(Accur_NNM ) ',  �ȣ�'  num2str(rank_NNM)  ',  |E|_0;'  num2str(E_NNM_0)]);
        disp('--------------------------------------');
        
        error_mat(i,j) = Accur_NNM;
        rank_mat(i,j) = rank_NNM;
        sparse_num(i,j) = E_NNM_0;
    end
end

save('D:\SR\WSNM-new-exp\WSNM_RPCA\batch_plot\NNM_error_matrix.mat','error_mat', 'rank_mat', 'sparse_num');
% disp(['inexactWNNM����:   ' num2str(Accur_iWNNM ) '.     �ȣ�'  num2str(rank_iWNNM)  '.    |E|_0;'  num2str(E_iWNNM_0)  '.    ʱ�䣺' num2str(time_iWNNM) '.' ])
% disp(['iNNM����:          ' num2str(Accur_iNNM ) '.     �ȣ�'  num2str(rank_iNNM)  '.     |E|_0;'  num2str(E_iNNM_0)  '.   ʱ�䣺' num2str(time_iNNM) '.' ])
% disp(['��'  num2str(r) '|E|_0' num2str(EL0)])
% disp(['inexactNNM����:    ' num2str(Accur_iNNM ) '.     �ȣ�'  num2str(rank_iNNM)  '.     ʱ�䣺' num2str(time_iNNM) '.' ])
% %
