%% Finds all files with a given file extension within a series of directories
%:Inputs:
% - Directories (cell array) ; List of directories to look for files within
% - Desired_File_Extension (Character array / String) ; Extension of file
%:Outputs:
% - File_List (Structure) ; listing of all files that match the required filename
function File_List = Search_Files(Directories, Desired_File_Extension)
    %% Input Validation
    %Assume inputs valid
    Continue = true;
    %Validate directory list input
    if(exist('Directories','var'))
        %Convert string of char datatypes to cell
        if(isstring(Directories))
            Directories = cellstr(Directories);
        elseif(ischar(Directories))
            Directories = cellstr(Directories);
        end
        %If the datatype isn't a cell type
        if(~iscell(Directories))
            disp("Invalid input for directories");
            Continue = false;
        end
    else
        disp("Invalid input for directories");
        Continue = false;
    end
    %Validate file extension input
    if(exist('Desired_File_Extension','var'))
        if(~(isstring(Desired_File_Extension) || ischar(Desired_File_Extension)))
            disp("Invalid input for file extension");
            Continue = false;
        end
    else
        Desired_File_Extension = '';
    end

    %% If the function inputs are valid
    if(Continue)
        %counter for valid file indexing
        Valid_File_Counter = 1;
        %% Find all files that correspond to raw data from the list of directories
        for Current_Directory = 1:length(Directories)
            %Get current directory
            Read_Directory = Directories{Current_Directory};
            %get all files within the directory
            Files = dir(Read_Directory);
            %for each file
            for Current_File = 1:length(Files)
                %exclude files
                if(sum(strcmp(Files(Current_File).name,{'.','..'})) == 0)
                    %get current file's directory path
                    Current_File_Path = strcat(Read_Directory, filesep, Files(Current_File).name);
                    %get fileparts
                    [~, ~, File_Parts_Ext] = fileparts(Current_File_Path);
                    %file with no extension found with filename that matches the
                    %directory filename found using dir
                    if(strcmpi(File_Parts_Ext, Desired_File_Extension) == 1)
                        %add to list of valid files
                        File_List(Valid_File_Counter) = Files(Current_File);
                        %File_List(Valid_File_Counter).Directory = Read_Directory;
                        Valid_File_Counter = Valid_File_Counter + 1;
                    end
                end
                clear File_Parts_Ext Current_File_Path;
            end
            %clear up workspace
            clear Files Current_File;
        end
        clear Valid_File_Counter;
    end
    
    %% Verify output
    if(~exist('File_List','var'))
        File_List = struct('name', {}, 'folder', {}, 'date', {}, 'bytes', {}, 'isdir', {}, 'datenum', {});
    end
end