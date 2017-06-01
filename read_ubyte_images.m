clear;
%filename = 'train-labels-idx1-ubyte';
filename = 't10k-labels-idx1-ubyte';

myfile = fopen(filename, 'r');
if (myfile == -1)
  fprintf(1,'ERROR: Could not open file %s.\n', filename);
  exit(0);
end
[magic_number,count] = fread(myfile, 1, 'uint32', 0, 'ieee-be');
if (count==-1)
  fprintf(1,'ERROR: Could not read magic number from file %s.\n', filename);
  exit(0);
end
if (magic_number ~= 2049)
  fprintf(1,'ERROR: Read incorrect magic number %d from file %s should be 2049.\n', magic_number, filename);
  exit(0);
end
[number_of_items,count] = fread(myfile, 1, 'uint32', 0, 'ieee-be');
if (count==-1)
  fprintf(1,'ERROR: Could not read number of items from file %s.\n', filename);
  exit(0);
end
magic_number
number_of_items
[labelValues,count] = fread(myfile, number_of_items, 'uint8', 0, 'ieee-be');
if (count==-1)
  fprintf(1,'ERROR: Could not read all label values from file %s.\n', filename);
  exit(0);
end

fclose(myfile);

%filename = 'train-images-idx3-ubyte';
filename = 't10k-images-idx3-ubyte';

myfile = fopen(filename, 'r');
if (myfile == -1)
  fprintf(1,'ERROR: Could not open file %s.\n', filename);
  exit(0);
end
[magic_number,count] = fread(myfile, 1, 'uint32', 0, 'ieee-be');
if (count==-1)
  fprintf(1,'ERROR: Could not read magic number from file %s.\n', filename);
  exit(0);
end
if (magic_number ~= 2051)
  fprintf(1,'ERROR: Read incorrect magic number %d from file %s should be 2051.\n', magic_number, filename);
  exit(0);
end
[number_of_items,count] = fread(myfile, 1, 'uint32', 0, 'ieee-be');
if (count==-1)
  fprintf(1,'ERROR: Could not read number of items from file %s.\n', filename);
  exit(0);
end
[number_rows,count] = fread(myfile, 1, 'uint32', 0, 'ieee-be');
if (count==-1)
  fprintf(1,'ERROR: Could not read number of items from file %s.\n', filename);
  exit(0);
end
[number_columns,count] = fread(myfile, 1, 'uint32', 0, 'ieee-be');
if (count==-1)
  fprintf(1,'ERROR: Could not read number of items from file %s.\n', filename);
  exit(0);
end
magic_number
number_of_items
number_rows
number_columns
[pixels,count] = fread(myfile, number_of_items*number_rows*number_columns, 'uint8', 0, 'ieee-be');
if (count==-1)
  fprintf(1,'ERROR: Could not read all image pixel values from file %s.\n', filename);
  exit(0);
end
imagedata = reshape( pixels, number_columns, number_rows*number_of_items)';

fclose(myfile);

clear pixels;


index = 50;
labelValues(index)
I = getImage(index, imagedata, number_rows, number_columns);
imshow(I,[]);
