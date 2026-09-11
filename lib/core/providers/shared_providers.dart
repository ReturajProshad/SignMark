// Shared, cross-feature Riverpod providers.
//
// This file intentionally starts empty. From Phase 2 onward it will expose
// infrastructure providers reused by multiple features, e.g.:
//   - a `file_picker` service provider (pick source PDF)
//   - a `path_provider`-backed save-directory service provider
//
// Feature-specific providers (e.g. the Syncfusion signature/watermark
// services) live in their own feature folders, not here
// (see `master_plan/03_state_management.md`).
