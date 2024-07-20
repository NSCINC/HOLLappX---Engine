-- SPDX-License-Identifier: MIT

-- Estrutura para armazenar detalhes do plano de investimento
local InvestmentPlan = {
    initialInvestment = 0,
    monthlyReturn = 0,
    annualReturn = 0,
    netAnnualReturn = 0,
    slots = 0
}

-- Mapeamento para armazenar dados em cache
local cache = {}

-- Evento para registrar adição de plano de investimento
local function InvestmentPlanAdded(planName, initialInvestment, slots)
    print("Plan added:", planName)
    -- Não é necessário emitir eventos em Lua, então apenas imprimimos uma mensagem
end

-- Evento para registrar atualização de plano de investimento
local function InvestmentPlanUpdated(planName)
    print("Plan updated:", planName)
end

-- Evento para registrar remoção de plano de investimento
local function InvestmentPlanRemoved(planName)
    print("Plan removed:", planName)
end

-- Função para adicionar um plano de investimento ao cache
local function addInvestmentPlan(planName, initialInvestment, monthlyReturn, annualReturn, netAnnualReturn, slots)
    print("Adding plan:", planName)
    assert(cache[planName] == nil, "Plan already exists")
    cache[planName] = {
        initialInvestment = initialInvestment,
        monthlyReturn = monthlyReturn,
        annualReturn = annualReturn,
        netAnnualReturn = netAnnualReturn,
        slots = slots
    }
    InvestmentPlanAdded(planName, initialInvestment, slots)
end

-- Função para atualizar um plano de investimento no cache
local function updateInvestmentPlan(planName, initialInvestment, monthlyReturn, annualReturn, netAnnualReturn, slots)
    print("Updating plan:", planName)
    local plan = cache[planName]
    assert(plan ~= nil, "Plan does not exist")
    cache[planName] = {
        initialInvestment = initialInvestment or plan.initialInvestment,
        monthlyReturn = monthlyReturn or plan.monthlyReturn,
        annualReturn = annualReturn or plan.annualReturn,
        netAnnualReturn = netAnnualReturn or plan.netAnnualReturn,
        slots = slots or plan.slots
    }
    InvestmentPlanUpdated(planName)
end

-- Função para remover um plano de investimento do cache
local function removeInvestmentPlan(planName)
    print("Removing plan:", planName)
    local plan = cache[planName]
    assert(plan ~= nil, "Plan does not exist")
    cache[planName] = nil
    InvestmentPlanRemoved(planName)
end

-- Função para consultar os detalhes de um plano de investimento no cache
local function getInvestmentPlanDetails(planName)
    print("Fetching details for plan:", planName)
    local plan = cache[planName]
    assert(plan ~= nil, "Plan does not exist")
    return plan.initialInvestment, plan.monthlyReturn, plan.annualReturn, plan.netAnnualReturn, plan.slots
end

-- Função para listar todos os planos de investimento
local function listInvestmentPlans()
    print("Listing all investment plans:")
    for planName, plan in pairs(cache) do
        print(string.format("Plan Name: %s", planName))
        print(string.format("  Initial Investment: %d", plan.initialInvestment))
        print(string.format("  Monthly Return: %d", plan.monthlyReturn))
        print(string.format("  Annual Return: %d", plan.annualReturn))
        print(string.format("  Net Annual Return: %d", plan.netAnnualReturn))
        print(string.format("  Slots: %d", plan.slots))
        print()
    end
end

-- Exemplo de uso das funções definidas

-- Etapa 1: Adicionar um plano de investimento
print("\nStep 1: Adding an Investment Plan")
addInvestmentPlan("economicPlan", 500, 5, 60, 300, 500)

-- Etapa 2: Consultar detalhes de um plano de investimento
print("\nStep 2: Fetching Investment Plan Details")
local initialInvestment, monthlyReturn, annualReturn, netAnnualReturn, slots = getInvestmentPlanDetails("economicPlan")
print("Initial Investment:", initialInvestment)
print("Monthly Return:", monthlyReturn)
print("Annual Return:", annualReturn)
print("Net Annual Return:", netAnnualReturn)
print("Slots:", slots)

-- Etapa 3: Atualizar um plano de investimento
print("\nStep 3: Updating an Investment Plan")
updateInvestmentPlan("economicPlan", nil, 10, nil, 400, nil)

-- Etapa 4: Consultar detalhes do plano de investimento após atualização
print("\nStep 4: Fetching Updated Investment Plan Details")
initialInvestment, monthlyReturn, annualReturn, netAnnualReturn, slots = getInvestmentPlanDetails("economicPlan")
print("Initial Investment:", initialInvestment)
print("Monthly Return:", monthlyReturn)
print("Annual Return:", annualReturn)
print("Net Annual Return:", netAnnualReturn)
print("Slots:", slots)

-- Etapa 5: Listar todos os planos de investimento
print("\nStep 5: Listing All Investment Plans")
listInvestmentPlans()

-- Etapa 6: Remover um plano de investimento
print("\nStep 6: Removing an Investment Plan")
removeInvestmentPlan("economicPlan")

-- Etapa 7: Listar todos os planos de investimento após remoção
print("\nStep 7: Listing All Investment Plans After Removal")
listInvestmentPlans()

-- Fim dos exemplos
print("\nLua code execution completed.")
