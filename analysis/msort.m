function [m_all]=msort(m_all);
%
%this routine is to clean up 0's, multiple longitudinal terms. or out-of-order terms in m_all

%m_all: m_all{length#}=[longitudinal_num# ... longitudinal_num#],longitudinal terms m for all the lengths in cell notation 
    % each cell has a vector including the longitudinal terms for this
    % length
% Z. Li, June 2010

nlengths=max(size(m_all));
for i=1:nlengths
    m_a=m_all{i};
    m_a=unique(m_a); % remove repetive longitudinal terms
    m_a=nonzeros(m_a); %return all the nonzeros longitudinal terms in m_a as a column vector
    m_a=sort(m_a); % order the longitudinal terms    
    m_all{i}=m_a';
end
