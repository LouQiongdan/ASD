function r=normalize(m)
summ=sum(m);
summ=repmat(summ,size(m,1),1);
r=m./summ;
