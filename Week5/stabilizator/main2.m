
cfg = Config();

traffic = LoadTraffic(cfg);
sequence = [traffic.train, traffic.test];
gtSequence = traffic.gt;
[u1Sequence, v1Sequence, x, y] = FindMotion(sequence);
[stabSequence, stabGT] = SeparateDesiredMovFromShake(sequence, gtSequence,...
                        u1Sequence, v1Sequence, x, y);
save('stabSequence.mat', stabSequence)
save('stabGT.mat', stabGT)