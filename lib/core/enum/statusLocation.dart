enum LocationStatus {
  serviceDisabled,//خدمة لموقع غير مفعلة 
  denied,//الاذن كرفوض
  deniedForever,//م رفض الاذن بشكل تام
  timeout, //انتهت مهلت البحث 
  success, //نجاح 
  unknown, // أي خطأ آخر غير متوقع
}
