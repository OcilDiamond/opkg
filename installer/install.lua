--[[
    TODO: 
        Add option to do either an internal install (HTTP),
        or a local install from a floppy!

    Useage:
        install.lua
        -N: Use Network Install
        -n: Use Offline Install
        -v: verbose
        -q: quiet
        -D: show debug statements
        -d: hide debug statements
        -L: show log statements
        -l: hide low statements
        -W: show warning statements
        -w: hide warning statements
        -E: show error statements,
        -e: hide error statements
        (not implemented) -C / --create-offline-install: Creats an offline install in the specified folder

]]

--  import libraries
local filesystem = require("filesystem")

--  Define defaults
local options = {
    ["network"] = true,
    ["show-debug"] = false,
    ["show-log"] = true,
    ["show-warn"] = true,
    ["show-error"] = true
}

--  Get our arguments
local args = {...}

for _, argument in pairs(args) do
    if argument == "-N" then
        options["network"] = true
    elseif argument == "-n" then
        options["network"] = false
    elseif argument == "-v" then
        options["show-debug"] = true
        options["show-log"] = true
        options["show-warn"] = true
        options["show-error"] = true
    elseif argument == "-q" then
        options["show-debug"] = false
        options["show-log"] = false
        options["show-warn"] = false
        options["show-error"] = false
    elseif argument == "-D" then
        options["show-debug"] = true
    elseif argument == "-d" then
        options["show-debug"] = false
    elseif argument == "-L" then
        options["show-log"] = true
    elseif argument == "-l" then
        options["show-log"] = false
    elseif argument == "-W" then
        options["show-warn"] = true
    elseif argument == "-w" then
        options["show-warn"] = false
    elseif argument == "-E" then
        options["show-error"] = true
    elseif argument == "-e" then
        options["show-error"] = false
    end
end

--  check something
if not options["network"] then
    print("Offline installs are currently not supported")
    return
end

--  define the logging methods
local function log_print(state, ...)
    local timestamp = "00.00" -- (TODO)
    local message = "[" .. timestamp .. "][" .. state .. "] " .. table.concat({...}, "")
    if options["show-" .. state] then
        if state == "error" then
            io.stderr:write(message .. "\n")
        else
            io.write(message .. "\n")
        end
    end
end
local function printd(...)
    log_print("debug", ...)
end
local function printl(...) 
    log_print("log", ...)
end
local function printw(...)
    log_print("warn", ...)
end
local function printe(...)
    log_print("error", ...)
end

printl("Downloading prerequisite")
--  prerequisite stage
do
    --  libraries
    local internet = require("internet")

    --  helpers
    local function create_folder(path)
        filesystem.makeDirectory(path)
    end
    local function download_file(url, path)
        local f, reason = io.open(filename, "w")
        if not f then
            printe("Failed opening file for writing: " .. reason)
            return
        end

        local result, response = pcall(internet.request, url)
        if result then
            printd("success")
            for chunk in response do
                if not options.k then
                    string.gsub(chunk, "\r\n", "\n")
                end
                f:write(chunk)
            end
            f:close()
            printd("Saved data to " .. filename)
            return true
          else
            printd("failed")
            f:close()
            fs.remove(filename)
            printe("HTTP request failed: " .. response)
            return false
        end
    end

    --  main
    local root_dir = "/tmp/opkg-install"
    local root_url = ""
    local to_download = {}

    create_folder(root_dir)
    if not download_file("", root_dir .. "/files.txt") then

    end

end

--  load in the required modules
local zipper = require("libs/zipper.lua")
local heyjson = require("libs/heyjson.lua")

--  define some helpers
function wget()

end