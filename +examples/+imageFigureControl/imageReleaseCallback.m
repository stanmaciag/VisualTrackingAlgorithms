function imageReleaseCallback(figureHandle, ~)

   coordinates = figureHandle.CurrentPoint;
   figureHandle.UserData.EndPosImg = examples.imageFigureControl.figPos2ImgPos(figureHandle, ...
       coordinates, figureHandle.UserData.ImgSize);
   figureHandle.UserData.CapturingPos = false;
   figureHandle.UserData.CapturingDone = true;
   
end

