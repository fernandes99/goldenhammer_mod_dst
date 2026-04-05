local loot_multiplier = GetModConfigData("loot_multiplier", true)

PrefabFiles = {
    "goldenhammer",
}

Assets = {
    Asset("ATLAS", "images/inventoryimages/goldenhammer.xml"),
    Asset("IMAGE", "images/inventoryimages/goldenhammer.tex"),
    Asset("ANIM", "anim/goldenhammer.zip"),
    Asset("ANIM", "anim/swap_goldenhammer.zip"),
}

local function RegisterRecipe()
    AddRecipe2(
        "goldenhammer",
        { Ingredient("goldnugget", 6), Ingredient("twigs", 2) },
        GLOBAL.TECH.SCIENCE_ONE,
        { atlas = "images/inventoryimages/goldenhammer.xml" },
        { GLOBAL.CRAFTING_FILTERS.TOOLS.name, GLOBAL.CRAFTING_FILTERS.STRUCTURES.name }
    )
end

local function RegisterStrings()
    GLOBAL.STRINGS.NAMES.GOLDENHAMMER = "Golden Hammer"
    GLOBAL.STRINGS.RECIPE_DESC.GOLDENHAMMER = "Recover 100% of your building materials."
end

local function WorkerHasGoldenHammerEquipped(worker)
    if worker == nil or worker.components.inventory == nil then
        return false
    end
    local equipped = worker.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HANDS)
    return equipped ~= nil and equipped:HasTag("goldenhammer")
end

local function IsHammerWorkableWithLoot(inst)
    local workable = inst.components.workable
    return workable ~= nil
        and workable.action == GLOBAL.ACTIONS.HAMMER
        and inst.components.lootdropper ~= nil
end

local function DeliverSpawnedItem(item, structure_inst, worker)
    local is_animal = item:HasTag("animal") or item:HasTag("insect")
    local inventory = worker and worker.components.inventory

    if is_animal and inventory ~= nil and not inventory:IsFull() then
        inventory:GiveItem(item)
        return
    end

    local lootdropper = structure_inst.components.lootdropper
    if lootdropper ~= nil then
        lootdropper:FlingItem(item)
    else
        local x, y, z = structure_inst.Transform:GetWorldPosition()
        item.Transform:SetPosition(x, y, z)
    end
end

local function GetRecipeForHammerRefund(prefab)
    print("Prefab: " .. prefab)
    local r = GLOBAL.GetValidRecipe(prefab)
    if r ~= nil and r.ingredients ~= nil then
        return r
    end
    local item_prefab = prefab .. "_item"
    print("Prefab Item: " .. item_prefab)
    if GLOBAL.PrefabExists(item_prefab) then
        r = GLOBAL.GetValidRecipe(item_prefab)
        if r ~= nil and r.ingredients ~= nil then
            return r
        end
    end
    return nil
end


local function SpawnFullRecipeLoot(structure_inst, worker)
    local recipe = GetRecipeForHammerRefund(structure_inst.prefab)
    if recipe == nil then
        return
    end

    -- 3. "Sobrepõe" o DropLoot original para ele não spawnar nada
    local lootdropper = structure_inst.components.lootdropper
    lootdropper.DropLoot = function() end

    for _, ingredient in ipairs(recipe.ingredients) do
        local count = ingredient.amount
        if loot_multiplier ~= nil and type(loot_multiplier) == "number" then
            count = math.max(1, math.floor(count * loot_multiplier + 0.5))
        end
        for _ = 1, count do
            local spawned = GLOBAL.SpawnPrefab(ingredient.type)
            if spawned ~= nil then
                DeliverSpawnedItem(spawned, structure_inst, worker)
            end
        end
    end
end

local function MakeGoldenHammerWorkableOnFinish(previous_on_finish)
    return function(structure_inst, worker)
        if WorkerHasGoldenHammerEquipped(worker) then
            print("✨ Golden Hammer detectado! Redirecionando Loot...")
            print("Loot: " .. structure_inst.prefab)
            print("Worker: " .. worker.name)

            -- Aqui eu devo verificar se existe um item chamado `${structure_inst.prefab}_item`, se existir, eu devo usar ele como o item a ser dropado, se não existir, eu devo usar o item padrão do prefab.
            SpawnFullRecipeLoot(structure_inst, worker)
        end
        if previous_on_finish ~= nil then
            previous_on_finish(structure_inst, worker)
        end
    end
end

local function OnAnyPrefabInit(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end

    if not IsHammerWorkableWithLoot(inst) then
        return
    end

    local previous = inst.components.workable.onfinish
    inst.components.workable:SetOnFinishCallback(MakeGoldenHammerWorkableOnFinish(previous))
end

RegisterRecipe()
RegisterStrings()
AddPrefabPostInitAny(OnAnyPrefabInit)