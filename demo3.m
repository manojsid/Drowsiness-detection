clc;
clear all;
close all;
%%

% info = imaqhwinfo('winvideo',1)
%       celldisp(info.SupportedFormats)
% %      vid=videoinput('winvideo',1,'YUY2_640x480'); 
%       vid=videoinput('winvideo',1,'RGB24_320x240'); 
%       set(vid,'ReturnedColorSpace','rgb'); 
% % %     obj=videoinput('winvideo',1);
%     
%     preview(vid);
%     pause;
%     data=getsnapshot(vid);
%     image(data);
%     
% 
% 
%   figure(1);
%     imshow(data);
%     x=data;
%     imwrite(x,'image1.jpg');
%     delete(vid);
load DB
cl = {'open','close'};

dim = [30 60;
        30 60
        40 65];
delete(imaqfind)
info = imaqhwinfo('winvideo',1)
vid=videoinput('winvideo',1,'YUY2_320x240');
triggerconfig(vid,'manual');
set(vid,'FramesPerTrigger',1 );
set(vid,'TriggerRepeat', Inf);
% start(vid);


% Modify the color space used for the data — To change the color space of the returned image data, set the value of the ReturnedColorSpace property.
set(vid,'ReturnedColorSpace','rgb');

start(vid)


% Create a detector object
faceDetector = vision.CascadeObjectDetector;   

no_detect=0;
for ii = 1:1000
    trigger(vid);
    im=getdata(vid,1); % Get the frame in im
    imshow(im)
    
    subplot(3,4,[1 2 5 6 9 10]);
    imshow(im)
    
    % Detect faces
    bbox = step(faceDetector, im); 
    
    if ~isempty(bbox);
        bbox = bbox(1,:);

        % Plot box
        rectangle('Position',bbox,'edgecolor','r');

         S = skin_seg2(im);
    
        % Segment skin region
        bw3 = cat(3,S,S,S);

        % Multiply with original image and show the output
        Iss = double(im).*bw3;

        Ic = imcrop(im,bbox);
        Ic1 = imcrop(Iss,bbox);
        subplot(3,4,[3 4]);
        imshow(uint8(Ic1))


        pause(0.00005)
        if no_detect>20
            value=1;
            break
        end
    else
        no_detect=no_detect+1
          if no_detect>20
              value=1;
            break
            
        end
    end
end
if value == 1
    s='a'
    s1=serial('COM18','BaudRate',9600);
    fopen(s1);
                    fwrite(s1,s);
                    fclose(s1);
                    delete(s1); 

    warndlg('Head moved');
end

