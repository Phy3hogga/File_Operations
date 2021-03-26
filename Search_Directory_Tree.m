%%  Get extreme end directories recursively of all directories in a directory tree
%:Inputs:
% - Directory_Path (Char array / String) ; Absolute Path to Root Directory
% - Return_All (Boolean) ; Returns all results (true), returns extreme end directories (false)
% - Empty cell array
%:Outputs:
% - Cell array of extreme end directories
function Directories = Search_Directory_Tree(Directory_Path, Return_All, Directories)
    %% Raw input handling  
    %ensure that directories exists and is valid
    if(~exist('Directories','var'))
        Directories = {};
    else
        if(~iscell(Directories))
            disp("Directories expected to be a cell array, defaulting to empty cell array.");
            Directories = {};
        end
    end
    %ensure return all exists and is valid
    if(~exist('Return_All','var'))
        Return_All = false;
    else
        if(~islogical(Return_All))
            disp("Return_All expected to be a cell array, defaulting to false.");
            Directories = false;
        end
    end
    
    %% Verify that the current directory path is a string or character array and exists
    %Assume directory doesn't exist and isn't supplied valid
    Valid_Directory = false;
    %verify directory path is a string or character array
    if(ischar(Directory_Path) || isstring(Directory_Path))
        %validate directory exists
        if(isdir(Directory_Path))
            Valid_Directory = true;
        end
    end
    
    %% If the directory path supplied exists, check all items within the directory
    if(Valid_Directory)
        %get a list of all objects within the current directory path
        Directory_Contents = dir(Directory_Path);
        %for each item in the current directory
        for i = 1:length(Directory_Contents)
            %if isn't up or down a directory (constants)
            if(sum(strcmp(Directory_Contents(i).name,{'.','..'})) ~= 1)
                %get absolute directory path
                Check_Directory = strcat(Directory_Contents(i).folder, filesep, Directory_Contents(i).name);
                %check item is a directory
                if(exist(Check_Directory, 'file') == 7)
                    %get size of directories before checking a directory
                    Size_Before = size(Directories);
                    %% check to see if subdirectories exist in the current directory recursively
                    Directories = Search_Directory_Tree(Check_Directory, Return_All, Directories);
                    %get size of directories after checking a directory
                    Size_After = size(Directories);
                    %% Check if the directory has been added
                    Directory_Already_Added = any(strcmp(Directories, Check_Directory));
                    if(~Directory_Already_Added)
                        %% Determine whether returning all directories or just the extreme ends
                        if(Return_All)
                            %Add all directories
                            Directories{length(Directories) + 1} = Check_Directory;
                        else
                            %if sizes match, no new entries have been added
                            if(Size_Before == Size_After)
                                %add current directory as end of tree branch
                                Directories{length(Directories) + 1} = Check_Directory;
                            end
                        end
                    end
                end
            end
        end
    end
    
    %% Add root directory if directories is empty
    if(isempty(Directories))
        %% Check if the directory has been added
        Directory_Already_Added = any(strcmp(Directories, Directory_Path));
        if(~Directory_Already_Added)
            Directories{length(Directories) + 1} = Directory_Path;
        end
    end
end