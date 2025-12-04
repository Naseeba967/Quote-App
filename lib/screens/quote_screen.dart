import 'package:code_alpha_quote_app/constants/app_colors.dart';
import 'package:code_alpha_quote_app/models/quote_model.dart';
import 'package:code_alpha_quote_app/providers/quote_provider.dart';
import 'package:code_alpha_quote_app/screens/favourtie_screen.dart';
import 'package:code_alpha_quote_app/widgets/action_button.dart';
import 'package:code_alpha_quote_app/widgets/quote_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class QuoteScreen extends StatefulWidget {
  const QuoteScreen({super.key});

  @override
  State<QuoteScreen> createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize provider on first load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuoteProvider>().initialize();
    });
  }

  void _handleFavorite(QuoteProvider provider) {
    if (!provider.isFavorite) {
      // Only allow if not already favorite
      provider.saveFavorite();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.favorite, color: Colors.white),
              const SizedBox(width: 12),
              const Text('Added to favorites!'),
            ],
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
         
  backgroundColor: AppColors.background,

      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Quote App',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        actions: [
          Consumer<QuoteProvider>(
            builder: (context, provider, child) {
              return Stack(
                children: [
                  IconButton(
                    icon: Icon(Icons.favorite, color: AppColors.primary),

                    onPressed: () {
                      print(provider.favoritesCount);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => FavoritesScreen()),
                      );
                    },
                    tooltip: 'View Favourite',
                  ),
                  if (provider.favoritesCount > 0)
                    Positioned(
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Text(
                          '${provider.favoritesCount}',

                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),

      body: Consumer<QuoteProvider>(
        builder: (context, provider, child) {
          return SafeArea(
            child: Container(
              height: MediaQuery.of(context).size.height - 100,
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  SizedBox( height: 30,),
                  if (provider.currentQuote != null)
                    QuoteCard(quoteModel: provider.currentQuote!)
                  else if (provider.status == QuoteStatus.error &&
                      provider.currentQuote == null)
                    buildErrorState(context, provider)
                  else
                    Center(child: CircularProgressIndicator()),
            
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ActionButton(
                        icon: provider.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border_outlined,
                        onPressed: () => _handleFavorite(provider),
                      ),
                      ActionButton(
                        icon: Icons.copy,
                        onPressed: () => _handleCopy(provider.currentQuote!),
                      ),
                      ActionButton(
                        icon: Icons.share,
                        onPressed: () => _handleShare(provider.currentQuote!),
                      ),
                    ],
                  ),
                  // const Spacer(),
                  const SizedBox(height: 70),
                  Padding(
                    padding: EdgeInsets.symmetric( horizontal: 30),
                    child: SizedBox(
                      
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: provider.isLoading
                            ? null
                            : () => provider.fetchNewQuote(),
            
                        style: ElevatedButton.styleFrom(
                          // elevation: 4,
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          shadowColor: AppColors.primary.withValues(alpha: 0.4),
                          padding: EdgeInsets.symmetric(
                            horizontal: 60,
                            vertical: 18,
                          ),
                        ),
                        child: Text('New Quote'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildErrorState(BuildContext context, QuoteProvider provider) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.red.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 64,
            color: Colors.red.withOpacity(0.6),
          ),
          const SizedBox(height: 16),
          const Text(
            'Oops! Something went wrong',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            provider.errorMessage,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => provider.fetchNewQuote(),
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Try Again'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleCopy(QuoteModel quote) {
    // Format the quote text
    final quoteText = '"${quote.content}"\n\n— ${quote.author}';

    // Copy to clipboard
    Clipboard.setData(ClipboardData(text: quoteText));

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            const Text('Quote copied to clipboard!'),
          ],
        ),
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _handleShare(QuoteModel quote) {
    // Format the quote text
    final quoteText = '"${quote.content}"\n\n— ${quote.author}';

    // Share using share_plus package
    Share.share(quoteText, subject: 'Inspiring Quote');
  }
}
