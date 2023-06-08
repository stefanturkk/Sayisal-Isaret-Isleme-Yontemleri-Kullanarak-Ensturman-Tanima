% Ses dosyasını yükle
dosyaAdi = 'C:\görüntü işleme\piano\yeni\22.wav';
[y, fs] = audioread(dosyaAdi);
y = mean(y, 2); 

% Parametreleri tanımlanması
frameBoyutu = 512; 
adimBoyutu = frameBoyutu / 2;


[S, f, t] = spectrogram(y, hamming(frameBoyutu), adimBoyutu, frameBoyutu, fs);


spektralMerkez = sum(f .* abs(S), 1) ./ sum(abs(S), 1);
spektralYayilma = sqrt(sum(((f - spektralMerkez).^2) .* abs(S), 1) ./ sum(abs(S), 1));
spektralCarpiklik = sum(((f - spektralMerkez).^3) .* abs(S), 1) ./ (spektralYayilma.^3 .* sum(abs(S), 1));
spektralKurtosis = sum(((f - spektralMerkez).^4) .* abs(S), 1) ./ (spektralYayilma.^4 .* sum(abs(S), 1));


esikler = [
    2000 200 600 800; % Spektral merkez eşikleri [gitar piyano davul keman] 
    1500 300 200 600; % Spektral yayılma eşikleri [gitar piyano davul keman] 
    5 5 7 8; % Spektral çarpıklık eşikleri [gitar piyano davul keman] 
    10 7 10 15 % Spektral kurtosis eşikleri [gitar piyano davul keman] 
];

% Spektral özellikleri eşik değerleriyle karşılaştır
enstrumanEtiketleri = {'gitar', 'piyano', 'davul', 'keman'};
enstrumanSkorlari = zeros(1, 4);

for i = 1:length(enstrumanEtiketleri)
    skorlar = [spektralMerkez(i); spektralYayilma(i); spektralCarpiklik(i); spektralKurtosis(i)];
    enstrumanSkorlari(i) = sum(skorlar > esikler(:, i));
end

% En yüksek değere sahip enstrümanın bulunması
[~, tahminEdilenIndex] = max(enstrumanSkorlari);
tahminEdilenEtiket = enstrumanEtiketleri{tahminEdilenIndex};

% Tahmin edilen enstrümanı ekrana yazdır
disp(['Tahmin edilen enstrüman: ' tahminEdilenEtiket]);


