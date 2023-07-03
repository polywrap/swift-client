// This file was autogenerated by some hot garbage in the `uniffi` crate.
// Trust me, you don't want to mess with it!

#pragma once

#include <stdbool.h>
#include <stdint.h>

// The following structs are used to implement the lowest level
// of the FFI, and thus useful to multiple uniffied crates.
// We ensure they are declared exactly once, with a header guard, UNIFFI_SHARED_H.
#ifdef UNIFFI_SHARED_H
    // We also try to prevent mixing versions of shared uniffi header structs.
    // If you add anything to the #else block, you must increment the version suffix in UNIFFI_SHARED_HEADER_V4
    #ifndef UNIFFI_SHARED_HEADER_V4
        #error Combining helper code from multiple versions of uniffi is not supported
    #endif // ndef UNIFFI_SHARED_HEADER_V4
#else
#define UNIFFI_SHARED_H
#define UNIFFI_SHARED_HEADER_V4
// ⚠️ Attention: If you change this #else block (ending in `#endif // def UNIFFI_SHARED_H`) you *must* ⚠️
// ⚠️ increment the version suffix in all instances of UNIFFI_SHARED_HEADER_V4 in this file.           ⚠️

typedef struct RustBuffer
{
    int32_t capacity;
    int32_t len;
    uint8_t *_Nullable data;
} RustBuffer;

typedef int32_t (*ForeignCallback)(uint64_t, int32_t, RustBuffer, RustBuffer *_Nonnull);

typedef struct ForeignBytes
{
    int32_t len;
    const uint8_t *_Nullable data;
} ForeignBytes;

// Error definitions
typedef struct RustCallStatus {
    int8_t code;
    RustBuffer errorBuf;
} RustCallStatus;

// ⚠️ Attention: If you change this #else block (ending in `#endif // def UNIFFI_SHARED_H`) you *must* ⚠️
// ⚠️ increment the version suffix in all instances of UNIFFI_SHARED_HEADER_V4 in this file.           ⚠️
#endif // def UNIFFI_SHARED_H

void ffi_polywrap_native_3690_FFIUri_object_free(
      void*_Nonnull ptr,
    RustCallStatus *_Nonnull out_status
    );
void*_Nonnull polywrap_native_3690_FFIUri_new(
      RustBuffer authority,RustBuffer path,RustBuffer uri,
    RustCallStatus *_Nonnull out_status
    );
RustBuffer polywrap_native_3690_FFIUri_authority(
      void*_Nonnull ptr,
    RustCallStatus *_Nonnull out_status
    );
RustBuffer polywrap_native_3690_FFIUri_path(
      void*_Nonnull ptr,
    RustCallStatus *_Nonnull out_status
    );
RustBuffer polywrap_native_3690_FFIUri_to_string(
      void*_Nonnull ptr,
    RustCallStatus *_Nonnull out_status
    );
void ffi_polywrap_native_3690_FFIInvoker_object_free(
      void*_Nonnull ptr,
    RustCallStatus *_Nonnull out_status
    );
RustBuffer polywrap_native_3690_FFIInvoker_invoke_raw(
      void*_Nonnull ptr,void*_Nonnull uri,RustBuffer method,RustBuffer args,RustBuffer env,RustBuffer resolution_context,
    RustCallStatus *_Nonnull out_status
    );
RustBuffer polywrap_native_3690_FFIInvoker_get_implementations(
      void*_Nonnull ptr,void*_Nonnull uri,
    RustCallStatus *_Nonnull out_status
    );
RustBuffer polywrap_native_3690_FFIInvoker_get_interfaces(
      void*_Nonnull ptr,
    RustCallStatus *_Nonnull out_status
    );
RustBuffer polywrap_native_3690_FFIInvoker_get_env_by_uri(
      void*_Nonnull ptr,void*_Nonnull uri,
    RustCallStatus *_Nonnull out_status
    );
void ffi_polywrap_native_3690_FFIWasmWrapper_object_free(
      void*_Nonnull ptr,
    RustCallStatus *_Nonnull out_status
    );
void*_Nonnull polywrap_native_3690_FFIWasmWrapper_new(
      RustBuffer wasm_module,
    RustCallStatus *_Nonnull out_status
    );
RustBuffer polywrap_native_3690_FFIWasmWrapper_invoke(
      void*_Nonnull ptr,RustBuffer method,RustBuffer args,RustBuffer env,void*_Nonnull invoker,
    RustCallStatus *_Nonnull out_status
    );
void ffi_polywrap_native_3690_FFIStaticUriResolver_object_free(
      void*_Nonnull ptr,
    RustCallStatus *_Nonnull out_status
    );
void*_Nonnull polywrap_native_3690_FFIStaticUriResolver_new(
      RustBuffer uri_map,
    RustCallStatus *_Nonnull out_status
    );
