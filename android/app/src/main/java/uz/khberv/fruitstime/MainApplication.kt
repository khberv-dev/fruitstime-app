package uz.khberv.fruitstime

import android.app.Application
import com.yandex.mapkit.MapKitFactory

class MainApplication : Application() {
    override fun onCreate() {
        super.onCreate()
        MapKitFactory.setApiKey("9b104dbc-7702-4a81-a7c4-e03acf385e52")
    }
}
