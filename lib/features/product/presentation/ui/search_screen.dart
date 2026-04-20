import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';
import 'package:fruitstime/features/product/domain/entity/product_entity.dart';
import 'package:fruitstime/features/product/presentation/controller/search_products_provider.dart';
import 'package:fruitstime/features/product/presentation/ui/product_view_sheet.dart';
import 'package:fruitstime/features/product/presentation/ui/widget/product_list_item.dart';
import 'package:fruitstime/l10n/app_localizations.dart';
import 'package:fruitstime/utils/debouncer.dart';
import 'package:go_router/go_router.dart';

class SearchScreen extends ConsumerStatefulWidget {
  static const path = '/search';

  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final debouncer = Debouncer(delay: Duration(milliseconds: 400));
  final searchInputController = TextEditingController();

  @override
  void initState() {
    super.initState();

    searchInputController.addListener(() {
      if (searchInputController.text.trim().isNotEmpty) {
        debouncer.call(() {
          ref.read(searchProductsStateProvider.notifier).search(searchInputController.text.trim());
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final searchProductsState = ref.watch(searchProductsStateProvider);
    final searchResult = searchProductsState.data ?? [];

    void onProductItemClick(ProductEntity product) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => ProductViewSheet(product: product),
      );
    }

    void onBackClick() {
      ref.read(searchProductsStateProvider.notifier).clean();
      context.pop();
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Column(
            children: [
              SizedBox(
                height: 52,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchInputController,
                        autofocus: true,
                        decoration: InputDecoration(hintText: localization.searchJuicesHint),
                      ),
                    ),
                    SizedBox(width: AppSpacing.md),
                    IconButton(
                      onPressed: onBackClick,
                      icon: SvgPicture.asset('assets/icons/close.svg'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: searchProductsState.isLoading
                    ? Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                        padding: EdgeInsets.only(top: AppSpacing.md),
                        child: Column(
                          children: List.generate(
                            searchResult.length,
                            (index) => Column(
                              children: [
                                ProductListItem(
                                  product: searchResult[index],
                                  onPressed: onProductItemClick,
                                  hasNestedCounter: false,
                                ),
                                SizedBox(height: AppSpacing.sm),
                              ],
                            ),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    debouncer.dispose();
    searchInputController.dispose();

    super.dispose();
  }
}
