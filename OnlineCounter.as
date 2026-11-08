import flash.net.URLRequest;
import flash.net.URLLoader;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.utils.Timer;
import flash.events.TimerEvent;
import flash.text.TextField;

// 1. متغيرات الاتصال والعداد
private var serverUrl:String = "https://my-game-server-production-fb37.up.railway.app";
private var playerCountText:TextField; // خانة النص اللي هتظهر جوه اللعبة
private var updateTimer:Timer;

// 2. دالة تهيئة العداد وبدء الاتصال
public function initOnlineCounter(targetTextField:TextField):void {
    playerCountText = targetTextField;
    
    // جلب البيانات لأول مرة فوراً
    fetchOnlinePlayers();
    
    // إعداد مؤقت (Timer) لتحديث العداد كل 30 ثانية تلقائياً
    updateTimer = new Timer(30000); // 30000 مللي ثانية = 30 ثانية
    updateTimer.addEventListener(TimerEvent.TIMER, onTimerTick);
    updateTimer.start();
}

// 3. دالة إرسال الطلب للسيرفر
private function fetchOnlinePlayers():void {
    var request:URLRequest = new URLRequest(serverUrl);
    var loader:URLLoader = new URLLoader();
    
    loader.addEventListener(Event.COMPLETE, onServerResponse);
    loader.addEventListener(IOErrorEvent.IO_ERROR, onServerError);
    
    try {
        loader.load(request);
    } catch (e:Error) {
        trace("خطأ في إرسال الطلب: " + e.message);
    }
}

// 4. دالة استقبال الرد من السيرفر وعرضه في اللعبة
private function onServerResponse(event:Event):void {
    var loader:URLLoader = URLLoader(event.target);
    var playerCount:String = loader.data; // الرقم أو النص الراجع من السيرفر
    
    if (playerCountText != null) {
        playerCountText.text = "Online: " + playerCount;
    }
    trace("عدد اللاعبين المتصلين: " + playerCount);
}

// 5. دالة التعامل مع خطأ الاتصال
private function onServerError(event:IOErrorEvent):void {
    trace("فشل الاتصال بالسيرفر، سيتم إعادة المحاولة لاحقاً.");
}

// 6. الحدث الخاص بالمؤقت
private function onTimerTick(event:TimerEvent):void {
    fetchOnlinePlayers();
}
