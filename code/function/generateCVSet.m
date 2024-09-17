function [ train_x,train_y,train_classes,test_x,test_y,test_classes ] = generateCVSet( X,Y,original_target,kk,index,totalCV )
    assert(index <= 10);
    assert(totalCV <= 10);
    m = size(X,1);
    slice = ceil(m/totalCV);
    test_x = X(kk((index - 1) * slice + 1: min( index * slice , m ) ) ,:);
    test_y = Y(kk((index - 1) * slice + 1: min( index * slice , m ) ) ,:);
    test_classes = original_target(kk((index - 1) * slice + 1: min( index * slice , m ) ) ,:);
    
    train_x = X(setdiff(kk,kk((index - 1) * slice + 1: min( index * slice , m ) )),:);
    train_y = Y(setdiff(kk,kk((index - 1) * slice + 1: min( index * slice , m ) )),:);
    train_classes = original_target(setdiff(kk,kk((index - 1) * slice + 1: min( index * slice , m ) )),:);
end