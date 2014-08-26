LOCAL_PATH := $(call my-dir)

##############################################
include $(CLEAR_VARS)
LOCAL_MODULE := dtp_prebuilt
LOCAL_SRC_FILES := $(LOCAL_PATH)/libs/libdtp.so
include $(PREBUILT_SHARED_LIBRARY)

##############################################
include $(CLEAR_VARS)
LOCAL_MODULE    := dtp_jni
LOCAL_SRC_FILES := dtp_native_api.cpp render_android.c ao_android.cpp vo_android.c ao_opensl.c
LOCAL_SRC_FILES += android_dtplayer.cpp

LOCAL_CFLAGS += -D GL_GLEXT_PROTOTYPES

#ao control
AO_OPENSL = yes
AO_AUDIOTRACK = no
ifeq ($(AO_OPENSL),yes)
	LOCAL_CFLAGS += -D ENABLE_OPENSL
endif
ifeq ($(AO_AUDIOTRACK),yes)
	LOCAL_CFLAGS += -D ENABLE_AUDIOTRACK
endif

LOCAL_C_INCLUDES := $(LOCAL_PATH)/include
LOCAL_LDLIBS    := -llog -lz

#android env
LOCAL_C_INCLUDES += $(AOSP_TREE)/libnativehelper/include/     #runtime
LOCAL_C_INCLUDES += $(AOSP_TREE)/frameworks/base/include/     #runtime
LOCAL_C_INCLUDES += $(AOSP_TREE)/frameworks/av/include/       #media
LOCAL_C_INCLUDES += $(AOSP_TREE)/system/core/include          #cutils
LOCAL_C_INCLUDES += $(AOSP_TREE)/hardware/libhardware/include #hardware
LOCAL_C_INCLUDES += $(AOSP_TREE)/frameworks/native/include    #utils
LOCAL_C_INCLUDES += $(AOSP_TREE)/frameworks/native/include/media/openmax    #openmax

LOCAL_LDLIBS     += -L$(AOSP_OUT)/system/lib -landroid_runtime -lmedia  -lutils -lGLESv1_CM -lOpenSLES -lstagefright -lbinder -lstdc++
LOCAL_LDLIBS     += -L$(LOCAL_PATH)/libs -ldtp

include $(BUILD_SHARED_LIBRARY)
