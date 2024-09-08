<div align="center">
<h1><a href="https://defold.com/">Defold</a> on Neovim (extended)</h1>
</div>

> [!Note]
> Work in progress. Tested only on Linux, but it should work on macOS as well.

- Configures luals to better work with defold projects
- Includes defold API annotations
- Adds a command to extract dependency annotations
- Adds commands to build, hot-reload and fetch
- Configures all defold filetypes to be properly detected and highlighted
- Works with built-in LSP and with [coc.nvim](https://github.com/neoclide/coc.nvim)

Intended to be used as [external editor](#script-for-opening-neovim-as-defold-external-editor).

## Dependencies

The plugin can work without dependencies, but if you want to get LSP documentation
and completions for external libraries in the ".internal" directory, you need to install
these dependencies and invoke `DoNe annotate` command.
To run remote actions, `curl` and one of `ss` or `lsof` utils must be exucutable
(most Linux distros and MacOS include them by default).

Make sure luarocks is using 5.1 lua version
```sh
luarocks config | grep lua_version
```
if its not then change it to 5.1
```sh
luarocks config lua_version 5.1
```

```sh
sudo luarocks install sha1
sudo luarocks install luazip
sudo luarocks install lyaml

# luazip requires zziplib library
# on ArchLinux zziplib can be installed with
sudo pacman -S zziplib
```

## Install

Using lazy.nvim and lazy loading only by `:Lazy load DoNe` command
```lua
{
   "monkoose/DoNe",
   lazy = true,
   -- optional configuration
   config = function()
      -- as example adding some keybindings
      vim.keymap.set("n", "<F5>", "<Cmd>DoNe build<CR>")
      --- ...
   end,
}
```

## Usage

DoNe provides neovim user command with the same name `:DoNe`:
- **`:DoNe build`** - builds and runs defold project
- **`:DoNe reload`** - hot-reloads defold project
- **`:DoNe fetch`** - fetches project dependencies
- **`:DoNe annotate`** - collects extensions annotations for improved autocompletion and documentation
- **`:DoNe clear`** - removes all annotations of the dependencies (useful when you change projects, so autocompletion wouldn't show them)
- **`:DoNe actions`** - lists all available commands accepted by defold editor (it can be used with `lua require('done.remote').actions(<cmd-name>)`)
- **`:DoNe delete_server_pipe`** - if neovim started as an external editor with instructions below and `servername=$HOME/.cache/nvim/defold.pipe`,
then removes the server pipe. Required because from time to time something goes wrong, so neovim stops connectiong to this pipe.
Use it when opening an external editor creates new neovim windows.


## Script for opening neovim as defold external editor

Opens only one neovim window by utilizing its server capabilities.
Name it how you want (for example, `neovim-for-defold`), make it executable and put in any directory in your $PATH environment variable.
On defold's menu `File > Preferences > Code` change the `Custom Editor` field to `neovim-for-defold` (or the name you chose).
Change `st` in the script to your favorite terminal in which you would like to start neovim. You don't need to change anything else.

```sh
#!/bin/sh

regex="^(.*):([0-9]+)$"
servername="$HOME/.cache/nvim/defold.pipe"

if [[ $1 =~ $regex ]]; then
    command="edit +${BASH_REMATCH[2]} ${BASH_REMATCH[1]}"
else
    command="edit $1"
fi

if nvim --server "$servername" --remote-expr "1" &> /dev/null; then
    nvim --server "$servername" --remote-send "<C-\\><C-n>:$command<CR>"
else
    # If server not present start it, load DoNe plugin with lazy.nvim and open required file
    # Change `st` to your favorite terminal
    st -e nvim --listen "$servername" +"lua require('lazy').load({ plugins = 'DoNe' })" \
        +"let &titlestring = '=defold editor=  %t'" +"$command"
fi
```

<details>
<summary>I'm using slightly modified version for better awesomewm integration.</summary>

    #!/bin/sh

    regex="^(.*):([0-9]+)$"
    servername="$HOME/.cache/nvim/defold.pipe"

    if [[ $1 =~ $regex ]]; then
        command="edit +${BASH_REMATCH[2]} ${BASH_REMATCH[1]}"
    else
        command="edit $1"
    fi

    if nvim --server "$servername" --remote-expr "1" &> /dev/null; then
        nvim --server "$servername" --remote-send "<C-\\><C-n>:$command<CR>"

        # Focus neovim window on awesomewm
        for _, c in ipairs(client.get()) do
            if string.match(c.name, "=defold editor=") then
                c:jump_to()
                break
            end
        end
        '

    else
        # change of `titlestring` required for focusing neovim window
        st -e nvim --listen "$servername" +"lua require('lazy').load({ plugins = 'DoNe' })" \
            +"let &titlestring = '=defold editor=  %t'" +"$command"
    fi

</details>

<details>
<summary>Misc notes</summary>
Defold api annotations were generated with https://github.com/astrochili/defold-annotations
TODO: add github workflow to update them automatically


</details>
