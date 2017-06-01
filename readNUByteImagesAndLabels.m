function [labels,imagedata,irows,icols] = readNUByteImagesAndLabels(N, image_filename, label_filename)
%
% This function will read the data from the ubyte format data
% files provided as part of the MNIST hand-written character.
%
% Andrew Willis
% March 31, 2008
%
myfile = fopen(label_filename, 'r');
if (myfile == -1)
  fprintf(1,'ERROR: Could not open file %s.\n', label_filename);
  exit(0);
end
[magic_number,count] = fread(myfile, 1, 'uint32', 0, 'ieee-be');
if (count==-1)
  fprintf(1,'ERROR: Could not read magic number from file %s.\n', label_filename);
  exit(0);
end
if (magic_number ~= 2049)
  fprintf(1,'ERROR: Read incorrect magic number %d from file %s should be 2049.\n', magic_number, label_filename);
  exit(0);
end
[number_of_items,count] = fread(myfile, 1, 'uint32', 0, 'ieee-be');
if (count==-1)
  fprintf(1,'ERROR: Could not read number of items from file %s.\n', label_filename);
  exit(0);
end
%magic_number
%number_of_items
[labels,count] = fread(myfile, N, 'uint8', 0, 'ieee-be');
if (count==-1)
  fprintf(1,'ERROR: Could not read all label values from file %s.\n', label_filename);
  exit(0);
end

fclose(myfile);

myfile = fopen(image_filename, 'r');
if (myfile == -1)
  fprintf(1,'ERROR: Could not open file %s.\n', image_filename);
  exit(0);
end
[magic_number,count] = fread(myfile, 1, 'uint32', 0, 'ieee-be');
if (count==-1)
  fprintf(1,'ERROR: Could not read magic number from file %s.\n', image_filename);
  exit(0);
end
if (magic_number ~= 2051)
  fprintf(1,'ERROR: Read incorrect magic number %d from file %s should be 2051.\n', magic_number, image_filename);
  exit(0);
end
[number_of_items,count] = fread(myfile, 1, 'uint32', 0, 'ieee-be');
if (count==-1)
  fprintf(1,'ERROR: Could not read number of items from file %s.\n', image_filename);
  exit(0);
end
[number_rows,count] = fread(myfile, 1, 'uint32', 0, 'ieee-be');
if (count==-1)
  fprintf(1,'ERROR: Could not read number of items from file %s.\n', image_filename);
  exit(0);
end
[number_columns,count] = fread(myfile, 1, 'uint32', 0, 'ieee-be');
if (count==-1)
  fprintf(1,'ERROR: Could not read number of items from file %s.\n', image_filename);
  exit(0);
end
%magic_number
%number_of_items
%number_rows
%number_columns
[pixels,count] = fread(myfile, N*number_rows*number_columns, 'uint8', 0, 'ieee-be');
if (count==-1)
  fprintf(1,'ERROR: Could not read all image pixel values from file %s.\n', image_filename);
  exit(0);
end
imagedata = reshape( pixels, number_columns, number_rows*N)';

fclose(myfile);
labels=uint8(labels);
imagedata=uint8(imagedata);
icols = number_columns;
irows = number_rows;
%clear pixels;
%index = 50;
%labelValues(index)
%I = getImage(index, imagedata, number_rows, number_columns);
%imshow(I,[]);
