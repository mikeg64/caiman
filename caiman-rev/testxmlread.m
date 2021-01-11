xDoc = xmlread('simfile.xml');
props=xDoc.getElementsByTagName('prop');

%These will output string array's but we use char to convert to character array 
%and use strip to remove spaces %
pemail=props.item(0);
userEmail           = strip(char(pemail.getTextContent));
 
pimageFile=props.item(1);
imageFile           = strip(char(pimageFile.getTextContent));
 
pjobtype=props.item(2);
jobtype             = strip(char(pjobtype.getTextContent));
 
 
 
 
%experiments see
% http://matlab.izmiran.ru/help/techdoc/ref/xmlread.html
% vaguely helpful!!!!

% xRoot = xDoc.getDocumentElement;  %simulation node
% schemaURL = ...
%    char(xRoot.getAttribute('filename'))
% 
% %schemaURL =
% %   http://www.mathworks.com/namespace/info/v1/info.xsd
% 
% simelement=xDoc.getElementsByTagName('simulation');
% %thisListItem = simelement.item(1);
% %childNode = thisListItem.getFirstChild;
% 
% props=xDoc.getElementsByTagName('prop');
% props.getLength
% 
% prop=props.item(2);
% 
%  pemail=props.item(0);
%  userEmail           = pemail.getTextContent;
%  
%  pimageFile=props.item(1);
%  imageFile           = pimageFile.getTextContent;
%  
%  pjobtype=props.item(2);
%  jobtype             = pjobtype.getTextContent;
%  
%  
% %string=prop.getElementsByTagName('string');
% %string.getData
% 
