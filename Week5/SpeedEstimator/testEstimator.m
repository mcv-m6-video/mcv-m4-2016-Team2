cfg = Config();

% Highway
sequence = LoadHighway(cfg);

image = sequence.train{1};
x = [10.0522; 190.7488; 273.9328; 263.9826];
y = [190.8483; 24.0821; 20.1020; 239.4055];


x1 = [x, y];
x1 = makehomogeneous(x1');
x2 = [0 0; 0 200; 200 200; 200 0];
x2 = makehomogeneous(x2');
% x2 = [0 0 1; 0 1, 1; 1, 1, 1; 1, 0, 1];

H = homography2d(x1, x2);

s = [200 200];
y = uint8(zeros(s(1), s(2), 3));

T =inv(H);
for r=1:s(1)
    for c=1:s(2)
        p = double([c r 1]');
        pimh = T*p;
        pim(1) = pimh(1) / pimh(3);
        pim(2) = pimh(2) / pimh(3);
        cim = pim(1);
        rim = pim(2);
        
        cc = round(cim);
        rr = round(rim);
        if cc>0 && cc<=size(image, 2) && rr>0 && r<=size(image, 1)
            y(r, c, :) = image(rr, cc, :);
        end
    end
end
figure;imshow(y)
