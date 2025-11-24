package `fun`.onepali.app

import android.app.Activity
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.provider.DocumentsContract
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.OutputStream

class MainActivity : FlutterActivity() {
    private val CHANNEL = "fun.onepali.app/storage"
    private val REQUEST_CODE_PICK_FOLDER = 1001
    private var folderPickerResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "pickFolder" -> {
                    android.util.Log.d("MainActivity", "pickFolder called")
                    folderPickerResult = result
                    try {
                        pickFolder()
                        android.util.Log.d("MainActivity", "Folder picker activity started")
                        // Don't call result.success() here - wait for onActivityResult
                    } catch (e: Exception) {
                        android.util.Log.e("MainActivity", "Error starting folder picker", e)
                        result.error("FOLDER_PICKER_ERROR", "Failed to start folder picker: ${e.message}", null)
                        folderPickerResult = null
                    }
                }
                "verifyFolderUri" -> {
                    val uriString = call.argument<String>("uri")
                    if (uriString != null) {
                        val isValid = verifyFolderUri(uriString)
                        result.success(isValid)
                    } else {
                        result.success(false)
                    }
                }
                "saveFile" -> {
                    val folderUri = call.argument<String>("folderUri")
                    val filename = call.argument<String>("filename")
                    val fileBytes = call.argument<ByteArray>("fileBytes")
                    if (folderUri != null && filename != null && fileBytes != null) {
                        val success = saveFileToFolder(folderUri, filename, fileBytes)
                        result.success(success)
                    } else {
                        result.success(false)
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun pickFolder() {
        try {
            val intent = Intent(Intent.ACTION_OPEN_DOCUMENT_TREE).apply {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    putExtra(DocumentsContract.EXTRA_INITIAL_URI, Uri.parse("content://com.android.externalstorage.documents/document/primary%3ADocuments"))
                }
                addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
                addFlags(Intent.FLAG_GRANT_WRITE_URI_PERMISSION)
                addFlags(Intent.FLAG_GRANT_PERSISTABLE_URI_PERMISSION)
            }
            
            // Check if there's an activity that can handle this intent
            if (intent.resolveActivity(packageManager) != null) {
                android.util.Log.d("MainActivity", "Starting folder picker activity")
                startActivityForResult(intent, REQUEST_CODE_PICK_FOLDER)
            } else {
                android.util.Log.e("MainActivity", "No activity found to handle folder picker intent")
                folderPickerResult?.error("NO_ACTIVITY", "No file manager found to select folder", null)
                folderPickerResult = null
            }
        } catch (e: Exception) {
            android.util.Log.e("MainActivity", "Error starting folder picker", e)
            folderPickerResult?.error("FOLDER_PICKER_ERROR", "Failed to start folder picker: ${e.message}", null)
            folderPickerResult = null
        }
    }

    private fun verifyFolderUri(uriString: String): Boolean {
        return try {
            val uri = Uri.parse(uriString)
            contentResolver.persistedUriPermissions.any { it.uri == uri }
        } catch (e: Exception) {
            false
        }
    }

    private fun saveFileToFolder(folderUriString: String, filename: String, fileBytes: ByteArray): Boolean {
        return try {
            android.util.Log.d("MainActivity", "saveFileToFolder: folderUri=$folderUriString, filename=$filename, size=${fileBytes.size}")
            val folderUri = Uri.parse(folderUriString)
            
            // Verify this is a tree URI
            if (!DocumentsContract.isTreeUri(folderUri)) {
                android.util.Log.e("MainActivity", "URI is not a tree URI: $folderUriString")
                return false
            }
            
            val treeDocumentId = DocumentsContract.getTreeDocumentId(folderUri)
            android.util.Log.d("MainActivity", "Tree document ID: $treeDocumentId")
            
            // Build the document URI for the folder (parent)
            val folderDocumentUri = DocumentsContract.buildDocumentUriUsingTree(
                folderUri,
                treeDocumentId
            )
            android.util.Log.d("MainActivity", "Folder document URI: $folderDocumentUri")
            
            // Create the file in the selected folder
            // Note: createDocument needs the parent document URI, not the tree URI
            val newFileUri = try {
                DocumentsContract.createDocument(
                    contentResolver,
                    folderDocumentUri,
                    "application/pdf",
                    filename
                )
            } catch (e: Exception) {
                android.util.Log.e("MainActivity", "Exception in createDocument: ${e.message}")
                null
            }
            
            if (newFileUri == null) {
                android.util.Log.e("MainActivity", "Failed to create document - createDocument returned null")
                return false
            }
            
            android.util.Log.d("MainActivity", "Created file URI: $newFileUri")

            // Write the file
            contentResolver.openOutputStream(newFileUri, "w")?.use { outputStream: OutputStream ->
                outputStream.write(fileBytes)
                outputStream.flush()
                android.util.Log.d("MainActivity", "File written successfully: $filename")
                true
            } ?: run {
                android.util.Log.e("MainActivity", "Failed to open output stream for: $newFileUri")
                false
            }
        } catch (e: Exception) {
            android.util.Log.e("MainActivity", "Error saving file", e)
            e.printStackTrace()
            false
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        
        if (requestCode == REQUEST_CODE_PICK_FOLDER) {
            android.util.Log.d("MainActivity", "onActivityResult: resultCode=$resultCode")
            if (resultCode == Activity.RESULT_OK && data != null) {
                val treeUri = data.data
                android.util.Log.d("MainActivity", "Folder selected: $treeUri")
                if (treeUri != null) {
                    try {
                        // Take persistent URI permission
                        contentResolver.takePersistableUriPermission(
                            treeUri,
                            Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_GRANT_WRITE_URI_PERMISSION
                        )
                        android.util.Log.d("MainActivity", "Persistent permission granted for: $treeUri")
                        folderPickerResult?.success(treeUri.toString())
                    } catch (e: Exception) {
                        android.util.Log.e("MainActivity", "Error taking persistent permission", e)
                        folderPickerResult?.error("PERMISSION_ERROR", "Failed to get folder permission: ${e.message}", null)
                    }
                } else {
                    android.util.Log.w("MainActivity", "Tree URI is null")
                    folderPickerResult?.success(null)
                }
            } else {
                android.util.Log.d("MainActivity", "Folder picker cancelled or failed")
                folderPickerResult?.success(null)
            }
            folderPickerResult = null
        }
    }
}