# Release build'de R8 için ek kurallar.
# Flutter ve eklentiler kendi kurallarını otomatik ekler; burada yalnızca
# R8'in sildiği/kırdığı bir sınıf tespit edilirse kural eklenir.

# Flutter deferred components (Play Core) kullanılmıyor; R8 eksik sınıf
# uyarısında build'i durdurmasın.
-dontwarn com.google.android.play.core.**
