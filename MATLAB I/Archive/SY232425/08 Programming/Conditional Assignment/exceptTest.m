aa = randi(10, 2, 3);
bb = randi(10, 1, 3);
ll = logical(randi([0 1], 1, 3));

try
    userMerge = conditionalMerge(aa, bb, ll)
    error("You failed to catch different sized matrics. %s", mat2str4(aa, bb, ll, userMerge))
catch ME
    disp(ME.message)
end