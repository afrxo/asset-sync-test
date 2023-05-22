local PLACE = ...;
local TEMP_FOLDER = "temp"

local function copyChildren(from, to)
    if (not from) then return end;
    for _, child in ipairs(from:GetChildren()) do
        child.Parent = to;
    end
end

local function isBlacklisted(NoSync, mirror, place, directory)
    if (not NoSync:FindFirstChild(place)) then return false end;

    for _, child in ipairs(NoSync:FindFirstChild(place):GetChildren()) do
        if (child.Name == (mirror.."/"..directory)) then return true end;
    end
end

local function syncAssets(Sync, NoSync, Target, place, mirror, output)
    local Assets = Sync[mirror];

    for _, directory in ipairs(Assets:GetChildren()) do
        directory = directory.Name;
        if (not isBlacklisted(NoSync, mirror, place, directory)) then
            copyChildren(Assets:FindFirstChild(directory), Target:FindFirstChild(directory));
        end
    end

    local outputPath = TEMP_FOLDER .. "/" .. output;
    remodel.writePlaceFile(Target, outputPath);
end

local start = os.clock()

-- Use local asset place / fetch using readPlaceAsset
local assetPlace = remodel.readPlaceFile("assets.rbxl");
local precompiled = remodel.readPlaceFile(PLACE .. ".rbxl");

local sync = assetPlace.Workspace.sync;
local noSync = assetPlace.Workspace.nosync;

local output = PLACE .. "-synced.rbxl";

-- Sync assets shared across places
syncAssets(sync, noSync, precompiled, PLACE, "shared", output);
if (sync:FindFirstChild(PLACE)) then
    -- Sync place specific assets
    syncAssets(sync, noSync, precompiled, PLACE, PLACE, output);
end;

print("Finished syncing assets for:", PLACE);
print("Completed in:", os.clock() - start, "seconds.");