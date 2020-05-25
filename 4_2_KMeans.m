close all;
clear all;
clc;

disp('Preparing training data');
folderCat = './Datasets/Training/Cat/';
folderDog = './Datasets/Training/Dog/';
filesCat = dir(fullfile(folderCat, '*.jpg'));
filesDog = dir(fullfile(folderDog, '*.jpg'));

feats = zeros(length(filesCat) + length(filesDog), 256);
labels = zeros(length(filesCat) + length(filesDog),1);
for i = 1:length(filesCat)
    disp(i);
    filename = filesCat(i,1).name;
    img = imread([folderCat filename]);
    img1 = imresize(img,[256,256]);
    feat = lbp(img1);
    feats(i,:) = feat;
    labels(i) = 1;
end
for i = 1:length(filesDog)
    disp(i);
    filename = filesDog(i,1).name;
    img = imread([folderDog filename]);
    img1 = imresize(img,[256,256]);
    feat = lbp(img1);
    feats(i + length(filesCat),:) = feat;
    labels(i + length(filesCat)) = 2;
end

disp('Preparing testing data');
folderCat = './Datasets/Testing/Cat/';
folderDog = './Datasets/Testing/Dog/';
filesCat = dir(fullfile(folderCat, '*.jpg'));
filesDog = dir(fullfile(folderDog, '*.jpg'));

featsTest = zeros(length(filesCat) + length(filesDog), 256);
pred = zeros(length(filesCat) + length(filesDog), 1);
pL = 0;

for i = 1:length(filesCat)
    disp(i);
    filename = filesCat(i,1).name;
    img = imread([folderCat filename]);
    img1 = imresize(img,[256,256]);
    feat = lbp(img1);
    featsTest(i,:) = feat;
    pred(i) = 1;
end
for i = 1:length(filesDog)
    disp(i);
    filename = filesDog(i,1).name;
    img = imread([folderDog filename]);
    img1 = imresize(img,[256,256]);
    feat = lbp(img1);
    featsTest(i + length(filesCat),:) = feat;
    pred(i + length(filesCat)) = 2;
end
disp('Performing testing');
accurateClassification = 0;
k = 3;
T = 0;
prediction = 0;
%lab = zeros(length(filesCat) + length(filesDog),1);
for i = 1:size(featsTest,1)
    feat = featsTest(i,:);
    dists = distChiSq(feat,feats);
    for n = 1:k
    [m, idx] = min(dists);
    dists(bsxfun(@eq,dists,m))= 100;
    count_dog = 0;
    count_cat = 0;
        if(labels(idx) == pred(idx))
            prediction = prediction +1;
        end
    end
    prediction = prediction /k;
    if(prediction > 0.5)
        accurateClassification = accurateClassification + 1;
    end
end

accuracy = accurateClassification/length(pred);
disp(['The Accuracy:' num2str(accuracy * 100) '%']);
% close all;
% clc;
%
% folder = './Datasets/';
% files = dir(fullfile(folder,'*.jpg'));
% feats = zeros(length(files),256);
% for i = 1:length(files)
%     disp(i);
%     filename = files(i,1).name;
%     img= imread([folder filename]);
%     img= imresize(img,[320,480]);
%     feat = lbp(img);
%     feats(i,:) = feat;
% end
%
% query = imread('37.jpg');
% query = imresize(query,[320,480]);
% feat = lbp(query);
%
% dists = distChiSq(feat,feats);
% [val,idx] = min(dists);
% k=3;
% class1_count = 0;
% class2_count = 0;
% labels = [1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2];
% for k = 1:k
%     [m,idx] = min(dists);
%     dists(bsxfun(@eq,dists,m))=Inf;
%     img_result= imread([folder files(idx,1).name]);
%     img_result= imresize(img_result,[320,480]);
%     subplot(1,2,1); imshow(query); title('Query');
%     subplot(1,2,2); imshow(img_result); title('Result');
% end
%
% for i = 1:100
%     if (dist(i)== Inf)
%         count = 1;
%         if (labels(i)==1)
%             class1_count = class1_count + 1;
%         end
%         if (labels(i)==2)
%             class2_count = class2_count + 1;
%         end
%     end
% end
% disp(class1_count);
% disp(class2_count);
