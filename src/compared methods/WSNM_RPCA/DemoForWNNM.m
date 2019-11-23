%%������ֵʵ�飬��WNNM��RPCA���ȥ��RPCA�Ա�
%%
clc
clear
addpath exact_alm_rpca inexact_alm_rpca
pr=0.05:0.05:0.5; %rank ratio [0.01, 0.5]
ps=[0.05, 0.1, 0.15, 0.2, 0.25]; %sparse error ratio [0.01, 0.5]
m=400;

num=1;
error_mat_nnm = zeros(length(ps), length(pr));  rank_mat_nnm = zeros(length(ps), length(pr));   sparse_mat_nnm = zeros(length(ps), length(pr));
error_mat_wnnm = zeros(length(ps), length(pr)); rank_mat_wnnm = zeros(length(ps), length(pr));  sparse_mat_wnnm = zeros(length(ps), length(pr));
error_mat_wsnm1 = zeros(length(ps), length(pr));rank_mat_wsnm1 = zeros(length(ps), length(pr)); sparse_mat_wsnm1 = zeros(length(ps), length(pr));
error_mat_wsnm2 = zeros(length(ps), length(pr));rank_mat_wsnm2 = zeros(length(ps), length(pr)); sparse_mat_wsnm2 = zeros(length(ps), length(pr));

for s_idx = 4:4
    ps_cur = ps(s_idx);
    
    for j = 1:8
        pr_cur = pr(j);
        
        %---------------------------------
        r=round(pr_cur*m);
        EL0=round(m*m*ps_cur);
        
        %each num inner iteration, initalize the following:
        time_NNM=0;Accur_NNM=0;rank_NNM=0;E_NNM_0=0;
        time_WNNM=0;Accur_WNNM=0;rank_WNNM=0;E_WNNM_0=0;
        time_WSNM_1=0;Accur_WSNM_1=0;rank_WSNM_1=0;E_WSNM_error1=0;
        time_WSNM_2=0;Accur_WSNM_2=0;rank_WSNM_2=0;E_WSNM_error2=0;

        for i=1:num
            % �����������Ⱦ���
            U=normrnd(0,1,m,r);V=normrnd(0,1,m,r);
            A0=U*V';
            E=zeros(m,m);
            Ind = randperm(m*m);
            % �ڵ��Ⱦ����ϼ���ϡ������
            E(Ind(1:EL0))=100*rand(1,EL0)-50;
            D=A0+E;
    
            %RPCA��������ǣ������۲����D����ԭ�� A��E����Ҫ��A
%             tic;
%             [A_NNM E_NNM ]=exact_alm_rpca(D, 1 / sqrt(m));
%             time_NNM=toc+time_NNM;
%             Accur_NNM=(sum(sum((A_NNM-A0).^2))).^0.5/(sum(sum(A0.^2))).^0.5+Accur_NNM;
%             rank_NNM=rank(A_NNM)+rank_NNM;
%             E_NNM_0=length(find(abs(E_NNM)>0))+E_NNM_0;
%             disp(['NNM����:          ' num2str(Accur_NNM ) '.     �ȣ�'  num2str(rank_NNM)  '.    |E|_0;'  num2str(E_NNM_0)  '.   ʱ�䣺' num2str(time_NNM) '.' ])
%              disp('--------------------------------------');
%     
%     
            tic
            [A_WNNM E_WNNM ]=inexact_alm_WSNMrpca(D, 4, 1);
            time_WNNM=toc+time_WNNM;
            Accur_WNNM=(sum(sum((A_WNNM-A0).^2))).^0.5/(sum(sum(A0.^2))).^0.5+Accur_WNNM;
            rank_WNNM=rank(A_WNNM)+rank_WNNM;
            E_WNNM_0=length(find(abs(E_WNNM)>0))+E_WNNM_0;
            tic;
            disp(['WNNM����:          ' num2str(Accur_WNNM ) '.     �ȣ�'  num2str(rank_WNNM)  '.    |E|_0;'  num2str(E_WNNM_0)  '.   ʱ�䣺' num2str(time_WNNM) '.' ])
            disp('--------------------------------------');
    
            tic;
            [A_WSNM_1 E_WSNM_1 ]=inexact_alm_WSNMrpca(D, 40, 0.7);
            time_WSNM_1=toc+time_WSNM_1;
            Accur_WSNM_1=(sum(sum((A_WSNM_1-A0).^2))).^0.5/(sum(sum(A0.^2))).^0.5+Accur_WSNM_1;
            rank_WSNM_1=rank(A_WSNM_1)+rank_WSNM_1;
            E_WSNM_error1=length(find(abs(E_WSNM_1)>0))+E_WSNM_error1;
            disp(['WSNM_1����:          ' num2str(Accur_WSNM_1 ) '.     �ȣ�'  num2str(rank_WSNM_1)  '.    |E|_0;'  num2str(E_WSNM_error1)  '.   ʱ�䣺' num2str(time_WSNM_1) '.' ])
            disp('--------------------------------------');
