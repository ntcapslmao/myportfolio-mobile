# myportfolio_mobile

* Nama    : Muhammad Ghazi ALfisyahri Latief
* NPM     : 2506537751
* Kelas   : PBP D

# Individual Assignment 7: Basic Flutter

## 1. Jelaskan apa yang dimaksud dengan widget tree pada Flutter dan bagaimana hubungan induk-anak (parent-child) bekerja antar-widget!

Widget tree pada Flutter merupakan suatu struktur hierarkis berbentuk tree yang merepresentasikan susunan, konfigurasi, dan komposisi elemen *user interface* (UI). Flutter sendiri menganut filosofi "*everything is a widget*". Tree ini memiliki root widget (misal `MaterialApp`) yang bercabang ke widget-widget *layout* (seperti `Scaffold`, `Row`, dan `Column`) hingga berujung ke *leaf nodes* berupa konten visual konkret (seperti `Text` atau `Icon`). Widget tree bersifat *declarative* dan *immutable* sehingga Flutter akan mengevaluasi atau *rebuild* cabang pohon dengan efisien saat terjadi suatu update.

Hubungan *parent-child* bekerja dengan mekanisme komposisi (*parent* membungkus *child* dengan properti `child` atau `children`). Dalam penentuan *layout* di layar, hubungan ini menganut prinsip Flutter, yaitu "*constraints go down, sizes go up, parent sets position*", dalam artian parent memberikan batasan ukuran (lebar/tinggi min/max) ke *child*, *child* menentukan ukuran sendiri sesuai dengan batasan itu, dan *parent* bertugas menempatkan posisi koordinat fisik *child* di layar.

Selain *layout*, hubungan ini juga mengatur aliran data dan interaksi. *Configurations* dan data dialirkan ke bawah dari parent ke *child* dengan parameter *Constructor* atau `InheritedWidget` (misal `Theme.of(context)`), sedangkan user actions dialirkan ke atas dari *child* ke *parent* dengan callback (misal `onTap` di `InkWell`). Setiap kali widget *parent* di-*rebuild*, *child* branch di bawahnya otomatis dievaluasi kembali, kecuali *child* widget dioptimasi menggunakan keyword `const`.

## 2. Sebutkan semua widget yang kamu gunakan dalam proyek ini dan jelaskan fungsinya masing-masing!

*Custom widgets* yang digunakan:
1. `MyApp`, yaitu root widget aplikasi yang membungkus `MaterialApp` dan mengatur konfigurasi awal saat aplikasi dijalankan.
2. `MyHomePage`, yaitu widget halaman utama aplikasi yang menampung informasi profil pengguna dan daftar menu portofolio.
3. `InfoCard`, yaitu kartu khusus yang dirancang untuk menampilkan judul dan isi profil.
4. `ItemCard`, yaitu kartu tombol menu portofolio yang interaktif dan menampilkan ikon, nama menu, dan warna *background*.

