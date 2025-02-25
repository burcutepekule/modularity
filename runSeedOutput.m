function [] = runSeedOutput(seed,numSims,outputMat_1,outputMat_2,numOfInputs,numOfOutputs,numOfGates,numOfCandidateSolutions,mult,preDefinedSize,freqAlternate,L,mutProb,onlyChangeConnections,folder_name,MVG)

rng(seed);
clearvars -except seed numSims outputMat_1 outputMat_2 numOfInputs numOfOutputs numOfGates numOfRuns numOfCandidateSolutions mult preDefinedSize freqAlternate L mutProb onlyChangeConnections folder_name MVG
disp(['---------------- Simulating seed ' num2str(seed) ' with mutation prob : ' num2str(mutProb) ' ----------------'])

% Pre-allocate arrays with final size
maxFitnessKeep = zeros(1, numSims);
minFitnessKeep = zeros(1, numSims);
meanFitnessKeep = zeros(1, numSims);

if(onlyChangeConnections==0)
    weightMutations = [(1-mutProb) mutProb/3 mutProb/3 mutProb/3];
else
    weightMutations = [(1-mutProb) mutProb 0 0];
end

sim = 1;
[keepCircuits,keepStructure,keepNumOfLayers,textCircuits,strAllText] = generateRandomCircuits(numOfInputs,numOfOutputs,numOfGates,numOfCandidateSolutions);

% %below is not necessary
% fittestStructurePick = [0 4;1 2;2 4;3 2;4 2;5 1];
% llsearch=find(keepNumOfLayers==5);
% for ll=llsearch
%     if(sum(sum(abs(keepStructure{ll}-fittestStructurePick)))==0)
%         disp(['---------------- seed ' num2str(seed) ', initialization complete, similar structure to possible modular solution found. ----------------'])
%     end
% end

outputMat = outputMat_1;
[fitness,~] = calculateFitnessAndFaultTolerance(textCircuits,keepStructure,outputMat,0);
circuitSizesVec = zeros(1, size(keepStructure,2));
for k=1:size(keepStructure,2)
    keepStructure_temp=keepStructure{k};
    circuitSizesVec(k) = sum(keepStructure_temp(2:end,2));
end

fitness = fitness-mult.*(circuitSizesVec>preDefinedSize);
textCircuitsMutated = textCircuits;
structuresMutated = keepStructure;
maxFitness = max(fitness,[],2);
minFitness = min(fitness,[],2);
[sortedFitness,sortedIndex] = sort(fitness,'descend');
meanFitness = mean(sortedFitness);

% Store initial values
maxFitnessKeep(1) = maxFitness;
minFitnessKeep(1) = minFitness;
meanFitnessKeep(1) = meanFitness;

fittestCircuitIdx = sortedIndex(1:L);
fittestCircuitIdx = sort(fittestCircuitIdx);
fittestStructure = structuresMutated(fittestCircuitIdx);
logicalArray = cell2mat(textCircuitsMutated(:,1))==fittestCircuitIdx;
fittestTextCircuit = textCircuitsMutated(orColumns(logicalArray),:);

disp(['---------------- seed ' num2str(seed) ', initialization complete, max fitness ' num2str(maxFitness) ', min fitness ' num2str(minFitness) ', mean fitness ' num2str(meanFitness) ' ----------------'])

