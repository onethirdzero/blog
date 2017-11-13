#!/bin/bash

echo -e "\033[0;32mDeploying updated site to GitHub User Page..\033[0m"
echo

# Build the project.
# If using a theme, replace with `hugo -t <YOURTHEME>`.
hugo

# Go to public/ directory.
cd public

# Add changes to git.
git add .

# Default commit mesage.
msg="Rebuild site on [`date`]"

# If adding a custom commit message, accept only 1 argument.
if [ $# -eq 1 ]
  then msg="$1"
fi

# Push to submodule's remote.
git commit -m "$msg"
git push origin master

# Come back up to the project root.
cd ..

echo "See your updated site at http://onethirdzero.github.io"
echo

exit 0
