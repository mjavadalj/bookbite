#ifndef WHISPER_EDGE_H
#define WHISPER_EDGE_H

#include <stdint.h>

#if _WIN32
#define FFI_PLUGIN_EXPORT __declspec(dllexport)
#else
#define FFI_PLUGIN_EXPORT __attribute__((visibility("default"))) __attribute__((used))
#endif

#ifdef __cplusplus
extern "C" {
#endif

// Opaque handle wrapping a whisper_context plus per-run state
// (progress, abort flag). One handle == one loaded model.
typedef struct we_context we_context;

// Loads a ggml whisper model from disk. Returns NULL on failure.
// use_gpu: 1 to allow Metal/GPU offload where available, 0 for CPU only.
FFI_PLUGIN_EXPORT we_context *we_init(const char *model_path, int use_gpu);

// Frees the model and all associated state.
FFI_PLUGIN_EXPORT void we_free(we_context *ctx);

// Flags for we_transcribe.
#define WE_FLAG_NO_CONTEXT 1   // don't condition on previous output (streaming)
#define WE_FLAG_SUPPRESS_NST 2 // suppress non-speech tokens like "(music)"

// Runs full transcription over 16 kHz mono float32 PCM samples.
// language: ISO 639-1 code ("en", "tr", ...), "auto" or NULL for detection.
// translate: 1 to translate to English, 0 to transcribe verbatim.
// n_threads: 0 picks a sensible default for the device.
// flags: bitwise OR of WE_FLAG_* values.
// Returns 0 on success, non-zero whisper error code otherwise.
// Blocking — call from a worker isolate/thread.
FFI_PLUGIN_EXPORT int we_transcribe(we_context *ctx, const float *pcm,
                                    int n_samples, const char *language,
                                    int translate, int n_threads, int flags);

// Results of the last we_transcribe call on this handle.
FFI_PLUGIN_EXPORT int we_n_segments(we_context *ctx);
FFI_PLUGIN_EXPORT const char *we_segment_text(we_context *ctx, int i);
// Segment timestamps in centiseconds (10 ms units), as reported by whisper.
FFI_PLUGIN_EXPORT int64_t we_segment_t0(we_context *ctx, int i);
FFI_PLUGIN_EXPORT int64_t we_segment_t1(we_context *ctx, int i);
// ISO 639-1 code of the language detected/used by the last run.
FFI_PLUGIN_EXPORT const char *we_detected_language(we_context *ctx);

// Progress of the currently running we_transcribe on this handle, 0-100.
// Safe to poll from another thread/isolate while we_transcribe blocks.
FFI_PLUGIN_EXPORT int we_progress(we_context *ctx);

// Requests cancellation of the in-flight we_transcribe on this handle.
// Safe to call from another thread/isolate.
FFI_PLUGIN_EXPORT void we_abort(we_context *ctx);

// whisper/ggml build info string (backends, SIMD features).
FFI_PLUGIN_EXPORT const char *we_system_info(void);

#ifdef __cplusplus
}
#endif

#endif // WHISPER_EDGE_H
