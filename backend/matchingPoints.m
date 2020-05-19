function [matched1, matched2] = matchingPoints(image1, image1Features, image2, image2Features)
    [referenceFeatures, referencePoints] = extractFeatures(image1, image1Features);
    [targetFeatures, targetPoints] = extractFeatures(image2, image2Features);
    pairs = matchFeatures(referenceFeatures, targetFeatures);
    matched1 = referencePoints(pairs(:, 1), :);
    matched2 = targetPoints(pairs(:, 2), :);
end