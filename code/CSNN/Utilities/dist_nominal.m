function z = dist_normimal(w,p,attribute,AttVector)

[R,Nw] = size(w);
[R2,Np] = size(p);
if (R ~= R2)
    error('Attribute numbers do not match.')
end

z = zeros(Nw,Np);
for ii=1:Nw
    id=find(AttVector==0);
    z(ii,:)= sum((repmat(w(id,ii),1,Np)-p(id,:)).^2);
    for j=find(AttVector==1)
        wid=Locate(attribute(j).values,w(j,ii));
        pid=Locate(attribute(j).values,p(j,:));
        z(ii,:)=z(ii,:)+attribute(j).VDM(wid,pid);
    end       
end
z = sqrt(z);
