whos
%
% for i=1:length(lengths)
%     clas(i,1:4)=mode_class(b_v,shapes(:,i,mod),ndm,nlm);
% end
%
mod=[1:1:4];
figure(2)
subplot(2,1,1)
semilogx(lengths,curve(:,2,mod))
title('standard finite strip half-wavelength vs. lambda curve'), axis tight %axis([10 1e5 0 5])
subplot(2,1,2)
semilogx(lengths,clas(:,1),'-.',lengths,clas(:,2),':',lengths,clas(:,3),'--',lengths,clas(:,4),'-'),legend('global','distortional','local','other'),axis tight
title('contribution of buckling modes')
