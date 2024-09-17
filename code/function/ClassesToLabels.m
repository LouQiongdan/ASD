function [labels] = ClassesToLabels(original_target)
N = size(original_target,1);
 labels = zeros(N,5);
 for i = 1:N
     switch original_target(i,1)
         case 0
             labels(i,:) = [1,0,0,0,0];
         case 1
             labels(i,:) = [0,1,0,0,0];
         case 2
             labels(i,:) = [0,0,1,0,0];
         case 3
             labels(i,:) = [0,0,0,1,0];
         case 4
             labels(i,:) = [0,0,0,0,1];
     end   
end

