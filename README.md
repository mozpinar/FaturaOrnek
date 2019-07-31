# Örnek Fatura yazılımı 
Fatura giriş yapılabilen örnek bir proje. Tedarikçiler, müşteriler, stoklar, döviz kurları girilen ve birbiriyle ilişkilendirilen basit bir sistem.

### Altyapısına ilişkin özellikleri
  * Delphi 10.2 Tokyo ile ve modern yazılım standartlarına göre yazılmıştır. Bazı kısımlar daha basit olsun diye bazı tasarım kalıplarından ödün verilse de genelde uyulmaya çalışılmıştır. Örneğin FireDAC kullanılmasına karşın programın sadece bir Unit'inde FD veritabanı işlemleri vardır, diğer kısımlar jeneriktir. Haliyle 1 günde FireDAC'tan başka bir DB Engine ya da DB kullanılır hale getirilebilir.
  * Formlar arasında sıkı bağ yoktur. Bir formu projeden çıkarıp, .pas ve . dfm dosyalarını silseniz bile derleyebilirsiniz. Sadece menüden o formu seçtiğinizde bulunamadı hatası verir.
  * Temelde 4 tür form öngörülmüştür. 
     * Ana Form : Bu zaten tektir,
     * Liste formları : Ana formdan seçim yapıldığında bu formlar açılır, örneğin ana formdan Satıcılar seçildiğinde Satıcılar Listesi açılır. Bunun üzerinde ekle, düzelt, sil butonları bulunur. Ana formla bu ekranlar arasında direkt bağlantı yoktur. Her liste formu kendisini global bir listeye ismiyle kaydeder, ana form bu formu bu isimle çağırır.
  
### Bu programın bazı özellikleri
  * Alım satım işlemleri dövizlidir, döviz dönüştürme işlemlerini otomatik yapar.
  * Ayrıca bir döviz cinsleri ve kurları için giriş ekranı vardır.
  * Müşteriler, Satıcı firmalar, Stok kartları girişleri 
  * Fatura girişi sırasında, firmayı seçtiğinizde faturanın döviz kodunu ve döviz kurunu firmanın döviz kodu olarak otomatik getirir. Her stok kaleminin ayrı döviz kodu olabilir. Giriş esnasında birim fiyatları stoğun döviz kodundan fatura döviz koduna otomatik çevirir. Her satıra miktar girildiğinde fatura, Kdv tutarını otomatik hesaplar.
  

### Programın çalışabilir kodları [burada](https://raw.githubusercontent.com/mozpinar/FaturaOrnek/master/FaturaOrnekExe.rar)!

![Parola ekranı](https://raw.githubusercontent.com/mozpinar/FaturaOrnek/master/Docs/1-Login%20form.png)

![Ana form](https://github.com/mozpinar/FaturaOrnek/blob/master/Docs/2-Main%20form.png)
![Tüm modül grid formları Ana Form üzerinde açılmışken](https://raw.githubusercontent.com/mozpinar/FaturaOrnek/master/Docs/3-Child%20forms%20in%20main%20form.png)

![Müşteriler](https://raw.githubusercontent.com/mozpinar/FaturaOrnek/master/Docs/4-Customer%20edit%20form%20on%20main%20form.png)

![Satış fatura giriş formu](https://raw.githubusercontent.com/mozpinar/FaturaOrnek/master/Docs/6-Sales%20invoice%20edit%20form%20on%20main%20form-2.png)
