define_command fdg "fishdots plugin for doing useful things with git"
define_subcommand fdg save on_fdg_save "save all edits"
define_subcommand fdg sync on_fdg_sync "save all edits then push to origin"

function fdg_save -e on_fdg_save
    git add -A .
    git commit -m  "$argv"
end

function fdg_sync -e on_fdg_sync
    fdg_save $argv
    git push origin master
end