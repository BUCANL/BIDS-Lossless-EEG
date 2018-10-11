% This function loads a single file and gathers all of the needed
% information. fOutID should be the output file handle from
% main_diagnostics. singleSetFile should reflect its name.
function single_diagnostic(fOutID, singleSetFile)
    % Storing what's going to be written to the csv in a variable to act as
    % a buffer. Line starts with filename.
    outString = [singleSetFile, ','];

    % Load:
    EEG = pop_loadset('filepath','','filename',singleSetFile);
    EEG = eeg_checkset( EEG );
    
    % Basic row info:
    outString = [outString, num2str(EEG.nbchan), ','];
    outString = [outString, num2str(EEG.pnts), ','];
    outString = [outString, num2str(EEG.srate), ','];
    
    % All time_info flag enables in seconds:
    % Manual
    outString = [outString, num2str(length(find(EEG.marks.time_info(1).flags==1)) / EEG.srate), ','];
    % ch_s_sd m
    outString = [outString, num2str(length(find(EEG.marks.time_info(1).flags == 1 & EEG.marks.time_info(3).flags == 1)) / EEG.srate), ','];
    % ch_s_sd b m
    outString = [outString, num2str(length(find(EEG.marks.time_info(1).flags == 1 & EEG.marks.time_info(3).flags == 0.5)) / EEG.srate), ','];
    % ch_s_sd b m ch_sd b
    outString = [outString, num2str(length(find(EEG.marks.time_info(1).flags == 1 & EEG.marks.time_info(3).flags == 0.5 & EEG.marks.time_info(4).flags == 0.5)) / EEG.srate), ','];
    % ch_s_sd b m ic_sd1 b
    outString = [outString, num2str(length(find(EEG.marks.time_info(1).flags == 1 & EEG.marks.time_info(3).flags == 0.5 & EEG.marks.time_info(8).flags == 0.5)) / EEG.srate), ','];
    % ch_sd m
    outString = [outString, num2str(length(find(EEG.marks.time_info(1).flags == 1 & EEG.marks.time_info(4).flags == 1)) / EEG.srate), ','];
    % ch_sd b m
    outString = [outString, num2str(length(find(EEG.marks.time_info(1).flags == 1 & EEG.marks.time_info(4).flags == 0.5)) / EEG.srate), ','];
    % ch_sd b m ic_sd1 b
    outString = [outString, num2str(length(find(EEG.marks.time_info(1).flags == 1 & EEG.marks.time_info(4).flags == 0.5 & EEG.marks.time_info(8).flags == 0.5)) / EEG.srate), ','];
    % low_r m
    outString = [outString, num2str(length(find(EEG.marks.time_info(1).flags == 1 & EEG.marks.time_info(5).flags == 1)) / EEG.srate), ','];
    % ic_sd1 m
    outString = [outString, num2str(length(find(EEG.marks.time_info(1).flags == 1 & EEG.marks.time_info(8).flags == 1)) / EEG.srate), ','];
    % ic_sd1 b m
    outString = [outString, num2str(length(find(EEG.marks.time_info(1).flags == 1 & EEG.marks.time_info(8).flags == 0.5)) / EEG.srate), ','];
    % ic_sd2
    outString = [outString, num2str(length(find(EEG.marks.time_info(12).flags==1)) / EEG.srate), ','];
    
    % Single chan_info flag enables in seconds:
    for i=2:5 % [2,5] are ch_s_sd, ch_sd, low_r, and bridge respectively.
        outString = [outString, num2str(length(find(EEG.marks.chan_info(i).flags==1))), ','];
    end
    
    % Amica diagnostic info:
    outString = [outString, num2str(mean(EEG.amica(2).models.Lt)), ','];
    outString = [outString, num2str(std(EEG.amica(2).models.Lt)), ','];
    quants = quantile(EEG.amica(2).models.Lt,[0.05,0.15,0.25,0.5,0.75,0.85,0.95]);
    for i=1:length(quants)
        outString = [outString, num2str(quants(i)), ','];
    end
    % Pre QC comp count:
    outString = [outString, num2str(length(EEG.icachansind)), ','];
    
    % Final write - includes newline
    fprintf(fOutID,'%s\n',outString);
end