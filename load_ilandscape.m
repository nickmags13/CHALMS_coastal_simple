function Silandscape=load_ilandscape(landscapefname)
myVars={'istartmap','startrents','meantrendrents','meanlproj'};
Silandscape=load(landscapefname,myVars{:});
end