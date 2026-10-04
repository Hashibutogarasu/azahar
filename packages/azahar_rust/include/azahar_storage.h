#ifndef AZAHAR_STORAGE_H
#define AZAHAR_STORAGE_H

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef void (*AzaharStorageEntryCallback)(void* user, const char* name);

/**
 * The core reaches every file through this table so that the platform specific storage, such as
 * the Storage Access Framework of Android, stays in the Rust crate instead of the core.
 */
typedef struct AzaharStorageApi {
  int32_t (*exists)(const char* path);
  int32_t (*is_directory)(const char* path);
  uint64_t (*size)(const char* path);
  int32_t (*create_dir)(const char* path);
  int32_t (*remove_file)(const char* path);
  int32_t (*remove_dir)(const char* path);
  int32_t (*rename)(const char* from, const char* to);
  int32_t (*copy)(const char* from, const char* to);
  /** Creates the file for a writing mode, since a document of Android cannot be created by opening it. */
  int32_t (*open)(const char* path, const char* mode);
  int32_t (*list)(const char* path, void* user, AzaharStorageEntryCallback callback);
  /** The string is owned by the crate and replaced by `set_root`, so the caller copies it. */
  const char* (*user_path)(void);
  int32_t (*set_root)(const char* location);
} AzaharStorageApi;

const AzaharStorageApi* azahar_storage_api(void);

#ifdef __cplusplus
}
#endif

#endif