if(MVG==1)
    if(mutProb==0)
        save([folder_name '/BEFORE_TOL_FITTEST_CIRCUIT_SIZE_MVG_SEED_' num2str(seed) '_' num2str(sim) '_' num2str(numOfInputs) '.mat'])
    else
        save([folder_name '/BEFORE_TOL_FITTEST_CIRCUIT_SIZE_MVG_MUT_SEED_' num2str(seed) '_' num2str(sim) '_' num2str(numOfInputs) '.mat'])
    end

    for sim = 2:numSims
        if(logical(mod(floor((sim-1)./freqAlternate),2)))
            outputMat = outputMat_2;
            disp(['---------------- simulation ' num2str(sim) ' , using output #' num2str(2) ' ----------------'])
        else
            outputMat = outputMat_1;
            disp(['---------------- simulation ' num2str(sim) ' , using output #' num2str(1) ' ----------------'])
        end

        structuresMutated = [];
        indexColumnCircuit = cell2mat(fittestTextCircuit(:,1));
        indexColumnCircuitUnq = unique(indexColumnCircuit);
        indexColumnCircuitNew = [];
        replicationPerCircuit = ceil(numOfCandidateSolutions/length(indexColumnCircuitUnq));

        for c=1:length(indexColumnCircuitUnq)
            indexColumnCircuitNew(indexColumnCircuit==indexColumnCircuitUnq(c))=1+(c-1)*replicationPerCircuit;
            structuresMutated{1+(c-1)*replicationPerCircuit} = fittestStructure{c};
        end
        fittestTextCircuit(:,1) = num2cell(indexColumnCircuitNew);
        textCircuitsMutated = fittestTextCircuit;
        circuitSizesVec = zeros(1, replicationPerCircuit*length(indexColumnCircuitUnq));

        for c=1:length(indexColumnCircuitUnq)
            mutationIndexVec = datasample(0:3,replicationPerCircuit-1,'Weights',weightMutations,'Replace',true);
            fittestTextCircuitTemp = fittestTextCircuit(cell2mat(fittestTextCircuit(:,1))==(1+(c-1)*replicationPerCircuit),:);
            fittestStructureTemp = structuresMutated{1+(c-1)*replicationPerCircuit};
            circuitSizesVec((c-1)*replicationPerCircuit+1) = sum(fittestStructureTemp(2:end,2));
            for mut=1:length(mutationIndexVec)
                [textCircuitsTemp_mutated,structureTemp_mutated] = mutateCircuit(fittestTextCircuitTemp,fittestStructureTemp,mutationIndexVec(mut));
                indexColumnCircuit = cell2mat(textCircuitsTemp_mutated(:,1));
                textCircuitsTemp_mutated(:,1) = num2cell((indexColumnCircuit-1)+(mut+1)*ones(size(indexColumnCircuit)));
                textCircuitsMutated = [textCircuitsMutated;textCircuitsTemp_mutated];
                structuresMutated{mut+(c-1)*replicationPerCircuit+1} = structureTemp_mutated;
                circuitSizesVec(mut+(c-1)*replicationPerCircuit+1)=sum(structureTemp_mutated(2:end,2));
            end
        end

        [~,ii]=sort(cell2mat(textCircuitsMutated(:,1)),'ascend');
        textCircuitsMutatedOrdered=textCircuitsMutated(ii,:);
        textCircuitsMutated = textCircuitsMutatedOrdered;
        [fitnessTemp,~] = calculateFitnessAndFaultTolerance(textCircuitsMutated,structuresMutated,outputMat,0);
        fitnessTemp = fitnessTemp-mult.*(circuitSizesVec>preDefinedSize);

        maxFitness = max(fitnessTemp,[],2);
        minFitness = min(fitness,[],2);
        [sortedFitness,sortedIndex] = sort(fitnessTemp,'descend');
        meanFitness = mean(sortedFitness);

        % Store values in pre-allocated arrays
        minFitnessKeep(sim) = minFitness;
        maxFitnessKeep(sim) = maxFitness;
        meanFitnessKeep(sim) = meanFitness;

        fittestCircuitIdx = sortedIndex(1:L);
        fittestCircuitIdx = sort(fittestCircuitIdx);
        fittestStructure = structuresMutated(fittestCircuitIdx);
        logicalArray = cell2mat(textCircuitsMutated(:,1))==fittestCircuitIdx;
        fittestTextCircuit = textCircuitsMutated(orColumns(logicalArray),:);

        disp(['---------------- seed ' num2str(seed) ', simulation ' num2str(sim) ' complete, max fitness ' num2str(maxFitness) ', min fitness ' num2str(minFitness) ', mean fitness ' num2str(meanFitness) ' ----------------'])
        if(mod(sim,5)==0) %save every x (5 is ok for freqAlternate=20 but not for 2)
            if(mutProb==0)
                save([folder_name '/BEFORE_TOL_FITTEST_CIRCUIT_SIZE_MVG_SEED_' num2str(seed) '_' num2str(sim) '_' num2str(numOfInputs) '.mat'])
            else
                save([folder_name '/BEFORE_TOL_FITTEST_CIRCUIT_SIZE_MVG_MUT_SEED_' num2str(seed) '_' num2str(sim) '_' num2str(numOfInputs) '.mat'])
            end
        end
    end
    save([folder_name '/BEFORE_TOL_ALL_SIZE_MVG_SEED_' num2str(seed) '.mat'])
    disp(['---------------- seed ' num2str(seed) ', max fitness of 1 achieved, now check fault tolerance convergence ----------------'])
