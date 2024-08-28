-- vim: ft=lua tw=80

-- Global objects defined by the C code
read_globals = {
    vim = {
        other_fields = true,
        fields = {
            b = {
                fields = {
                    epuppet_subtype = {
                        read_only = false,
                    }
                }
            }
        }
    }
}
