function [ft,fa] = UDR(signal,time,width_fig,height_fig,linewidth,MinBranchLength,target)
%%
% UDR is a filter that works on the image domain for EEG signal processing.
% Instead of being processed in the time domain, the input signal is
% visualized in an increasing line width, the representation frame of which
% is converted into a binary image. An effective thinning algorithm is then
% employed to obtain a unit width skeleton as the smoothed signal. Then,
% the skeleton is projected back to the time domain.

%% Input
% signal:             the input signal amplitude (a vector)
% time:               the input signal time points (a vector)
% width_fig:          the width of a figure where the signal is plotted (a number)
% height_fig:         the height of a figure where the signal is plotted (a number)
% linewidth:          the linewidth which the signal is plotted (a number)
% MinBranchLength:    a parameter in the thinning algorithm that defines the
%                   minimum length of skeleton while thinning (a number)   
% target:             the number of sample point (a number)

%% Output
% fa:                 the filtered signal amplitude (a vector)
% ft:                 the filtered signal time points (a vector)

%% Plot the origin signal with a specific linewidth 
    f1      = figure('Position',[600 100 width_fig height_fig],'visible','off');
    hold on;
    set(gca,'position',[0 0 1 1],'units','normalized')
    plot(time,signal,"LineWidth",linewidth);
    axis tight;
    axis off 
    yax     = ylim; miny    = yax(1); maxy  = yax(2); 
    xax     = xlim; minx    = xax(1); maxx  = xax(2);
%     axis([minx maxx miny*1.1 maxy*1.1])
    
%% Get a binary image from the figure 
    Frame   = getframe(f1);
    b_image = ~rgb2gray(frame2im(Frame)/255);
    close(f1)
    % Padding
    b_image = [ones(size(b_image,1),50) b_image ones(size(b_image,1),50)];
    
%% Skeletonize binary image (Thinning) 
    skel    = bwskel(logical(b_image),'MinBranchLength',MinBranchLength);
    % Unpadding
    skel    = skel(:,51:end-50);
    
%% Project back to the time domain  
    [r,c]   = find(flipud(skel) == 1);
    ft      = interp1([0,size(skel,2)],[minx maxx],c);
    fa      = interp1([0,size(skel,1)],[miny maxy],r);
    
%% Ensure the smoothed signal has the same number of sample point as the input signal
    ft      = reshape(ft,[1,numel(ft)]);
    fa      = reshape(fa,[1,numel(fa)]);
    fa      = interp1( 1:length(fa), fa, linspace(1, length(fa), target));
    ft      = interp1( 1:length(ft), ft, linspace(1, length(ft), target));
    
end