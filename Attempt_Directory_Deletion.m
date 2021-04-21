%% Attempts to delete a directory (including all directory contents)
function Success = Attempt_Directory_Deletion(Directory_Path)
    Success = false;
    if(isfolder(Directory_Path))
        Temporary_Files_Removed = rmdir(Directory_Path, 's');
        if(~Temporary_Files_Removed)
            warning(strcat("Attempt_Directory_Deletion : Failed to delete temporary directory: ", Directory_Path));
        else
            Success = true;
        end
    end
end