define_command fdg "fishdots plugin for doing useful things with git"
define_subcommand fdg save on_fdg_save "save all edits"
define_subcommand fdg sync on_fdg_sync "save all edits then push to origin"
define_subcommand_nonevented fdg release fdg_release "(<ver> <msg>) Update release version, tag and push"
define_subcommand_nonevented fdg tag fdg_tag "(<ver> <msg>) release, without use of latest-release.txt file"
define_subcommand_nonevented fdg ed fdg_find_and_edit "find a file in the current repo and edit"

function fdg_save -e on_fdg_save
    git add -A .
    git commit -m "$argv"
end

function fdg_sync -e on_fdg_sync
    fdg_save $argv
    set branchname (git branch | grep '*' | cut -d' ' -f2)
    if test -z $branchname
      set branchname "master"
    end
    git push origin $branchname
end

function fdg_tag -a ver msg -d "release, without use of latest-release.txt file"
  fdg sync "$msg"
  git tag -a $ver -m "$msg"
  git push origin --tags
end

function fdg_release -a ver msg -d "a function to prepare a fishdots style release"
    if not test -e latest_release.txt
        echo "release ver msg present. Aborting."
        return
    end
    if not test -d ".git"
        echo "Not in root of a git repo. Aborting."
        return
    end
    echo -n "$ver" > latest-release.txt
    git add -A .
    git commit -m "$msg"
    git tag -a v(cat latest-release.txt) -m "$msg"
    git push origin --all
    git push origin --tags
end

function fdg_find_and_edit -d "fimd a file in the repo and edit it"
  set -l file (rg --files (git root) | fzf)
  eval "$EDITOR $file"
end

