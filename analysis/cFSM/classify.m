function [clas]=classify(prop,node,elem,lengths,shapes,GBTcon,BC,m_all);%,clas_GDLO
%MODAL CLASSIFICATION
%

%
%input
%prop: [matnum Ex Ey vx vy G] 6 x nmats
%node: [node# x z dofx dofz dofy dofrot stress] nnodes x 8;
%elem: [elem# nodei nodej t matnum] nelems x 5;
%lengths: lengths to be analyzed
%shapes: array of mode shapes dof x lengths x mode
%method:
%   method=1=vector norm
%   method=2=strain energy norm
%   method=3=work norm
%
%
%output
%clas: array or % classification

%BWS August 29, 2006
%modified SA, Oct 10, 2006
%Z.Li, June 2010

wait_message=waitbar(0,'Performing Modal Classification'); %callback for cancel is at the end of strip
%
nnodes = length(node(:,1));
ndof_m= 4*nnodes;

%CLEAN UP INPUT
%clean up 0's, multiple terms. or out-of-order terms in m_all
[m_all]=msort(m_all);

%loop for the lengths
nlengths = length(lengths);
l=0; %length_index = one
while l<nlengths 
	l=l+1; %length index = length index + one
    %
    a=lengths(l);
    %longitudinal terms included in the analysis for this length
    m_a=m_all{l};   
    [b_v_l,ngm,ndm,nlm]=base_column(node,elem,prop,a,BC,m_a);
    %orthonormal vectors
    b_v=base_update(GBTcon.ospace,GBTcon.norm,b_v_l,a,m_a,node,elem,prop,ngm,ndm,nlm,BC,GBTcon.couple,GBTcon.orth);
    %
    %classification
    for mod=1:length(shapes{l}(1,:))
        mode=shapes{l}(:,mod); 
        clas{l}(mod,1:4)=mode_class(b_v,mode,ngm,ndm,nlm,m_a,ndof_m,GBTcon.couple);   
    end
   	info=['Length ',num2str(lengths(l)),' done.'];
	waitbar(l/nlengths);
end
%delete waitbar
if ishandle(wait_message)
    delete(wait_message);
end
