#include <dtp_av.h>

#include <gl_render.h>
#include <dttv_jni_dtp.h>
#include "gl_ops.h"

struct gl_ctx {
    int width;
    int height;
    int pixfmt;
    int filter;
    long arg;

    gl_ops_t *ops;
    lock_t mutex;
    void *handle;
};

static gl_ctx ctx;

extern gl_ops_t gl_ops_yuv;
extern gl_ops_t gl_ops_rgb;

using namespace android;

#define TAG "GL-RENDER"

int gl_create(void *h)
{
    ctx = {0};
    ctx.handle = h;
    lock_init(&ctx.mutex, NULL);
    return 0;
}

int gl_setup(int w, int h)
{
    ctx.width = w;
    ctx.height = h;
    if(ctx.ops == 0) {
        ctx.ops = &gl_ops_rgb;
        ctx.pixfmt = DTAV_PIX_FMT_RGBA;
    }
    ctx.ops->init();
    ctx.ops->setup(w, h);
    return 0;
}

int gl_set_parameter(long type, long arg)
{
    ctx.filter = (int)type;
    switch (ctx.filter) {
        case GL_FILTER_TYPE_YUV:
            ctx.pixfmt = DTAV_PIX_FMT_YUV420P;
            ctx.ops = &gl_ops_yuv;
            break;
        case GL_FILTER_TYPE_RGB:
            ctx.ops = &gl_ops_rgb;
            ctx.pixfmt = DTAV_PIX_FMT_RGBA;
            break;
    }
    return 0;
}

int gl_notify()
{
    if(ctx.handle == 0) {
        return 0;
    }
    static android::DTPlayer * player = (android::DTPlayer *) ctx.handle;
    player->Notify(MEDIA_FRESH_VIDEO);
    return 0;
}

int gl_update_frame(dt_av_frame_t *frame)
{
    if(ctx.handle == 0) {
        LOGV("update gl frame failed. handle == 0\n");
        return 0;
    }
    LOGV("update gl frame pix:%d \n", ctx.pixfmt);
    ctx.ops->update(frame);
    return 0;
}

int gl_render()
{
    LOGV("Enter render frame \n");
    ctx.ops->render();
    LOGV("Exit render frame \n");
    return 0;
}