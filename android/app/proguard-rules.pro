# Reglas ProGuard para Flutter
# Mantener las clases de Flutter

-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Mantener las clases de plugins
-keep class androidx.** { *; }

# Ignorar warnings
-ignorewarnings

# Mantener anotaciones
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes InnerClasses
-keepattributes EnclosingMethod

# Preservar información de depuración
-keepattributes SourceFile,LineNumberTable
-renamesourcefileattribute SourceFile