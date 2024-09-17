function    Cost=CostMatrix(NumClass,maxvalue,kind)


if(nargin<1)
    help CostMatrix;
elseif(nargin<2)
    if(NumClass<2)
        error('NumClass error.')
    end
    maxvalue=10;
    kind='c';
elseif(nargin<3)
    kind='c';
end

switch(kind)
    case 'a'   
        for i=1:NumClass   
            for j=1:NumClass
                if (i ~= j)
                    Cost(i,j) = 1;
                end
            end
        end
        I=round(rand(1,1)*(NumClass-1))+1;     
        for j=1:NumClass
            if(j~=I)
                Cost(I,j) = round(rand(1,1) * (maxvalue-2) + 2);
            end
        end
        
   
    case 'b'   
        for j=1:NumClass
            rn = round(rand(1,1) * (maxvalue-1) + 1);
            for i=1:NumClass
                if (i ~= j) 
                    Cost(i,j) = rn;
                end
            end
        end    
        if(min(Cost(find(Cost(:)>0)))>1)
            rn=round(rand(1,1)*(NumClass-1))+1;
            for i=1:NumClass
                if(i~=rn)
                    Cost(i,rn)=1;
                end
            end                  
        end
    case 'c' 
        Cost=zeros(NumClass);
        for i=1:NumClass
            for j=1:NumClass               
                if (i ~= j)
                    rn1 = round(rand(1,1) * (maxvalue-1) + 1);
                    Cost(i,j) = rn1;
                end
            end
        end  
        if(min(Cost(find(Cost(:)>0)))>1)
            rn1=round(rand(1,1)*(NumClass-1))+1;
            rn2=round(rand(1,1)*(NumClass-1))+1;
            while(rn1==rn2)
                rn1=round(rand(1,1)*(NumClass-1))+1;
            end
            Cost(rn1,rn2)=1;
        end
   
    otherwise
        error('type error.')
end
        


    
