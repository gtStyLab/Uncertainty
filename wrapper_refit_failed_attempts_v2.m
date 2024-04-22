function wrapper_refit_failed_attempts_v2(result_fileName_stem,nT_list,cov_list,gs_idx,result_fileName_appendix)
    addpath(genpath('/storage/home/hcoda1/5/yhan309/scratch/uncertainty_main'));

    if ~exist('result_fileName_appendix','var')
        result_fileName_appendix = '';
    end
    for nT = nT_list
        for cov = cov_list
            for rep = 1:3
                result_fileName = sprintf('%s_nT-%d_cov-%03d_rep-%03d%s.mat',result_fileName_stem,nT,cov,rep,result_fileName_appendix);
                refit_failed_attempts_v2(result_fileName,gs_idx);
            end
        end
    end



end