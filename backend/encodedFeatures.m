function features = encodedFeatures(method, image)
    switch method
        case "BRISK"
        features = detectBRISKFeatures(image);
    case "BRISK"
        features = detectBRISKFeatures(image);
    case "FAST"
        features = detectFASTFeatures(image);
    case "Harris"
        features = detectHarrisFeatures(image);
    case "MinEigen"
        features = detectMinEigenFeatures(image);
    case "MSER"
        features = detectMSERFeatures(image);
    case "ORB"
        features = detectORBFeatures(image);
    case "SURF"
        features = detectSURFFeatures(image);
    case "KAZE"
        features = detectKAZEFeatures(image);
    end
end