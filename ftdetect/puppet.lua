-- nvim older than 0.7.0 vim.filetype is null, and detection fallback to vimscript
if vim.filetype == nil then
    return nil
end
vim.filetype.add({
    extension = {
        epp =
            function(path, bufnr)
                local root = vim.fn.fnamemodify(path, ':r')
                local matched = vim.filetype.match({ buf = bufnr, filename = root })
                -- subtype not detected in lua file, return nil so detection fallback
                -- on ftdetect/*.vim
                if matched == nil then
                    return nil
                -- don't loop
                elseif string.match(matched, 'epuppet') then
                    return matched
                -- Some epp files may get marked as "mason" type before this script is reached.
                -- NVim's own detect.lua forces the type if it detects a `<%` at the start of
                -- the file. All files ending in .epp should be epuppet
                elseif matched ~= 'mason' then
                    return matched .. '.epuppet'
                end
                if vim.g.epuppet_default_subtype ~= nil then
                    return vim.g.epuppet_default_subtype .. '.epuppet'
                else
                    return 'epuppet'
                end
            end,
    }
})
