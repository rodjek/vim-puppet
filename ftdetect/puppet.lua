-- Some epp files may get marked as "mason" type before this script is reached.
-- Vim's own scripts.vim forces the type if it detects a `<%` at the start of
-- the file. All files ending in .epp should be epuppet
vim.filetype.add({
    extension = {
        epp =
            function(path, bufnr)
                local path_wo_epp = path:sub(1,-5)
                local matched = vim.filetype.match({ buf = bufnr, filename = path_wo_epp })
                if matched ~= nil and matched ~= 'mason' then
                    vim.b.epuppet_subtype = matched
                end
                return 'epuppet'
            end,
    }
})
