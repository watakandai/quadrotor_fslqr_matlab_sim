function [ A, B1, B2, C1, C2, D11, D12, D21, D22 ] = g2ss( G, numY, numU )
[A, B, C, D] = unpck(G);
numW = size(B, 2) - numU; 
numZ = size(C, 1) - numY;

B1 = B(:,1:numW);
B2 = B(:,1+numW:numW+numU);
C1 = C(1:numZ, :);
C2 = C(1+numZ:numZ+numY, :);
D11 = D(1:numZ, 1:numW);
D12 = D(1:numZ, 1+numW:numW+numU);
D21 = D(1+numZ:numZ+numY, 1:numW);
D22 = D(1+numZ:numZ+numY,1+numW:numW+numU);
end

