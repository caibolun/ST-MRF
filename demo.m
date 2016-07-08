close all;
clc;
clear;

video_path = '.\bali\';
img_files = dir([video_path '*.png']);

%% parameter
% DCP parameter
omega  = 0.7;
t0=0.1;
% ST-MRF parameter
D_r = 20;
eps = 10^-4;
f=1;
rho=0.1;
A_r=15;

lambda_t=hann(f*2+3);
lambda_t(lambda_t==0)=[];
lambda_t=lambda_t./sum(lambda_t);
lambda_t=reshape(lambda_t,1,1,numel(lambda_t));

%% init
I = single(imread([video_path img_files(1).name]))./255;
gray_I = rgb2gray(I);
% init A
[min_value, ~] = MinPooling(I,single([A_r A_r]));
min_value=reshape(min_value,size(min_value,1)*size(min_value,2),size(min_value,3));
L=mean(min_value,2);
item=find(L==max(L(:)));
A=min_value(item,:);
A=mean(A,1);
A=reshape(A,1,1,3);
% init buffer
D = min(I,[],3);        %Eq.(2)
Dt=cat(3,D,D,D);        %init D_t buffer
uD=convBox(D, D_r);     %mean filter of D
uD_t=cat(3,uD,uD,uD);   %init uD_t buffer
pre_gray=gray_I;
pre_I=I;

nFrames=0;
time=0;
for n = 1 : numel(img_files)
    if n<numel(img_files)
        I = single(imread([video_path img_files(n+1).name]))./255;
        
        tic
        gray_I = rgb2gray(I);
        
        D = min(I,[],3);	%Eq.(2)
        Dt(:,:,1)=[];       %pop the old D_t 
        Dt=cat(3,Dt,D);     %push the new D
        
        uD=convBox(D, D_r); %mean filter of D   
        uD_t(:,:,1)=[];     %pop the old D_t
        uD_t=cat(3,uD_t,uD);%push the new uD
        
        refine_D = stMRF(pre_gray, Dt, uD_t, lambda_t, D_r, eps); %Eq.(7)
    else
        Dt(:,:,1)=[];       %pop the old D_t
        Dt=cat(3,Dt,D);     %push the new D
        uD_t(:,:,1)=[];     %pop the old uD_t
        uD_t=cat(3,uD_t,uD);%push the new uD
        
        refine_D = stMRF(pre_gray, Dt, uD_t, lambda_t, D_r, eps);
    end
    transmission = 1 - omega * bsxfun(@rdivide,refine_D, A);
    transmission = max(t0,transmission);
    dehaze = (pre_I-bsxfun(@times,A,(1-transmission)))./transmission; %Eq.(1) 
    
    %% update A
    [min_value, ~] = MinPooling(I,single([A_r A_r]));
    min_value=reshape(min_value,size(min_value,1)*size(min_value,2),size(min_value,3));
    L=mean(min_value,2);
    item=find(L==max(L(:)));
    Atemp=min_value(item,:);
    Atemp=mean(Atemp,1);
    Atemp=reshape(Atemp,1,1,3); 
    A = rho*Atemp+(1-rho)*A;
    
    %% update image buffer
    pre_gray=gray_I;
    pre_I=I;
    
    time=time+toc;
    nFrames=nFrames+1;
    subplot(1,2,1);imshow(pre_I);title('Hazy');
    subplot(1,2,2);imshow(dehaze);title('ST-MRF');
    drawnow;
end
disp(['ST-MRF Dehazing:' num2str(nFrames/time) 'fps']);



