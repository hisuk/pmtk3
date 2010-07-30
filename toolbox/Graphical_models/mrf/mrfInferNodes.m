function [nodeBels, logZ, edgeBels] = mrfInferNodes(mrf, varargin)
%% Return all node beliefs (single marginals)
% 
% mrf is a struct as created by mrfCreate
%
% Optional named args are the same as for dgmInferNodes
%
%%
[clamped, args]   = process_options(varargin, 'clamped', []); %#ok
visVars           = find(clamped);
hidVars           = setdiffPMTK(1:mrf.nnodes, visVars);
edgeBelsRequested = nargout > 2;
    
query = num2cell(hidVars); 
if edgeBelsRequested
    query = [query(:); mrf.edges(:)]; 
end
[bels, logZ] = mrfInferQuery(mrf, query, varargin{:});
if edgeBelsRequested
    nhid     = numel(hidVars);
    nodeBels = bels(1:nhid);
    edgeBels = bels(nhid+1:end);
else
    nodeBels = bels;
end
nodeBels = insertClampedBels(nodeBels, visVars, hidVars);
end