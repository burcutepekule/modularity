function [] = plot14panel(varargin)
if(length(varargin)==13)
    textCircuits    = varargin{1};
    keepStructure   = varargin{2};
    IsubOneVals     = varargin{3};
    IallFinalVals   = varargin{4};
    degeneracyVals  = varargin{5};
    redundancyVals  = varargin{6};
    complexityVals  = varargin{7};
    IfinalVals      = varargin{8};
    IsubMatKeepVals = varargin{9};
    IsubsubHatMatKeepVals = varargin{10};
    ind_min   = varargin{11};
    textOnAll = varargin{12};
    textOnMI  = varargin{13};
    numPanels = 7;
elseif(length(varargin)==14)
    textCircuits    = varargin{1};
    keepStructure   = varargin{2};
    IsubOneVals     = varargin{3};
    IallFinalVals   = varargin{4};
    degeneracyVals  = varargin{5};
    redundancyVals  = varargin{6};
    complexityVals  = varargin{7};
    IfinalVals      = varargin{8};
    IsubMatKeepVals = varargin{9};
    IsubsubHatMatKeepVals = varargin{10};
    ind_min   = varargin{11};
    ind_max   = varargin{12};
    textOnAll = varargin{13};
    textOnMI  = varargin{14};
    numPanels = 14;
else
    disp('Number of inputs doesnt make sense!')
    numPanels = 0;
end

cmap = [1 0.8 0.8 ;bone(100)];


