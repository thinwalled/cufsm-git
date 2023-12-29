function [d_part]=longtermpart(nnodes,mode,m_a)
%


%
% nnodes=length(node(:,1));
% mode=shapes(:,22,1);
ddd=0;
totalm=length(m_a);%Total number of longitudinal terms
for mn=1:1:totalm
    dg(:,mn)=mode((mn-1)*4*nnodes+1:(mn)*4*nnodes);
    dg_norm(mn,1)=norm(dg(:,mn));
    ddd=dg_norm(mn,1)+ddd;
end
d_part=dg_norm./ddd;%norm(dg_norm,2);
% hist(d_norm);hold on
% bar(m_a,d_part)