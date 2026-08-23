#include "whisper_edge.h"

#include <stdatomic.h>
#include <stdlib.h>
#include <string.h>

#include "whisper.h"

struct we_context {
    struct whisper_context *wctx;
    atomic_int progress;
    atomic_bool abort_requested;
    char language[16];
};

FFI_PLUGIN_EXPORT we_context *we_init(const char *model_path, int use_gpu) {
    struct whisper_context_params cparams = whisper_context_default_params();
    cparams.use_gpu = use_gpu != 0;

    struct whisper_context *wctx =
        whisper_init_from_file_with_params(model_path, cparams);
    if (wctx == NULL) {
        return NULL;
    }

    we_context *ctx = calloc(1, sizeof(we_context));
    if (ctx == NULL) {
        whisper_free(wctx);
        return NULL;
    }
    ctx->wctx = wctx;
    atomic_init(&ctx->progress, 0);
    atomic_init(&ctx->abort_requested, false);
    return ctx;
}

FFI_PLUGIN_EXPORT void we_free(we_context *ctx) {
    if (ctx == NULL) {
        return;
    }
    whisper_free(ctx->wctx);
    free(ctx);
}

static void we_on_progress(struct whisper_context *wctx,
                           struct whisper_state *state, int progress,
                           void *user_data) {
    (void) wctx;
    (void) state;
    we_context *ctx = user_data;
    atomic_store(&ctx->progress, progress);
}

static bool we_should_abort(void *user_data) {
    we_context *ctx = user_data;
    return atomic_load(&ctx->abort_requested);
}

FFI_PLUGIN_EXPORT int we_transcribe(we_context *ctx, const float *pcm,
                                    int n_samples, const char *language,
                                    int translate, int n_threads, int flags) {
    if (ctx == NULL || pcm == NULL || n_samples <= 0) {
        return -1;
    }

    atomic_store(&ctx->progress, 0);
    atomic_store(&ctx->abort_requested, false);

    // whisper keeps the language pointer until whisper_full returns; copy the
    // caller's string into memory owned by this handle.
    if (language == NULL || language[0] == '\0') {
        strcpy(ctx->language, "auto");
    } else {
        strncpy(ctx->language, language, sizeof(ctx->language) - 1);
        ctx->language[sizeof(ctx->language) - 1] = '\0';
    }

    struct whisper_full_params params =
        whisper_full_default_params(WHISPER_SAMPLING_GREEDY);

    params.language         = ctx->language;
    params.translate        = translate != 0;
    params.no_context       = (flags & WE_FLAG_NO_CONTEXT) != 0;
    params.suppress_nst     = (flags & WE_FLAG_SUPPRESS_NST) != 0;
    params.print_realtime   = false;
    params.print_progress   = false;
    params.print_timestamps = false;
    params.print_special    = false;

    // BookBite recordings are capped at five seconds. The upstream default
    // always encodes a padded 30-second context (1500 frames), which takes
    // several minutes on the minimum 32-bit Cortex-A53 device. Match the
    // encoder context to the real input at 50 frames per second, keeping the
    // documented five-second minimum used by Whisper's positional context.
    int audio_ctx = (n_samples + 319) / 320;
    if (audio_ctx < 250) {
        audio_ctx = 250;
    } else if (audio_ctx > 1500) {
        audio_ctx = 1500;
    }
    params.audio_ctx       = audio_ctx;
    params.duration_ms     = (n_samples * 1000) / WHISPER_SAMPLE_RATE;
    params.no_timestamps   = true;
    params.single_segment  = true;
    params.max_tokens      = 64;
    params.temperature_inc = 0.0f;

    if (n_threads > 0) {
        params.n_threads = n_threads;
    }

    params.progress_callback           = we_on_progress;
    params.progress_callback_user_data = ctx;
    params.abort_callback              = we_should_abort;
    params.abort_callback_user_data    = ctx;

    int ret = whisper_full(ctx->wctx, params, pcm, n_samples);
    if (ret == 0) {
        atomic_store(&ctx->progress, 100);
    }
    return ret;
}

FFI_PLUGIN_EXPORT int we_n_segments(we_context *ctx) {
    return whisper_full_n_segments(ctx->wctx);
}

FFI_PLUGIN_EXPORT const char *we_segment_text(we_context *ctx, int i) {
    return whisper_full_get_segment_text(ctx->wctx, i);
}

FFI_PLUGIN_EXPORT int64_t we_segment_t0(we_context *ctx, int i) {
    return whisper_full_get_segment_t0(ctx->wctx, i);
}

FFI_PLUGIN_EXPORT int64_t we_segment_t1(we_context *ctx, int i) {
    return whisper_full_get_segment_t1(ctx->wctx, i);
}

FFI_PLUGIN_EXPORT const char *we_detected_language(we_context *ctx) {
    return whisper_lang_str(whisper_full_lang_id(ctx->wctx));
}

FFI_PLUGIN_EXPORT int we_progress(we_context *ctx) {
    return atomic_load(&ctx->progress);
}

FFI_PLUGIN_EXPORT void we_abort(we_context *ctx) {
    atomic_store(&ctx->abort_requested, true);
}

FFI_PLUGIN_EXPORT const char *we_system_info(void) {
    return whisper_print_system_info();
}
