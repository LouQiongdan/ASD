function    out=LabelFormatConvertion(label,ClassType,kind)


if (nargin<3)
    kind=1;
end

switch(kind)
    
    case 1
        if(size(label,1)>1)
            error('input label format error.')
        end
        NumClass=length(ClassType);
        n=length(label);
        out=zeros(NumClass,n);
        
        class=Locate(ClassType,label);
        for i=1:n            
            out(class(i),i)=1;              
        end        
       
   
    case 2
        if(size(label,1)~=length(ClassType))
            error('input label format is not consistent with class type.')
        end
        [tmp,id]=max(label);
        out=ClassType(id);
        
    otherwise
        error('wrong kind.');
end
        
            
