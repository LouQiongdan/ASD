 function [parameter_cell ] = adaptive_validate( data, target,original_target, oldOptmParameter,TSKoptions)

optmParameter         = oldOptmParameter;
alpha_searchrange     = oldOptmParameter.alpha_searchrange;
beta_searchrange      = oldOptmParameter.beta_searchrange;
gamma_searchrange     = oldOptmParameter.gamma_searchrange;
lambda_searchrange    = oldOptmParameter.lambda_searchrange;
miu_searchrange       = oldOptmParameter.miu_searchrange;

k_searchrange=TSKoptions.k_searchrange;
h_searchrange=TSKoptions.h_searchrange;
total = length(alpha_searchrange)*length(beta_searchrange)*length(gamma_searchrange)*length(k_searchrange)*length(h_searchrange)*length(lambda_searchrange)*length(miu_searchrange);
index = 1;
L = size(target,1);
[N,D] = size(data);
parameter_cell=zeros(total,47);
ii=1;
for p=1:length(k_searchrange)
    for q=1:length(h_searchrange)        
        randorder = randperm(N);
        num_cv = 10;          
        for i=1:length(alpha_searchrange)
            for j=1:length(beta_searchrange)
                for k = 1:length(gamma_searchrange) 
                    for l = 1:length(lambda_searchrange)
                        for u = 1:length(miu_searchrange)
                            fprintf('\n-   %d-th/%d: search parameter alpha and beta for LLSF,TSK_k= %f,TSK_h= %f, alpha = %f, beta = %f, gamma = %f, lambda = %f, and miu = %f',index, total,k_searchrange(p),h_searchrange(q), alpha_searchrange(i), beta_searchrange(j), gamma_searchrange(k), lambda_searchrange(l), miu_searchrange(u));
                            index = index + 1;
                            optmParameter.alpha = alpha_searchrange(i);
                            optmParameter.beta = beta_searchrange(j); 
                            optmParameter.gamma = gamma_searchrange(k);
                            optmParameter.lambda = lambda_searchrange(l);
                            optmParameter.miu = miu_searchrange(u);
                            optmParameter.maxIter = 100;
                            optmParameter.minimumLossMargin = 0.01;
                            optmParameter.outputtempresult = 0;
                            optmParameter.drawConvergence = 0;
                            TempResult=zeros(num_cv,20); 
                            
                            for cv = 1:num_cv
                                [cv_train_data,cv_train_target,cv_train_classes,cv_test_data,cv_test_target,cv_test_classes ] = generateCVSet(data,target',original_target',randorder,cv,num_cv);
                                                 
                                ClassType = unique(cv_test_classes)';
                                C = ones(1,length(ClassType));
                                cv_train_data = [cv_train_data,ones(size(cv_train_data,1),1)];
                                attribute = zeros(1,D+1);
                                attribute(end) = 1;
                                [newTrain,newTrainClasses]=SmoteOverSampling(cv_train_data',cv_train_classes',ClassType,C,attribute,5,'nominal');
                                cv_train_data(:,end) =  [];
                                newTrain(end,:) = [];
                                cv_train_data = [cv_train_data;newTrain'];
                                cv_train_classes = [cv_train_classes;newTrainClasses'];
                                newTrainLabels = ClassesToLabels(newTrainClasses');
                                cv_train_target = [cv_train_target;newTrainLabels];
                                TSKoptions.k=k_searchrange(p);
                                TSKoptions.h=h_searchrange(q);
                                [train_v,train_b] = gene_ante_fcm(cv_train_data,TSKoptions);
                                [train_U] = calc_membership(cv_train_data,train_v,train_b);
        
                                Atrain = zeros(L,TSKoptions.k);
                                Ntrain = size(cv_train_data,1);
                                for n = 1:Ntrain 
                                    label_j = find(cv_train_target(n,:)==1);
                                    Atrain(label_j,:) = Atrain(label_j,:)+train_U(n,:);
                                end
                                Vtrain = fuzzymm(Atrain,train_U');
                                cv_train_distribution_target = Vtrain'+cv_train_target;
                                                       
                                cv_train_target = cv_train_distribution_target;
                                [C,S]  = SolveObjectiveFunction( cv_train_data, cv_train_target,optmParameter);
                                Outputs = (cv_test_data*C)';
                                [~,class_index] = max(Outputs);
                                Pre_results = class_index-1;
                                multiclass_mAP_auc = Evaluation(Pre_results,cv_test_classes',Outputs,cv_test_target');  
                                multiclass_Result = perf_measures_multi_class(cv_test_classes', Pre_results);
                                Pre_labels = zeros(size(Outputs));
                                for n = 1:length(class_index) 
                                    Pre_labels(class_index(n),n) = 1;
                                end
                                multilabel_Result = EvaluationAll(Pre_labels,Outputs,cv_test_target')';
                                TempResult(cv,:) = [multilabel_Result,multiclass_Result,multiclass_mAP_auc];
                            end
                            Result=(mean(TempResult))';
                            STD=std(TempResult);
                            parameter_cell(ii,1:20)=Result(1:20,1)';
                            parameter_cell(ii,21:40)=STD(1,1:20);
                            parameter_cell(ii,41)=alpha_searchrange(i);
                            parameter_cell(ii,42)=beta_searchrange(j);
                            parameter_cell(ii,43)=gamma_searchrange(k);
                            parameter_cell(ii,44)=lambda_searchrange(l);
                            parameter_cell(ii,45)=k_searchrange(p);
                            parameter_cell(ii,46)=h_searchrange(q);
                            parameter_cell(ii,47)=miu_searchrange(u);
                            ii=ii+1;
                        end
                    end
                end
            end
        end
    end
end

end

