whos

% for i=1:length(lengths)
%     clas(i,1:4)=mode_class(b_v,shapes(:,i,mod),ndm,nlm);
% end

mod = 1:1:4;

figure(2)
title('Standard finite strip half-wavelength vs. lambda curve')
subplot(2, 1, 1)
semilogx(lengths, curve(:, 2, mod))
axis tight

subplot(2, 1, 2)
title('Contribution of buckling modes')
semilogx(lengths, clas(:, 1), '-.', lengths, clas(:, 2), ':', lengths, clas(:, 3), '--', lengths, clas(:, 4), '-'), legend('Global', 'Distortional', 'Local', 'Other')
axis tight
