function [SigmaX,svp]=ClosedWNNM(SigmaY,C,oureps)
%��Ȩ�˷�����С������Ľ�����
%�����Ŀ�꺯������
%         sum(w*SigmaY)+1/2*||Y-X||_F^2
% ����w_i =C/(sigmaX_i+oureps),oureps��һ���㹻С�ĳ���
%
temp=(SigmaY-oureps).^2-4*(C-oureps*SigmaY);
ind=find (temp>0);
svp=length(ind);
SigmaX=max(SigmaY(ind)-oureps+sqrt(temp(ind)),0)/2;

end