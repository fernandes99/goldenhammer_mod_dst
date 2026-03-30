local assets = {
    Asset("ANIM", "anim/goldenhammer.zip"),
    Asset("ANIM", "anim/swap_goldenhammer.zip"),
    Asset("ATLAS", "images/inventoryimages/goldenhammer.xml"), 
}

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_goldenhammer", "swap_object")
    owner.AnimState:Show("ARM_carry") 
    owner.AnimState:Hide("ARM_normal") 
end

local function onunequip(inst, owner) 
    owner.AnimState:ClearOverrideSymbol("swap_object")
    owner.AnimState:Hide("ARM_carry") 
    owner.AnimState:Show("ARM_normal") 
end


local function fn()
    local inst = CreateEntity()

    print("GoldenHammer: prefab carregado")

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("goldenhammer")
    inst.AnimState:SetBuild("goldenhammer")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("goldenhammer")

    inst:AddTag("hammer")

    inst:AddTag("tool")

    inst:AddTag("weapon")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "goldenhammer"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/goldenhammer.xml"

    inst:AddComponent("inspectable")

    inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.HAMMER)

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(10)

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(200)
    inst.components.finiteuses:SetUses(200)
    inst.components.finiteuses:SetOnFinished(inst.Remove)

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
	inst.components.equippable.walkspeedmult = 1

    return inst
end

return Prefab("goldenhammer", fn, assets)