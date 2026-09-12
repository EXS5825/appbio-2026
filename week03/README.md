# Homework Assignment 3
For this assignment select one of the repositories you were assigned to peer-review.

I chose Amy Choi's repository (https://github.com/amygchoi/appbio-2026/tree/main/week02). 

### Fork the clone of one of the repositories you were assigned to review.
Forked Amy's repository: 
<img width="2342" height="506" alt="image" src="https://github.com/user-attachments/assets/fae1a31f-8ea3-4853-90c2-868364c88b24" />

Cloned the forked repository: 
```
git clone https://github.com/EXS5825/appbio-2027.git
```

Output: 
```
Cloning into 'appbio-2027'...
remote: Enumerating objects: 62, done.
remote: Counting objects: 100% (62/62), done.
remote: Compressing objects: 100% (47/47), done.
remote: Total 62 (delta 9), reused 53 (delta 5), pack-reused 0 (from 0)
Receiving objects: 100% (62/62), 3.16 MiB | 9.42 MiB/s, done.
Resolving deltas: 100% (9/9), done.
```

### Verify that the code is not doing something dangerous.
Examined the file and made sure I understood what each line was doing. 

### Evaluate the README.md of the assignment. Does the README.md make it clear how to run the code and what the outcomes are?
The README.md is very clear on how to run the code, with detailed and understandable descriptions. 

### Verify that the results are reproducible. Does the code do what the author says it does?
Yes, the Makefile ran successfully. 

### Ask the AI Agent to compare your solution to theirs.
I asked Claude to compare the two Makefiles. Here is its summary:

"Makefile 2 (Amy's) is more production-ready: better organization, explicit pipeline stages, an index step, and robust download handling. Makefile 1 (mine) is simpler and more easily re-targeted to a different accession, but depends on the datasets CLI and produces a flatter, less structured output." 

### Ask the AI Agent to evaluate which solution it thinks is better.
Overall, it selects Amy's as the better Makefile. The one caveat listed is that the FTP paths are hardcoded, making it more difficult to adapt the Makefile to a different genome (as opposed to the accession-driven design in my Makefile). 

### In a paragraph or two, summarize your findings above.
Visually inspecting the code, my Makefile is much more basic and simple. It also has an easily-switchable accession variable that its parameters are structured around. This suits my purposes for this assignment, but Amy's code is more thorough in how she organizes and processes her data, especially for further use. 

I thought the AI's assessment of "robustness" was interesting: 
"Makefile 2's curl flags `(--fail --location --show-error)` make it fail loudly on HTTP errors and follow redirects, which is good practice. Makefile 1's datasets call has no equivalent error handling visible in the recipe, though the CLI likely handles this internally. The download-then-rename pattern in Makefile 2 `(--output $(FASTA_DOWNLOAD) && mv ... $@)` also prevents a partial file from being left behind as a valid target." 

I am not used to thinking about how my code can "fail loudly" if something goes wrong, but this would be useful to keep in mind in the future! 

### Make a change to the forked repository that addresses an issue you found.

### Commit and push the change to your fork.

### On the GitHub interface create a pull request to the original repository.

### The author will review the pull request and merge it if they agree with your changes.

### Add the URL of the pull request to the README.md file.
