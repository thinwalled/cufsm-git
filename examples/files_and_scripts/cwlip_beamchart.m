%BWS
%5 August 2004
%Beam Chart Creation
%
%Load results file
load cwlip_Mx
%
%Elastic buckling results
%half-wavelngth (in.)
L=curve(:,1,1);
%buckling load factor Mcr/My
LF=curve(:,2,1);
%
%section
My=126.55; %kip-in
%
%LOCAL BUCKLING
%ignore any dependency of local buckling on length
for i=1:length(L)
    Mcrl_My(i,1)=LF(23);
end
%
%DISTORTIONAL BUCKLING
Mcrd_My_star=LF(46);
Lcrd=L(46);
for i=1:length(L)
    if L(i)<Lcrd
        Mcrd_My(i,1)=Mcrd_My_star*(L(i)/Lcrd)^log(L(i)/Lcrd);
    else
        Mcrd_My(i,1)=Mcrd_My_star;
    end
end
%
%GLOBAL BUCKLING
X(:,1)=1./L(60:99).^2;
X(:,2)=1./L(60:99).^4;
y=LF(60:99).^2;
beta = nlinfit(X,y,@'beta(1)*X(1)+beta(2)*X(2)',[1 1])
%p=polyfit(x,y,2);
%p(3)=0;
%ye=polyval(p,1./L.^2);
%Mcre_My=ye.^0.5;



figure(1)
semilogx(L,LF,'.-',L,Mcrl_My,':',L,Mcrd_My,':')
xlabel('half-wavelength (in.)')
ylabel('M_{cr}/M_y')
axis([1 1000 0 10])

