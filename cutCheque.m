clear all
I=imread('ch7.jpg'); % Load the image file and store it as the variable I. 
figure,imshow(I);
pause
%I3=rgb2gray(I);
%I3=im2double(I3);
I3=im2bw(I,0.9);
figure,imshow(I3);
pause
[rows,cols]=size(I3);
%getting the margins
xstart=cols;
xend=1;
ystart=rows;
yend=1;

for r=1:rows
    for c=1:cols
        if((I3(r,c)==1))
            if (r<ystart)
                ystart=r;
            end
            if((r>yend))
                yend=r; 
            end
            if (c<xstart)
                xstart=c;
            end
            if (c>xend)
                xend=c;
            end     
       end  
    end
end


        
%cutting the image and copying it to another matrix        
for i=ystart:yend
    for j=xstart:xend
        im((i-ystart+1),(j-xstart+1))=I3(i,j);
    end
end

              
 %resizing the image         
I3=imresize(im,[500,1000]);
[x y]=size(I3)
figure,imshow(I3);
pause

%cropping  row with the cheque number
im=imcrop(I3,[1,440,1000,40]);
%finding the first column with a black pixel 
im=imfilter(im,[1,1]);
blackPixel=1000;
[r c]=size(im);
for m=1:r
    for n=1:c
        if((im(m,n)==0))
            if (n<blackPixel && n>100)
                blackPixel=n;
            end
        end
    end
end
im=imcrop(im,[blackPixel,1,1000-blackPixel,40]);
%cropping the cheque number
im=imcrop(im,[15,1,110,40]);
figure,imshow(im);

%filtering the cheque number to remove noise

[r,c]=size(im)
    

 figure,imshow(im);
 pause
 [r,c]=size(im)

blackFound=0;
right=c;
    for i=1:6
        %getting the column number of the first black pixel
        for j=1:r
            for k=1:c
                if(im(j,k)==0)
                    if(k<right)
                        right=k;
                    end
                end
            end
        end
        
        finish=right;
        pureWhiteFound=0;
        %finding the next pure white column
        
        while(pureWhiteFound==0 && finish~=c+1)
            row=1;
            blackFound=0;
            while(blackFound==0 && row~=(r+1))
                if(im(row,finish)==0)
                    blackFound=1;%if a black pixel is found in the column step to the next coloumn
                else
                    row=row+1;
                end
            end
            if(blackFound==0)
                pureWhiteFound=1;%if non black pixel is found in the curren column
            else
                finish=finish+1;
            end
        end
        I=imcrop(im,[right,1,finish-right-1,r]);
        %getting the above and bottom margins
        ystart=r;
        yend=1;
        [p q]=size(I);
        for m=1:p
            for n=1:q
                if((I(m,n)==0))
                    if (m<ystart)
                        ystart=m;
                    end
                    if((m>yend))
                        yend=m; 
                    end
               end  
            end
        end
        %the i th number in the cheque number is cropped
        number(:,:,i)=imresize(imcrop(im,[right,ystart,finish-right-1,yend-ystart]),[40,20]); 
        %the rest of the cheque number image after cropping the i th number
        im=imcrop(im,[finish,1,c,r]);     
        [r,c]=size(im);
        right=c;
    end
    for i=1:6
        figure,imshow(number(:,:,i));
        pause
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%loading the sample images
 sample(:,:,1)=im2bw(imresize(rgb2gray(imread('one.jpg')),[128 128]));
 sample(:,:,2)=im2bw(imresize(rgb2gray(imread('two.jpg')),[128 128]));
 sample(:,:,3)=im2bw(imresize(rgb2gray(imread('three.jpg')),[128 128]));
 sample(:,:,4)=im2bw(imresize(rgb2gray(imread('four.jpg')),[128 128]));
 sample(:,:,5)=im2bw(imresize(rgb2gray(imread('five.jpg')),[128 128]));
 sample(:,:,6)=im2bw(imresize(rgb2gray(imread('six.jpg')),[128 128]));
 sample(:,:,7)=im2bw(imresize(rgb2gray(imread('seven.jpg')),[128 128]));
 sample(:,:,8)=im2bw(imresize(rgb2gray(imread('eight.jpg')),[128 128]));
 sample(:,:,9)=im2bw(imresize(rgb2gray(imread('nine.jpg')),[128 128]));
 sample(:,:,10)=im2bw(imresize(rgb2gray(imread('zero.jpg')),[128 128]));
%cutting the samople images to prpare for matching 
for i=1:10
    xstart=128;
    xend=1;
    ystart=128;
    yend=1;

    for r=1:128
        for c=1:128
            if((sample(r,c,i)==0))
                if (r<ystart)
                    ystart=r;
                end
                if((r>yend))
                    yend=r; 
                end
                if (c<xstart)
                    xstart=c;
                end
                if (c>xend)
                    xend=c;
                end     
           end  
        end
    end
     samplecut(:,:,i)=imresize(imcrop(sample(:,:,i),[xstart,ystart,xend-xstart,yend-ystart]),[40 20]);
end

%comparing the numbers
for i=1:6
    percentage=0;
    picsize=40*20;
    for j=1:10
        matchingPixels=0;
        for m=1:40
            for n=1:20
                if(number(m,n,i)==samplecut(m,n,j))
                    matchingPixels=matchingPixels+1;
                end
            end
        end
        matchingPercentage=(matchingPixels/picsize)*100;
        if(matchingPercentage>percentage)
            percentage=matchingPercentage;
            if(j==1)
                num(i)=1;
            elseif(j==2)
                num(i)=2;
            elseif(j==3)
                num(i)=3;
            elseif(j==4)
                num(i)=4;
            elseif(j==5)
                num(i)=5;
            elseif(j==6)
                num(i)=6;
            elseif(j==7)
                num(i)=7;
            elseif(j==8)
                num(i)=8;
             elseif(j==9)
                num(i)=9;
            else
                num(i)=0;
                
            end
                    
        end
       
    end   
end
%calculating the cheque number
chequeNumber=num(1)*10^5+num(2)*10^4+num(3)*10^3+num(4)*10^2+num(5)*10+num(6);

%formatting the cheque number in case of zeros at the begining
    str=int2str(chequeNumber);
    l=length(str);
    for i=l:5
        str=strcat('0',str);
    end
    ChequeNumber=str;
    display(ChequeNumber);
    


    


        

