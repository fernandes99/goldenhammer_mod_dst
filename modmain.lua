local loot_multiplier = GetModConfigData("loot_multiplier", true)

PrefabFiles = {
    "goldenhammer"
}

Assets = {
    Asset("ATLAS", "images/inventoryimages/goldenhammer.xml"),
    Asset("IMAGE", "images/inventoryimages/goldenhammer.tex"),
    Asset("ANIM", "anim/goldenhammer.zip"),
}

AddRecipe2(
    "goldenhammer",
    {
        Ingredient("goldnugget", 6),
        Ingredient("twigs", 2),
    },
    GLOBAL.TECH.NONE,
    {
        atlas = "images/inventoryimages/goldenhammer.xml",
    },
    { "CHARACTER" }
)

GLOBAL.STRINGS.RECIPE_DESC.GOLDENHAMMER = "TESTE";

AddPrefabPostInitAny(function(inst)
    if not GLOBAL.TheWorld.ismastersim then return end

    -- Verificamos se o objeto é martelável e tem um lootdropper
    if inst.components.workable and inst.components.workable.action == GLOBAL.ACTIONS.HAMMER 
       and inst.components.lootdropper then
        
        local old_onfinish = inst.components.workable.onfinish

        inst.components.workable:SetOnFinishCallback(function(inst, worker)
            local is_golden = false

            if worker and worker.components.inventory then
                local item = worker.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HANDS)
                if item and item:HasTag("goldenhammer") then
                    is_golden = true
                end
            end

            if is_golden then
                print("✨ Golden Hammer detectado! Redirecionando Loot...")
                
                -- 1. Salva a função original de drop para não quebrar o objeto para sempre e prevenir crashes
                local old_DropLoot = inst.components.lootdropper.DropLoot
                
                -- 2. "Sobrepõe" o DropLoot original para ele não spawnar nada
                inst.components.lootdropper.DropLoot = function() end

                -- 3. Lógica customizada: Dropa 100% da receita
                local recipe = GLOBAL.GetValidRecipe(inst.prefab) or GLOBAL.AllRecipes[inst.prefab]
                if recipe and recipe.ingredients then
                    for _, ingredient in ipairs(recipe.ingredients) do
                        for i = 1, ingredient.amount do
                            local item = GLOBAL.SpawnPrefab(ingredient.type)
                            
                            if item then
                                -- Verifica se o item é um animal e se quem está recebendo (inst) tem inventário
                                local is_animal = item:HasTag("animal") or item:HasTag("insect")
                                local inventory = worker and worker.components.inventory
                                
                                if is_animal and inventory and not inventory:IsFull() then
                                    -- Tenta colocar direto no inventário
                                    inventory:GiveItem(item)
                                else
                                    -- Se não for animal ou o inventário estiver cheio, dropa no chão
                                    if inst.components.lootdropper then
                                        inst.components.lootdropper:FlingItem(item)
                                    else
                                        local x, y, z = inst.Transform:GetWorldPosition()
                                        item.Transform:SetPosition(x, y, z)
                                    end
                                end
                            end
                        end
                    end
                end

                -- 4. Chama o onfinish original (que vai seguir com a execução... deletar a estrutura, tocar som, etc)
                if old_onfinish then
                    old_onfinish(inst, worker)
                end
            else
                -- Se não for o golden hammer, segue a vida normal
                if old_onfinish then
                    old_onfinish(inst, worker)
                end
            end
        end)
    end
end)
