function crop = selectAndCrop(image) 
    preview = imshow(image);
    roi = drawrectangle;
    crop = imcrop(image,roi.Position);
    preview.Visible = false;
    close all;
    clf;
end