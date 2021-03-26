%% Extracts parameters from a filename in the format of Dx(AB_CD);Dy(EF_GH) where D[variable_name]([value])[seperator]...
%% Will place values of 0 if parameters are missing from any files
%:Inputs:
% - List of files (cell array)
% - Position_Extraction_Parameters (structure)
%:Outputs:
% - File List (cell array)
% - Parameter Values (structure)
function [Files, Parameter_Values] = Extract_Position_Variables_From_Filename(Files, Extraction_Parameters)
    %% Raw Input handling
    Continue = true;
    switch nargin
        case 0
            disp("List of files not supplied");
            Continue = false;
        case 1
        case 2
        otherwise
    end
    %% Parameter handling
    %Parameter_Seperator
    [Struct_Var_Value, Struct_Var_Valid, Struct_Default_Used] = Verify_Structure_Input(Extraction_Parameters, 'Parameter_Seperator', ';');
    if(Struct_Var_Valid || Struct_Default_Used)
        Parameter_Seperator = Struct_Var_Value;
    end
    %Variable_Order
    [Struct_Var_Value, Struct_Var_Valid, Struct_Default_Used] = Verify_Structure_Input(Extraction_Parameters, 'Variable_Order', {});
    if(Struct_Var_Valid || Struct_Default_Used)
        %Only set if the list isn't empty
        if(~isempty(Struct_Var_Value))
            Variable_Order = Struct_Var_Value;
        end
    end
    clear Struct_Var_Value Struct_Var_Valid Struct_Default_Used;
    %Verify variable order and parameter_seperator exists
    if(~exist('Parameter_Seperator','var'))
        disp("Parameter_Seperator not supplied, check inputs");
        Continue = false;
    end
    
    %% If inputs are valid
    if(Continue)
        %% Pull variables out of the filename if any exist
        %reassign variable for ease of use
        Unique_Parameter_Names = {};
        %for each valid file found
        for Current_File = 1:length(Files)
            %split filename by semicolon seperator
            Filename_Parts = strsplit(Files(Current_File).name, Parameter_Seperator);
            %for each seperate parameter
            for Filename_Part = 1:length(cell(Filename_Parts))
                %check parameter
                Parameter = strtrim(regexp(Files(Current_File).name,'[A-Za-z]+\([0-9]+_[0-9]+\)','match'));
                %if filename match isn't empty
                if(~isempty(Parameter))
                    %for each parameter in the filename
                    for Parameter_Number = 1:length(Parameter)
                        %get parameter names
                        Parameter_Name = char(string(strtrim(regexp(Parameter(Parameter_Number),'[A-Za-z]+(?=\()','match'))));
                        %get array of unique parameter names
                        if(sum(strcmp(Parameter_Name,Unique_Parameter_Names)) == 0)
                            %add unique parameter
                            Unique_Parameter_Names{length(Unique_Parameter_Names)+1} = Parameter_Name;
                        end
                        Parameter_Value = str2double(strrep(string(strtrim(regexp(Parameter(Parameter_Number),'(?<=\()[0-9]+_[0-9]+(?=\))','match'))),'_','.'));
                        %add parameters for current file
                        Files(Current_File).(Parameter_Name) = Parameter_Value/1000;
                    end
                end
                %read data
                Files(Current_File).Data = Read_HXT_File(strcat(Files(Current_File).folder, filesep, Files(Current_File).name));
            end
        end
        %Ensure all fields have values (default to 0)
        Default_Parameter_Values_Set = false;
        for Current_File = 1:length(Files)
            for Parameter_Number = 1:length(Unique_Parameter_Names)
                Parameter_Name = Unique_Parameter_Names{Parameter_Number};
                Empty_Index = find(arrayfun(@(Files) isempty(Files.(Parameter_Name)), Files));
                if(~isempty(Empty_Index))
                    Default_Parameter_Values_Set = true;
                end
                [Files(Empty_Index).(Parameter_Name)] = deal(0);
            end
        end
        %display message
        if(Default_Parameter_Values_Set)
            disp("No co-ordinates found for some filenames; defaulting un-set values to 0");
        end
        clear Default_Parameter_Values_Set Empty_Index Parameter Parameter_Name Parameter_Value Filename_Part Filename_Parts Parameter_Number Parameter_Seperator;
        
        %% If a specific variable order has been specified, re-order co-ordinates
        %get unique variables in order
        if(exist('Variable_Order','Var'))
            %count number of variables
            Variable_Count = 1;
            %input variables from user selection
            for Variable_Order_Number = 1:length(Variable_Order)
                %get index of current variable in variable list
                Variable_Index = strcmp(Unique_Parameter_Names,Variable_Order(Variable_Order_Number));
                %if the current variable exists
                if(sum(Variable_Index) == 1)
                    %add to array
                    Parameter_Values(Variable_Count).Name = Variable_Order{Variable_Order_Number};
                    Parameter_Values(Variable_Count).Values = [Files(:).(Variable_Order{Variable_Order_Number})];
                    Parameter_Values(Variable_Count).Num_Values = length(Parameter_Values(Variable_Count).Values);
                    Parameter_Values(Variable_Count).Unique_Values = unique([Files(:).(Variable_Order{Variable_Order_Number})]);
                    Parameter_Values(Variable_Count).Num_Unique_Values = length(Parameter_Values(Variable_Count).Unique_Values);
                    %increment number of variables added
                    Variable_Count = Variable_Count + 1;
                end
            end
            clear Variable_Count Variable_Order_Number;
%WHAT ABOUT PARAMETERS NOT IN THE LIST
%MOVE ELSE CONDITION OUT OF LOOP TO ADD ALL MISSING VALUES
        else
            %use all parameters in order provided
            for Unique_Parameter_Number = 1:length(Unique_Parameter_Names)
                Parameter_Values(Unique_Parameter_Number).Name = Unique_Parameter_Names{Unique_Parameter_Number};
                Parameter_Values(Unique_Parameter_Number).Values = [Files(:).(Unique_Parameter_Names{Unique_Parameter_Number})];
                Parameter_Values(Unique_Parameter_Number).Num_Values = length(Parameter_Values(Unique_Parameter_Number).Values);
                Parameter_Values(Unique_Parameter_Number).Unique_Values = unique([Files(:).(Unique_Parameter_Names{Unique_Parameter_Number})]);
                Parameter_Values(Unique_Parameter_Number).Num_Unique_Values = length(Parameter_Values(Unique_Parameter_Number).Unique_Values);
            end
        end
        clear Variable_Order Variable_Index Unique_Parameter_Names;
    end
    
    %% Verify Parameter_Values exist
    if(~exist('Parameter_Values','var'))
        disp("No Variable_Order or position parameters found in filename; using default placeholders.");
        %Dx
        Parameter_Values(1).Name = 'Dx';
        Parameter_Values(1).Values = 0;
        Parameter_Values(1).Num_Values = 1;
        Parameter_Values(1).Unique_Values = 0;
        Parameter_Values(1).Num_Unique_Values = 1;
        %Dy
        Parameter_Values(2).Name = 'Dy';
        Parameter_Values(2).Values = 0;
        Parameter_Values(2).Num_Values = 1;
        Parameter_Values(2).Unique_Values = 0;
        Parameter_Values(2).Num_Unique_Values = 1;
        %Dz
        Parameter_Values(3).Name = 'Dz';
        Parameter_Values(3).Values = 0;
        Parameter_Values(3).Num_Values = 1;
        Parameter_Values(3).Unique_Values = 0;
        Parameter_Values(3).Num_Unique_Values = 1;
    end
end