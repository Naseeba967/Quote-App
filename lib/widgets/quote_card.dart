import 'package:code_alpha_quote_app/constants/app_colors.dart';
import 'package:code_alpha_quote_app/models/quote_model.dart';
import 'package:flutter/material.dart';

class QuoteCard extends StatelessWidget {
  final QuoteModel quoteModel;
  const QuoteCard({super.key, required this.quoteModel, t});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(32),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.format_quote,
            size: 40,
            color: AppColors.primary.withOpacity(0.3),
          ),
          const SizedBox(height: 20),
          Text(
            quoteModel.displayQuote,
            textAlign: TextAlign.center,

            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 17,
              height: 1.6,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.3,
            ),
          ),
          SizedBox(height: 10),
          Text(
            quoteModel.displayAuthor,
            textAlign: TextAlign.center,

            style: TextStyle(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
