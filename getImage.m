function I = getImage(index,imagedata,rows,columns)
  %
  % Parameters
  %     index     = index of the image to retrieve i=1,2,...,numImages
  %     imagedata = pixel data for all of the images
  %     rows      = number of rows in each image
  %     columns   = number of columns in each image
  %
  % Returns 
  %     I = image of a number from the image data with dimension (rows,columns)
  %
  I = double(imagedata((index-1)*rows+1:index*rows,:));
