%% Finds all files with a given file extension within a series of directories
%:Inputs:
% - Directories (cell array) ; List of directories to look for subdirectories within
%:Outputs:
% - File_List (Structure) ; listing of all files that match the required filename
function Subdirectories = Search_Directories(Directories)
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

    %% If the function inputs are valid
    if(Continue)
        %counter for valid file indexing
        Valid_Subdirectory_Counter = 1;
        %% Find all files that correspond to raw data from the list of directories
        for Current_Directory = 1:length(Directories)
            %Get current directory
            Read_Directory = Directories{Current_Directory};
            %get all files within the directory
            Directory_Contents = dir(Read_Directory);
            %for each file
            for Current_File = 1:length(Directory_Contents)
                %exclude files
                if(sum(strcmp(Directory_Contents(Current_File).name,{'.','..'})) == 0)
                    %get current file's directory path
                    Current_File_Path = strcat(Read_Directory, filesep, Directory_Contents(Current_File).name);
                    %get fileparts
                    %directory filename found using dir
                    if(isfolder(Current_File_Path) == 1)
                        %add to list of valid files
                        Subdirectories(Valid_Subdirectory_Counter) = Directory_Contents(Current_File);
                        %File_List(Valid_File_Counter).Directory = Read_Directory;
                        Valid_Subdirectory_Counter = Valid_Subdirectory_Counter + 1;
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
    if(~exist('Subdirectories','var'))
        Subdirectories = struct();
    end
end