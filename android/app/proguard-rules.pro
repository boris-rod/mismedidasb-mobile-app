-keep class com.dexterous.** { *; }
-keep class com.amazon.** {*;}
-keep class com.dooboolab.** { *; }
-keep class com.android.vending.billing.**
-dontwarn com.amazon.**
-keepattributes *Annotation*

#watch rules
-dontwarn com.no.nordicsemi.android.dfu.**
-keep class no.nordicsemi.android.dfu.** { *; }

-keep public interface no.nordicsemi.android.dfu.** { *; }
-keep public class com.yc.pedometer.update.Updates { *; }

-keep public class com.yc.pedometer.update.Updates$RealsilDfuCallback { *; }
#Rxjava RxAndroid
-dontwarn sun.misc.**
-keepclassmembers class rx.internal.util.unsafe.*ArrayQueue*Field* {
   long producerIndex;
   long consumerIndex;
}
-keepclassmembers class rx.internal.util.unsafe.BaseLinkedQueueProducerNodeRef {
    rx.internal.util.atomic.LinkedQueueNode producerNode;
}
-keepclassmembers class rx.internal.util.unsafe.BaseLinkedQueueConsumerNodeRef {
    rx.internal.util.atomic.LinkedQueueNode consumerNode;
}