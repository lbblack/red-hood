local AttackShieldAISystem = tiny.processingSystem(class("AttackShieldAISystem"))

AttackShieldAISystem.filter = tiny.requireAll("ai", "isAttacking", "isShielding", "isEnemy")

function AttackShieldAISystem:process(e, dt)
	if e.hit then
		return
	end
	
	if e.ai == "attack" then
		-- print("ATTACKING")
		e.attackAnimation:update(dt)
	elseif e.ai == "shield" then
		-- print("SHIELDING")
		e.shieldAnimation:update(dt)
	end
end

return AttackShieldAISystem