uint64_t polywrap_native_3690_FFIStaticUriResolver_try_resolve_uri(
      void*_Nonnull ptr,void*_Nonnull uri,void*_Nonnull invoker,void*_Nonnull resolution_context,
    RustCallStatus *_Nonnull out_status
    );
void ffi_polywrap_native_3690_FFIRecursiveUriResolver_object_free(
      void*_Nonnull ptr,
    RustCallStatus *_Nonnull out_status
    );
void*_Nonnull polywrap_native_3690_FFIRecursiveUriResolver_new(
      uint64_t uri_resolver,
    RustCallStatus *_Nonnull out_status
    );
uint64_t polywrap_native_3690_FFIRecursiveUriResolver_try_resolve_uri(
      void*_Nonnull ptr,void*_Nonnull uri,void*_Nonnull invoker,void*_Nonnull resolution_context,
    RustCallStatus *_Nonnull out_status
    );
void ffi_polywrap_native_3690_FFIUriResolutionContext_object_free(
      void*_Nonnull ptr,
    RustCallStatus *_Nonnull out_status
    );
void*_Nonnull polywrap_native_3690_FFIUriResolutionContext_new(
      
    RustCallStatus *_Nonnull out_status
    );
void polywrap_native_3690_FFIUriResolutionContext_set_resolution_path(
      void*_Nonnull ptr,RustBuffer resolution_path,
    RustCallStatus *_Nonnull out_status
    );
void polywrap_native_3690_FFIUriResolutionContext_set_history(
      void*_Nonnull ptr,RustBuffer history,
    RustCallStatus *_Nonnull out_status
    );
void polywrap_native_3690_FFIUriResolutionContext_set_resolving_uri_map(
      void*_Nonnull ptr,RustBuffer resolving_uri_map,
    RustCallStatus *_Nonnull out_status
    );
void polywrap_native_3690_FFIUriResolutionContext_set_start_resolving(
      void*_Nonnull ptr,void*_Nonnull uri,
    RustCallStatus *_Nonnull out_status
    );
void polywrap_native_3690_FFIUriResolutionContext_set_stop_resolving(
      void*_Nonnull ptr,void*_Nonnull uri,
    RustCallStatus *_Nonnull out_status
    );
void polywrap_native_3690_FFIUriResolutionContext_track_step(
      void*_Nonnull ptr,RustBuffer step,
    RustCallStatus *_Nonnull out_status
    );
RustBuffer polywrap_native_3690_FFIUriResolutionContext_get_history(
      void*_Nonnull ptr,
    RustCallStatus *_Nonnull out_status
    );
RustBuffer polywrap_native_3690_FFIUriResolutionContext_get_resolution_path(
      void*_Nonnull ptr,
    RustCallStatus *_Nonnull out_status
    );
void*_Nonnull polywrap_native_3690_FFIUriResolutionContext_create_sub_history_context(
      void*_Nonnull ptr,
    RustCallStatus *_Nonnull out_status
    );
void*_Nonnull polywrap_native_3690_FFIUriResolutionContext_create_sub_context(
      void*_Nonnull ptr,
    RustCallStatus *_Nonnull out_status
    );
void ffi_polywrap_native_3690_FFIClient_object_free(
      void*_Nonnull ptr,
    RustCallStatus *_Nonnull out_status
    );
RustBuffer polywrap_native_3690_FFIClient_invoke_raw(
      void*_Nonnull ptr,void*_Nonnull uri,RustBuffer method,RustBuffer args,RustBuffer env,RustBuffer resolution_context,
    RustCallStatus *_Nonnull out_status
    );
RustBuffer polywrap_native_3690_FFIClient_get_implementations(
      void*_Nonnull ptr,void*_Nonnull uri,
    RustCallStatus *_Nonnull out_status
    );
RustBuffer polywrap_native_3690_FFIClient_get_interfaces(
      void*_Nonnull ptr,
    RustCallStatus *_Nonnull out_status
    );
RustBuffer polywrap_native_3690_FFIClient_get_env_by_uri(
      void*_Nonnull ptr,void*_Nonnull uri,
    RustCallStatus *_Nonnull out_status
    );
void*_Nonnull polywrap_native_3690_FFIClient_as_invoker(
      void*_Nonnull ptr,
    RustCallStatus *_Nonnull out_status
    );
RustBuffer polywrap_native_3690_FFIClient_invoke_wrapper_raw(
      void*_Nonnull ptr,uint64_t wrapper,void*_Nonnull uri,RustBuffer method,RustBuffer args,RustBuffer env,RustBuffer resolution_context,
    RustCallStatus *_Nonnull out_status
    );
uint64_t polywrap_native_3690_FFIClient_load_wrapper(
      void*_Nonnull ptr,void*_Nonnull uri,RustBuffer resolution_context,
    RustCallStatus *_Nonnull out_status
    );
