function imageMovementCallback(figureHandle, ~)

    if figureHandle.UserData.CapturingPos
       
        coordinates = figureHandle.CurrentPoint;
        figureHandle.UserData.CurrentPosImg = examples.imageFigureControl.figPos2ImgPos(figureHandle, ...
            coordinates, figureHandle.UserData.ImgSize);
        
    end

end

