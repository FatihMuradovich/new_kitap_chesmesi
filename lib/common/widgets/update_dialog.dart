import 'package:flutter/material.dart';

import 'package:new_kitap_chesmesi/common/constants/custom_colors.dart';
import 'package:new_kitap_chesmesi/core/service/update_service.dart';
import 'package:new_kitap_chesmesi/localization/localization.dart';

enum UpdateDialogAction {
  updateNow,
  later,
}

class UpdateDialog extends StatelessWidget {
  final UpdateCheckResult result;

  const UpdateDialog({
    super.key,
    required this.result,
  });

  static Future<UpdateDialogAction?> show({
    required BuildContext context,
    required UpdateCheckResult result,
  }) {
    return showDialog<UpdateDialogAction>(
      context: context,
      barrierDismissible: !result.isMandatory,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      builder: (context) => PopScope(
        canPop: !result.isMandatory,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 360,
            ),
            child: Material(
              color: Colors.transparent,
              child: UpdateDialog(result: result),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              context.l10n.updateAvailable,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontFamily: 'Poppins-regular',
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              context.l10n.updateAvailableHint,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontFamily: 'Poppins-regular',
                color: Colors.grey[700],
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            // if (result.storeVersion.isNotEmpty)
            //   Container(
            //     padding:
            //         const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            //     decoration: BoxDecoration(
            //       color: CustomColors.orangeColor.withOpacity(0.1),
            //       borderRadius: BorderRadius.circular(999),
            //     ),
            //     child: Text(
            //       'Version ${result.storeVersion} is here',
            //       style: theme.textTheme.labelMedium?.copyWith(
            //         fontFamily: 'Poppins-regular',
            //         fontWeight: FontWeight.w600,
            //         color: CustomColors.orangeColor,
            //       ),
            //     ),
            //   ),
            // const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: CustomColors.orangeColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                onPressed: () =>
                    Navigator.of(context).pop(UpdateDialogAction.updateNow),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      context.l10n.updateNow,
                      style: TextStyle(
                        fontFamily: 'Poppins-regular',
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.arrow_forward,
                      size: 18,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
            if (!result.isMandatory) ...[
              const SizedBox(height: 16),
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(UpdateDialogAction.later),
                child: Text(
                  context.l10n.later,
                  style: TextStyle(
                    fontFamily: 'Poppins-regular',
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