void ffi_polywrap_native_3690_FFIBuilderConfig_object_free(
      void*_Nonnull ptr,
    RustCallStatus *_Nonnull out_status
    );
void*_Nonnull polywrap_native_3690_FFIBuilderConfig_new(
      
    RustCallStatus *_Nonnull out_status
    );
void polywrap_native_3690_FFIBuilderConfig_add_env(
      void*_Nonnull ptr,void*_Nonnull uri,RustBuffer env,
    RustCallStatus *_Nonnull out_status
    );
void polywrap_native_3690_FFIBuilderConfig_remove_env(
      void*_Nonnull ptr,void*_Nonnull uri,
    RustCallStatus *_Nonnull out_status
    );
void polywrap_native_3690_FFIBuilderConfig_add_interface_implementation(
      void*_Nonnull ptr,void*_Nonnull interface_uri,void*_Nonnull implementation_uri,
    RustCallStatus *_Nonnull out_status
    );
void polywrap_native_3690_FFIBuilderConfig_remove_interface_implementation(
      void*_Nonnull ptr,void*_Nonnull interface_uri,void*_Nonnull implementation_uri,
    RustCallStatus *_Nonnull out_status
    );
void polywrap_native_3690_FFIBuilderConfig_add_wrapper(
      void*_Nonnull ptr,void*_Nonnull uri,uint64_t wrapper,
    RustCallStatus *_Nonnull out_status
    );
void polywrap_native_3690_FFIBuilderConfig_remove_wrapper(
      void*_Nonnull ptr,void*_Nonnull uri,
    RustCallStatus *_Nonnull out_status
    );
void polywrap_native_3690_FFIBuilderConfig_add_package(
      void*_Nonnull ptr,void*_Nonnull uri,uint64_t package,
    RustCallStatus *_Nonnull out_status
    );
void polywrap_native_3690_FFIBuilderConfig_remove_package(
      void*_Nonnull ptr,void*_Nonnull uri,
    RustCallStatus *_Nonnull out_status
    );
void polywrap_native_3690_FFIBuilderConfig_add_redirect(
      void*_Nonnull ptr,void*_Nonnull from,void*_Nonnull to,
    RustCallStatus *_Nonnull out_status
    );
void polywrap_native_3690_FFIBuilderConfig_remove_redirect(
      void*_Nonnull ptr,void*_Nonnull from,
    RustCallStatus *_Nonnull out_status
    );
void polywrap_native_3690_FFIBuilderConfig_add_resolver(
      void*_Nonnull ptr,uint64_t resolver,
    RustCallStatus *_Nonnull out_status
    );
void*_Nonnull polywrap_native_3690_FFIBuilderConfig_build(
      void*_Nonnull ptr,
    RustCallStatus *_Nonnull out_status
    );
void ffi_polywrap_native_3690_FFIWrapper_init_callback(
      ForeignCallback  _Nonnull callback_stub,
    RustCallStatus *_Nonnull out_status
    );
void ffi_polywrap_native_3690_FFIWrapPackage_init_callback(
      ForeignCallback  _Nonnull callback_stub,
    RustCallStatus *_Nonnull out_status
    );
void ffi_polywrap_native_3690_FFIUriResolver_init_callback(
      ForeignCallback  _Nonnull callback_stub,
    RustCallStatus *_Nonnull out_status
    );
void ffi_polywrap_native_3690_FFIUriWrapper_init_callback(
      ForeignCallback  _Nonnull callback_stub,
    RustCallStatus *_Nonnull out_status
    );
void ffi_polywrap_native_3690_FFIUriWrapPackage_init_callback(
      ForeignCallback  _Nonnull callback_stub,
    RustCallStatus *_Nonnull out_status
    );
void ffi_polywrap_native_3690_FFIUriPackageOrWrapper_init_callback(
      ForeignCallback  _Nonnull callback_stub,
    RustCallStatus *_Nonnull out_status
    );
void*_Nonnull polywrap_native_3690_ffi_uri_from_string(
      RustBuffer uri,
    RustCallStatus *_Nonnull out_status
    );
RustBuffer ffi_polywrap_native_3690_rustbuffer_alloc(
      int32_t size,
    RustCallStatus *_Nonnull out_status
    );
RustBuffer ffi_polywrap_native_3690_rustbuffer_from_bytes(
      ForeignBytes bytes,
    RustCallStatus *_Nonnull out_status
    );
void ffi_polywrap_native_3690_rustbuffer_free(
      RustBuffer buf,
    RustCallStatus *_Nonnull out_status
    );
RustBuffer ffi_polywrap_native_3690_rustbuffer_reserve(
      RustBuffer buf,int32_t additional,
    RustCallStatus *_Nonnull out_status
    );