%     
            tic;
            [A_WSNM_2 E_WSNM_2 ]=inexact_alm_WSNMrpca(D, 190, 0.4);
            time_WSNM_2=toc+time_WSNM_2;
            Accur_WSNM_2=(sum(sum((A_WSNM_2-A0).^2))).^0.5/(sum(sum(A0.^2))).^0.5+Accur_WSNM_2;
            rank_WSNM_2=rank(A_WSNM_2)+rank_WSNM_2;
            E_WSNM_error2=length(find(abs(E_WSNM_2)>0))+E_WSNM_error2;
            disp(['WSNM_2����:          ' num2str(Accur_WSNM_2 ) '.     �ȣ�'  num2str(rank_WSNM_2)  '.    |E|_0;'  num2str(E_WSNM_error2)  '.   ʱ�䣺' num2str(time_WSNM_2) '.' ])
            disp('--------------------------------------');
    
        end
        time_WNNM=time_WNNM/num;Accur_WNNM=Accur_WNNM/num;rank_WNNM=rank_WNNM/num;E_WNNM_0=E_WNNM_0/num;
        time_WSNM_1=time_WSNM_1/num;Accur_WSNM_1=Accur_WSNM_1/num;rank_WSNM_1=rank_WSNM_1/num;E_WSNM_error1=E_WSNM_error1/num;
        time_WSNM_2=time_WSNM_2/num;Accur_WSNM_2=Accur_WSNM_2/num;rank_WSNM_2=rank_WSNM_2/num;E_WSNM_error2=E_WSNM_error2/num;
        time_NNM=time_NNM/num;Accur_NNM=Accur_NNM/num;rank_NNM=rank_NNM/num;E_NNM_0=E_NNM_0/num;
        % time_iNNM=time_iNNM/num;Accur_iNNM=Accur_iNNM/num;rank_iNNM=rank_iNNM/num;E_iNNM_0=E_iNNM_0/num;

        
        error_mat_nnm(s_idx, j) = Accur_NNM; rank_mat_nnm(s_idx, j) = rank_NNM; sparse_mat_nnm(s_idx, j) = E_NNM_0;
        error_mat_wnnm(s_idx, j) = Accur_WNNM; rank_mat_wnnm(s_idx, j) = rank_WNNM; sparse_mat_wnnm(s_idx, j) = E_WNNM_0;
        error_mat_wsnm1(s_idx, j) = Accur_WSNM_1; rank_mat_wsnm1(s_idx, j) = rank_WSNM_1; sparse_mat_wsnm1(s_idx, j) = E_WSNM_error1;
        error_mat_wsnm2(s_idx, j) = Accur_WSNM_2; rank_mat_wsnm2(s_idx, j) = rank_WSNM_2; sparse_mat_wsnm2(s_idx, j) = E_WSNM_error2;
        save('Matrix_nnm.mat','error_mat_nnm','rank_mat_nnm', 'sparse_mat_nnm');
        save('Matrix_wnnm.mat','error_mat_wnnm','rank_mat_wnnm', 'sparse_mat_wnnm');
        save('Matrix_wsnm1.mat','error_mat_wsnm1','rank_mat_wsnm1', 'sparse_mat_wsnm1');
        save('Matrix_wsnm2.mat','error_mat_wsnm2','rank_mat_wsnm2', 'sparse_mat_wsnm2');
    end %for j = 0.05:0.05:0.4
end %for s_idx = 1:4