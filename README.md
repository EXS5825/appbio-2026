AI ready code editor: Visual Studio Code
Q: What version is your samtools command in the bioinfo environment?
    1.24 (using htslib 1.24)
Q: Show commands needed to create a nested directory structure.
  1. mkdir BMMB_852
  2. cd BMMB_852
  3. mkdir messing-around
Q: Show commands that create files in different directories
  1. cd directory1
  2. touch hello1
  3. cd ..
  4. cd directory2
  5. touch hello2
Q: Show how to access these files using relative and absolute paths.
     relative:
         cd directory1
         open . hello1
         cd directory2
         open . hello2 
     absolute:
         cd /Users/exs5825/Desktop/BMMB_852/parent-directory/directory1/
         open . hello1
