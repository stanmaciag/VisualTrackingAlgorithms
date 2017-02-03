function imageKeyPressCallback(figureHandle, eventData)

    if strcmp(eventData.Key,'escape')
       
        figureHandle.UserData.CapturingPos = false;
        figureHandle.UserData.CapturingDone = false;
        
    end
    
end

