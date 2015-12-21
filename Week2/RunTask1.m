cfg = Config;

[highway, fall, traffic] = LoadDatabases(cfg);
highway.gaussian = GaussianPerPixel( highway.train );
fall.gaussian = GaussianPerPixel( fall.train );
traffic.gaussian = GaussianPerPixel( traffic.train );