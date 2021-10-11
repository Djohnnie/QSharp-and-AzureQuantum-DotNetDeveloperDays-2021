from azure.quantum import Workspace

workspace = Workspace(
    resource_id = "/subscriptions/50f157c9-e6e8-4191-beb7-3de96b563d95/resourceGroups/rq-azure-quantum/providers/Microsoft.Quantum/Workspaces/aq-workspace-djohnnie"
)

workspace.login()

from typing import List
from azure.quantum.optimization import Problem
from azure.quantum.optimization import ProblemType
from azure.quantum.optimization import Term

def buildTermsForCargoWeights(
    containerWeights: List[int] ) -> List[Term]:

    terms: List[Term] = []

    for i in range(len(containerWeights)):
        for j in range(len(containerWeights)):
            if i == j:
                continue

            terms.append(
                Term(
                    w = containerWeights[i] * containerWeights[j],
                    indices = [i, j]
                )
            )

    return terms

cargoWeights = [
    1, 5, 9, 21, 35, 5, 3, 5, 10, 11, 
    86, 2, 23, 44, 1, 17, 33, 8, 66, 
    24, 16, 5, 102, 2, 39, 16, 12, 26]

terms = buildTermsForCargoWeights( cargoWeights )

problem = Problem( 
    name = "Load my ships", 
    problem_type = ProblemType.ising, 
    terms = terms
)

from azure.quantum.optimization import ParallelTempering

solver = ParallelTempering( workspace, timeout = 100 )
result = solver.optimize( problem )

def outputResult( result ):
    
    totalWeightForShip1 = 0
    totalWeightForShip2 = 0

    for cargo in result['configuration']:
        
        cargoAssignment = result['configuration'][cargo]
        cargoWeight = cargoWeights[int(cargo)]
        ship = ''

        if cargoAssignment == 1:
            ship = "First"
            totalWeightForShip1 += cargoWeight
        else:
            ship = "Second"
            totalWeightForShip2 += cargoWeight

        print(f'Cargo: [{cargoWeight} tonnes] -> {ship} ship')

    print(f'\nTotal assigned weights:')
    print(f'\tShip 1: {totalWeightForShip1} tonnes')
    print(f'\tShip 2: {totalWeightForShip2} tonnes')

outputResult(result)