*Built-in* Flutter *widgets* yang digunakan:
1. `MaterialApp`, yaitu root widget berbasis *Material Design* yang mengelola *global themes*, judul aplikasi, navigasi dasar, dan *homepage*.
2. `Scaffold`, untuk menyediakan kerangka layout standar halaman *Material Design*, seperti `AppBar`, `body`, dan `SnackBar`.
3. `AppBar`, untuk menampilkan *navbar* atau judul di bagian paling atas page (*header*).
4. `Padding`, untuk memberikan *padding* di sekeliling *child widgets* agar elemen tidak saling menempel satu sama lain atau menempel ke tepi wadah.
5. `Column`, untuk menyusun kumpulan *child widgets* secara vertikal, ibarat kolom dalam tabel.
6. `Row`, untuk menyusun kumpulan *child widgets* secara horizontal, ibarat baris dalam tabel.
7. `Center`, untuk menempatkan *child widget* tepat di tengah dari ruang yang tersedia.
8. `SizedBox`, untuk memberi *empty space* dengan ukuran lebar/tinggi yang tetap sebagai pemisah antar widget.
9. `GridView.count`, untuk menampilkan daftar kartu tombol dalam *grid layout* dengan jumlah kolom tetap (3 kolom).
10. `Card`, untuk menampilkan kotak bergaya Material dengan *elevation* dan sudut yang rounded untuk wadah `InfoCard`.
11. `Container`, yaitu widget pembungkus serbaguna untuk mengatur lebar *responsive* dan *padding* dalam `InfoCard` dan `ItemCard`.
12. `Material`, untuk memberikan permukaan dasar Material pada `ItemCard` untuk mengatur *background colour*, *border radius*, serta menjadi *animation canvas* `InkWell`.
13. `InkWell`, untuk implementasi `onTap` (aksi sentuhan) pada `Card` sekaligus menampilkan *ripple* dan *highlights* saat ditekan.
14. `SnackBar`, untuk menampilkan *temporary notification bar* di bawah layar sebagai respon *button click*.
15. `Expanded`, untuk mengatur widget `Text` dalam `Row` milik `SnackBar` agar bisa meluas memenuhi sisa lebar layar yang tersedia sehingga mencegah *overflow*.
16. `Icon`, untuk menampilkan *vector graphical icons* dari koleksi *Material Icons* pada *button* dan notifikasi.
17. `Text`, untuk menampilkan rangkaian teks di judul aplikasi, *profile*, *button labels*, dan `SnackBar` *message*.

## 3. Apa fungsi dari widget MaterialApp? Jelaskan mengapa widget ini umumnya digunakan sebagai root widget pada aplikasi Flutter!

`MaterialApp` adalah widget pembungkus tingkat atas yang memberikan fondasi sistem *Material Design* serta *global configurations* aplikasi, mulai dari *colour theme*/*typography* (`ThemeData`), judul aplikasi (`title`), *routing system*/*page navigation* (`Navigator`), *localisation*, dan penentuan *homepage*.

`MaterialApp` umumnya dipakai sebagai *root* widget karena `MaterialApp` menyediakan dependensi yang sifatnya wajib untuk widget yang ada di bawahnya. Widget-widget bawaan seperti `Scaffold`, `AppBar`, `InkWell`, dan `SnackBar` membutuhkan konteks dari `MaterialApp` (seperti `Theme`, `MediaQuery`, `Directionality`, `Navigator`, dan `ScaffoldMessenger`). Tanpa `MaterialApp` di *root* dari widget *tree*, widget-widget tersebut akan gagal dirender dan akan menghasilkan suatu error.

