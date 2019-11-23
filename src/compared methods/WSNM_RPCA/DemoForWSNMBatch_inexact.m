%%������ֵʵ�飬��WNNM��RPCA���ȥ��RPCA�Ա�
%%
clc
clear
addpath exact_alm_rpca inexact_alm_rpca
m=300;

%num=5;
Accur_WNNM=0;rank_WNNM=0;E_WNNM_0=0;

pr = [0.01:0.01:0.5];
ps = [0.01:0.01:0.5];
error_mat = zeros(length(pr), length(ps));
rank_mat  = zeros(length(pr), length(ps));
sparse_num = zeros(length(pr), length(ps));
C = 50; C_step = 0.6;

if exist('E:\8G\WSNM_RPCA_p\batch_plot\WSNM_error_matrix_state.mat')
   run_state = load('E:\8G\WSNM_RPCA_p\batch_plot\WSNM_error_matrix_state.mat');
   ii = run_state.i;
   jj = run_state.j+1;
   C = run_state.C - C_step;
   %ii = 11;
   %jj = 28;
   error_state = load('E:\8G\WSNM_RPCA_p\batch_plot\WSNM_error_matrix.mat');
   error_mat = error_state.error_mat;
   rank_mat  = error_state.rank_mat;
   sparse_num = error_state.sparse_num;
   first = 1;
   
   for i=ii:length(pr)
        if first==0;
            jj = 1;
        end
        for j=jj:length(ps)
            r=round(pr(i)*m);
            EL0=round(m*m*ps(j));
        
            %construct low rank matrix for recovering
            U=normrnd(0,1,m,r);V=normrnd(0,1,m,r);
            A0=U*V';
            E=zeros(m,m);
            Ind = randperm(m*m);
            % �ڵ��Ⱦ����ϼ���ϡ������
            E(Ind(1:EL0))=100*rand(1,EL0)-50; %[-50,50]
            D=A0+E;
        
            %perform WNNM-RPCA
            fprintf('----pr=%3f--------ps=%3f------\n', pr(i), ps(j));
%             if (mod(i,10)==0 && j==1)
%                 C = C - 8; %CԽ��p_r��,p_eСʱ��Ȼ��Ч
%                        %CԽС��p_rС,p_e��ʱ��Ȼ��Ч
%             end
            [A_WNNM E_WNNM ]=inexact_alm_WSNMrpca(D, C, 0.7); %C=5
            %[A_WNNM E_WNNM ]= inexact_alm_WSNMrpca(D, 4, 1); %C=5
            Accur_WNNM=(sum(sum((A_WNNM-A0).^2))).^0.5/(sum(sum(A0.^2))).^0.5;
            rank_WNNM=rank(A_WNNM);
            E_WNNM_0=length(find(abs(E_WNNM)>0));
            disp(['WSNM����:  ' num2str(Accur_WNNM ) ',  �ȣ�'  num2str(rank_WNNM)  ',  |E|_0;'  num2str(E_WNNM_0)]);
            disp('--------------------------------------');
        
            error_mat(i,j) = Accur_WNNM;
            rank_mat(i,j) = rank_WNNM;
            sparse_num(i,j) = E_WNNM_0;
           
        
            %save state
            save('E:\8G\WSNM_RPCA_p\batch_plot\WSNM_error_matrix_state.mat','i','j', 'C', 'C_step');
            save('E:\8G\WSNM_RPCA_p\batch_plot\WSNM_error_matrix.mat','error_mat');
        end
        first = 0;
        C = C - C_step;
   end
   return;
end

for i=1:length(pr)
    for j=1:length(ps)
        r=round(pr(i)*m);
        EL0=round(m*m*ps(j));
        
        %construct low rank matrix for recovering
        U=normrnd(0,1,m,r);V=normrnd(0,1,m,r);
        A0=U*V';
        E=zeros(m,m);
        Ind = randperm(m*m);
        % �ڵ��Ⱦ����ϼ���ϡ������
        E(Ind(1:EL0))=100*rand(1,EL0)-50;  %[-50,50]
        D=A0+E;
        
        %perform RPCA
        fprintf('----pr=%3f--------ps=%3f------\n', pr(i), ps(j));
        [A_WNNM E_WNNM ]= inexact_alm_WSNMrpca(D, C, 0.7); %C=5
        
        %[A_WNNM E_WNNM ]= inexact_alm_WSNMrpca(D, 8, 1); %C=5
        Accur_WNNM=(sum(sum((A_WNNM-A0).^2))).^0.5/(sum(sum(A0.^2))).^0.5;
        rank_WNNM=rank(A_WNNM);
        E_WNNM_0=length(find(abs(E_WNNM)>0));
        disp(['WSNM����:  ' num2str(Accur_WNNM ) ',  �ȣ�'  num2str(rank_WNNM)  ',  |E|_0;'  num2str(E_WNNM_0)]);
        disp('--------------------------------------');
        
        error_mat(i,j) = Accur_WNNM;
        rank_mat(i,j) = rank_WNNM;
        sparse_num(i,j) = E_WNNM_0;
        
        %save state
        save('E:\8G\WSNM_RPCA_p\batch_plot\WSNM_error_matrix_state.mat','i','j', 'C', 'C_step');
        save('E:\8G\WSNM_RPCA_p\batch_plot\WSNM_error_matrix.mat','error_mat', 'rank_mat', 'sparse_num');
    end
    % update C
    C = C - C_step;
end

% disp(['inexactWNNM����:   ' num2str(Accur_iWNNM ) '.     �ȣ�'  num2str(rank_iWNNM)  '.    |E|_0;'  num2str(E_iWNNM_0)  '.    ʱ�䣺' num2str(time_iWNNM) '.' ])
% disp(['iNNM����:          ' num2str(Accur_iNNM ) '.     �ȣ�'  num2str(rank_iNNM)  '.     |E|_0;'  num2str(E_iNNM_0)  '.   ʱ�䣺' num2str(time_iNNM) '.' ])
% disp(['��'  num2str(r) '|E|_0' num2str(EL0)])
% disp(['inexactNNM����:    ' num2str(Accur_iNNM ) '.     �ȣ�'  num2str(rank_iNNM)  '.     ʱ�䣺' num2str(time_iNNM) '.' ])
% %
