# SignMark

A Flutter app that lets you pick a real PDF, add a typed signature or a text watermark, and save a modified PDF to disk. Built as a time-boxed hiring-task submission — judged on working PDF I/O, clean architecture, and honest scope framing.

## Setup

- **Flutter version:** 3.x (stable channel)
- **Get dependencies:** `flutter pub get`
- **Syncfusion Community License:** Register a free account at [syncfusion.com/products/communitylicense](https://www.syncfusion.com/products/communitylicense) (individuals/small teams under $1M revenue, ≤5 developers qualify). As of Syncfusion Flutter v18.3.0.x, no `registerLicense()` call is needed in code and no trial watermark is produced — this is purely a paperwork/eligibility step.
- **Platform permissions:**
  - **Android:** `READ_EXTERNAL_STORAGE` and `WRITE_EXTERNAL_STORAGE` declared in `AndroidManifest.xml`, plus `requestLegacyExternalStorage="true"` for Android 10 scoped-storage compatibility.
  - **iOS:** `UIFileSharingEnabled` and `LSSupportsOpeningDocumentsInPlace` set in `Info.plist` so saved PDFs appear in the Files app under "On My iPhone".

## Architecture

- **MVVM, feature-first, Clean Architecture** — each feature (`pdf_source`, `signature`, `watermark`) is split into `domain/` (entities, abstract repositories, use cases), `data/` (repository implementations, SDK-wrapping services), and `presentation/` (screens, viewmodels, widgets). This keeps PDF SDK and file I/O code out of widgets, making the domain layer trivially testable and the PDF engine swappable.
- **Riverpod** (`flutter_riverpod`) with plain `Notifier`/`AsyncNotifier` — no code generation, no `build_runner`, zero build-time risk under a deadline.
- **`flutter_screenutil`** for responsive sizing — every widget dimension uses `.w` / `.h` / `.sp` / `.r`, no raw pixel literals.

One-paragraph rationale: For a task this size, feature-first + Clean Architecture gives the reviewer clear separation of concerns without over-engineering. Riverpod without codegen avoids the most common Flutter CI failure mode (stale generated files), and ScreenUtil guarantees the UI matches the spec across device sizes.

## Scope decisions

- **Signature placement:** Fixed bottom-center of page 1. The spec explicitly allows this simplification to keep scope small. Position is computed from real page dimensions (`page.size.width/height`) so it's correct for any page size (A4, Letter, etc.). A drag-to-position upgrade would wrap the page preview in a `GestureDetector`, convert dragged offsets to real PDF coordinates via a scale factor, and store an `Offset` in `SignatureState` — see `master_plan/05_signature_screen.md` for the full upgrade path.
- **Signature Draw/Import tabs and Watermark Image tab:** UI-complete, functionally stubbed, visibly labeled with a "STUB" chip and "Coming soon" text. Explicitly allowed by the spec.
- **PDF engine:** `syncfusion_flutter_pdf` — chosen because it loads existing PDFs, reads real page counts, and draws text/graphics directly onto specific pages without rasterizing (unlike the `pdf` + `printing` fallback, which would flatten original content into images). Free for individuals under the Community License.

## What's real vs. stubbed

| Area                          | Status     | Notes |
|-------------------------------|------------|-------|
| PDF picking                   | Real       | `file_picker`, PDF extension filter |
| Real page count               | Real       | parsed from the picked file via Syncfusion |
| Signature — Type tab          | Real       | full config → embedded into output PDF |
| Signature — Draw tab          | Stub       | UI shell only, visibly labeled |
| Signature — Import tab        | Stub       | UI shell only, visibly labeled |
| Signature placement           | Simplified | fixed bottom-center of page 1 |
| Watermark — Text tab          | Real       | full config → embedded into output PDF |
| Watermark — Image tab         | Stub       | UI shell only, visibly labeled |
| Watermark page range          | Real       | validated against real page count |
| PDF write + save to disk      | Real       | new file in `Documents/SignMark/editedPdf`, real path shown |

## Known limitations

- **Watermark "Under" layer:** Syncfusion's `page.layers.add()` creates an OCG (Optional Content Group) layer, but for loaded PDFs the layer is appended to the content stream rather than inserted beneath existing content. In most viewers the watermark will still render correctly; true content-stream-level "under" positioning would require lower-level PDF manipulation beyond Syncfusion's public API.
- **Font bold/italic:** Only `PdfFontStyle.bold` is available for the bold-italic watermark option (Syncfusion's `PdfFontStyle` enum has no `boldItalic` value). The font renders as bold.
- **Page range clamping:** When a PDF is picked, `pageFrom` and `pageTo` are clamped to `1..totalPages`. If the user manually types a value outside this range, the validation error blocks submission but does not auto-correct the input.

## Time spent

| Phase                                   | Estimate | Actual |
|------------------------------------------|----------|--------|
| Project scaffold, theme, routing          | 2h       | 1h     |
| pdf_source feature (pick + page count)    | 2h       | 1h     |
| Signature screen — UI                     | 3h       | 2h     |
| Signature screen — PDF embed logic        | 3h       | 2h     |
| Watermark screen — UI                     | 4h       | 2h     |
| Watermark screen — PDF embed logic        | 3h       | 2h     |
| File save/path/permissions plumbing       | 2h       | 1h     |
| README + cleanup + manual testing         | 2h       | 1h     |
| **Total**                                 | **21h**  | **12h** |
