function [] = printGIF(totalNum,freqAlternate,seed,env_in,inputSize,folder_name)

filename = [folder_name '/circuitsAnimated_' env_in '_SEED_' num2str(seed) '_' num2str(inputSize) '.gif'] ;

for simIdx=[1 freqAlternate:freqAlternate:totalNum]

    load([folder_name '/BEFORE_TOL_FITTEST_CIRCUIT_SIZE_' env_in '_MUT_SEED_' num2str(seed) '_' num2str(simIdx) '_' num2str(inputSize) '.mat']);


    if(logical(mod(floor((simIdx-1)./freqAlternate),2)))
        if(simIdx==1)
            titleText = {'Initialization : Using output #2'};
        else
            titleText = {'End of epoch : Using output #2'};
        end
    else

        if(simIdx==1)
            titleText = {'Initialization : Using output #1'};
        else
            titleText = {'End of epoch : Using output #1'};
        end
    end


    indPlot          = 1; %plot the "fittest"
    allInds          = unique(cell2mat(fittestTextCircuit(:,1)));
    structureTemp    = fittestStructure{indPlot};
    textCircuitsTemp = fittestTextCircuit(cell2mat(fittestTextCircuit(:,1))==allInds(indPlot),:);


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    close all;
    figure
    set(gcf, 'Position',  [100, 300, 700, 1200])
    [ha, ~] = tight_subplot(2,1,[0.08 0.05],[0.05 0.05],[0.075 0.02]);
    axis tight manual

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% FIRST COLUMN %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    cmap     = bone(4);
    cmap     = [cmap(1:3,:);[255, 42, 38]./255;[255, 114, 111]./255];
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    cla(ha(1))
    axes(ha(1))

    if(inputSize>4)
        connectionMatInitial = drawCircuit_text(structureTemp,textCircuitsTemp,0);
    else
        connectionMatInitial = drawCircuit_text_optimal(structureTemp,textCircuitsTemp,0);
    end

    title(titleText,'FontSize', 16);
    axis off;



    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    cla(ha(2))
    axes(ha(2))
    plot([1 freqAlternate:freqAlternate:simIdx],maxFitnessKeep([1 freqAlternate:freqAlternate:simIdx]),'k','linewidth',2)
    hold on;
    plot([1 freqAlternate:freqAlternate:simIdx],meanFitnessKeep([1 freqAlternate:freqAlternate:simIdx]),'Color', [255, 0, 142]./255,'linewidth',2)
    grid on;
    axis([0 totalNum 0.35 1.05])
    ylabel('Value', 'FontSize', 16);
    xlabel('Iteration index', 'FontSize', 16);
    title('Fitness values', 'FontSize', 16);
    %     legend('Fitness','Fault Tolerance', 'FontSize', 14, 'Location', 'southeast');
    legend(['Max Fitness : ' num2str(round(maxFitnessKeep(simIdx),3))],...
        ['Mean Fitness : ' num2str(round(meanFitnessKeep(simIdx),3))],...
        'FontSize', 14, 'Location', 'southeast');
    ha(2).FontSize=16;
    ha(2).Position(1)=1.15*ha(2).Position(1);
    ha(2).Position(3)=0.98*ha(2).Position(3);

    set(gcf,'InvertHardCopy','off','Color','white');

    % Capture the plot as an image
    frame = getframe(gcf);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);


    % Write to the GIF File
    delayTime = 0.45;
    if simIdx == 1
        imwrite(imind,cm,filename,'gif','DelayTime',delayTime,'Loopcount',inf);
    else
        imwrite(imind,cm,filename,'gif','DelayTime',delayTime,'WriteMode','append');
        if(simIdx == totalNum) % append the last frame a few times more so that one can see the final results for longer
            for rep=1:8
                imwrite(imind,cm,filename,'gif','DelayTime',delayTime,'WriteMode','append');
            end
        end
    end
end
close(gcf)
end

