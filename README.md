AI ready code editor: Visual Studio Code

What version is your samtools command in the bioinfo environment? 1.24 (using htslib 1.24)

### Show commands needed to create a nested directory structure.
Input: 
```
mkdir BMMB_852
```
Output: Made a directory called BMMB_852.

Input: 
```
cd BMMB_852
```
Output: change directories into BMMB_852. 

Input: 
```
mkdir messing-around
```
Output: make a directory "messing-around" nested inside the directory "BMMB_852". 

### Show commands that create files in different directories. 
Input: 
```
cd directory1
```
Output: change directories into "directory1" 

Input: 
```
touch hello1
```
Output: creates a file called "hello1" inside the directory "directory1"

Input: 
```
cd ..
```
Output: changes directories back into the parent directory for directory1. 

Input: 
```
cd directory2
```
Output: change directories into "directory2"

Input: 
```
touch hello2
```
Output: creates a file called "hello2" inside the directory "directory2"

### Show how to access these files using relative and absolute paths.
##### Relative path: 
Input: 
```
cd directory1
```
Output: changes directories into directory1

Input: 
```
open . hello1
```
Output: opens the file hello1


Input: 
```
cd directory2
```
Output: changes directories into directory2

Input: 
```
open . hello2
```
Output: opens the file hello2

##### Absolute path: 
Input: 
```
cd /Users/exs5825/Desktop/BMMB_852/parent-directory/directory1/
         open . hello1
```
Output: opens the file hello1. 

Input:
```
cd /Users/exs5825/Desktop/BMMB_852/parent-directory/directory2/
         open . hello2
```
Output: opens the file hello2. 