close all;
if(numPanels>0)
    if(numPanels==14)
        [ha, ~] = tight_subplot(7,2,[0.08 0.05],[0.05 0.05],[0.055 0.02]);
        set(gcf, 'Position',  [100, 300, 900, 1800])
        
        fittestStructure_1     = keepStructure{ind_min};
        fittestTextCircuit_1   = textCircuits(cell2mat(textCircuits(:,1))==ind_min,:);
        degenval_1 = degeneracyVals(ind_min);
        redunval_1 = redundancyVals(ind_min);
        compval_1  = complexityVals(ind_min);
        
        axes(ha(1))
        connectionMatInitial_1 = drawCircuit_text_MI(fittestStructure_1,fittestTextCircuit_1,IsubOneVals(ind_min,:),IallFinalVals(ind_min),degenval_1,redunval_1,compval_1,textOnAll,textOnMI);
        axis off;
        sum(IsubOneVals(ind_min,:)./IallFinalVals(ind_min))
        
        fittestStructure_2     = keepStructure{ind_max};
        fittestTextCircuit_2   = textCircuits(cell2mat(textCircuits(:,1))==ind_max,:);
        degenval_2 = degeneracyVals(ind_max);
        redunval_2 = redundancyVals(ind_max);
        compval_2  = complexityVals(ind_max);
        
        axes(ha(2))
        connectionMatInitial_2 = drawCircuit_text_MI(fittestStructure_2,fittestTextCircuit_2,IsubOneVals(ind_max,:),IallFinalVals(ind_max),degenval_2,redunval_2,compval_2,textOnAll,textOnMI);
        axis off;
        sum(IsubOneVals(ind_max,:)./IallFinalVals(ind_max))
        
        valsMatmin_1=IsubMatKeepVals(:,:,ind_min);
        valsMatmax_1=IsubMatKeepVals(:,:,ind_max);
        valsMatmin_2=IfinalVals(:,:,ind_min);
        valsMatmax_2=IfinalVals(:,:,ind_max);
        valsMatmin_3=IsubsubHatMatKeepVals(:,:,ind_min);
        valsMatmax_3=IsubsubHatMatKeepVals(:,:,ind_max);
        
        bottom = -0.4;
        %         top    = max([valsMatmin_1(:);valsMatmax_1(:);valsMatmin_2(:);valsMatmax_2(:)]);
        top    = 1.4; % ALSO TO HAVE CONSISTENCY ACROSS FIGURES
        
        
        axes(ha(3))
        imagesc(valsMatmin_1')
        caxis([bottom top]);
        colormap(cmap)
        cb=colorbar;
        cb.Ticks=bottom:0.25:top;
        cb.TickLabels{1}='NA';
        title('$I(X_{i}^{k},O)$','interpreter','latex','Fontsize',16)
        ylabel('$k$','interpreter','latex','Fontsize',16)
        %         xlabel('$i$','interpreter','latex','Fontsize',16)
        set(ha(3),'xtick',[])

        
        axes(ha(4))
        imagesc(valsMatmax_1')
        caxis([bottom top]);
        colormap(cmap)
        cb=colorbar;
        cb.Ticks=bottom:0.25:top;
        cb.TickLabels{1}='NA';
        title('$I(X_{i}^{k},O)$','interpreter','latex','Fontsize',16)
        ylabel('$k$','interpreter','latex','Fontsize',16)
        %         xlabel('$i$','interpreter','latex','Fontsize',16)
        set(ha(4),'xtick',[])

        axes(ha(5))
        tVals = round(nansum(valsMatmin_1'),3);
        t = num2cell(round(nansum(valsMatmin_1'),3)); % extact values into cells
        t = cellfun(@num2str, t, 'UniformOutput', false); % convert to string
        imagesc(nansum(valsMatmin_1'))
        x = 1:length(nansum(valsMatmin_1'));
        % we are only interested in the first value for redundancy and last
        % value because it is equal to I(X,O)
        endIdx = length(x);
        if(tVals(1)<0.6)
            text(1, 1, t{1}, 'HorizontalAlignment', 'Center','Color','White','Fontweight','Bold')
        else
            text(1, 1, t{1}, 'HorizontalAlignment', 'Center','Color','Black','Fontweight','Bold')
        end
        if(tVals(endIdx)<0.6)
            text(endIdx, 1, t{endIdx}, 'HorizontalAlignment', 'Center','Color','White','Fontweight','Bold')
        else
            text(endIdx, 1, t{endIdx}, 'HorizontalAlignment', 'Center','Color','Black','Fontweight','Bold')
        end
        
        caxis([bottom top]);
        colormap(cmap)
        cb=colorbar;
        cb.TickLabels{1}='NA';
        title('$\sum_{k} I(X_{i}^{k},O)$','interpreter','latex','Fontsize',16)
        %         ylabel('$k$','interpreter','latex','Fontsize',16)
        xlabel('$i$','interpreter','latex','Fontsize',16)
        
        
        axes(ha(6))
        tVals = round(nansum(valsMatmax_1'),3);
        t = num2cell(round(nansum(valsMatmax_1'),3)); % extact values into cells
        t = cellfun(@num2str, t, 'UniformOutput', false); % convert to string
        imagesc(nansum(valsMatmax_1'))
        x = 1:length(nansum(valsMatmax_1'));
        % we are only interested in the first value for redundancy and last
        % value because it is equal to I(X,O)
        endIdx = length(x);
        if(tVals(1)<0.6)
            text(1, 1, t{1}, 'HorizontalAlignment', 'Center','Color','White','Fontweight','Bold')
        else
            text(1, 1, t{1}, 'HorizontalAlignment', 'Center','Color','Black','Fontweight','Bold')
        end
        
        if(tVals(endIdx)<0.6)
            text(endIdx, 1, t{endIdx}, 'HorizontalAlignment', 'Center','Color','White','Fontweight','Bold')
        else
            text(endIdx, 1, t{endIdx}, 'HorizontalAlignment', 'Center','Color','Black','Fontweight','Bold')
        end
        
        caxis([bottom top]);
        colormap(cmap)
        cb=colorbar;
        cb.TickLabels{1}='NA';
        title('$\sum_{k} I(X_{i}^{k},O)$','interpreter','latex','Fontsize',16)
        %         ylabel('$k$','interpreter','latex','Fontsize',16)
        xlabel('$i$','interpreter','latex','Fontsize',16)
        
        axes(ha(7))
        imagesc(valsMatmin_2')
        caxis([bottom top]);
        colormap(cmap)
        cb=colorbar;
        cb.Ticks=bottom:0.25:top;
        cb.TickLabels{1}='NA';
        title('$I(X_{i}^{k},O) + I(\hat{X}_{i}^{k},O) - I(X,O)$','interpreter','latex','Fontsize',16)
        ylabel('$k$','interpreter','latex','Fontsize',16)
        %         xlabel('$i$','interpreter','latex','Fontsize',16)
        set(ha(7),'xtick',[])

        axes(ha(8))
        imagesc(valsMatmax_2')
        caxis([bottom top]);
        colormap(cmap)
        cb=colorbar;
        cb.Ticks=bottom:0.25:top;
        cb.TickLabels{1}='NA';
        title('$I(X_{i}^{k},O) + I(\hat{X}_{i}^{k},O) - I(X,O)$','interpreter','latex','Fontsize',16)
        ylabel('$k$','interpreter','latex','Fontsize',16)
        %         xlabel('$i$','interpreter','latex','Fontsize',16)
        set(ha(8),'xtick',[])
        
        axes(ha(9))
        tVals = round(nanmean(valsMatmin_2,2)',3);
        t = num2cell(round(nanmean(valsMatmin_2,2)',3)); % extact values into cells
        t = cellfun(@num2str, t, 'UniformOutput', false); % convert to string
        imagesc(nanmean(valsMatmin_2,2)')
        x = 1:length(nanmean(valsMatmin_2,2)');
        y = ones(1,length(nanmean(valsMatmin_2,2)'));
        for m=1:length(x)
            if(tVals(m)<0.6)
                text(x(m), y(m), t{m}, 'HorizontalAlignment', 'Center','Color','White','Fontweight','Bold')
            else
                text(x(m), y(m), t{m}, 'HorizontalAlignment', 'Center','Color','Black','Fontweight','Bold')
            end
        end
        caxis([bottom top]);
        colormap(cmap)
        cb=colorbar;
        cb.TickLabels{1}='NA';
        title('$<I(X_{i}^{k},O) + I(\hat{X}_{i}^{k},O) - I(X,O)>$','interpreter','latex','Fontsize',16)
        %         ylabel('$k$','interpreter','latex','Fontsize',16)
        xlabel('$i$','interpreter','latex','Fontsize',16)
        
        
        axes(ha(10))
        tVals=round(nanmean(valsMatmax_2,2)',3);
        t = num2cell(round(nanmean(valsMatmax_2,2)',3)); % extact values into cells
        t = cellfun(@num2str, t, 'UniformOutput', false); % convert to string
        imagesc(nanmean(valsMatmax_2,2)')
        x = 1:length(nanmean(valsMatmax_2,2)');
        y = ones(1,length(nanmean(valsMatmax_2,2)'));
        for m=1:length(x)
            if(tVals(m)<0.6)
                text(x(m), y(m), t{m}, 'HorizontalAlignment', 'Center','Color','White','Fontweight','Bold')
            else
                text(x(m), y(m), t{m}, 'HorizontalAlignment', 'Center','Color','Black','Fontweight','Bold')
            end
        end
        
        caxis([bottom top]);
        colormap(cmap)
        cb=colorbar;
        cb.TickLabels{1}='NA';
        title('$<I(X_{i}^{k},O) + I(\hat{X}_{i}^{k},O) - I(X,O)>$','interpreter','latex','Fontsize',16)
        %         ylabel('$k$','interpreter','latex','Fontsize',16)
        xlabel('$i$','interpreter','latex','Fontsize',16)
        
        axes(ha(11))
        imagesc(valsMatmin_3')
        caxis([bottom top]);
        colormap(cmap)
        cb=colorbar;
        cb.Ticks=bottom:0.25:top;
        cb.TickLabels{1}='NA';
        title('$I(X_{i}^{k},\hat{X}_{i}^{k})$','interpreter','latex','Fontsize',16)
        ylabel('$k$','interpreter','latex','Fontsize',16)
        %         xlabel('$i$','interpreter','latex','Fontsize',16)
        set(ha(11),'xtick',[])

        axes(ha(12))
        imagesc(valsMatmax_3')
        caxis([bottom top]);
        colormap(cmap)
        cb=colorbar;
        cb.Ticks=bottom:0.25:top;
        cb.TickLabels{1}='NA';
        title('$I(X_{i}^{k},\hat{X}_{i}^{k})$','interpreter','latex','Fontsize',16)
        ylabel('$k$','interpreter','latex','Fontsize',16)
        %         xlabel('$i$','interpreter','latex','Fontsize',16)
        set(ha(12),'xtick',[])
        
        axes(ha(13))
        tVals = round(nanmean(valsMatmin_3,2)',3);
        t = num2cell(round(nanmean(valsMatmin_3,2)',3)); % extact values into cells
        t = cellfun(@num2str, t, 'UniformOutput', false); % convert to string
        imagesc(nanmean(valsMatmin_3,2)')
        x = 1:length(nanmean(valsMatmin_3,2)');
        y = ones(1,length(nanmean(valsMatmin_3,2)'));
        for m=1:length(x)
            if(tVals(m)<0.6)
                text(x(m), y(m), t{m}, 'HorizontalAlignment', 'Center','Color','White','Fontweight','Bold')
            else
                text(x(m), y(m), t{m}, 'HorizontalAlignment', 'Center','Color','Black','Fontweight','Bold')
            end
        end
        caxis([bottom top]);
        colormap(cmap)
        cb=colorbar;
        cb.TickLabels{1}='NA';
        title('$<I(X_{i}^{k},\hat{X}_{i}^{k})>$','interpreter','latex','Fontsize',16)
        %         ylabel('$k$','interpreter','latex','Fontsize',16)
        xlabel('$i$','interpreter','latex','Fontsize',16)
        
        
        axes(ha(14))
        tVals=round(nanmean(valsMatmax_3,2)',3);
        t = num2cell(round(nanmean(valsMatmax_3,2)',3)); % extact values into cells
        t = cellfun(@num2str, t, 'UniformOutput', false); % convert to string
        imagesc(nanmean(valsMatmax_3,2)')
        x = 1:length(nanmean(valsMatmax_3,2)');
        y = ones(1,length(nanmean(valsMatmax_3,2)'));
        for m=1:length(x)
            if(tVals(m)<0.6)
                text(x(m), y(m), t{m}, 'HorizontalAlignment', 'Center','Color','White','Fontweight','Bold')
            else
                text(x(m), y(m), t{m}, 'HorizontalAlignment', 'Center','Color','Black','Fontweight','Bold')
            end
        end
        caxis([bottom top]);
        colormap(cmap)
        cb=colorbar;
        cb.TickLabels{1}='NA';
        title('$<I(X_{i}^{k},\hat{X}_{i}^{k})>$','interpreter','latex','Fontsize',16)
        %         ylabel('$k$','interpreter','latex','Fontsize',16)
        xlabel('$i$','interpreter','latex','Fontsize',16)
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        shrink2height = 0.025;
        initialHeight = ha(7).Position(4);
        ha(5).Position(4)=shrink2height;
        ha(6).Position(4)=shrink2height;
        ha(9).Position(4)=shrink2height;
        ha(10).Position(4)=shrink2height;
        ha(13).Position(4)=shrink2height;
        ha(14).Position(4)=shrink2height;
        leftoverHeight= 3*(initialHeight-shrink2height);
        
        ha(1).Position(4)=ha(1).Position(4)+leftoverHeight/0.8;
        ha(2).Position(4)=ha(2).Position(4)+leftoverHeight/0.8;
        ha(3).Position(4)=ha(3).Position(4)+leftoverHeight/1.5;
        ha(4).Position(4)=ha(4).Position(4)+leftoverHeight/1.5;
        ha(7).Position(4)=ha(7).Position(4)+leftoverHeight/1.5;
        ha(8).Position(4)=ha(8).Position(4)+leftoverHeight/1.5;
        ha(11).Position(4)=ha(11).Position(4)+leftoverHeight/1.5;
        ha(12).Position(4)=ha(12).Position(4)+leftoverHeight/1.5;
        
        offset = 0.012;
        ha(1).Position(2)=ha(1).Position(2)-0.11;
        ha(2).Position(2)=ha(2).Position(2)-0.11;
        ha(3).Position(2)=ha(3).Position(2)-0.125-offset;
        ha(4).Position(2)=ha(4).Position(2)-0.125-offset;
        ha(5).Position(2)=ha(5).Position(2)-0.04-offset;
        ha(6).Position(2)=ha(6).Position(2)-0.04-offset;
        ha(7).Position(2)=ha(7).Position(2)-0.1-offset;
        ha(8).Position(2)=ha(8).Position(2)-0.1-offset;
        ha(9).Position(2)=ha(9).Position(2)-0.02-offset;
        ha(10).Position(2)=ha(10).Position(2)-0.02-offset;
        ha(11).Position(2)=ha(11).Position(2)-0.08-offset;
        ha(12).Position(2)=ha(12).Position(2)-0.08-offset;
        ha(13).Position(2)=ha(13).Position(2)-offset;
        ha(14).Position(2)=ha(14).Position(2)-offset;        
    elseif(numPanels==7)
        [ha, ~] = tight_subplot(7,1,[0.08 0.05],[0.05 0.05],[0.065 0.02]);
        set(gcf, 'Position',  [100, 300, 450, 1800])
        
        if(iscell(keepStructure)) %still giving a cell, picking one with ind_min
            fittestStructure_1     = keepStructure{ind_min};
            fittestTextCircuit_1   = textCircuits(cell2mat(textCircuits(:,1))==ind_min,:);
        else %means only one entry, which is a matrix
            fittestStructure_1     = keepStructure;
            fittestTextCircuit_1   = textCircuits;
        end
        degenval_1 = degeneracyVals(ind_min);
        redunval_1 = redundancyVals(ind_min);
        compval_1  = complexityVals(ind_min);
        
        axes(ha(1))
        connectionMatInitial_1 = drawCircuit_text_MI(fittestStructure_1,fittestTextCircuit_1,IsubOneVals(ind_min,:),IallFinalVals(ind_min),degenval_1,redunval_1,compval_1,textOnAll,textOnMI);
        axis off;
        sum(IsubOneVals(ind_min,:)./IallFinalVals(ind_min))
        
        
        valsMatmin_1=IsubMatKeepVals(:,:,ind_min);
        valsMatmin_2=IfinalVals(:,:,ind_min);
        valsMatmin_3=IsubsubHatMatKeepVals(:,:,ind_min);

        bottom = -0.4;
        %         top    = max([valsMatmin_1(:);valsMatmin_2(:)]);
        top    = 1.4; % ALSO TO HAVE CONSISTENCY ACROSS FIGURES
        
        axes(ha(2))
        imagesc(valsMatmin_1')
        caxis([bottom top]);
        colormap(cmap)
        cb=colorbar;
        cb.Ticks=bottom:0.25:top;
        cb.TickLabels{1}='NA';
        title('$I(X_{i}^{k},O)$','interpreter','latex','Fontsize',16)
        ylabel('$k$','interpreter','latex','Fontsize',16)
        %         xlabel('$i$','interpreter','latex','Fontsize',16)
        set(ha(2),'xtick',[])
        
        axes(ha(3))
        tVals = round(nansum(valsMatmin_1'),3);
        t = num2cell(round(nansum(valsMatmin_1'),3)); % extact values into cells
        t = cellfun(@num2str, t, 'UniformOutput', false); % convert to string
        imagesc(nansum(valsMatmin_1'))
        x = 1:length(nansum(valsMatmin_1'));
        % we are only interested in the first value for redundancy and last
        % value because it is equal to I(X,O)
        endIdx = length(x);
        if(tVals(1)<0.6)
            text(1, 1, t{1}, 'HorizontalAlignment', 'Center','Color','White','Fontweight','Bold')
        else
            text(1, 1, t{1}, 'HorizontalAlignment', 'Center','Color','Black','Fontweight','Bold')
        end
        
        if(tVals(endIdx)<0.6)
            text(endIdx, 1, t{endIdx}, 'HorizontalAlignment', 'Center','Color','White','Fontweight','Bold')
        else
            text(endIdx, 1, t{endIdx}, 'HorizontalAlignment', 'Center','Color','Black','Fontweight','Bold')
        end
        
        
        caxis([bottom top]);
        colormap(cmap)
        cb=colorbar;
        cb.TickLabels{1}='NA';
        title('$\sum_{k} I(X_{i}^{k},O)$','interpreter','latex','Fontsize',16)
        %         ylabel('$k$','interpreter','latex','Fontsize',16)
        xlabel('$i$','interpreter','latex','Fontsize',16)
        
        
        axes(ha(4))
        imagesc(valsMatmin_2')
        caxis([bottom top]);
        colormap(cmap)
        cb=colorbar;
        cb.Ticks=bottom:0.25:top;
        cb.TickLabels{1}='NA';
        title('$I(X_{i}^{k},O) + I(\hat{X}_{i}^{k},O) - I(X,O)$','interpreter','latex','Fontsize',16)
        ylabel('$k$','interpreter','latex','Fontsize',16)
        %         xlabel('$i$','interpreter','latex','Fontsize',16)
        set(ha(4),'xtick',[])
        
        axes(ha(5))
        tVals = round(nanmean(valsMatmin_2'),3);
        t = num2cell(round(nanmean(valsMatmin_2,2)',3)); % extact values into cells
        t = cellfun(@num2str, t, 'UniformOutput', false); % convert to string
        imagesc(nanmean(valsMatmin_2,2)')
        x = 1:length(nanmean(valsMatmin_2,2)');
        y = ones(1,length(nanmean(valsMatmin_2,2)'));
        
        for m=1:length(x)
            if(tVals(m)<0.6)
                text(x(m), y(m), t{m}, 'HorizontalAlignment', 'Center','Color','White','Fontweight','Bold')
            else
                text(x(m), y(m), t{m}, 'HorizontalAlignment', 'Center','Color','Black','Fontweight','Bold')
            end
        end
        
        caxis([bottom top]);
        colormap(cmap)
        cb=colorbar;
        cb.TickLabels{1}='NA';
        title('$<I(X_{i}^{k},O) + I(\hat{X}_{i}^{k},O) - I(X,O)>$','interpreter','latex','Fontsize',16)
        %         ylabel('$k$','interpreter','latex','Fontsize',16)
        xlabel('$i$','interpreter','latex','Fontsize',16)
        
        
        axes(ha(6))
        imagesc(valsMatmin_3')
        caxis([bottom top]);
        colormap(cmap)
        cb=colorbar;
        cb.Ticks=bottom:0.25:top;
        cb.TickLabels{1}='NA';
        title('$I(X_{i}^{k},\hat{X}_{i}^{k})$','interpreter','latex','Fontsize',16)
        ylabel('$k$','interpreter','latex','Fontsize',16)
        %         xlabel('$i$','interpreter','latex','Fontsize',16)
        set(ha(6),'xtick',[])
        
        axes(ha(7))
        tVals = round(nanmean(valsMatmin_3'),3);
        t = num2cell(round(nanmean(valsMatmin_3,2)',3)); % extact values into cells
        t = cellfun(@num2str, t, 'UniformOutput', false); % convert to string
        imagesc(nanmean(valsMatmin_3,2)')
        x = 1:length(nanmean(valsMatmin_3,2)');
        y = ones(1,length(nanmean(valsMatmin_3,2)'));
        
        for m=1:length(x)
            if(tVals(m)<0.6)
                text(x(m), y(m), t{m}, 'HorizontalAlignment', 'Center','Color','White','Fontweight','Bold')
            else
                text(x(m), y(m), t{m}, 'HorizontalAlignment', 'Center','Color','Black','Fontweight','Bold')
            end
        end
        
        caxis([bottom top]);
        colormap(cmap)
        cb=colorbar;
        cb.TickLabels{1}='NA';
        title('$<I(X_{i}^{k},\hat{X}_{i}^{k})>$','interpreter','latex','Fontsize',16)
        %         xlabel('$k$','interpreter','latex','Fontsize',16)
        ylabel('$i$','interpreter','latex','Fontsize',16)
        
        shrink2height = 0.025;
        initialHeight = ha(4).Position(4);
        ha(3).Position(4)=shrink2height;
        ha(5).Position(4)=shrink2height;
        ha(7).Position(4)=shrink2height;
        leftoverHeight= 3*(initialHeight-shrink2height);
        
        ha(1).Position(4)=ha(1).Position(4)+leftoverHeight/0.8;
        ha(2).Position(4)=ha(2).Position(4)+leftoverHeight/1.5;
        ha(4).Position(4)=ha(4).Position(4)+leftoverHeight/1.5;
        ha(6).Position(4)=ha(6).Position(4)+leftoverHeight/1.5;

        offset = 0.012;
        ha(1).Position(2)=ha(1).Position(2)-0.11;
        ha(2).Position(2)=ha(2).Position(2)-0.125-offset;
        ha(3).Position(2)=ha(3).Position(2)-0.04-offset;
        ha(4).Position(2)=ha(4).Position(2)-0.1-offset;
        ha(5).Position(2)=ha(5).Position(2)-0.02-offset;
        ha(6).Position(2)=ha(6).Position(2)-0.08-offset;
        ha(7).Position(2)=ha(7).Position(2)-offset;
        
    end
    set(gcf,'InvertHardCopy','off','Color','white');
end

end

