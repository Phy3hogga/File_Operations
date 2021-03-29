# File Operations

Matlab scripts that provide some simple quality of life functions while searching for files, creating directories and pulling variables out of filenames (specific use case, not public). This is a supporting submodule for other repositories.

### Functions
#### Attempt_Directory_Creation
Attempts to create a directory, verifies if the directory exists upon trying to create it (should provide safe error correction for directory permission issues).
```matlab
Directory_Path = "C:\Path\To\Directory";
Success = Attempt_Directory_Creation(Directory_Path);
```

#### Search_Directories
Get a single list of subsequent subdirectories from a list of one or more parent directories.
```matlab
Directory_Path = {"C:\Path\To\Directory"};
Subdirectories = Search_Directories(Directories);
```

#### Search_Directory_Tree
Recursive version of Search_Directories where this version finds the extreme branches of a directory tree, rather than the subsequent subdirectory. When Return_All is set to true, this function will also return all intermediate directories between the root and extreme branches. Directories is a cell array containing one or more directories.
```matlab
Directory_Path = "C:\Path\To\Directory";
Directories = Search_Directory_Tree(Directory_Path, Return_All, Directories);
```

#### Search Files
Gets a single list of files that have a specific file extension within a list of multiple directories.
```matlab
Directories = {"C:\Path\To\Directory_1", "C:\Path\To\Directory_2"};
Desired_File_Extension = '.mat';
File_List = Search_Files(Directories, Desired_File_Extension);
```

#### Extract_Position_Variables_From_Filename
Extracts numeric variables from a filename in the form Dx(10_13);Dy(245_76) where the preceding text describes the variable name and the value is noted in the following parenthesis with an underscore representing a decimal point. Multiple parameters are separated by a semicolon. i.e. Dx(10_13) implies Dx = 10.13

*Note: this function has a very specific use-case and is not advised to be used in most instances.*
```matlab
Extraction_Parameters.Variable_Order = {'Dx', 'Dy'};
Extraction_Parameters.Parameter_Seperator = ';';
[Files, Parameter_Values] = Extract_Position_Variables_From_Filename(Files, Extraction_Parameters);
```

### Examples
Find a list of files that have a '.bin' file extension with a naming scheme that contains certain variables.
```matlab
%% Find all files that correspond to raw data
Root_Directory = "C:\Path\To\Directory";
%Find all directories in tree (non-recursive search)
Directories = Search_Directory_Tree(Root_Directory, false);
 % Search for all bin files within the list of directories
Files = Search_Files(Directories, '.bin');
%% Read filenames to extract the co-ordinates that the files were captured at
Extraction_Parameters.Variable_Order = {'Dx', 'Dy', 'Dz'};
Extraction_Parameters.Parameter_Seperator = ';';
[Files, Parameter_Values] = Extract_Position_Variables_From_Filename(Files, Extraction_Parameters);
```

## Built With

* [Matlab R2018A](https://www.mathworks.com/products/matlab.html)
* [Windows 10](https://www.microsoft.com/en-gb/software-download/windows10)

## Contributing

This code is provided as a submodule for multiple repositories and is not intended to be used in any other way.

## Authors
* **Alex Hogg** - *Initial work* - [Phy3hogga](https://github.com/Phy3hogga)