Selain itu, karena `MaterialApp` berada di *root* dari widget *tree*, aturan *theme*, ukuran layar, dan alur navigasi dapat diwariskan dan diakses secara seragam oleh seluruh halaman dalam aplikasi, sesuai dengan prinsip DRY (*Don't Repeat Yourself*) dalam pemrograman.

## 4. Jelaskan perbedaan antara StatelessWidget dan StatefulWidget! Kapan kita sebaiknya memilih StatelessWidget dan kapan harus menggunakan StatefulWidget?

`StatelessWidget` bersifat statis dan *immutable*. Tampilannya hanya bergantung pada konfigurasi/*arguments* yang diterima lewat *constructor* saat dibangun. Widget ini langsung memiliki *method* `build()` dan hanya akan di-*rebuild* jika widget *parent* me-*rebuild* dengan data baru. `StatelessWidget` semestinya digunakan ketika tampilan widget bersifat tetap dan tidak perlu mengubah data dirinya sendiri, misal `InfoCard`, `ItemCard`, atau *static page* seperti `MyHomePage`. Widget ini lebih ringan dan hemat dari segi *performance*.

Di sisi lain, `StatefulWidget` memiliki *state* internal yang dapat berubah secara dinamis selama aplikasi berjalan yang dikelola dalam kelas terpisah `State<T>`. Widget ini memiliki *lifecycle* seperti `initState()` dan `dispose()`, serta menyediakan *method* `setState()` untuk memberi tahu Flutter agar melakukan *rebuild* UI setiap kali terjadi perubahan data. `StatefulWidget` semestinya digunakan ketika tampilan UI harus merespons perubahan internal secara *real-time* seperti *form input* (*checkbox*, *text field*), animasi, *timer*, pengambilan data asinkron dari API, atau *counter*.

## 5. Apa itu BuildContext dan mengapa penting di Flutter? Bagaimana penggunaannya di dalam metode build?

`BuildContext` adalah *reference object* (*handle*) yang merepresentasikan lokasi spesifik suatu widget dalam *widget tree* (secara internal merujuk pada objek `Element` widget tersebut). Setiap widget memiliki `BuildContext`-nya sendiri. `BuildContext` sendiri berperan sebagai jembatan agar sebuah widget dapat berkomunikasi ke atas dan mengakses data dari widget leluhur (*ancestor*) di dalam *widget tree*, seperti tema, ukuran layar, *navigation systems*, atau `Scaffold`, secara langsung tanpa harus melempar parameter satu per satu dari *root tree* (*prop drilling*).

Flutter secara otomatis menyuntikkan parameter `BuildContext` *context* ke dalam `Widget build(BuildContext context)`. Di dalamnya, *context* umumnya diteruskan ke *method* `.of(context)` untuk mencari konfigurasi atau state leluhur terdekat. Pada proyek ini, `MediaQuery.of(context).size.width` di `InfoCard` bertugas untuk mengambil ukuran lebar layar *device* untuk menghitung lebar *card* secara *responsive*. Selain itu, `ScaffoldMessenger.of(context).showSnackBar(...)` di `ItemCard` bertugas untuk menelusuri *widget tree* ke atas untuk menemukan `Scaffold`/`ScaffoldMessenger` terdekat untuk menampilkan notifikasi `SnackBar`. Contoh lainnya adalah `Theme.of(context)` untuk mengakses *global colour themes* dan `Navigator.of(context)` untuk berpindah halaman.

## 6. Jelaskan konsep hot reload di Flutter dan apa perbedaannya dengan hot restart! Kapan kita tidak bisa hanya mengandalkan hot reload dan harus melakukan hot restart atau full restart?

*Hot reload* adalah fitur *development* Flutter (didukung *compiler* Just-In-Time/JIT) yang menyuntikkan Dart *code files* yang baru diubah langsung ke dalam Dart Virtual Machine (VM) yang sedang berjalan. Setelah kode dimasukkan, Flutter langsung memanggil ulang *method* `build()` untuk memperbarui tampilan *widget tree* dalam hitungan kurang dari satu detik tanpa menghancurkan *state* aplikasi saat ini.

*Hot reload* sendiri (`r` saja) memperbarui UI secara instan dengan mempertahankan *state* aplikasi (*variable*, *input form*, dan halaman aktif tidak hilang). Fungsi `main()` dan `initState()` tidak dijalankan ulang. Di sisi lain, *hot restart* (`R`, atau `Shift + R` lebih tepatnya) akan mengosongkan dan mereset seluruh *state* aplikasi kembali ke awal, lalu menjalankan ulang program mulai dari `main()` dan `initState()`. Waktunya akan sedikit lebih lama dari *hot reload* namun akan tetap jauh lebih cepat daripada *compile* ulang sepenuhnya.

Ketika kita tidak bisa mengandalkan *hot reload*, kita harus menjalankan *hot restart* ketika kita mengubah isi fungsi `main()`, *global*/*static variables*, atau logika *initialisation* di `initState()`, atau mengubah struktur tipe widget (misal dari `StatelessWidget` menjadi `StatefulWidget` atau sebaliknya) atau mengubah *constructor*/*schema* kelas model yang *instance*-nya sudah ada di *memory*.

*Hot restart* pun terkadang tidak bisa diandalkan, dan kita harus menjalankan *full restart* dengan menghentikan aplikasi (q) dan melakukan `flutter run` ulang ketika kita menambahkan atau mengubah dependensi, aset gambar atau *font* di dalam `pubspec.yaml`, atau mengubah kode/konfigurasi *native* spesifik platform (seperti file-file Android `build.gradle`, iOS `Info.plist`, atau C++ Windows).

## AI Disclosure and Reflections

Saya menggunakan *Generative AI* untuk membantu pengerjaan *Individual Assignment* 7 pekan ini, yaitu Gemini 3.8 Flash dan Gemini 4 Hydrogen melalui extension Antigravity di VSCode.

Karena permintaan utama tugas pekan ini cukup sederhana (dan petunjuk implementasinya sudah ada di dokumen *Individual Assignment* 7), saya lebih memanfaatkan AI untuk mempelajari sintaks serta dasar-dasar Dart, memahami perilaku widget Flutter lainnya (misalnya perilaku *ripple effect* pada `InkWell` dan menyesuaikan *colour scheme* dengan `myportfolio` versi website), serta memvalidasi pemahaman saya seputar pertanyaan reflektif dan menambah wawasan seputar Flutter dan Dart.

Untuk strategi *prompting*, saya tetap menerapkan batasan yang sama dengan pekan sebelumnya, yaitu dengan melarang Antigravity untuk mengubah *file* proyek secara langsung, sehingga saya tetap menulis seluruh perubahan program pada `main.dart` dan `menu.dart` secara mandiri. Saya juga mengarahkan *Generative AI* untuk memberikan penjelasan yang ringkas dan *to-the-point* agar diskusi tidak bertele-tele dan terasa lebih efektif sebagai sarana pembelajaran, bukan hanya menghasilkan kode yang tinggal saya *copy and paste* saja.

Keterbatasan yang saya temukan pada pekan ini adalah ketika saya mengimplementasikan `SnackBar` dan `SnackBarAction`. Pada awalnya, AI menyarankan saya untuk menambahkan ikon serta `SnackBarAction` 'Tutup' di dalam `SnackBar`. Ternyata, hasil dan perilakunya tidak sesuai ekspektasi saya, yaitu untuk `SnackBar` menutup dirinya sendiri setelah 2 detik tanpa harus ditutup secara manual. Karena saya menjalankan Flutter melalui Edge (saya tidak menggunakan Chrome, hanya Edge dan OperaGX; juga tidak memakai emulator karena keterbatasan *disk space* di laptop saya), `SnackBar` terus tertahan di layar dan tidak mau hilang otomatis, kecuali tombol tutup diklik secara manual. Setelah saya menghilangkan `SnackBarAction` itu, `SnackBar` muncul secara mulus, namun saat menghilang, `SnackBar` menghilang secara tiba-tiba tanpa animasi. Ketika saya mengembalikan *behaviour* kembali ke *fixed* agar animasi menghilangnya lebih mulus, `RoundedRectangleBorder` yang tersisa menimbulkan *white spot* aneh di bawah layar karena tetap terkena *rounding*. Pada akhirnya, saya memutuskan untuk kembali ke *fixed behaviour* sehingga tidak *floating* dan kembali menyerupai tutorial 8 (dengan *rounded edge* di bagian atas saja).

# Individual Assignment 8: Flutter Navigation, Layouts, Forms, and Input Elements

## 1. Jelaskan perbedaan antara Navigator.push(), Navigator.pushReplacement(), dan Navigator.pop(). Metode apa yang digunakan untuk membuka formulir dari kartu aksi? Jelaskan juga bagaimana opsi Home di drawer membawa pengguna kembali ke halaman utama.

`Navigator` pada Flutter sendiri mengelola perpindahan halaman dengan memakai struktur data Stack. `Navigator.push()` menambahkan *route* baru ke stack tanpa menghapus *route* sebelumnya, sedangkan `.pushReplacement()` langsung menggantikan *route* yang ada di *top of stack* dengan *route* baru. Sementara itu, `Navigator.pop()` mengambil dan menghapus *route* atau overlay (misal `AlertDialog`) paling atas stack agar tampilan kembali ke *route* di bawahnya. Seperti stack pada umumnya, `Navigator` bersifat *last in*, *first out* (LIFO).

Kartu aksi di ItemCard membuka halaman *forms* dengan memakai `Navigator.push()`. Hal ini membuat *homepage* tetap berada di stack (di bawah forms yang baru saja di-push) sehingga *user* bisa langsung kembali ke *home* dengan tombol *back* bawaan *device* tanpa harus membuka drawer dan menekan tombol *home*.

Sebaliknya, opsi *Home* pada `LeftDrawer` membawa user kembali ke homepage dengan memakai `Navigator.pushReplacement()` untuk kembali ke `MyHomePage`. Method ini mengganti halaman forms yang sedang aktif dengan `MyHomePage` sehingga alur navigasi tetap rapi tanpa adanya duplikat dalam stack.

## 2. Bagaimana susunan Scaffold, AppBar, dan Drawer membantu menjaga struktur halaman tetap konsisten? Berikan satu contoh penggunaan warna tema portofolio di lebih dari satu halaman.

Susunan tersebut menjaga struktur halaman agar tetap konsisten dengan menyediakan kerangka visual yang seragam di setiap halaman. `Scaffold` memisahkan *header* (`AppBar`), *sidebar* (`drawer`), dan isi dari halaman itu sendiri (`body`). `AppBar` memastikan setiap halaman selalu memiliki *navbar* dan *menu buttons* di posisi yang sama. Dengan memindahkan `LeftDrawer` menjadi widget sendiri dan memakainya berulang kali pada `MyHomePage` dan seluruh halaman *forms*, *list navigation* dan tampilan drawer akan sama di seluruh aplikasi.

Contoh dari penerapan *color theme* portfolio di lebih dari satu halaman adalah pada penggunaan warna `0xFF0C0E1A` (hitam tetapi tidak terlalu hitam) yang digunakan pada `backgroundColor` `AppBar` di `MyHomePage` dan seluruh halaman *forms*, serta pada `DrawerHeader` di `LeftDrawer`. Selain itu, warna utama `0xFF818CF8` (ungu pastel dari myportfolio versi web) juga digunakan pada tombol simpan di halaman *forms* dengan `Theme.of(context).colorScheme.primary`.

## 3. Mengapa tata letak tersebut dipilih untuk formulir? Jelaskan peran widget pengatur jarak dan widget penggulir ketika ruang layar terbatas.

Layout *forms* menggunakan `SingleChildScrollView` yang membungkus `Column` dengan `CrossAxisAlignment.stretch` karena susunan vertikal memudahkan *user* untuk mengisi *field* secara berurutan dari atas ke bawah. `Stretch` juga memastikan lebar setiap input *field* menyesuaikan lebar layar yang tersedia tanpa ukuran *static* yang bisa jadi terpotong pada device dengan layar yang lebih sempit. Hal ini ibarat mengatur `width: 100%` di CSS myportfolio versi web.

Saat ruang di layar terbatas, widget pengatur jarak seperti `Padding` dan `SizedBox` berperan menjaga keterbacaan *interface*. `Padding` memberikan jarak tepi agar elemen forms tidak saling menabrak dan tidak menempel ke pinggir layar, sedangkan `SizedBox` digunakan untuk menjaga jarak antar-*field* yang konsisten sehingga pesan *input validation* yang muncul tidak menimpa/berhimpitan dengan elemen selanjutnya.

Sementara itu, `SingleChildScrollView` berperan mencegah terjadinya *overflow* karena `Column` secara bawaan tidak bisa digulir. Saat layar berukuran kecil, ketika *item media* ditambahkan pada `CreativeProject` *forms*, atau saat *keyboard* muncul dan mempersempit tinggi tampilan, widget ini memastikan seluruh input dan tombol simpan/*save* tetap bisa dijangkau pengguna.

## 4. Apa peran GlobalKey<FormState>, validator, dan validate() saat tombol Simpan ditekan? Berikan satu contoh nilai yang ditolak oleh validasi dan jelaskan mengapa memilih jenis input atau papan ketik saja belum cukup.

Ketika tombol Simpan ditekan, `GlobalKey<FormState>` (`_formKey`) berperan sebagai penghubung agar tombol bisa mengakses `FormState` melalui `_formKey.currentState`. Dari situ, `validate()` dipanggil dan akan mengeksekusi `validator` untuk setiap kolom dalam `Form` serentak. Jika semua `validator` mengembalikan null, `validate()` mengembalikan true sehingga `AlertDialog` berisi ringkasan dapat ditampilkan. Sebaliknya, jika ada satu pun `validator` yang mengembalikan *error message*, dialog tidak akan dibuka dan *error message* langsung muncul untuk kolom yang bermasalah.

Contoh nilai yang ditolak oleh *input validation* adalah teks yang isinya hanya *whitespace* pada kolom wajib seperti nama institusi/proyek/posisi, karena dicek menggunakan `value.trim().isEmpty` (*whitespace* kena trim, dan *input field* berujung kosong). Contoh lainnya adalah teks seperti `github.com/...` pada kolom tautan/url karena tidak memiliki awalan `http://` atau `https://` yang valid; dan tanggal selesai yang lebih awal/duluan dari tanggal mulai.

Memilih jenis input atau keyboard (misal `TextInputType.url`) belum cukup karena hal itu hanya mempermudah tampilan keyboard dan tidak membatasi isi data secara ketat. Pengguna tetap bisa menempelkan teks yang salah format, membiarkan kolom wajib kosong, mengisi kolom dengan *whitespace*, atau melanggar aturan antarkolom dengan memasang tanggal selesai lebih dulu dari tanggal mulai, sehingga `validator` tetap harus ada.

## AI Disclosure and Reflections

Saya menggunakan *Generative AI* untuk membantu pengerjaan *Individual Assignment* 8 pekan ini, yaitu **Gemini 4 Hydrogen** melalui *extension* Antigravity di VSCode.

Pada tugas ini, bagian yang paling terbantu oleh AI adalah pengecekan serta penyusunan halaman formulir (`EducationFormPage`, `ExperienceFormPage`, dan `CreativeProjectFormPage`) agar konsisten mengikuti `project_form.dart` dari tutorial 9, penyeragaman *colour theme* dengan `myportfolio` versi web (`0xFF0C0E1A` dan `0xFF818CF8`), serta *input validation* yang sesuai dengan model aslinya di Django. Selain itu, AI juga membantu mengubah dan menerapkan relasi *1-to-Many* antara `CreativeProject` dan `PortfolioItem` di Django ke dalam bentuk *dynamic list* pada `StatefulWidget` (yang secara temporer dibatasi 3 item dulu sebelum implementasi DRF dan networking nantinya), serta me-*review* jawaban pertanyaan reflektif saya.

Untuk strategi *prompting*, saya tetap membatasi konteks yang diberikan serta mencegah Antigravity untuk mengubah file secara langsung, sama seperti pekan-pekan sebelumnya. Saya mengerjakannya secara bertahap per model (dimulai dari `Education`, merapikan `project_form.dart`, lalu `Experience`, hingga `CreativeProject`) sambil tetap memeriksa dan menyesuaikan detail kode secara manual.

Keterbatasan yang saya temukan pekan ini muncul pada tahap testing ketika AI melebihi cakupan pembelajaran sampai saat ini. AI sempat menginisiasi dan menyarankan untuk mengisi `test/widget_test.dart` dengan *widget test* untuk memverifikasi validasi serta navigasi formulir. Namun, karena materi *testing* pada Flutter/Dart belum dibahas di kelas maupun di tutorial apapun dan saya sendiri belum memahami konsep *widget testing* tersebut, saya memutuskan untuk tidak mengubah `widget_test.dart` dan hanya mengandalkan `flutter analyze` serta *manual testing* di *browser* sesuai arahan tugas.