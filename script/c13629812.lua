--忍法 影縫いの術
function c13629812.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1c0)
	e1:SetCost(c13629812.cost)
	e1:SetTarget(c13629812.target)
	e1:SetOperation(c13629812.operation)
	c:RegisterEffect(e1)
	--return
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(13629812,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCondition(c13629812.retcon)
	e2:SetOperation(c13629812.retop)
	c:RegisterEffect(e2)
end
function c13629812.cfilter(c)
	return c:IsSetCard(0x2b)
end
function c13629812.filter(c,e)
	return c:IsAbleToRemove() and c:IsCanBeEffectTarget(e)
end
function c13629812.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local dg=Duel.GetMatchingGroup(c13629812.filter,tp,0,LOCATION_MZONE,nil,e)
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,c13629812.cfilter,1,false,aux.ReleaseCheckTarget,nil,dg) end
	local g=Duel.SelectReleaseGroupCost(tp,c13629812.cfilter,1,1,false,aux.ReleaseCheckTarget,nil,dg)
	Duel.Release(g,REASON_COST)
end
function c13629812.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsAbleToRemove() end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c13629812.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or not tc then return end
	local seq=tc:GetSequence()
	if tc:IsControler(1-tp) then seq=seq+16 end
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,0,REASON_EFFECT+REASON_TEMPORARY)~=0 and tc:IsLocation(LOCATION_REMOVED) then
		c:SetCardTarget(tc)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE_FIELD)
		e1:SetRange(LOCATION_SZONE)
		e1:SetLabel(seq)
		e1:SetCondition(c13629812.discon)
		e1:SetOperation(c13629812.disop)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
	end
end
function c13629812.discon(e)
	return e:GetHandler():GetCardTargetCount()>0
end
function c13629812.disop(e,tp)
	return 0x1<<e:GetLabel()
end
function c13629812.retcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetFirstCardTarget()
	if tc and tc:IsLocation(LOCATION_REMOVED) and not c:IsLocation(LOCATION_DECK) then
		e:SetLabelObject(tc)
		tc:CreateEffectRelation(e)
		return true
	else return false end
end
function c13629812.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	if tc and tc:IsRelateToEffect(e) then
		local seq=tc:GetPreviousSequence()
		if seq>4 then
			Duel.SendtoGrave(tc,REASON_RULE+REASON_RETURN)
		end
		local zone=0x1<<seq
		Duel.ReturnToField(tc,tc:GetPreviousPosition(),zone)
	end
end
