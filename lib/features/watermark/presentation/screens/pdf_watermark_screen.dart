import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_back_bar.dart';
import '../../../../core/widgets/primary_action_button.dart';
import '../../../pdf_source/presentation/viewmodel/pdf_source_notifier.dart';
import '../viewmodel/watermark_notifier.dart';
import '../viewmodel/watermark_state.dart';
import '../widgets/anchor_grid.dart';
import '../widgets/dimension_badge.dart';
import '../widgets/layer_dropdown.dart';
import '../widgets/page_range_card.dart';
import '../widgets/rotation_slider.dart';
import '../widgets/text_format_card.dart';
import '../widgets/text_image_tabs.dart';
import '../widgets/transparency_slider.dart';

class PdfWatermarkScreen extends ConsumerStatefulWidget {
  const PdfWatermarkScreen({super.key});

  @override
  ConsumerState<PdfWatermarkScreen> createState() => _PdfWatermarkScreenState();
}

class _PdfWatermarkScreenState extends ConsumerState<PdfWatermarkScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wmState = ref.watch(watermarkNotifierProvider);
    final pdfState = ref.watch(pdfSourceNotifierProvider);

    ref.listen<AsyncValue<String>>(
      watermarkNotifierProvider.select((s) => s.saveStatus),
      (previous, next) {
        if (previous?.isLoading == true && next.hasValue) {
          _showSuccessDialog(context, next.value!);
        } else if (previous?.isLoading == true && next.hasError) {
          _showErrorDialog(context, next.error);
        }
      },
    );

    if (pdfState.hasPdf && wmState.totalPages == 0) {
      ref
          .read(watermarkNotifierProvider.notifier)
          .setTotalPages(pdfState.pdfSource!.pageCount);
    }

    final validationError = _getValidationError(wmState);

    return Scaffold(
      appBar: const AppBackBar(title: 'PDF Watermark'),
      body: Column(
        children: [
          TextImageTabs(controller: _tabController),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _TextTab(
                  textController: _textController,
                  state: wmState,
                  validationError: validationError,
                ),
                const _ImageStubTab(),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(AppSizes.screenPadding),
            child: PrimaryActionButton(
              label: 'Apply Watermark',
              isLoading: wmState.saveStatus.isLoading,
              onPressed: (wmState.canSubmit &&
                      pdfState.hasPdf &&
                      !wmState.saveStatus.isLoading)
                  ? () {
                      final sourcePath = pdfState.pdfSource!.path;
                      ref
                          .read(watermarkNotifierProvider.notifier)
                          .applyWatermark(sourcePath);
                    }
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  String? _getValidationError(WatermarkState state) {
    if (state.totalPages == 0) return null;
    if (state.pageFrom > state.pageTo) {
      return '"From" must be less than or equal to "To"';
    }
    if (state.pageFrom < 1) {
      return '"From" must be at least 1';
    }
    if (state.pageTo > state.totalPages) {
      return '"To" exceeds total pages (${state.totalPages})';
    }
    return null;
  }

  void _showSuccessDialog(BuildContext context, String savedPath) {
    final fileName = savedPath.split(Platform.isWindows ? '\\' : '/').last;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Watermark Saved'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('File: $fileName'),
            SizedBox(height: AppSizes.gapXs),
            Text(
              savedPath,
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(BuildContext context, Object? error) {
    final isReadError = error is FileSystemException &&
        error.path != null &&
        !error.path!.contains('Cannot write');
    final message = isReadError
        ? 'Couldn\'t read the source PDF: ${error.message}'
        : error is FileSystemException && error.path == null
            ? 'Couldn\'t write the output PDF: ${error.message}'
            : 'Failed to save watermarked PDF: $error';
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class _TextTab extends ConsumerWidget {
  const _TextTab({
    required this.textController,
    required this.state,
    required this.validationError,
  });

  final TextEditingController textController;
  final WatermarkState state;
  final String? validationError;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(watermarkNotifierProvider.notifier);
    final pdfState = ref.watch(pdfSourceNotifierProvider);

    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSizes.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!pdfState.hasPdf)
            _PickPdfButton(onTap: () => ref.read(pdfSourceNotifierProvider.notifier).pickPdf())
          else
            _PdfInfoBanner(
              fileName: pdfState.pdfSource!.fileName,
              pageCount: pdfState.pdfSource!.pageCount,
              onClear: () => ref.read(pdfSourceNotifierProvider.notifier).clearPdf(),
            ),
          SizedBox(height: AppSizes.gapM),
          TextFormatCard(
            text: state.text,
            onTextChanged: (v) {
              notifier.setText(v);
            },
            fontIndex: state.fontIndex,
            onFontChanged: notifier.setFontIndex,
            fontSizePt: state.fontSizePt,
            onFontSizeChanged: notifier.setFontSize,
            style: state.style.name,
            onStyleChanged: notifier.setStyleOption,
            colorHex: state.colorHex,
            onColorChanged: notifier.setColor,
          ),
          SizedBox(height: AppSizes.gapM),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(AppSizes.cardPadding),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.all(Radius.circular(AppSizes.radiusM)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnchorGrid(
                  selected: state.anchor,
                  onSelect: notifier.setAnchor,
                ),
                SizedBox(height: AppSizes.gapM),
                LayerDropdown(
                  selected: state.layer,
                  onChanged: notifier.setLayer,
                ),
              ],
            ),
          ),
          SizedBox(height: AppSizes.gapM),
          Center(
            child: DimensionBadge(width: 342, height: 152),
          ),
          SizedBox(height: AppSizes.gapM),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(AppSizes.cardPadding),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.all(Radius.circular(AppSizes.radiusM)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Adjustments', style: AppTextStyles.subtitle),
                SizedBox(height: AppSizes.gapS),
                TransparencySlider(
                  value: state.opacityPercent,
                  onChanged: notifier.setOpacity,
                ),
                RotationSlider(
                  value: state.rotationDegrees,
                  onChanged: notifier.setRotation,
                ),
              ],
            ),
          ),
          SizedBox(height: AppSizes.gapM),
          PageRangeCard(
            pageFrom: state.pageFrom,
            pageTo: state.pageTo,
            totalPages: state.totalPages,
            onPageFromChanged: notifier.setPageFrom,
            onPageToChanged: notifier.setPageTo,
            validationError: validationError,
          ),
        ],
      ),
    );
  }
}

