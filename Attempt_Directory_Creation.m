%% Attempt to create a directory and return success or failure
%:Inputs:
% - Directory Path (Char Array / String)
%:Outputs:
% - Success (Boolean)
function Status = Attempt_Directory_Creation(Directory_Path)
    %% Attempt to create the requested directory
    %check directory path consists of characters
    if(ischar(Directory_Path) || isstring(Directory_Path))
        %if the directory doesn't exist
        if(~(exist(Directory_Path, 'dir') == 7))
            %attempt to create the directory
            try
                mkdir(Directory_Path);
            catch
                disp(strcat("Unable to create directory :", Directory_Path));
            end
        end
    else
        %invalid datatype supplied to function
        disp("Directory_Path expected to be a character array");
    end
    %% Validate the directory now exists
    %check the directory exists after attempted creation
    if((exist(Directory_Path, 'dir') == 7))
        %directory exists
        Status = true;
    else
        %directory doesn't exist
        Status = false;
    end
end