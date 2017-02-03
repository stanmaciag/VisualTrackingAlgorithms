function imagePosition = figPos2ImgPos(figureHandle, figurePosition, imageSize)

    figureRect = get(figureHandle,'Position');
    figureSize = [figureRect(3), figureRect(4)];
    imagePosition = [figureSize(2) - figurePosition(2), ...
        figurePosition(1)];
    
end

