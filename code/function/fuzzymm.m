function [R] = fuzzymm(A,B)

[m,n]=size(A);[q,p]=size(B);
if n~=q
    disp('��һ������������͵ڶ����������������ͬ��');
else
    R=zeros(m,p);
for k =1:m    
    for j=1:p
        temp=[];
        for i =1:n
            Min = min(A(k,i),B(i,j));
            temp=[temp Min]; 
        end
        R(k,j)=max(temp);
    end
end
end
end

