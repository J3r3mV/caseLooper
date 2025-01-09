#!/usr/bin/lua

package.cpath = package.cpath .. ";./lib/?.so"
local fs = require("fsystem") -- .so

-- ============================================================
-- Script : caseLooper.lua
-- Author : J3r3m - https://github.com/J3r3mV/caseLooper
-- Version : 1.0
--
-- Description :
--      This script allows you to loop the control of test cases using
--  input redirection.
--      Test cases are saved in a file in the format:
--          in<identifier>[.extension]
--      Test results are saved in a file in the format:
--          out<identifier>[.extension], optional.
--
--      This tool will control the result of your script using the "input"
-- dataset with the "output" result.
--
-- Prerequisites :
--      - Lua :)
--      - All these files must be in a "tests" folder at the same level as your script.

-- Usage:
--      - Start by typing: "lua caseLooper.lua -h" to know how it works and its options.
--      - Example : lua caseLooper.lua -i python -s example.lua -d
-- ============================================================

local SEP_OS = package.config:sub(1, 1)
local PATH_TEST = "tests"
local ECHEC = "\27[31m"
local SUCCESS = "\27[32m"
local NC = "\27[38;5;214m"
local RESET = "\27[0m"
local RESULT = "\27[34m"
local BOLD = "\27[1m"

-- ============================================================
-- FUNCTIONS
-- ============================================================

local function runTest(sFile, args)
    if sFile:match("^in%d+") then

        local sIdFile = sFile:match("in(%d+)")
        local sExtension = sFile:match("in%d+([%.%w]*)")
        local sPathIn = PATH_TEST .. SEP_OS .. sFile

        -- Data File Input

        local fFileIn = io.open(sPathIn, "r")
        if fFileIn then

            local sContentIn = fFileIn:read("*a")
            fFileIn:close()

            -- Execute test

            local sCmd = string.format("%s %s < %s", args.i, args.s, sPathIn)
            local proc = io.popen(sCmd, "r")
            if proc then
                local sResult = proc:read("*a")
                local success, _, exitCode = proc:close()
                if not success then
                    print(
                        sCmd .. " : Error in execution command ! Exit code : " ..
                            exitCode)

                end

                -- Data File Output if exist

                local sContentOut = nil
                local sPathOut = string.format("%s%s%s%s%s", PATH_TEST, SEP_OS,
                                               "out", sIdFile, sExtension)
                local fFileOut = io.open(sPathOut, "r")
                if fFileOut then
                    sContentOut = fFileOut:read("*a")
                    fFileOut:close()
                end

                -- Bilan test

                local color
                local bResult = (sResult == sContentOut)
                if bResult then
                    color = SUCCESS
                else
                    if not sContentOut then
                        color = NC
                        sContentOut = "Output file not found !"
                    else
                        color = ECHEC
                    end
                end

                print(color .. "Unit Case n° " .. BOLD .. sIdFile .. " = " ..
                          string.upper(tostring(bResult)) .. RESET)

                if args.d then
                    print("\tResult script = ")
                    print(RESULT .. "\t" .. sResult .. RESET)
                    print("\tResult Output File = ")
                    print(RESULT .. "\t" .. sContentOut .. RESET)
                end

            end

        else
            print(sFile .. " : Input file name not found !")
        end

    end
end

local function show_help()
    print("Usage: lua your_script.lua -i <value> [-u <value>] [-d]")
    print("Options:")
    print("  -h    : Help")
    print("  -s    : Yous script (required)")
    print("  -i    : Interpreter, lua, php, python, ... (required)")
    print(
        "  -u    : Input file name to be tested individually; if omitted, all tests will be run (optional)")
    print(
        "  -d    : Displays detailed input and output of the test case (optional)")
end

-- ============================================================
-- MAIN
-- ============================================================

-- ### Parameters

local args = {}
for i = 1, #arg do
    if arg[i]:sub(1, 1) == "-" then
        local key = arg[i]:sub(2)
        local value =
            arg[i + 1] and arg[i + 1]:sub(1, 1) ~= "-" and arg[i + 1] or true
        args[key] = value
    end
end

if args.h or not args.s or not args.i then
    show_help()
    if not args.h then
        print(ECHEC .. "Error: the options -s and -i are required." .. RESET)
    end
    os.exit(1)
end

-- ### Use case individually

if args.u then
    runTest(args.u, args)
    os.exit(0)
end

-- ### Main-Loop

for _, sFile in ipairs(fs.readdirFile(PATH_TEST)) do runTest(sFile, args) end
