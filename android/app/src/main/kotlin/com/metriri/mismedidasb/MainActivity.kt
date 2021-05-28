package com.metriri.mismedidasb

import android.bluetooth.BluetoothDevice
import android.content.Context
import android.os.Bundle
import android.text.TextUtils
import android.util.Log
import androidx.annotation.NonNull
import com.yc.pedometer.info.HeartRateHeadsetSportModeInfo
import com.yc.pedometer.info.SportsModesInfo
import com.yc.pedometer.info.StepOneDayAllInfo
import com.yc.pedometer.info.TemperatureInfo
import com.yc.pedometer.listener.RateCalibrationListener
import com.yc.pedometer.listener.TemperatureListener
import com.yc.pedometer.listener.TurnWristCalibrationListener
import com.yc.pedometer.sdk.*
import com.yc.pedometer.utils.GlobalVariable
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.EventChannel.StreamHandler
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity(), ICallback, ServiceStatusCallback, OnServerCallbackListener, RateCalibrationListener, TurnWristCalibrationListener, TemperatureListener, DeviceScanInterfacer {

    companion object {
        val TAG = "MainActivity"
        val EVENT_CHANNEL_SINK_TYPE_KEY = "EVENT_CHANNEL_SINK_TYPE_KEY"
        val ACTIONS_FROM_FLUTTER = "watch.metriri.com/actions_from_flutter"
        val ACTIONS_FROM_NATIVE = "watch.metriri.com/actions_from_native"

        //Channel methods
        val START_SCAN = "start_scan"
        val STOP_SCAN = "stop_scan"
        val CONNECT = "connect"
        val DISCONNECT = "disconnect"
        val IS_SUPPORT_BLE = "is_support_ble"
        val IS_BLE_ENABLED = "is_ble_enabled"

        //Channel event
        val LE_SCAN_CALLBACK = "LeScanCallback"
        val BLOOD_PRESSURE_CALLBACK = "mOnBloodPressureListener"
        val RATE_CALLBACK = "mOnRateListener"
        val STEP_CHANGE_CALLBACK = "mOnStepChangeListener"
        val RATE24_CALLBACK = "mOnRateOf24HourListener"
    }

    private lateinit var mContext: Context

    private var mBLEServiceOperate: BLEServiceOperate? = null
    private var mBluetoothLeService: BluetoothLeService? = null
    private var mDataProcessing: DataProcessing? = null
    private var mWriteCommand: WriteCommandToBLE? = null

    private var eventSink: EventSink? = null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        Log.w("configureFlutterEngine", "configureFlutterEngine:MainActivity")

        mContext = this

        mBLEServiceOperate = BLEServiceOperate
                .getInstance(mContext)

        mBLEServiceOperate!!.setDeviceScanListener(this)

        mBluetoothLeService = mBLEServiceOperate!!.bleService
        if (mBluetoothLeService != null) {
            mBluetoothLeService!!.setICallback(this)
            mBluetoothLeService!!.setRateCalibrationListener(this)
            mBluetoothLeService!!.setTurnWristCalibrationListener(this)
            mBluetoothLeService!!.setTemperatureListener(this)
        }

        mWriteCommand = WriteCommandToBLE.getInstance(mContext)
        mDataProcessing = DataProcessing.getInstance(mContext)

        mDataProcessing!!.setOnStepChangeListener(mOnStepChangeListener)
        mDataProcessing!!.setOnSleepChangeListener(mOnSleepChangeListener)
        mDataProcessing!!.setOnRateListener(mOnRateListener)
        mDataProcessing!!.setOnRateOf24HourListenerRate(mOnRateOf24HourListener)
        mDataProcessing!!.setOnBloodPressureListener(mOnBloodPressureListener)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, ACTIONS_FROM_FLUTTER).setMethodCallHandler { call, result ->
            when (call.method) {
                IS_SUPPORT_BLE -> {
                    try {
                        val supported = mBLEServiceOperate!!.isSupportBle4_0
                        result.success(supported)

                    } catch (e: Exception) {
                        result.error("500", e.message, e.localizedMessage)
                    }
                }
                IS_BLE_ENABLED -> {
                    try {
                        val isEnabled = mBLEServiceOperate!!.isBleEnabled
                        result.success(isEnabled)
                    } catch (e: Exception) {
                        result.error("500", e.message, e.localizedMessage)
                    }
                }
                START_SCAN -> {
                    try {
                        mBLEServiceOperate!!.startLeScan()
                        result.success(200)
                        Log.w("START_SCAN", "START_SCAN:MainActivity")
                    } catch (e: Exception) {
                        result.error("500", e.message, e.localizedMessage)
                    }
                }
                STOP_SCAN -> {
                    try {
                        mBLEServiceOperate!!.stopLeScan()
                        result.success(200)
                    } catch (e: Exception) {
                        result.error("500", e.message, e.localizedMessage)
                    }
                }
                CONNECT -> {
                    try {
                        val mac = call.arguments as? String
                        mBLEServiceOperate!!.connect(mac)
                        result.success(200)
                    } catch (e: Exception) {
                        result.error("500", e.message, e.localizedMessage)
                    }
                }
                DISCONNECT -> {
                    try {
                        mBLEServiceOperate!!.disConnect()
                        result.success(200)
                    } catch (e: Exception) {
                        result.error("500", e.message, e.localizedMessage)
                    }
                }
            }
        }


        EventChannel(flutterEngine.dartExecutor.binaryMessenger, ACTIONS_FROM_NATIVE).setStreamHandler(
                object : StreamHandler {
                    override fun onListen(args: Any?, events: EventSink) {
                        Log.w("EventChannel", "onListen:MainActivity")
                        eventSink = events;
                    }

                    override fun onCancel(args: Any?) {
                        Log.w("EventChannel", "onCancel:MainActivity")
                        eventSink = null
                    }
                }
        )
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        Log.w("onCreate", "onCreate:MainActivity")
    }

    override fun onPause() {
        super.onPause()
        mBLEServiceOperate?.stopLeScan()
    }

    override fun onDestroy() { // unBindService
        super.onDestroy()
        mBLEServiceOperate!!.unBindService() // unBindService
    }

    private val mOnStepChangeListener: StepChangeListener = StepChangeListener { info: StepOneDayAllInfo ->
        val map = emptyMap<String, Any>().toMutableMap()
        map[EVENT_CHANNEL_SINK_TYPE_KEY] = STEP_CHANGE_CALLBACK

        map["calendar"] = info.calendar
        map["step"] = info.step
        map["distance"] = info.distance
        map["calories"] = info.calories
        map["run_steps"] = info.runSteps
        map["run_calories"] = info.runCalories
        map["run_distance"] = info.runDistance
        map["run_duration_time"] = info.runDurationTime
        map["walk_steps"] = info.walkSteps
        map["walk_calories"] = info.walkCalories
        map["walk_distance"] = info.walkDistance
        map["walk_duration_time"] = info.walkDurationTime

        eventSink?.success(map)
    }

    private val mOnSleepChangeListener: SleepChangeListener = SleepChangeListener {
        //update Sleep UI
    }
    private val mOnRateListener: RateChangeListener = RateChangeListener { rate: Int, status: Int ->
        val map = emptyMap<String, Any>().toMutableMap()
        map[EVENT_CHANNEL_SINK_TYPE_KEY] = RATE_CALLBACK

        map["temp_rate"] = rate
        map["temp_status"] = status

        eventSink?.success(map)
    }
    private val mOnRateOf24HourListener: RateOf24HourRealTimeListener = RateOf24HourRealTimeListener { maxHeartRateValue: Int, minHeartRateValue: Int, averageHeartRateValue: Int, isRealTimeValue: Boolean ->
        val map = emptyMap<String, Any>().toMutableMap()
        map[EVENT_CHANNEL_SINK_TYPE_KEY] = RATE24_CALLBACK

        map["max_heart_rate_value"] = maxHeartRateValue
        map["min_heart_rate_value"] = minHeartRateValue
        map["average_heart_rate_value"] = averageHeartRateValue
        map["is_real_time_value"] = isRealTimeValue

        eventSink?.success(map)

    }
    private val mOnBloodPressureListener: BloodPressureChangeListener = BloodPressureChangeListener { highPressure: Int, lowPressure: Int, status: Int ->
        val map = emptyMap<String, Any>().toMutableMap()
        map[EVENT_CHANNEL_SINK_TYPE_KEY] = BLOOD_PRESSURE_CALLBACK

        map["temp_blood_pressure_status"] = status
        map["high_pressure"] = highPressure
        map["low_pressure"] = lowPressure

        eventSink?.success(map)
    }
    override fun LeScanCallback(device: BluetoothDevice?, rssi: Int, scanRecord: ByteArray?) {
        runOnUiThread(Runnable {
            Log.w(TAG, "Scanning result: LeScanCallback ${eventSink != null}")
            if (device != null) {
                if (TextUtils.isEmpty(device.name)) {
                    return@Runnable
                }
                val map = emptyMap<String, Any>().toMutableMap()
                map[EVENT_CHANNEL_SINK_TYPE_KEY] = LE_SCAN_CALLBACK

                map["device_name"] = device.name
                map["device_address"] = device.address
                map["device_rssi"] = rssi

                eventSink!!.success(map)
            }
        })
    }

    override fun OnResult(result: Boolean, status: Int) {
        TODO("OnResult: Not yet implemented")
    }

    override fun OnDataResult(result: Boolean, status: Int, data: ByteArray?) {
        var stringBuilder: StringBuilder? = null
        if (data != null && data.isNotEmpty()) {
            stringBuilder = StringBuilder(data.size)
            for (byteChar: Byte in data) {
                stringBuilder.append(String.format("%02X", byteChar))
            }
            Log.i(TAG, "BLE---->APK data =$stringBuilder")
//            when (status) {
//                ICallbackStatus.OPEN_CHANNEL_OK -> mHandler.sendEmptyMessage(OPEN_CHANNEL_OK_MSG)
//                ICallbackStatus.CLOSE_CHANNEL_OK -> mHandler.sendEmptyMessage(CLOSE_CHANNEL_OK_MSG)
//                ICallbackStatus.BLE_DATA_BACK_OK -> mHandler.sendEmptyMessage(TEST_CHANNEL_OK_MSG)
//                ICallbackStatus.UNIVERSAL_INTERFACE_SDK_TO_BLE_SUCCESS -> mHandler.sendEmptyMessage(UNIVERSAL_INTERFACE_SDK_TO_BLE_SUCCESS_MSG)
//                ICallbackStatus.UNIVERSAL_INTERFACE_SDK_TO_BLE_FAIL -> mHandler.sendEmptyMessage(UNIVERSAL_INTERFACE_SDK_TO_BLE_FAIL_MSG)
//                ICallbackStatus.UNIVERSAL_INTERFACE_BLE_TO_SDK_SUCCESS -> mHandler.sendEmptyMessage(UNIVERSAL_INTERFACE_BLE_TO_SDK_SUCCESS_MSG)
//                ICallbackStatus.UNIVERSAL_INTERFACE_BLE_TO_SDK_FAIL -> mHandler.sendEmptyMessage(UNIVERSAL_INTERFACE_BLE_TO_SDK_SUCCESS_MSG)
//                ICallbackStatus.CUSTOMER_ID_OK -> if (result) {
////                    Log.d(TAG, "客户ID = " + GBUtils.getInstance(mContext).customerIDAsciiByteToString(data))
//                }
//            }
        }
    }

    override fun onSportsTimeCallback(result: Boolean, calendar: String?, sportsTime: Int, timeType: Int) {
        TODO("onSportsTimeCallback: Not yet implemented")
    }

    private var sportTimes = 0
    override fun OnResultSportsModes(result: Boolean, status: Int, switchStatus: Boolean, sportsModes: Int, info: SportsModesInfo?) {
        when (status) {
            ICallbackStatus.CONTROL_MULTIPLE_SPORTS_MODES -> {
            }
            ICallbackStatus.INQUIRE_MULTIPLE_SPORTS_MODES -> {
            }
            ICallbackStatus.SYNC_MULTIPLE_SPORTS_MODES_START ->
                sportTimes = sportsModes
            ICallbackStatus.SYNC_MULTIPLE_SPORTS_MODES -> {
                sportTimes--
//                if (sportTimes == 0) {
//                    Toast.makeText(mContext, "sportTimes==0，说明同步完成", Toast.LENGTH_SHORT).show()
//                }
            }
            ICallbackStatus.MULTIPLE_SPORTS_MODES_REAL -> {
            }
        }
    }

    override fun OnResultHeartRateHeadset(result: Boolean, status: Int, sportStatus: Int, values: Int, info: HeartRateHeadsetSportModeInfo?) {
        when (status) {
            ICallbackStatus.HEART_RATE_HEADSET_SPORT_STATUS -> {
            }
            ICallbackStatus.HEART_RATE_HEADSET_RATE_INTERVAL -> {
            }
            ICallbackStatus.HEART_RATE_HEADSET_SPORT_DATA -> if (info != null) {
                val sportMode = info.hrhSportsModes
                val rateValue = info.hrhRateValue
                val calories = info.hrhCalories
                val pace = info.hrhPace
                val stepCount = info.hrhSteps
                val count = info.hrhCount
                val distance = info.hrhDistance
                val durationTime = info.hrhDuration
                //					HeartRateHeadsetUtils.LLogI("心率耳机 上报上来的实时数据 回调 sportMode="+sportMode+",rateValue="+rateValue+",calories="+calories
//							+",pace="+pace+",stepCount="+stepCount+",count="+count+",distance="+distance+",durationTime="+durationTime);
            }
        }
    }

    override fun OnServiceStatuslt(status: Int) {
        if (status == ICallbackStatus.BLE_SERVICE_START_OK) {
            if (mBluetoothLeService == null) {
                mBluetoothLeService = mBLEServiceOperate!!.bleService
                mBluetoothLeService!!.setICallback(this)
            }
        }
    }

    override fun OnServerCallback(status: Int, description: String?) {
        TODO("OnServerCallback: Not yet implemented")
    }

    override fun onRateCalibrationStatus(status: Int) {
/*		status: 0----校准完成
		        1----校准开始
		        253---清除校准参数完成
		        校准开始后，应用端自己做超时，10秒钟没收到校准完成0，则需主动调用停止校准stopRateCalibration()*/
        Log.d(TAG, "心率校准 status:$status")
    }

    override fun onTurnWristCalibrationStatus(status: Int) {

        // TODO Auto-generated method stub
        Log.d(TAG, "翻腕校准 status:$status")
        /*status: 0----校准完成
                  1----校准开始
                  255----校准失败
                  253---清除校准参数完成*/
    }

    override fun onTestResult(info: TemperatureInfo?) {
        //单次测试结果
        Log.d(TAG, "calendar =" + info!!.calendar + ",startDate =" + info.startDate + ",secondTime =" + info.secondTime
                + ",bodyTemperature =" + info.bodyTemperature)
    }

    override fun onSamplingResult(info: TemperatureInfo?) {

//        info.getType();以下三种类型
//        TemperatureUtil.TYPE_NOT_SUPPORT_SAMPLING ;//不支持体温原始数据采样
//        TemperatureUtil.TYPE_SUPPORT_SAMPLING_MODE_1;//支持体温原始数据采样,格式一
//        TemperatureUtil.TYPE_SUPPORT_SAMPLING_MODE_2;//支持体温原始数据采样,格式二
        Log.d(TAG, "type =" + info!!.type + ",calendar =" + info.calendar + ",startDate =" + info.startDate + ",secondTime =" + info.secondTime
                + ",bodyTemperature =" + info.bodyTemperature + ",bodySurfaceTemperature =" + info.bodySurfaceTemperature
                + ",ambientTemperature =" + info.ambientTemperature)
    }

    override fun onCharacteristicWriteCallback(status: Int) {
        // 写入操作的系统回调，status = 0为写入成功，其他或无回调表示失败
        // add 20170221
        // 写入操作的系统回调，status = 0为写入成功，其他或无回调表示失败
        Log.d(TAG, "Write System callback status = $status")
    }

    override fun onIbeaconWriteCallback(result: Boolean, ibeaconSetOrGet: Int, ibeaconType: Int, data: String?) {
        // public static final int IBEACON_TYPE_UUID = 0;// Ibeacon
        // 指令类型,设置UUID/获取UUID
        // public static final int IBEACON_TYPE_MAJOR = 1;// Ibeacon
        // 指令类型,设置major/获取major
        // public static final int IBEACON_TYPE_MINOR = 2;// Ibeacon
        // 指令类型,设置minor/获取minor
        // public static final int IBEACON_TYPE_DEVICE_NAME = 3;// Ibeacon
        // 指令类型,设置蓝牙device name/获取蓝牙device name
        // public static final int IBEACON_SET = 0;// Ibeacon
        // 设置(设置UUID/设置major,设置minor,设置蓝牙device name)
        // public static final int IBEACON_GET = 1;// Ibeacon
        // 获取(设置UUID/设置major,设置minor,设置蓝牙device name)

        // public static final int IBEACON_TYPE_UUID = 0;// Ibeacon
        // 指令类型,设置UUID/获取UUID
        // public static final int IBEACON_TYPE_MAJOR = 1;// Ibeacon
        // 指令类型,设置major/获取major
        // public static final int IBEACON_TYPE_MINOR = 2;// Ibeacon
        // 指令类型,设置minor/获取minor
        // public static final int IBEACON_TYPE_DEVICE_NAME = 3;// Ibeacon
        // 指令类型,设置蓝牙device name/获取蓝牙device name
        // public static final int IBEACON_SET = 0;// Ibeacon
        // 设置(设置UUID/设置major,设置minor,设置蓝牙device name)
        // public static final int IBEACON_GET = 1;// Ibeacon
        // 获取(设置UUID/设置major,设置minor,设置蓝牙device name)
        Log.d(TAG, "onIbeaconWriteCallback 设置或获取结果result =" + result
                + ",ibeaconSetOrGet =" + ibeaconSetOrGet + ",ibeaconType ="
                + ibeaconType + ",数据data =" + data)
        if (result) { // success
            when (ibeaconSetOrGet) {
                GlobalVariable.IBEACON_SET -> when (ibeaconType) {
                    GlobalVariable.IBEACON_TYPE_UUID -> Log.d(TAG, "设置UUID成功,data =$data")
                    GlobalVariable.IBEACON_TYPE_MAJOR -> Log.d(TAG, "设置major成功,data =$data")
                    GlobalVariable.IBEACON_TYPE_MINOR -> Log.d(TAG, "设置minor成功,data =$data")
                    GlobalVariable.IBEACON_TYPE_DEVICE_NAME -> Log.d(TAG, "设置device name成功,data =$data")
                    GlobalVariable.IBEACON_TYPE_TX_POWER -> Log.d(TAG, "设置TX power成功,data =$data")
                    GlobalVariable.IBEACON_TYPE_ADVERTISING_INTERVAL -> Log.d(TAG, "设置advertising interval成功,data =$data")
                    else -> {
                    }
                }
                GlobalVariable.IBEACON_GET -> when (ibeaconType) {
                    GlobalVariable.IBEACON_TYPE_UUID -> Log.d(TAG, "获取UUID成功,data =$data")
                    GlobalVariable.IBEACON_TYPE_MAJOR -> Log.d(TAG, "获取major成功,data =$data")
                    GlobalVariable.IBEACON_TYPE_MINOR -> Log.d(TAG, "获取minor成功,data =$data")
                    GlobalVariable.IBEACON_TYPE_DEVICE_NAME -> Log.d(TAG, "获取device name成功,data =$data")
                    GlobalVariable.IBEACON_TYPE_TX_POWER -> Log.d(TAG, "获取TX power成功,data =$data")
                    GlobalVariable.IBEACON_TYPE_ADVERTISING_INTERVAL -> Log.d(TAG, "获取advertising interval,data =$data")
                    else -> {
                    }
                }
                else -> {
                }
            }
        } else { // fail
            when (ibeaconSetOrGet) {
                GlobalVariable.IBEACON_SET -> when (ibeaconType) {
                    GlobalVariable.IBEACON_TYPE_UUID -> Log.d(TAG, "设置UUID失败")
                    GlobalVariable.IBEACON_TYPE_MAJOR -> Log.d(TAG, "设置major失败")
                    GlobalVariable.IBEACON_TYPE_MINOR -> Log.d(TAG, "设置minor失败")
                    GlobalVariable.IBEACON_TYPE_DEVICE_NAME -> Log.d(TAG, "设置device name失败")
                    else -> {
                    }
                }
                GlobalVariable.IBEACON_GET -> when (ibeaconType) {
                    GlobalVariable.IBEACON_TYPE_UUID -> Log.d(TAG, "获取UUID失败")
                    GlobalVariable.IBEACON_TYPE_MAJOR -> Log.d(TAG, "获取major失败")
                    GlobalVariable.IBEACON_TYPE_MINOR -> Log.d(TAG, "获取minor失败")
                    GlobalVariable.IBEACON_TYPE_DEVICE_NAME -> Log.d(TAG, "获取device name失败")
                    else -> {
                    }
                }
                else -> {
                }
            }
        }
    }

    override fun onQueryDialModeCallback(result: Boolean, screenWith: Int, screenHeight: Int, screenCount: Int) {
        // 查询表盘方式回调
        Log.d(TAG, "result =" + result + ",screenWith =" + screenWith
                + ",screenHeight =" + screenHeight + ",screenCount ="
                + screenCount)
    }

    override fun onControlDialCallback(result: Boolean, leftRightHand: Int, dialType: Int) {
        when (leftRightHand) {
            GlobalVariable.LEFT_HAND_WEAR -> Log.d(TAG, "设置左手佩戴成功")
            GlobalVariable.RIGHT_HAND_WEAR -> Log.d(TAG, "设置右手佩戴成功")
            GlobalVariable.NOT_SET_UP -> Log.d(TAG, "不设置，保持上次佩戴方式成功")
            else -> {
            }
        }
        when (dialType) {
            GlobalVariable.SHOW_VERTICAL_ENGLISH_SCREEN -> Log.d(TAG, "设置显示竖屏英文界面成功")
            GlobalVariable.SHOW_VERTICAL_CHINESE_SCREEN -> Log.d(TAG, "设置显示竖屏中文界面成功")
            GlobalVariable.SHOW_HORIZONTAL_SCREEN -> Log.d(TAG, "设置显示横屏成功")
            GlobalVariable.NOT_SET_UP -> Log.d(TAG, "不设置，默认上次显示的屏幕成功")
            else -> {
            }
        }
    }


//    override fun registerWith(registry: PluginRegistry?) {
//        if (!registry!!.hasPlugin("io.flutter.plugins.firebasemessaging")) {
//            FirebaseMessagingPlugin.registerWith(registry!!.registrarFor("io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin"));
//        }
//    }
}