else
    if(mutProb==0)
        save([folder_name '/BEFORE_TOL_FITTEST_CIRCUIT_SIZE_CG_SEED_' num2str(seed) '_' num2str(sim) '_' num2str(numOfInputs) '.mat'])
    else
        save([folder_name '/BEFORE_TOL_FITTEST_CIRCUIT_SIZE_CG_MUT_SEED_' num2str(seed) '_' num2str(sim) '_' num2str(numOfInputs) '.mat'])
    end

    outputMat = outputMat_1; %CONSTANT ENVIRONMENT
    for sim = 2:numSims
        structuresMutated = [];
        indexColumnCircuit = cell2mat(fittestTextCircuit(:,1));
        indexColumnCircuitUnq = unique(indexColumnCircuit);
        indexColumnCircuitNew = [];
        replicationPerCircuit = ceil(numOfCandidateSolutions/length(indexColumnCircuitUnq));

        for c=1:length(indexColumnCircuitUnq)
            indexColumnCircuitNew(indexColumnCircuit==indexColumnCircuitUnq(c))=1+(c-1)*replicationPerCircuit;
            structuresMutated{1+(c-1)*replicationPerCircuit} = fittestStructure{c};
        end
        fittestTextCircuit(:,1) = num2cell(indexColumnCircuitNew);
        textCircuitsMutated = fittestTextCircuit;
        circuitSizesVec = zeros(1, replicationPerCircuit*length(indexColumnCircuitUnq));

        for c=1:length(indexColumnCircuitUnq)
            mutationIndexVec = datasample(0:3,replicationPerCircuit-1,'Weights',weightMutations,'Replace',true);
            fittestTextCircuitTemp = fittestTextCircuit(cell2mat(fittestTextCircuit(:,1))==(1+(c-1)*replicationPerCircuit),:);
            fittestStructureTemp = structuresMutated{1+(c-1)*replicationPerCircuit};
            circuitSizesVec((c-1)*replicationPerCircuit+1) = sum(fittestStructureTemp(2:end,2));
            for mut=1:length(mutationIndexVec)
                [textCircuitsTemp_mutated,structureTemp_mutated] = mutateCircuit(fittestTextCircuitTemp,fittestStructureTemp,mutationIndexVec(mut));
                indexColumnCircuit = cell2mat(textCircuitsTemp_mutated(:,1));
                textCircuitsTemp_mutated(:,1) = num2cell((indexColumnCircuit-1)+(mut+1)*ones(size(indexColumnCircuit)));
                textCircuitsMutated = [textCircuitsMutated;textCircuitsTemp_mutated];
                structuresMutated{mut+(c-1)*replicationPerCircuit+1} = structureTemp_mutated;
                circuitSizesVec(mut+(c-1)*replicationPerCircuit+1)=sum(structureTemp_mutated(2:end,2));
            end
        end

        [~,ii]=sort(cell2mat(textCircuitsMutated(:,1)),'ascend');
        textCircuitsMutatedOrdered=textCircuitsMutated(ii,:);
        textCircuitsMutated = textCircuitsMutatedOrdered;
        [fitnessTemp,~] = calculateFitnessAndFaultTolerance(textCircuitsMutated,structuresMutated,outputMat,0);
        fitnessTemp = fitnessTemp-mult.*(circuitSizesVec>preDefinedSize);

        maxFitness = max(fitnessTemp,[],2);
        minFitness = min(fitness,[],2);
        [sortedFitness,sortedIndex] = sort(fitnessTemp,'descend');
        meanFitness = mean(sortedFitness);

        % Store values in pre-allocated arrays
        minFitnessKeep(sim) = minFitness;
        maxFitnessKeep(sim) = maxFitness;
        meanFitnessKeep(sim) = meanFitness;

        fittestCircuitIdx = sortedIndex(1:L);
        fittestCircuitIdx = sort(fittestCircuitIdx);
        fittestStructure = structuresMutated(fittestCircuitIdx);
        logicalArray = cell2mat(textCircuitsMutated(:,1))==fittestCircuitIdx;
        fittestTextCircuit = textCircuitsMutated(orColumns(logicalArray),:);

        disp(['---------------- seed ' num2str(seed) ', simulation ' num2str(sim) ' complete, max fitness ' num2str(maxFitness) ', min fitness ' num2str(minFitness) ', mean fitness ' num2str(meanFitness) ' ----------------'])

        if(mod(sim,5)==0) %save every x (5 is ok for freqAlternate=20 but not for 2)
            if(mutProb==0)
                save([folder_name '/BEFORE_TOL_FITTEST_CIRCUIT_SIZE_CG_SEED_' num2str(seed) '_' num2str(sim) '_' num2str(numOfInputs) '.mat'])
            else
                save([folder_name '/BEFORE_TOL_FITTEST_CIRCUIT_SIZE_CG_MUT_SEED_' num2str(seed) '_' num2str(sim) '_' num2str(numOfInputs) '.mat'])
            end
        end
    end
    save([folder_name '/BEFORE_TOL_ALL_SIZE_CG_SEED_' num2str(seed) '.mat'])
    disp(['---------------- seed ' num2str(seed) ', max fitness of 1 achieved, now check fault tolerance convergence ----------------'])
end
end