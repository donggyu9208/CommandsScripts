#####################################################################
# Untrack files already added to git repository based on .gitignore #
#####################################################################
git rm -r --cached .
git add .
git commit -m ".gitignore fix"

######################
# git set postBuffer #
######################
git config --global http.postBuffer 157286400

###################
# Git Credentials #
###################
# remove the stored credential from credentials storage
git config --system --unset credential.helper

# enable credentials storage in git
git config --global credential.helper store

################
# Undo Changes #
# Clean Branch #
################
git reset; git checkout .; git clean -fdxq;

git reset # unstage all files that have been added with git add
git checkout . # Revert all local uncommitted changes

git clean -n # See which files would be deleted 
git clean -f # Actually delete all the new files
git clean -f -x # Remove ignored files
git clean -f -d # Remove directories

###########
# Commits #
##########
Revert Changes to File 
git checkout <commit_hash> -- <file>

git checkout 767973a7e7843ce64ce46d4e632fbc3825a407df -- $filePath

###############
# Cherry Pick #
###############
# ----------- Cherry-pick Specific Commit --------- #
git cherry-pick [commit]
git cherry-pick --abort
git cherry-pick --strategy=recursive -X theirs {Imported_Commit}

####################
# Private Registry #
####################
docker pull registry 
docker run -d -p 5000:5000 --restart=always --name registry registry:2 

############
#  Branch  #
############
# ------------ Pull ---------- #
git pull <remote>

# ------------ Create ---------- #
git branch [Branch]
git checkout [Branch]

# ------------ Delete ---------- #
# Local
git branch -d [Branch]
git branch -D [Branch] # Equivalent of git branch --delete --force
# Remote
git push origin --delete [Branch]

# ----------- Push new branch to a remote Git Repo --------#
git checkout -b [Branch]
git commit -am "New Changes"
git push -u origin [Branch]

# ----------- Merge --------- #
git checkout [Branch]
git merge [BranchToMerge]

# ---------- Merge specific files ------- #
git checkout [Branch]
git checkout [BranchToMerge] [FileToMerge] 
git status
git commit -m "Merge code from [BranchToMerge] branch"

########
# Tags #
########
git show <tag>
git push --delete origin refs/tags/<tagName>
git checkout tags/<tag> -b <branch>
git fetch --tags

##############
# Submodules #
##############
# ------ Cloninig --------- #
# Cloning a repository including its submodules, you must use --recursive parameter
git clone --recursive [URL to Git Repo]

# After cloning a repository, if you want to load it's submodules you have to use submodule update
git submodule update --init
git submodule update --init --recursive # for nested submodules

# Repositories can include many submodules and can download them all sequentially which can take much time.
# For this reason, we can fetch multiple submodules at the same time.
git submodule update --init --recursive --jobs 8 # Download up to 8 submodules at the same time
git clone --recursive --jobs 8 [URL to Git Repo]
# short version
git submodule update --init --recursive -j 8

# ----------- Pull ---------------#
git pull --recurse-submodules # pull all changes in the repo including changes in the submodules
git submodule update --remote # pull all changes for the submodules only


# ----------- Add a Submodule to a git repository ----------- #
git submodule add -b [branchName] [URL to Git repo] [Submodule directory]
# add submodule and define the master branch as the one you want to track
git submodule add -b master [URL to Git repo] [Submodule directory]
git submodule init

# **** IMPORTANT NOTE **** #
# Every time you update a submodule to a specific commit, you also need to git commit in the parent git repo to track the changes in submodule
# After making new commits in the submodule, or have pulled in new commits from the submodule, it shows in git status from the parent git repo that
# Submodule directory is modified. This is the limitation of submodule branch tracking.
# git module add -b simply adds information about a branch in the .gitmodule file 

# How to update a submodule to its latest commit in its master branch
cd [submodule directory]
git checkout master
git pull

cd ..
git add [submodule directory]
git commit -m "move submodule to latest commit in master"


# ----------- Delete a submodule from a repository ---------- #
git submodule deinit -f [submoduleName]
rm -rf .git/modules/[submoduleName]
git rm -f [submoduleName]

# ----------- Get Current Branch ---------- #
function Get-CurrentBranch {
    Param (
        $gitPath
    )
    if ($gitPath -ne $null) {
        cd $gitPath
    }
    
    $currentBranch = (git branch | select-string \*).ToString().Split(' ')[1]
}
