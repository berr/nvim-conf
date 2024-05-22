return function(module)
    -- This requires a module but simply outputs an error if it fails, and the
    -- rest of the configuration can keep running.
    local status, result = pcall(function() require(module) end)

    if not status then
        vim.notify(
            ("Error while requiring module %s: %s"):format(module, tostring(result)),
            vim.log.levels.ERROR
        )
        return
    end

    return result
end
