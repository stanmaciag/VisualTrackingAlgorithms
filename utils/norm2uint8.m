function Iuint8 = norm2uint8(I)

    Iuint8 = cast((I - min(min(I))) / ((max(max(I)))) * 255, 'uint8');

end