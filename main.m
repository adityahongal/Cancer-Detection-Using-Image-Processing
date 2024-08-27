% -- Clear commands -- %
clear all
close all
clc

% -- Getting input image -- %

[file,p] = uigetfile('*.*');

if file == 0
    
    warndlg('You Have Cancelled...');
    
else
    
    I = imread([p file]);
    
    figure(1),
    
    imshow(I);
    title('Input Image','FontName','Times New Roman');
    
% -- Image Noise Filtering -- %
    
    flevel = 0.5;
    fmat = 3;
    
    Im = fspecial('gaussian',[fmat fmat],flevel);
    
    Filt = imfilter(I,Im);
    
    figure(2),
    
    imshow(Filt);
    title('Filtered Image','FontName','Times New Roman');
    
    
% -- SEgmentation -- %
    
if size(Filt,3) == 3
    
    I = rgb2gray(Filt);
else
    I = Filt;
end
    
    imshow(I)
    
    text(732,501,'Image courtesy of Corel(R)',...
        'FontSize',7,'HorizontalAlignment','right')
    hy = fspecial('sobel');
    hx = hy';
    Iy = imfilter(double(I), hy, 'replicate');
    Ix = imfilter(double(I), hx, 'replicate');
    gradmag = sqrt(Ix.^2 + Iy.^2);
    
    figure
    imshow(gradmag,[]), title('Gradient magnitude (gradmag)')
    L = watershed(gradmag);
    Lrgb = label2rgb(L);
    figure, imshow(Lrgb), title('Watershed transform of gradient magnitude (Lrgb)')
    
    se = strel('disk', 20);
    Io = imopen(I, se);
    figure
    imshow(Io), title('Opening (Io)')
    
    Ie = imerode(I, se);
    Iobr = imreconstruct(Ie, I);
    
    figure
    imshow(Iobr), title('Opening-by-reconstruction (Iobr)')
    
    Ioc = imclose(Io, se);
    
    figure
    imshow(Ioc), title('Opening-closing (Ioc)')
    
    Iobrd = imdilate(Iobr, se);
    Iobrcbr = imreconstruct(imcomplement(Iobrd), imcomplement(Iobr));
    Iobrcbr = imcomplement(Iobrcbr);
    
    figure
    imshow(Iobrcbr), title('Opening-closing by reconstruction (Iobrcbr)')
    
    fgm = imregionalmax(Iobrcbr);
    
    figure
    imshow(fgm), title('Regional maxima of opening-closing by reconstruction (fgm)')
    
    I2 = I;
    I2(fgm) = 255;
    
    figure
    imshow(I2), title('Regional maxima superimposed on original image (I2)')
    
    se2 = strel(ones(5,5));
    fgm2 = imclose(fgm, se2);
    fgm3 = imerode(fgm2, se2);
    
    fgm4 = bwareaopen(fgm3, 20);
    I3 = I;
    I3(fgm4) = 200;
    
    figure
    imshow(I3)
    title('Modified regional maxima superimposed on original image (fgm4)')
    
    
    for ii = 1:size(fgm4,1)
        for jj = 1:size(fgm4,2)
            if fgm4(ii,jj) == 1
                outp(ii,jj) = I(ii,jj);
            else
                outp(ii,jj) = 0;
            end
        end
    end
    
    
    figure
    imshow(outp,[])
    title('Modified regional maxima superimposed on original image (fgm4)')
    
    
    bw1 = double(fgm);
    bw1 = im2bw(bw1);
    figure(11),
    imshow(I), title('Objects in cluster 1');
    
    hold on;
    
    boundaries = bwboundaries(bw1);
    numberOfBoundaries = size(boundaries);
    
    for k = 1 : numberOfBoundaries
        
        thisBoundary= boundaries{k};
        figure(11),plot(thisBoundary(:,2), thisBoundary(:,1), 'r', 'LineWidth',1.5);
        
    end
    hold off;
    

% -- GLCM Feature -- %

GLCM2 = graycomatrix((outp),'Offset',[2 0;0 2]);

stats = glcm(GLCM2,0);

v1 = stats.autoc(1);
v2 = stats.contr(1);
v3 = stats.corrm(1);
v4 = stats.corrp(1);
v5 = stats.cprom(1);
v6 = stats.cshad(1);
v7 = stats.dissi(1);
v8 = stats.energ(1);
v9 = stats.entro(1);
v10 = stats.homom(1);
v11 = stats.homop(1);
v12 = stats.maxpr(1);
v13 = stats.idmnc(1);

Glcm_fea = [v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 v11 v12 v13];

A = Glcm_fea
end