function SSR = calcSSR(concMatrix,xData)
    residualConcMatrix = concMatrix - xData;
    SSR = sum(sum(residualConcMatrix.^2));

end