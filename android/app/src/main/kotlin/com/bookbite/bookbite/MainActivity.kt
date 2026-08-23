package com.bookbite.bookbite

import android.graphics.BitmapFactory
import android.graphics.Matrix
import androidx.exifinterface.media.ExifInterface
import com.googlecode.tesseract.android.TessBaseAPI
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileOutputStream

private const val OCR_CHANNEL = "bookbite/ocr"

private data class OcrCandidate(
    val text: String,
    val score: Double,
)

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, OCR_CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method != "extractText") {
                    result.notImplemented()
                    return@setMethodCallHandler
                }
                val imagePath = call.argument<String>("imagePath")
                val language = call.argument<String>("language") ?: "fas"
                if (imagePath.isNullOrBlank()) {
                    result.error("invalid_source", "OCR image path is empty.", null)
                    return@setMethodCallHandler
                }
                Thread {
                    try {
                        val text = extractText(imagePath, language)
                        runOnUiThread { result.success(text) }
                    } catch (error: Exception) {
                        runOnUiThread {
                            result.error("ocr_failed", "Local OCR failed.", null)
                        }
                    }
                }.start()
            }
    }

    private fun extractText(imagePath: String, language: String): String {
        val image = decodeUprightBitmap(imagePath)
        val tessData = File(filesDir, "tessdata")
        if (!tessData.exists()) tessData.mkdirs()
        language.split("+").forEach { code ->
            copyAssetIfMissing("assets/tessdata/$code.traineddata", File(tessData, "$code.traineddata"))
        }

        val api = TessBaseAPI()
        try {
            check(api.init(filesDir.absolutePath, language, TessBaseAPI.OEM_LSTM_ONLY)) {
                "Tesseract data could not be initialized."
            }
            api.setPageSegMode(TessBaseAPI.PageSegMode.PSM_AUTO)
            api.setVariable("preserve_interword_spaces", "1")
            return recognizeBestOrientation(api, image)
        } finally {
            api.clear()
            api.recycle()
            image.recycle()
        }
    }

    private fun recognizeBestOrientation(
        api: TessBaseAPI,
        uprightFromExif: android.graphics.Bitmap,
    ): String {
        var best = OcrCandidate(text = "", score = Double.NEGATIVE_INFINITY)
        for (degrees in listOf(0f, 90f, 180f, 270f)) {
            val candidateBitmap = if (degrees == 0f) {
                uprightFromExif
            } else {
                rotateBitmap(uprightFromExif, degrees)
            }
            try {
                api.setImage(candidateBitmap)
                val text = api.getUTF8Text()?.trim().orEmpty()
                val confidence = api.meanConfidence().coerceAtLeast(0)
                val persianCharacters = text.count { character ->
                    character in '\u0600'..'\u06ff'
                }
                // Confidence alone can favor a wrongly oriented image containing
                // only a few confidently recognized marks. Reward substantial
                // Persian text so a readable page wins over short gibberish.
                val coverageBonus = (persianCharacters / 10.0).coerceAtMost(40.0)
                val candidate = OcrCandidate(text, confidence + coverageBonus)
                if (candidate.score > best.score) best = candidate
            } finally {
                api.clear()
                if (candidateBitmap !== uprightFromExif) candidateBitmap.recycle()
            }
        }
        return best.text
    }

    private fun rotateBitmap(
        source: android.graphics.Bitmap,
        degrees: Float,
    ): android.graphics.Bitmap = android.graphics.Bitmap.createBitmap(
        source,
        0,
        0,
        source.width,
        source.height,
        Matrix().apply { setRotate(degrees) },
        true,
    )

    private fun decodeUprightBitmap(imagePath: String): android.graphics.Bitmap {
        val source = BitmapFactory.decodeFile(imagePath)
            ?: error("Image could not be decoded.")
        val orientation = ExifInterface(imagePath).getAttributeInt(
            ExifInterface.TAG_ORIENTATION,
            ExifInterface.ORIENTATION_NORMAL,
        )
        if (orientation == ExifInterface.ORIENTATION_NORMAL ||
            orientation == ExifInterface.ORIENTATION_UNDEFINED
        ) {
            return source
        }

        val matrix = Matrix().apply {
            when (orientation) {
                ExifInterface.ORIENTATION_FLIP_HORIZONTAL -> setScale(-1f, 1f)
                ExifInterface.ORIENTATION_ROTATE_180 -> setRotate(180f)
                ExifInterface.ORIENTATION_FLIP_VERTICAL -> setScale(1f, -1f)
                ExifInterface.ORIENTATION_TRANSPOSE -> {
                    setRotate(90f)
                    postScale(-1f, 1f)
                }
                ExifInterface.ORIENTATION_ROTATE_90 -> setRotate(90f)
                ExifInterface.ORIENTATION_TRANSVERSE -> {
                    setRotate(-90f)
                    postScale(-1f, 1f)
                }
                ExifInterface.ORIENTATION_ROTATE_270 -> setRotate(-90f)
            }
        }
        val upright = android.graphics.Bitmap.createBitmap(
            source,
            0,
            0,
            source.width,
            source.height,
            matrix,
            true,
        )
        if (upright !== source) source.recycle()
        return upright
    }

    private fun copyAssetIfMissing(assetPath: String, destination: File) {
        if (destination.exists()) return
        assets.open("flutter_assets/$assetPath").use { input ->
            FileOutputStream(destination).use { output -> input.copyTo(output) }
        }
    }
}