class _ImageStubTab extends StatelessWidget {
  const _ImageStubTab();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.screenPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.image_outlined,
              size: AppSizes.iconL,
              color: AppColors.disabled,
            ),
            SizedBox(height: AppSizes.gapM),
            Text('Image Watermark', style: AppTextStyles.subtitle),
            SizedBox(height: AppSizes.gapXs),
            Text(
              'Coming soon — overlay an image as a watermark.',
              style: AppTextStyles.label,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSizes.gapS),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.hGapS,
                vertical: 4.h,
              ),
              decoration: BoxDecoration(
                color: AppColors.disabled,
                borderRadius: BorderRadius.all(
                  Radius.circular(AppSizes.radiusS),
                ),
              ),
              child: Text(
                'STUB',
                style: TextStyle(
                  fontSize: 10.sp,
                  color: AppColors.surface,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PickPdfButton extends StatelessWidget {
  const _PickPdfButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.all(Radius.circular(AppSizes.radiusM)),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(AppSizes.cardPadding),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primaryRed, width: 1.5.w),
          borderRadius: BorderRadius.all(Radius.circular(AppSizes.radiusM)),
        ),
        child: Row(
          children: [
            Icon(Icons.picture_as_pdf_outlined, color: AppColors.primaryRed, size: AppSizes.iconM),
            SizedBox(width: AppSizes.hGapS),
            Text(
              'Pick a PDF',
              style: AppTextStyles.body.copyWith(color: AppColors.primaryRed),
            ),
          ],
        ),
      ),
    );
  }
}

class _PdfInfoBanner extends StatelessWidget {
  const _PdfInfoBanner({
    required this.fileName,
    required this.pageCount,
    required this.onClear,
  });

  final String fileName;
  final int pageCount;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.primaryRedTint,
        borderRadius: BorderRadius.all(Radius.circular(AppSizes.radiusM)),
      ),
      child: Row(
        children: [
          Icon(Icons.picture_as_pdf, color: AppColors.primaryRed, size: AppSizes.iconM),
          SizedBox(width: AppSizes.hGapS),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  style: AppTextStyles.body,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '$pageCount page${pageCount == 1 ? '' : 's'}',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
          InkWell(
            onTap: onClear,
            borderRadius: BorderRadius.all(Radius.circular(AppSizes.radiusS)),
            child: Icon(Icons.close, size: AppSizes.iconS, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
