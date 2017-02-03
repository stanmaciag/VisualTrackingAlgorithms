function imageClickCallback(figureHandle, ~)

   coordinates = figureHandle.CurrentPoint;
   figureHandle.UserData.InitPosImg = examples.imageFigureControl.figPos2ImgPos(figureHandle, ...
       coordinates, figureHandle.UserData.ImgSize);
   figureHandle.UserData.CurrentPosImg = figureHandle.UserData.InitPosImg;
   figureHandle.UserData.CapturingPos = true;
   figureHandle.UserData.CapturingDone = false;
   
end