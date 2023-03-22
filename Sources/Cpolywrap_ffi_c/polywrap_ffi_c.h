#ifndef POLYWRAP_CLIENT_H
#define POLYWRAP_CLIENT_H

#include <stdint.h>
#include <stdlib.h>

typedef enum {
    SafeUriPackageOrWrapperType_Uri,
    SafeUriPackageOrWrapperType_WasmWrapper,
    SafeUriPackageOrWrapperType_PluginWrapper,
    SafeUriPackageOrWrapperType_WasmPackage,
    SafeUriPackageOrWrapperType_PluginPackage,
} SafeUriPackageOrWrapperType;

typedef enum {
    SafeUriResolverLikeType_Resolver,
    SafeUriResolverLikeType_Redirect,
    SafeUriResolverLikeType_WasmPackage,
    SafeUriResolverLikeType_PluginPackage,
    SafeUriResolverLikeType_WasmWrapper,
    SafeUriResolverLikeType_PluginWrapper,
} SafeUriResolverLikeType;

typedef struct BuilderConfig BuilderConfig;
typedef struct WasmWrapper WasmWrapper;
typedef struct PluginWrapper PluginWrapper;
typedef struct WasmPackage WasmPackage;
typedef struct PluginPackage PluginPackage;
typedef struct StaticResolver StaticResolver;
typedef struct ExtendableUriResolver ExtendableUriResolver;
typedef struct PolywrapClient PolywrapClient;

typedef struct {
    SafeUriResolverLikeType _type;
    void *data;
    const char *uri;
} SafeUriResolverLikeVariant;

typedef struct {
    uint8_t *data;
    uintptr_t len;
} Buffer;

typedef struct {
    Buffer (*_wrap_invoke)(const int8_t *method_name, const uint8_t *params_buffer, uintptr_t params_len, PolywrapClient *invoker);
} ExtPluginModule;

typedef struct {
    const char *uri;
    SafeUriPackageOrWrapperType data_type;
    void *data;
} SafeUriPackageOrWrapper;

#ifdef __cplusplus
extern "C" {
#endif

void *new_builder_config();

void add_env(BuilderConfig *builder_config_ptr, const char *uri, const char *env);

void remove_env(BuilderConfig *builder_config_ptr, const char *uri);

void set_env(BuilderConfig *builder_config_ptr, const char *uri, const char *env);

void add_interface_implementation(BuilderConfig *builder_config_ptr,
                                  const char *interface_uri,
                                  const char *implementation_uri);

void remove_interface_implementation(BuilderConfig *builder_config_ptr,
                                     const char *interface_uri,
                                     const char *implementation_uri);

void add_wasm_wrapper(BuilderConfig *builder_config_ptr, const char *uri, WasmWrapper *wrapper);

void add_plugin_wrapper(BuilderConfig *builder_config_ptr, const char *uri, PluginWrapper *wrapper);

void remove_wrapper(BuilderConfig *builder_config_ptr, const char *uri);

void add_wasm_package(BuilderConfig *builder_config_ptr, const char *uri, WasmPackage *package);

void add_plugin_package(BuilderConfig *builder_config_ptr, const char *uri, PluginPackage *package);

void remove_package(BuilderConfig *builder_config_ptr, const char *uri);

void add_redirect(BuilderConfig *builder_config_ptr, const char *from, const char *to);

void remove_redirect(BuilderConfig *builder_config_ptr, const char *from);

void add_wrapper_resolver(BuilderConfig *builder_config_ptr, SafeUriResolverLikeVariant resolver);

void add_redirect_resolver(BuilderConfig *builder_config_ptr, SafeUriResolverLikeVariant resolver);

void add_package_resolver(BuilderConfig *builder_config_ptr, SafeUriResolverLikeVariant resolver);

void add_resolver(BuilderConfig *builder_config_ptr, SafeUriResolverLikeVariant resolver);

const void *build_client(BuilderConfig *builder_config_ptr);

void set_plugin_env(ExtPluginModule *plugin_ptr, const char *env_json_str);

const char *get_plugin_env(ExtPluginModule *plugin_ptr, const char *key);

StaticResolver *create_static_resolver(const SafeUriPackageOrWrapper *entries, uintptr_t len);

ExtendableUriResolver *create_extendable_resolver();

PolywrapClient *create_client(BuilderConfig *builder_config_ptr);

const Buffer *invoke_raw(PolywrapClient *client_ptr,
                         const char *uri,
                         const char *method,
                         const Buffer *args,
                         const char *env);

const Buffer *encode(const char *json_str);

#ifdef __cplusplus
}
#endif

#endif // POLYWRAP_CLIENT_H