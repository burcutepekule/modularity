function [] = runSeed(seed,numSims,numOfInputs,mutProb,numOfGatesVec,onlyChangeConnections,freqAlternate,MVG)
folder_name = fullfile('./local_output', ['freq_' num2str(freqAlternate)]);
if ~isfolder(folder_name)
    mkdir(folder_name)
end
% THIS IS TO REPLICATE THE RESULTS OF URI ALON
inpMat         = [];
for i=0:(2^numOfInputs-1)
    inpMat = [inpMat;str2logicArray(dec2bin(i,numOfInputs))];
end
% An Introduction to Systems Biology, Eq. 15.5.1
if (numOfInputs==4)
    G1             = and(xor(inpMat(:,1),inpMat(:,2)),xor(inpMat(:,3),inpMat(:,4)));
    G2             = or(xor(inpMat(:,1),inpMat(:,2)),xor(inpMat(:,3),inpMat(:,4)));
    outputMat_1    = G1;
    outputMat_2    = G2;
    preDefinedSize = 11;
    numOfCandidateSolutions = 1000; %number of candidate solutions (generate here, this cannot be in a function since needs to be constant)
    if(numOfGatesVec==1)
        % randomly sampled # of gates
        numOfGates     = randi([preDefinedSize-2 preDefinedSize],1,numOfCandidateSolutions);%number of NAND gates to start with, excludes the output gates
    else
        % same # of gates for all circuits
        numOfGates     = preDefinedSize-1; %number of NAND gates to start with, excludes the output gates
    end
elseif (numOfInputs==6)
    layer_11       = xor(inpMat(:,1),inpMat(:,2));
    layer_12       = xor(inpMat(:,3),inpMat(:,4));
    layer_13       = xor(inpMat(:,5),inpMat(:,6));
    layer_21       = and(layer_11,layer_12);
    layer_22       = and(layer_12,layer_13);
    G1             = and(layer_21,layer_22);
    G2             = or(layer_21,layer_22);
    outputMat_1    = G1;
    outputMat_2    = G2;
    preDefinedSize = 21;
    numOfCandidateSolutions = 1000; %number of candidate solutions (generate here, this cannot be in a function since needs to be constant)
    if(numOfGatesVec==1)
        % randomly sampled # of gates
        numOfGates     = randi([preDefinedSize-2 preDefinedSize],1,numOfCandidateSolutions);%number of NAND gates to start with, excludes the output gates
    else
        % same # of gates for all circuits
        numOfGates     = preDefinedSize-1; %number of NAND gates to start with, excludes the output gates
    end
else
    disp(['---------------- Input Number not defined ----------------'])

end
numOfOutputs   = 1;
mult           = 0.2;
L              = floor(0.25*numOfCandidateSolutions); %top 25 percent / top 50 percent?
runSeedOutput(seed,numSims,outputMat_1,outputMat_2,numOfInputs,numOfOutputs,numOfGates,numOfCandidateSolutions,mult,preDefinedSize,freqAlternate,L,mutProb,onlyChangeConnections,folder_name,MVG)
end

