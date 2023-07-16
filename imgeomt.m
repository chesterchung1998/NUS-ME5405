% Function for geometric transformation/rotation of image.

function [im_out, axesofnew] = imgeomt(T , im , method, step)
    
    % 1. Pre-compute the range of output image by a forward mapping of the
    % corner coordinates.
    r = size(im , 1);
    c = size(im , 2);
    
    % Compute the range of original image
    try xrange = axesoforig.x; yrange = axesoforig.y;
    catch xrange=1:c; yrange=1:r; end
    [orig.xi , orig.yi] = meshgrid(xrange, yrange);

    % Corner points of the image
    orig.u = [[min(xrange),min(yrange)]' , [min(xrange),max(yrange)]', ...
              [max(xrange),min(yrange)]' , [max(xrange),max(yrange)]'];

    % Make homogenous
    orig.u(3,:) = 1;

    % Map forward
    forward.x = T * orig.u;

    % Compute the limits of the output image (bounding box)
    forward.x(1:2,:) = forward.x(1:2,:)./repmat(forward.x(3,:),2,1);
    maxx = max(forward.x(1,:));
    minx = min(forward.x(1,:));
    maxy = max(forward.x(2,:));
    miny = min(forward.x(2,:));

    % 2. Prepare a grid of spatial coordinates of the new image.
    axesofnew.x = minx:step:maxx;
    axesofnew.y = miny:step:maxy;
    [u,v] = meshgrid(axesofnew.x , axesofnew.y);
    x2 = [u(:) v(:) ones(size(v(:)))]';

    % 3. Perform backward mapping of the new coordinates.
    x1 = T \ x2;
    
    % Normalization
    x1(1:2,:) = x1(1:2,:) ./ repmat(x1(3,:),2,1);

    % 4. Put the back-mapped coordinates into interp2 to perform
    % interpolation.
    new.xi = reshape(x1(1,:) , size(u));
    new.yi = reshape(x1(2,:) , size(v));

    layers = size(im , 3);
    if layers > 1
        im_out = zeros(length(axesofnew.y) , length(axesofnew.x) , layers);
        for i = 1:layers
            im_out(:,:,1) = interp2(orig.xi , orig.yi , double(im(:,:,i)) , new.xi , new.yi , method);
        end
    else
        im_out = interp2(orig.xi , orig.yi , double(im) , new.xi , new.yi , method);
    end




