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
import '../viewmodel/signature_notifier.dart';
import '../widgets/color_swatch_row.dart';
import '../widgets/font_thumbnail_row.dart';
import '../widgets/live_preview_card.dart';
import '../widgets/name_input_field.dart';
import '../widgets/placement_preview.dart';
import '../widgets/size_slider.dart';
import '../widgets/weight_selector.dart';

class DrawSignatureScreen extends ConsumerStatefulWidget {
  const DrawSignatureScreen({super.key});

  @override
  ConsumerState<DrawSignatureScreen> createState() =>
      _DrawSignatureScreenState();
}

class _DrawSignatureScreenState extends ConsumerState<DrawSignatureScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sigState = ref.watch(signatureNotifierProvider);
    final pdfState = ref.watch(pdfSourceNotifierProvider);

    ref.listen<AsyncValue<String>>(
      signatureNotifierProvider.select((s) => s.saveStatus),
      (previous, next) {
        if (previous?.isLoading == true && next.hasValue) {
          _showSuccessDialog(context, next.value!);
        } else if (previous?.isLoading == true && next.hasError) {
          _showErrorDialog(context, next.error);
        }
      },
    );

    return Scaffold(
      appBar: const AppBackBar(title: 'Draw Signature'),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            indicatorColor: AppColors.primaryRed,
            labelColor: AppColors.primaryRed,
            unselectedLabelColor: AppColors.textSecondary,
            tabs: const [
              Tab(text: 'Type'),
              Tab(text: 'Draw'),
              Tab(text: 'Import'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _TypeTab(nameController: _nameController, state: sigState),
                const _StubTab(
                  icon: Icons.draw_outlined,
                  title: 'Draw Signature',
                  subtitle:
                      'Coming soon — draw your signature with your finger.',
                ),
                const _StubTab(
                  icon: Icons.file_upload_outlined,
                  title: 'Import Signature',
                  subtitle:
                      'Coming soon — import a signature image from your gallery.',
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(AppSizes.screenPadding),
            child: PrimaryActionButton(
              label: 'Done',
              isLoading: sigState.saveStatus.isLoading,
              onPressed: (sigState.canSubmit && pdfState.hasPdf && !sigState.saveStatus.isLoading)
                  ? () {
                      final sourcePath = pdfState.pdfSource!.path;
                      ref
                          .read(signatureNotifierProvider.notifier)
                          .embedSignature(sourcePath);
                    }
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(BuildContext context, String savedPath) {
    final fileName = savedPath.split(Platform.isWindows ? '\\' : '/').last;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Signature Saved'),
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
            : 'Failed to save signed PDF: $error';

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

class _TypeTab extends ConsumerWidget {
  const _TypeTab({required this.nameController, required this.state});

  final TextEditingController nameController;
  final SignatureState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          NameInputField(
            controller: nameController,
            onChanged: (v) =>
                ref.read(signatureNotifierProvider.notifier).setName(v),
            onClear: () {
              nameController.clear();
              ref.read(signatureNotifierProvider.notifier).setName('');
            },
          ),
          SizedBox(height: AppSizes.gapM),
          LivePreviewCard(
            name: state.name,
            font: state.selectedFont,
            fontSizePt: state.fontSizePt,
            isBold: state.isBold,
            color: state.color,
          ),
          SizedBox(height: AppSizes.gapM),
          FontThumbnailRow(
            selectedIndex: state.fontIndex,
            onTap: (i) =>
                ref.read(signatureNotifierProvider.notifier).setFontIndex(i),
          ),
          SizedBox(height: AppSizes.gapM),
          SizeSlider(
            value: state.fontSizePt,
            onChanged: (v) =>
                ref.read(signatureNotifierProvider.notifier).setFontSize(v),
          ),
          SizedBox(height: AppSizes.gapM),
          WeightSelector(
            isBold: state.isBold,
            onToggle: () =>
                ref.read(signatureNotifierProvider.notifier).toggleBold(),
          ),
          SizedBox(height: AppSizes.gapM),
          ColorSwatchRow(
            selectedHex: state.colorHex,
            onSelect: (hex) =>
                ref.read(signatureNotifierProvider.notifier).setColor(hex),
          ),
          SizedBox(height: AppSizes.gapM),
          const PlacementPreview(),
        ],
      ),
    );
  }
}

class _StubTab extends StatelessWidget {
  const _StubTab({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.screenPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: AppSizes.iconL, color: AppColors.disabled),
            SizedBox(height: AppSizes.gapM),
            Text(title, style: AppTextStyles.subtitle),
            SizedBox(height: AppSizes.gapXs),
            Text(
              subtitle,
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
