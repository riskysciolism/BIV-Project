%-Bild zurecht schneiden---------------------------------------------------------------------------

preview = imshow(image);
roi = drawrectangle;
crop = imcrop(image,roi.Position);


%-Umwandeln in Graustufenbild, falls nicht schon geschehen-----------------------------------------

if(size(target_image_data, 3) == 3)
    target_image_data_grey = rgb2gray(target_image_data);
else
    target_image_data_grey = target_image_data;
end


%-Das ausgewählte Detektionsverfahren anwenden-----------------------------------------------------

switch DetectionMethodDropDown.Value
    case "BRISK"
        referencePoints = detectBRISKFeatures(reference_image_data_grey);
        targetPoints = detectBRISKFeatures(target_image_data_grey);
    case "FAST"
        referencePoints = detectFASTFeatures(reference_image_data_grey);
        targetPoints = detectFASTFeatures(target_image_data_grey);
    case "Harris"
        referencePoints = detectHarrisFeatures(reference_image_data_grey);
        targetPoints = detectHarrisFeatures(target_image_data_grey);
    case "MinEigen"
        referencePoints = detectMinEigenFeatures(reference_image_data_grey);
        targetPoints = detectMinEigenFeatures(target_image_data_grey);
    case "ORB"
        referencePoints = detectORBFeatures(reference_image_data_grey);
        targetPoints = detectORBFeatures(target_image_data_grey);
    case "SURF"
        referencePoints = detectSURFFeatures(reference_image_data_grey);
        targetPoints = detectSURFFeatures(target_image_data_grey);
    case "KAZE"
        referencePoints = detectKAZEFeatures(reference_image_data_grey);
end


%-Die gefundenen Feature Punkte anzeigen-----------------------------------------------------------

hold(ReferenceImage, "on");
plot(referencePoints.selectStrongest(round(NumberofshownKeypointsSlider.Value)), ReferenceImage);
hold(ReferenceImage, "off");


hold(TargetImage, "on");
plot(targetPoints.selectStrongest(round(NumberofshownKeypointsSlider.Value)), TargetImage);
hold(TargetImage, "off");


%-Feature Deskriptoren extrahieren-----------------------------------------------------------------

[referenceFeatures, referencePoints] = extractFeatures(reference_image_data_grey, referencePoints);
[targetFeatures, targetPoints] = extractFeatures(target_image_data_grey, targetPoints);


%-Zueinander passende Punkte mithilfe der Deskriptoren finden--------------------------------------

pairs = matchFeatures(referenceFeatures, targetFeatures);


%-Vermeintlich übereinstimmende Merkmale anzeigen--------------------------------------------------

matchedReferencePoints = referencePoints(pairs(:, 1), :);
matchedTargetPoints = targetPoints(pairs(:, 2), :);

showMatchedFeatures(reference_image_data, target_image_data, matchedReferencePoints, ...
matchedTargetPoints, 'montage', "Parent", ResultImage);


%-Transformation aus den übereinstimmende Merkmale berechnen und als Bounding Box anzeigen---------

[tform, estimatedReferencePoints, estimatedTargetPoints] = ...
estimateGeometricTransform(matchedReferencePoints, matchedTargetPoints, 'affine');

foundPolygon = [1, 1;...                                                            % top-left
                size(reference_image_data, 2), 1;...                                % top-right
                size(reference_image_data, 2), size(reference_image_data, 1);...    % bottom-right
                1, size(reference_image_data, 1);...                                % bottom-left
                1, 1];                                                              % top-left

newFoundPolygon = transformPointsForward(tform, foundPolygon);

imshow(target_image_data, 'Parent', ResultImage);
hold(ResultImage, "on");
line(ResultImage, newFoundPolygon(:, 1), newFoundPolygon(:, 2), 'Color', 'y');
hold(ResultImage, "off");


%--------------------------------------------------------------------------------------------------