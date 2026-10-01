import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/database/database.dart';
import '../../../core/database/database_provider.dart';
import '../data/source_registry.dart';
import '../domain/source_contract.dart';

class SourceDetailScreen extends ConsumerStatefulWidget {
  final String sourceId;

  const SourceDetailScreen({
    super.key,
    required this.sourceId,
  });

  @override
  ConsumerState<SourceDetailScreen> createState() => _SourceDetailScreenState();
}

class _SourceDetailScreenState extends ConsumerState<SourceDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  BaseStorySource? _source;

  // ── Feed State ────────────────────────────────────────────────
  final List<SourceListingItem> _feedStories = [];
  bool _isLoadingFeed = false;
  bool _feedHasMore = true;
  int _feedPage = 1;
  final ScrollController _feedScroll = ScrollController();

  // ── Categories State ─────────────────────────────────────────
  List<SourceCategory> _categories = [];
  bool _isLoadingCategories = true;
  SourceCategory? _selectedCategory;
  final List<SourceListingItem> _categoryStories = [];
  bool _isLoadingCategoryStories = false;
  bool _categoryHasMore = true;
  int _categoryPage = 1;
  final ScrollController _catScroll = ScrollController();

  // ── Tags State ───────────────────────────────────────────────
  List<SourceTag> _tags = [];
  bool _isLoadingTags = true;
  SourceTag? _selectedTag;
  final List<SourceListingItem> _tagStories = [];
  bool _isLoadingTagStories = false;
  bool _tagHasMore = true;
  int _tagPage = 1;
  final ScrollController _tagScroll = ScrollController();

  // ── Search State ─────────────────────────────────────────────
  final TextEditingController _searchController = TextEditingController();
  final List<SourceListingItem> _searchResults = [];
  bool _isSearching = false;
  bool _searchHasMore = true;
  int _searchPage = 1;
  String _lastQuery = '';
  final ScrollController _searchScroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _source = SourceRegistry.getSourceById(widget.sourceId);

    _feedScroll.addListener(_onFeedScroll);
    _catScroll.addListener(_onCatScroll);
    _tagScroll.addListener(_onTagScroll);
    _searchScroll.addListener(_onSearchScroll);

    _loadFeedPage();
    _loadCategories();
    _loadTags();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _feedScroll.dispose();
    _catScroll.dispose();
    _tagScroll.dispose();
    _searchScroll.dispose();
    super.dispose();
  }

  // ── Scroll Listeners ─────────────────────────────────────────

  void _onFeedScroll() {
    if (_feedScroll.position.pixels >= _feedScroll.position.maxScrollExtent - 300 &&
        !_isLoadingFeed &&
        _feedHasMore) {
      _loadFeedPage();
    }
  }

  void _onCatScroll() {
    if (_catScroll.position.pixels >= _catScroll.position.maxScrollExtent - 300 &&
        !_isLoadingCategoryStories &&
        _categoryHasMore &&
        _selectedCategory != null) {
      _loadCategoryPage();
    }
  }

  void _onTagScroll() {
    if (_tagScroll.position.pixels >= _tagScroll.position.maxScrollExtent - 300 &&
        !_isLoadingTagStories &&
        _tagHasMore &&
        _selectedTag != null) {
      _loadTagPage();
    }
  }

  void _onSearchScroll() {
    if (_searchScroll.position.pixels >= _searchScroll.position.maxScrollExtent - 300 &&
        !_isSearching &&
        _searchHasMore &&
        _lastQuery.isNotEmpty) {
      _searchPage++;
      _doSearch(_lastQuery, append: true);
    }
  }

  // ── Feed ─────────────────────────────────────────────────────

  Future<void> _loadFeedPage() async {
    if (_source == null || _isLoadingFeed || !_feedHasMore) return;
    setState(() => _isLoadingFeed = true);
    try {
      final items = await _source!.getFeed(page: _feedPage);
      if (!mounted) return;
      setState(() {
        if (items.isEmpty) {
          _feedHasMore = false;
        } else {
          _feedStories.addAll(items);
          _feedPage++;
        }
        _isLoadingFeed = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoadingFeed = false);
    }
  }

  // ── Categories ───────────────────────────────────────────────

  Future<void> _loadCategories() async {
    if (_source == null) return;
    setState(() => _isLoadingCategories = true);
    try {
      final cats = await _source!.getCategories();
      if (!mounted) return;
      setState(() {
        _categories = cats;
        _isLoadingCategories = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoadingCategories = false);
    }
  }

  Future<void> _selectCategory(SourceCategory cat) async {
    // Reset state for new category selection
    setState(() {
      _selectedCategory = cat;
      _categoryStories.clear();
      _categoryPage = 1;
      _categoryHasMore = true;
    });
    _loadCategoryPage();
  }

  Future<void> _loadCategoryPage() async {
    if (_source == null || _isLoadingCategoryStories || !_categoryHasMore) return;
    setState(() => _isLoadingCategoryStories = true);
    try {
      final items = await _source!.getCategoryStories(
        _selectedCategory!.slug,
        page: _categoryPage,
      );
      if (!mounted) return;
      setState(() {
        if (items.isEmpty) {
          _categoryHasMore = false;
        } else {
          _categoryStories.addAll(items);
          _categoryPage++;
        }
        _isLoadingCategoryStories = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoadingCategoryStories = false);
    }
  }

  // ── Tags ─────────────────────────────────────────────────────

  Future<void> _loadTags() async {
    if (_source == null) return;
    setState(() => _isLoadingTags = true);
    try {
      final tags = await _source!.getTags();
      if (!mounted) return;
      setState(() {
        _tags = tags;
        _isLoadingTags = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoadingTags = false);
    }
  }

  Future<void> _selectTag(SourceTag tag) async {
    setState(() {
      _selectedTag = tag;
      _tagStories.clear();
      _tagPage = 1;
      _tagHasMore = true;
    });
    _loadTagPage();
  }

  Future<void> _loadTagPage() async {
    if (_source == null || _isLoadingTagStories || !_tagHasMore) return;
    setState(() => _isLoadingTagStories = true);
    try {
      final items = await _source!.getTagStories(
        _selectedTag!.slug,
        page: _tagPage,
      );
      if (!mounted) return;
      setState(() {
        if (items.isEmpty) {
          _tagHasMore = false;
        } else {
          _tagStories.addAll(items);
          _tagPage++;
        }
        _isLoadingTagStories = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoadingTagStories = false);
    }
  }

  // ── Search ───────────────────────────────────────────────────

  Future<void> _performSearch(String query) async {
    final q = query.trim();
    if (_source == null || q.isEmpty) return;
    // New query → reset
    setState(() {
      _searchResults.clear();
      _searchPage = 1;
      _searchHasMore = true;
      _lastQuery = q;
    });
    _doSearch(q, append: false);
  }

  Future<void> _doSearch(String query, {required bool append}) async {
    if (_isSearching || !_searchHasMore) return;
    setState(() => _isSearching = true);
    try {
      final items = await _source!.search(query, page: _searchPage);
      if (!mounted) return;
      setState(() {
        if (items.isEmpty) {
          _searchHasMore = false;
        } else {
          if (!append) _searchResults.clear();
          _searchResults.addAll(items);
          _searchPage++;
        }
        _isSearching = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isSearching = false);
    }
  }

  // ── Open Story ───────────────────────────────────────────────

  Future<void> _openStory(SourceListingItem item) async {
    if (_source == null) return;
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text('Loading "${item.title}"...'),
        duration: const Duration(seconds: 2),
      ),
    );

    try {
      final db = ref.read(databaseProvider);

      final existingNovel = await (db.select(db.novels)
            ..where((t) => t.sourceNovelUrl.equals(item.url)))
          .getSingleOrNull();

      int novelId;
      if (existingNovel != null) {
        novelId = existingNovel.id;
      } else {
        final details = await _source!.getStoryDetails(item.url);
        final content = await _source!.getChapterContent(item.url);

        novelId = await db.into(db.novels).insert(
          NovelsCompanion(
            title: Value(details.title),
            author: Value(details.author ?? item.author),
            coverUrl: Value(details.coverUrl ?? item.coverUrl),
            description: Value(details.description ?? item.summary),
            sourceId: Value(_source!.id),
            sourceNovelUrl: Value(item.url),
            isLocal: const Value(false),
            isFavorite: const Value(true),
            createdAt: Value(DateTime.now()),
          ),
        );

        await db.into(db.chapters).insert(
          ChaptersCompanion(
            novelId: Value(novelId),
            chapterIndex: const Value(1.0),
            title: Value(details.chapters.isNotEmpty
                ? details.chapters.first.title
                : 'Full Story'),
            url: Value(item.url),
            content: Value(content),
            isDownloaded: const Value(true),
          ),
        );
      }

      if (mounted) {
        context.push('/reader/$novelId');
      }
    } catch (e) {
      scaffold.showSnackBar(
        SnackBar(content: Text('Failed to load story: $e')),
      );
    }
  }

  // ── Build ────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    if (_source == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Source Not Found')),
        body: const Center(child: Text('Unknown source')),
      );
    }

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_source!.name),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.dynamic_feed), text: 'Feed'),
            Tab(icon: Icon(Icons.category_outlined), text: 'Categories'),
            Tab(icon: Icon(Icons.tag), text: 'Tags'),
            Tab(icon: Icon(Icons.search), text: 'Search'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFeedTab(theme),
          _buildCategoriesTab(theme),
          _buildTagsTab(theme),
          _buildSearchTab(theme),
        ],
      ),
    );
  }

  // ── Feed Tab ─────────────────────────────────────────────────

  Widget _buildFeedTab(ThemeData theme) {
    if (_feedStories.isEmpty && _isLoadingFeed) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_feedStories.isEmpty && !_feedHasMore) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.newspaper, size: 48, color: Colors.grey),
            const SizedBox(height: 12),
            const Text('No stories found on feed'),
            const SizedBox(height: 8),
            FilledButton.tonal(
              onPressed: () {
                setState(() {
                  _feedPage = 1;
                  _feedHasMore = true;
                  _feedStories.clear();
                });
                _loadFeedPage();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      controller: _feedScroll,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      itemCount: _feedStories.length + (_feedHasMore ? 1 : 0),
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, idx) {
        if (idx == _feedStories.length) {
          return _buildLoadMoreIndicator(_isLoadingFeed);
        }
        return _buildStoryTile(_feedStories[idx], theme);
      },
    );
  }

  // ── Categories Tab ───────────────────────────────────────────

  Widget _buildCategoriesTab(ThemeData theme) {
    if (_isLoadingCategories) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        SizedBox(
          height: 52,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            itemCount: _categories.length,
            itemBuilder: (context, idx) {
              final cat = _categories[idx];
              final isSelected = _selectedCategory?.slug == cat.slug;
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: FilterChip(
                  label: Text(cat.name),
                  selected: isSelected,
                  onSelected: (_) => _selectCategory(cat),
                ),
              );
            },
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: _selectedCategory == null
              ? const Center(child: Text('Select a category above'))
              : _categoryStories.isEmpty && _isLoadingCategoryStories
                  ? const Center(child: CircularProgressIndicator())
                  : _categoryStories.isEmpty && !_categoryHasMore
                      ? const Center(child: Text('No stories in this category'))
                      : ListView.separated(
                          controller: _catScroll,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 12.0),
                          itemCount:
                              _categoryStories.length + (_categoryHasMore ? 1 : 0),
                          separatorBuilder: (_, _) => const Divider(height: 1),
                          itemBuilder: (context, idx) {
                            if (idx == _categoryStories.length) {
                              return _buildLoadMoreIndicator(_isLoadingCategoryStories);
                            }
                            return _buildStoryTile(_categoryStories[idx], theme);
                          },
                        ),
        ),
      ],
    );
  }

  // ── Tags Tab ─────────────────────────────────────────────────

  Widget _buildTagsTab(ThemeData theme) {
    if (_isLoadingTags) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_tags.isEmpty) {
      return const Center(child: Text('No tags available for this source'));
    }

    return Column(
      children: [
        SizedBox(
          height: 52,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            itemCount: _tags.length,
            itemBuilder: (context, idx) {
              final tag = _tags[idx];
              final isSelected = _selectedTag?.slug == tag.slug;
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: FilterChip(
                  label: Text('#${tag.name}'),
                  selected: isSelected,
                  onSelected: (_) => _selectTag(tag),
                ),
              );
            },
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: _selectedTag == null
              ? const Center(child: Text('Select a tag above'))
              : _tagStories.isEmpty && _isLoadingTagStories
                  ? const Center(child: CircularProgressIndicator())
                  : _tagStories.isEmpty && !_tagHasMore
                      ? const Center(child: Text('No stories found for this tag'))
                      : ListView.separated(
                          controller: _tagScroll,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 12.0),
                          itemCount:
                              _tagStories.length + (_tagHasMore ? 1 : 0),
                          separatorBuilder: (_, _) => const Divider(height: 1),
                          itemBuilder: (context, idx) {
                            if (idx == _tagStories.length) {
                              return _buildLoadMoreIndicator(_isLoadingTagStories);
                            }
                            return _buildStoryTile(_tagStories[idx], theme);
                          },
                        ),
        ),
      ],
    );
  }

  // ── Search Tab ───────────────────────────────────────────────

  Widget _buildSearchTab(ThemeData theme) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search stories on ${_source!.name}...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  setState(() {
                    _searchResults.clear();
                    _searchHasMore = true;
                    _searchPage = 1;
                    _lastQuery = '';
                  });
                },
              ),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onSubmitted: _performSearch,
          ),
        ),
        Expanded(
          child: _isSearching && _searchResults.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : _searchResults.isEmpty
                  ? const Center(child: Text('Enter a query to search'))
                  : ListView.separated(
                      controller: _searchScroll,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      itemCount:
                          _searchResults.length + (_searchHasMore ? 1 : 0),
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemBuilder: (context, idx) {
                        if (idx == _searchResults.length) {
                          return _buildLoadMoreIndicator(_isSearching);
                        }
                        return _buildStoryTile(_searchResults[idx], theme);
                      },
                    ),
        ),
      ],
    );
  }

  // ── Shared Widgets ───────────────────────────────────────────

  Widget _buildLoadMoreIndicator(bool isLoading) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Center(
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Text(
                'Scroll down to load more',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
      ),
    );
  }

  Widget _buildStoryTile(SourceListingItem story, ThemeData theme) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 6.0),
      leading: Container(
        width: 44,
        height: 60,
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Icon(Icons.menu_book, size: 22),
      ),
      title: Text(
        story.title,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
      subtitle: story.summary != null && story.summary!.isNotEmpty
          ? Text(
              story.summary!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: theme.colorScheme.onSurfaceVariant, fontSize: 12),
            )
          : null,
      trailing: const Icon(Icons.chevron_right, size: 18),
      onTap: () => _openStory(story),
    );
  }
}
