
for iiii = 1:27
    
    I = imread(['Dataset\','IMG (',num2str(iiii),')','.jpg']);
    
% -- Image Noise Filtering -- %
    
    flevel = 0.5;
    fmat = 3;
    
    Im = fspecial('gaussian',[fmat fmat],flevel);
    
    Filt = imfilter(I,Im);
    
    
% -- SEgmentation -- %
    
if size(Filt,3) == 3
    
    I = rgb2gray(Filt);
else
    I = Filt;
end

    se = strel('disk', 20);
    Io = imopen(I, se);
    
    Ie = imerode(I, se);
    Iobr = imreconstruct(Ie, I);
    
    
    Ioc = imclose(Io, se);
    
    
    Iobrd = imdilate(Iobr, se);
    Iobrcbr = imreconstruct(imcomplement(Iobrd), imcomplement(Iobr));
    Iobrcbr = imcomplement(Iobrcbr);
    
    
    fgm = imregionalmax(Iobrcbr);
    
    
    I2 = I;
    I2(fgm) = 255;
    
    
    se2 = strel(ones(5,5));
    fgm2 = imclose(fgm, se2);
    fgm3 = imerode(fgm2, se2);
    
    fgm4 = bwareaopen(fgm3, 20);
    I3 = I;
    I3(fgm4) = 200;
    
    
    
    for ii = 1:size(fgm4,1)
        for jj = 1:size(fgm4,2)
            if fgm4(ii,jj) == 1
                outp(ii,jj) = I(ii,jj);
            else
                outp(ii,jj) = 0;
            end
        end
    end
    
    
    
    
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

Trainfea(iiii,:) = Glcm_fea;

end

save Trainfea Trainfea