clear all;close all;clc;
freqAlternate = 20;
MVG           = 1;
seedPick      = 9;
inputSize     = 4;
folder_name   = fullfile('./local_output', ['freq_' num2str(freqAlternate)]);
if(MVG==1)
    env_in='MVG';
else
    env_in='CG';
end
totalNumVec = [];
fileinfoBefore = dir([folder_name '/BEFORE_TOL_FITTEST_CIRCUIT_SIZE_' env_in '_MUT_SEED_' num2str(seedPick) '_*_' num2str(inputSize) '.mat']);
allNames       = {fileinfoBefore.name};
totalNumVec    = [totalNumVec max(str2double(extractBefore(extractAfter(allNames,['BEFORE_TOL_FITTEST_CIRCUIT_SIZE_' env_in '_MUT_SEED_' num2str(seedPick) '_' ]), ['_' num2str(inputSize) '.mat'])))];
% DELETE THE FILES BEFORE LAST SAVED FILE FOR SPACE
largestSimName = ['BEFORE_TOL_FITTEST_CIRCUIT_SIZE_' env_in '_MUT_SEED_' num2str(seedPick) '_' num2str(totalNumVec(end)) '_' num2str(inputSize) '.mat'];
close all;
printGIF(totalNumVec(end),freqAlternate,seedPick,env_in,inputSize,folder_name)

