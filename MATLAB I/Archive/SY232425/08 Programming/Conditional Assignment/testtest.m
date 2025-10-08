aa = randi(10, 3, 3);
bb = randi(10, 3, 3);
ll = logical(randi([0 1], 3, 3));

userMerge = conditionalMerge(aa, bb, ll); 

% Run reference solution.
refMerge = conditionalMerge(aa, bb, ll); 
userMerge(1,1) = -1;

% Compare.
if ~isequal(userMerge, refMerge)
    error("Results do not match:\n\n%s", mat2str4(aa, bb, ll, userMerge))
end