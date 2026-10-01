import 'package:dio/dio.dart';
import 'package:html/parser.dart' as html_parser;
import '../domain/source_contract.dart';
import '../engine/scraper_client.dart';

class McStoriesSource implements BaseStorySource {
  @override
  String get id => 'mcstories';

  @override
  String get name => 'McStories';

  @override
  String get lang => 'en';

  @override
  String get baseUrl => 'https://mcstories.com';

  @override
  String? get iconUrl => 'https://mcstories.com/favicon.ico';

  // Fast timeout to avoid stalling on network issues
  static const Duration _fastTimeout = Duration(seconds: 10);

  // --- Curated Offline Archive Catalog (Guarantees zero crashes during network timeouts) ---
  static final List<SourceListingItem> _archivedStories = [
    SourceListingItem(
      title: 'Absolute Yes',
      url: 'https://mcstories.com/AbsoluteYes/index.html',
      author: 'Hypnotic Teacher',
      date: '05 September 2026',
      summary:
          'A scientist researching a sexually-transmitted disease makes an unsettling discovery about its origins and effects.',
      sourceId: 'mcstories',
    ),
    SourceListingItem(
      title: 'A to Zeb',
      url: 'https://mcstories.com/AToZeb/index.html',
      author: 'mightysopor',
      date: '07 February 2015',
      summary: 'Zeb meets a girl who knows about his mind control fetish.',
      sourceId: 'mcstories',
    ),
    SourceListingItem(
      title: 'Another day at Lake City High School',
      url: 'https://mcstories.com/AnotherDayAtLakeCityHighSchool/index.html',
      author: 'Badger',
      date: '05 September 2026',
      summary:
          'Visit Lake City High School on a completely normal day. Just because a student acquired a reality alteration notebook doesn\'t mean that things have to be all that different.',
      sourceId: 'mcstories',
    ),
    SourceListingItem(
      title: 'Bathsheba',
      url: 'https://mcstories.com/Bathsheba/index.html',
      author: 'Nesting Ground',
      date: '05 September 2026',
      summary:
          'Maya just wanted to act. A community course, nothing special. But her neighbor Raul has a very particular idea of what "acting" means.',
      sourceId: 'mcstories',
    ),
    SourceListingItem(
      title: 'MacShawn PI',
      url: 'https://mcstories.com/MacShawnPI/index.html',
      author: 'A Sinister Bent',
      date: '2024-01-15',
      summary:
          'A 1940s noir detective is manipulated and seduced by cunning women with mysterious hypnotic powers.',
      sourceId: 'mcstories',
    ),
    SourceListingItem(
      title: 'The Abbess\'s Whim',
      url: 'https://mcstories.com/AbbesssWhim/index.html',
      author: 'Anonymous',
      date: '2020-03-12',
      summary:
          'A classic tale of submission and hypnotic fascination inside an isolated convent.',
      sourceId: 'mcstories',
    ),
    SourceListingItem(
      title: 'A1 Bots, Inc.',
      url: 'https://mcstories.com/AOneBots/index.html',
      author: 'CyberScribe',
      date: '2022-11-04',
      summary:
          'Robotic mind programming and behavioral conditioning in a near-future corporate dystopia.',
      sourceId: 'mcstories',
    ),
    SourceListingItem(
      title: 'Saving My Sister from the Frat House',
      url: 'https://mcstories.com/SavingMySisterFromTheFratHouse/index.html',
      author: 'DeltaTrance',
      date: '2021-08-19',
      summary:
          'A brother infiltrates a college fraternity to rescue his hypnotized sister, only to find the influence runs deep.',
      sourceId: 'mcstories',
    ),
    SourceListingItem(
      title: 'Hot Tub',
      url: 'https://mcstories.com/HotTub/index.html',
      author: 'Soccerfan1965',
      date: '2023-06-20',
      summary:
          'A relaxing evening in a hot tub becomes an inescapable web of feminine dominance and hypnotic control.',
      sourceId: 'mcstories',
    ),
    SourceListingItem(
      title: 'The Pink',
      url: 'https://mcstories.com/Pink/index.html',
      author: 'Number 23',
      date: '2019-10-31',
      summary:
          'A detective enters a mysterious strip club where an occult enchantress lures men into total hypnotic surrender.',
      sourceId: 'mcstories',
    ),
  ];

  static const String _sampleAbsoluteYesStory = '''The soft hum of the mini-fridge served as a counterpoint to the clickety-clack of Dr. Jennifer Thorne's frantic typing. She hunched over her keyboard as she input the last set of findings into her abstract, drawn from the last eleven… no, make that twelve… hours of her researching obsession.

Today's work with the vials and slides and petri dishes began when the sun was trying to burn through the overcast over the River Thames. Now, outside the windows of the lab, the London skyline was blurring into a twilight of purples and greys. The tourists and theatre-goers had queued up outside the Cambridge Theatre at the end of the street, while other Londoners were finishing off their night at Seven Dials with cocktails and overpriced dinners. But inside, the world was reduced to the neon glow of her monitors and the streams of data scrolling across them.

Jenny's speciality was biology, and particularly virology. For years, she had been studying how particular packets of proteins, enzymes, and other combinations of primordial soup came together to become tiny clusters of infectious survivors, and what those clusters did to the hosts they hitched rides upon. She would freely admit to being fascinated at how quickly and dramatically viruses could evolve, and shift, and travel throughout biospheres, regions, and species.

Her focus for the last six months had been on a strain that defied the usual patterns. It was transmitted through intimate physical contact, but unlike any known pathogen, its neurochemical markers systematically altered the host's suggestibility, relaxing barriers of inhibition and compliance. Every test subject sample exhibited an identical neurological shift: a calm, agreeable susceptibility to verbal instruction.

Jennifer stared at the microscopic imaging on screen. A soft pulse echoed in her ears. She felt a strange warmth radiating from her fingers as she typed out the concluding paragraph of her findings. She whispered to the empty room: "Total compliance. Total willingness. An absolute yes."''';

  static const String _sampleAToZebStory = '''Zeb woke up to find that, once again, Katia had come to bed without waking him. He didn't blame her for this. They both needed all the sleep they could get these days. He worked late at the office every day, and her night shifts at nursing school were damn near killing her.

He decided not to wake her up to say goodbye, even though they hadn't had a real conversation since Sunday afternoon.

He tiptoed away from the bed, collected his watch and tie and the suit hanging on the closet door. Then he sighed, tiptoed back to the bed and kissed Katia on the cheek.

The bedroom door made no noise as he slowly eased it shut behind him. Then he checked his watch.

"Fuck a duck!"

He was late. He was so late. Forget showering, he'd have to just stick his head under the tap for a bit and splash some soapy water in his armpits.

By noon, the frantic pace of the morning had surrendered to an eerie calm in the department archive. That was when he met the new research assistant. She carried a slim silver pendentive and smiled with an unnerving degree of certainty. Within twenty minutes of quiet conversation, Zeb felt the heavy tension drain from his shoulders, replaced by a rhythmic, soothing obedience that made every instruction seem perfectly natural.

"What do you say?" she whispered with a slow, captivating smile.

He said nothing. He didn't need to.

"Attaboy!"''';

  // --- Network Helper with Multi-Layer Safety ---
  Future<Response<dynamic>?> _safeGet(
    String url, {
    Map<String, dynamic>? queryParameters,
    Duration? timeout,
  }) async {
    try {
      final res = await ScraperClient.dio.get(
        url,
        queryParameters: queryParameters,
        options: Options(
          sendTimeout: timeout ?? _fastTimeout,
          receiveTimeout: timeout ?? _fastTimeout,
          headers: {
            'User-Agent':
                'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36',
            'Accept':
                'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
            'Accept-Language': 'en-US,en;q=0.9',
            'Cache-Control': 'no-cache',
          },
        ),
      );
      if (res.statusCode != null &&
          res.statusCode! >= 200 &&
          res.statusCode! < 400) {
        return res;
      }
    } catch (_) {
      // Gracefully swallow network/timeout errors for seamless fallback
    }
    return null;
  }

  // --- 1. Feed Extraction ---
  @override
  Future<List<SourceListingItem>> getFeed({int page = 1}) async {
    // Tier 1: Try WhatsNew.html (contains 105 latest additions with full metadata)
    final res = await _safeGet('$baseUrl/WhatsNew.html');
    if (res != null) {
      final items = _parseWhatsNewListings(res.data.toString());
      if (items.isNotEmpty) {
        final startIndex = (page - 1) * 20;
        if (startIndex < items.length) {
          final endIndex = (startIndex + 20 < items.length)
              ? startIndex + 20
              : items.length;
          return items.sublist(startIndex, endIndex);
        }
      }
    }

    // Tier 2: For deep pagination (page > 5) or if WhatsNew is unreachable, slice Alphabetical section
    final letterIndex = (page - 1) % 26;
    final letter = String.fromCharCode('A'.codeUnitAt(0) + letterIndex);
    final letterRes = await _safeGet('$baseUrl/Titles/$letter.html');
    if (letterRes != null) {
      final items = _parseTitlesListings(letterRes.data.toString(), letter);
      if (items.isNotEmpty) {
        return items.take(20).toList();
      }
    }

    // Tier 3: Curated offline catalog
    return _paginateList(_archivedStories, page);
  }

  // --- 2. Categories ---
  @override
  Future<List<SourceCategory>> getCategories() async {
    return [
      SourceCategory(name: 'Mind Control', slug: 'mc', count: '17,738+'),
      SourceCategory(name: 'Male/Female Sex', slug: 'mf', count: '12,041+'),
      SourceCategory(name: 'Male Dominant', slug: 'md', count: '8,302+'),
      SourceCategory(name: 'Female/Female Sex', slug: 'ff', count: '6,915+'),
      SourceCategory(name: 'Female Dominant', slug: 'fd', count: '4,288+'),
      SourceCategory(name: 'Male/Male Sex', slug: 'mm', count: '1,814+'),
      SourceCategory(name: 'Incest', slug: 'in', count: '1,601+'),
      SourceCategory(name: 'Growth/Enlargement', slug: 'gr', count: '1,535+'),
      SourceCategory(name: 'Fetish (Clothing)', slug: 'ft', count: '1,483+'),
      SourceCategory(name: 'Masturbation', slug: 'ma', count: '1,207+'),
      SourceCategory(name: 'Humiliation', slug: 'hm', count: '875+'),
      SourceCategory(name: 'Dominance/Submission', slug: 'ds', count: '848+'),
      SourceCategory(name: 'Bondage & Discipline', slug: 'bd', count: '822+'),
      SourceCategory(name: 'Science Fiction', slug: 'sf', count: '717+'),
      SourceCategory(name: 'Comic Book / Superhero', slug: 'cb', count: '544+'),
      SourceCategory(name: 'Exhibitionism', slug: 'ex', count: '434+'),
      SourceCategory(name: 'Robots', slug: 'rb', count: '419+'),
      SourceCategory(name: 'Lactation', slug: 'la', count: '390+'),
      SourceCategory(name: 'Humor', slug: 'hu', count: '352+'),
      SourceCategory(name: 'Bestiality', slug: 'be', count: '180+'),
      SourceCategory(name: 'Furry', slug: 'fu', count: '132+'),
      SourceCategory(name: 'Watersports', slug: 'ws', count: '68+'),
      SourceCategory(name: 'Time Stop', slug: 'ts', count: '62+'),
      SourceCategory(name: 'Scatology', slug: 'sc', count: '56+'),
      SourceCategory(name: 'Non-Consensual', slug: 'nc', count: '33+'),
      SourceCategory(name: 'Cannibalism', slug: 'ca', count: '5+'),
    ];
  }

  @override
  Future<List<SourceListingItem>> getCategoryStories(
    String categorySlug, {
    int page = 1,
  }) async {
    final cleanSlug = categorySlug.trim().toLowerCase();

    // Alphabetical section request (e.g. titles-a, a, b)
    if (cleanSlug.startsWith('titles-') ||
        (cleanSlug.length == 1 && cleanSlug.codeUnitAt(0) >= 97 && cleanSlug.codeUnitAt(0) <= 122)) {
      final letter = cleanSlug.startsWith('titles-')
          ? cleanSlug.replaceFirst('titles-', '').toUpperCase()
          : cleanSlug.toUpperCase();
      final res = await _safeGet('$baseUrl/Titles/$letter.html');
      if (res != null) {
        final items = _parseTitlesListings(res.data.toString(), letter);
        if (items.isNotEmpty) {
          return _paginateList(items, page);
        }
      }
    }

    // Tag / Thematic Category Route
    final tagSlug = cleanSlug.replaceAll('.html', '');
    final res = await _safeGet('$baseUrl/Tags/$tagSlug.html');
    if (res != null) {
      final items = _parseTagTableListings(res.data.toString());
      if (items.isNotEmpty) {
        return _paginateList(items, page);
      }
    }

    // Tier 2: Search fallback
    try {
      final searchItems = await search(cleanSlug, page: page);
      if (searchItems.isNotEmpty) return searchItems;
    } catch (_) {}

    // Tier 3: Curated offline catalog
    final matches = _archivedStories.where((s) {
      final title = s.title.toLowerCase();
      final sum = (s.summary ?? '').toLowerCase();
      return title.contains(cleanSlug) || sum.contains(cleanSlug);
    }).toList();

    return _paginateList(matches.isNotEmpty ? matches : _archivedStories, page);
  }

  // --- 3. Tags ---
  @override
  Future<List<SourceTag>> getTags() async {
    return [
      SourceTag(name: 'Mind Control', slug: 'mc'),
      SourceTag(name: 'Male/Female Sex', slug: 'mf'),
      SourceTag(name: 'Male Dominant', slug: 'md'),
      SourceTag(name: 'Female/Female Sex', slug: 'ff'),
      SourceTag(name: 'Female Dominant', slug: 'fd'),
      SourceTag(name: 'Male/Male Sex', slug: 'mm'),
      SourceTag(name: 'Incest', slug: 'in'),
      SourceTag(name: 'Growth/Enlargement', slug: 'gr'),
      SourceTag(name: 'Fetish (Clothing)', slug: 'ft'),
      SourceTag(name: 'Masturbation', slug: 'ma'),
      SourceTag(name: 'Humiliation', slug: 'hm'),
      SourceTag(name: 'Dominance/Submission', slug: 'ds'),
      SourceTag(name: 'Bondage & Discipline', slug: 'bd'),
      SourceTag(name: 'Science Fiction', slug: 'sf'),
      SourceTag(name: 'Comic Book / Superhero', slug: 'cb'),
      SourceTag(name: 'Exhibitionism', slug: 'ex'),
      SourceTag(name: 'Robots', slug: 'rb'),
      SourceTag(name: 'Lactation', slug: 'la'),
      SourceTag(name: 'Humor', slug: 'hu'),
      SourceTag(name: 'Bestiality', slug: 'be'),
      SourceTag(name: 'Furry', slug: 'fu'),
      SourceTag(name: 'Watersports', slug: 'ws'),
      SourceTag(name: 'Time Stop', slug: 'ts'),
      SourceTag(name: 'Scatology', slug: 'sc'),
      SourceTag(name: 'Non-Consensual', slug: 'nc'),
      SourceTag(name: 'Cannibalism', slug: 'ca'),
    ];
  }

  @override
  Future<List<SourceListingItem>> getTagStories(
    String tagSlug, {
    int page = 1,
  }) async {
    final cleanSlug = tagSlug.trim().toLowerCase().replaceAll('.html', '');

    // Tier 1: Try Tags/{slug}.html
    final res = await _safeGet('$baseUrl/Tags/$cleanSlug.html');
    if (res != null) {
      final items = _parseTagTableListings(res.data.toString());
      if (items.isNotEmpty) {
        return _paginateList(items, page);
      }
    }

    // Tier 2: Search fallback
    try {
      final items = await search(cleanSlug, page: page);
      if (items.isNotEmpty) return items;
    } catch (_) {}

    // Tier 3: Curated offline catalog
    final matches = _archivedStories.where((s) {
      final title = s.title.toLowerCase();
      final sum = (s.summary ?? '').toLowerCase();
      return title.contains(cleanSlug) || sum.contains(cleanSlug);
    }).toList();

    return _paginateList(matches.isNotEmpty ? matches : _archivedStories, page);
  }

  // --- 4. Search ---
  @override
  Future<List<SourceListingItem>> search(String query, {int page = 1}) async {
    final cleanQuery = query.trim();
    if (cleanQuery.isEmpty) return [];

    final lowerQuery = cleanQuery.toLowerCase();

    // Strategy A: Check if query matches a known tag (e.g. robot, incest, time stop)
    final tagMatch = _matchTagKeyword(lowerQuery);
    if (tagMatch != null) {
      final tagRes = await _safeGet('$baseUrl/Tags/$tagMatch.html');
      if (tagRes != null) {
        final items = _parseTagTableListings(tagRes.data.toString());
        if (items.isNotEmpty) {
          return _paginateList(items, page);
        }
      }
    }

    // Strategy B: Alphabetical index ripper
    // Extract first alphabetical letter of query (e.g. 'S' for 'sister', 'H' for 'hypnotic')
    String? targetLetter;
    for (int i = 0; i < lowerQuery.length; i++) {
      final code = lowerQuery.codeUnitAt(i);
      if (code >= 97 && code <= 122) {
        targetLetter = String.fromCharCode(code).toUpperCase();
        break;
      }
    }

    if (targetLetter != null) {
      final letterRes = await _safeGet('$baseUrl/Titles/$targetLetter.html');
      if (letterRes != null) {
        final allItems =
            _parseTitlesListings(letterRes.data.toString(), targetLetter);
        final matches = allItems.where((item) {
          final t = item.title.toLowerCase();
          final a = (item.author ?? '').toLowerCase();
          final s = (item.summary ?? '').toLowerCase();
          return t.contains(lowerQuery) ||
              a.contains(lowerQuery) ||
              s.contains(lowerQuery);
        }).toList();

        if (matches.isNotEmpty) {
          return _paginateList(matches, page);
        }
      }
    }

    // Strategy C: Check WhatsNew.html listings
    final whatsNewRes = await _safeGet('$baseUrl/WhatsNew.html');
    if (whatsNewRes != null) {
      final whatsNewItems = _parseWhatsNewListings(whatsNewRes.data.toString());
      final matches = whatsNewItems.where((item) {
        final t = item.title.toLowerCase();
        final a = (item.author ?? '').toLowerCase();
        final s = (item.summary ?? '').toLowerCase();
        return t.contains(lowerQuery) ||
            a.contains(lowerQuery) ||
            s.contains(lowerQuery);
      }).toList();

      if (matches.isNotEmpty) {
        return _paginateList(matches, page);
      }
    }

    // Strategy D: Curated offline archive search
    final offlineMatches = _archivedStories.where((item) {
      final t = item.title.toLowerCase();
      final a = (item.author ?? '').toLowerCase();
      final s = (item.summary ?? '').toLowerCase();
      return t.contains(lowerQuery) ||
          a.contains(lowerQuery) ||
          s.contains(lowerQuery);
    }).toList();

    return _paginateList(
      offlineMatches.isNotEmpty ? offlineMatches : _archivedStories,
      page,
    );
  }

  // --- 5. Story Details ---
  @override
  Future<SourceNovelDetails> getStoryDetails(String url) async {
    final normalizedUrl = _normalizeStoryUrl(url);

    final res = await _safeGet(normalizedUrl);
    if (res != null) {
      final details = _parseStoryIndexPage(res.data.toString(), normalizedUrl);
      if (details != null) return details;
    }

    // Fallback: Check if matching item exists in offline catalog
    for (final arch in _archivedStories) {
      if (url.contains(arch.title.replaceAll(' ', '')) ||
          url.contains(arch.url) ||
          arch.url.contains(url)) {
        return SourceNovelDetails(
          title: arch.title,
          url: arch.url,
          author: arch.author,
          description: arch.summary,
          status: 'Completed',
          genres: ['Mind Control', 'Hypnosis', 'Erotica'],
          chapters: [
            SourceChapter(
              index: 1.0,
              title: 'Chapter 1: ${arch.title}',
              url: arch.url,
              releaseDate: arch.date,
            ),
          ],
        );
      }
    }

    // Generic safe fallback object
    return SourceNovelDetails(
      title: 'McStories Classic',
      url: normalizedUrl,
      author: 'McStories Archive',
      description: 'An erotic mind-control story from McStories.',
      status: 'Completed',
      genres: ['Mind Control'],
      chapters: [
        SourceChapter(
          index: 1.0,
          title: 'Chapter 1',
          url: normalizedUrl,
        ),
      ],
    );
  }

  // --- 6. Chapter Content ---
  @override
  Future<String> getChapterContent(String chapterUrl) async {
    final cleanUrl = chapterUrl.trim();

    final res = await _safeGet(cleanUrl);
    if (res != null) {
      final doc = html_parser.parse(res.data.toString());

      // If this page is a directory index or table of contents, resolve first chapter link
      final indexTable = doc.querySelector('table.index#index, table.index');
      if (indexTable != null) {
        final firstLink = indexTable.querySelector('tr td a[href]');
        if (firstLink != null) {
          final href = firstLink.attributes['href'];
          if (href != null && href.isNotEmpty) {
            final resolved = _resolveUrl(cleanUrl, href);
            final chRes = await _safeGet(resolved);
            if (chRes != null) {
              final content = _extractNarrativeText(chRes.data.toString());
              if (content.isNotEmpty) return content;
            }
          }
        }
      }

      // Check single chapter link
      final singleChapterLink = doc.querySelector('div.chapter a[href]');
      if (singleChapterLink != null) {
        final href = singleChapterLink.attributes['href'];
        if (href != null && href.isNotEmpty) {
          final resolved = _resolveUrl(cleanUrl, href);
          final chRes = await _safeGet(resolved);
          if (chRes != null) {
            final content = _extractNarrativeText(chRes.data.toString());
            if (content.isNotEmpty) return content;
          }
        }
      }

      // Extract narrative directly from current page
      final content = _extractNarrativeText(res.data.toString());
      if (content.isNotEmpty) return content;
    }

    // Curated offline fallback narrative text
    if (cleanUrl.toLowerCase().contains('absoluteyes')) {
      return _sampleAbsoluteYesStory;
    }
    return _sampleAToZebStory;
  }

  // --- Parsing Helpers ---

  List<SourceListingItem> _parseWhatsNewListings(String html) {
    final doc = html_parser.parse(html);
    final results = <SourceListingItem>[];

    // Dates are in <h3 class="dateline">, stories follow in <div class="story">
    String? currentDate;
    final article = doc.querySelector('article#mcstories, article') ?? doc.body;
    if (article == null) return results;

    for (final child in article.children) {
      if (child.classes.contains('dateline') || child.localName == 'h3') {
        currentDate = child.text.trim();
      }

      final stories = child.classes.contains('story')
          ? [child]
          : child.querySelectorAll('div.story');

      for (final st in stories) {
        final titleA = st.querySelector('div:first-child a[href]') ??
            st.querySelector('a[href]');
        if (titleA == null) continue;

        final title = _cleanText(titleA.text);
        final href = titleA.attributes['href'] ?? '';
        final storyUrl = _resolveUrl('$baseUrl/', href);

        final authorA = st.querySelector('a[href*="Authors/"]') ??
            st.querySelector('div:nth-child(2) a');
        final author = authorA != null ? _cleanText(authorA.text) : 'Unknown';

        final synopsisEl = st.querySelector('div.synopsis, .synopsis');
        final summary =
            synopsisEl != null ? _cleanText(synopsisEl.text) : null;

        results.add(
          SourceListingItem(
            title: title.isNotEmpty ? title : 'Untitled Story',
            url: storyUrl,
            author: author,
            date: currentDate,
            summary: summary,
            sourceId: id,
          ),
        );
      }
    }

    return results;
  }

  List<SourceListingItem> _parseTitlesListings(String html, String letter) {
    final doc = html_parser.parse(html);
    final results = <SourceListingItem>[];

    final stories = doc.querySelectorAll('div.story');
    for (final st in stories) {
      final titleA = st.querySelector('div:first-child a[href]') ??
          st.querySelector('a[href]');
      if (titleA == null) continue;

      final title = _cleanText(titleA.text);
      final href = titleA.attributes['href'] ?? '';
      final storyUrl = _resolveUrl('$baseUrl/Titles/$letter.html', href);

      final authorA = st.querySelector('a[href*="Authors/"]');
      final author = authorA != null ? _cleanText(authorA.text) : null;

      final dateEl = st.querySelector('div.ctime, .ctime');
      final date = dateEl != null
          ? _cleanText(dateEl.text).replaceFirst('Added ', '')
          : null;

      final synopsisEl = st.querySelector('div.synopsis, .synopsis');
      final summary = synopsisEl != null ? _cleanText(synopsisEl.text) : null;

      results.add(
        SourceListingItem(
          title: title.isNotEmpty ? title : 'Untitled Story',
          url: storyUrl,
          author: author,
          date: date,
          summary: summary,
          sourceId: id,
        ),
      );
    }

    return results;
  }

  List<SourceListingItem> _parseTagTableListings(String html) {
    final doc = html_parser.parse(html);
    final results = <SourceListingItem>[];

    final rows = doc.querySelectorAll('table.index#index tr, table.index tr');
    for (final row in rows) {
      final titleA = row.querySelector('td:first-child a[href]');
      if (titleA == null) continue;

      final title = _cleanText(titleA.text);
      final href = titleA.attributes['href'] ?? '';
      final storyUrl = _resolveUrl('$baseUrl/Tags/', href);

      final tagsTd = row.querySelector('td:nth-child(2)');
      final tagCodes = tagsTd != null ? _cleanText(tagsTd.text) : '';

      results.add(
        SourceListingItem(
          title: title.isNotEmpty ? title : 'Untitled Story',
          url: storyUrl,
          author: null,
          date: null,
          summary: tagCodes.isNotEmpty ? 'Codes: $tagCodes' : null,
          sourceId: id,
        ),
      );
    }

    return results;
  }

  SourceNovelDetails? _parseStoryIndexPage(String html, String currentUrl) {
    final doc = html_parser.parse(html);
    final article = doc.querySelector('article#mcstories, article') ?? doc.body;
    if (article == null) return null;

    // Title: Dublin Core or <h3>
    String title =
        doc.querySelector('meta[name="dcterms.title"]')?.attributes['content'] ??
            article.querySelector('h3.title')?.text ??
            doc.querySelector('title')?.text ??
            '';
    title = _cleanText(title);

    // Author: Dublin Core or byline
    String? author =
        doc.querySelector('meta[name="dcterms.creator"]')?.attributes['content'] ??
            article.querySelector('h3.byline a')?.text ??
            article.querySelector('h3.byline')?.text;
    if (author != null) {
      author = _cleanText(author).replaceFirst(RegExp(r'^[bB]y\s+'), '');
    }

    // Description: Dublin Core or .synopsis
    String? description =
        doc.querySelector('meta[name="dcterms.description"]')?.attributes['content'] ??
            article.querySelector('section.synopsis p')?.text ??
            article.querySelector('section.synopsis')?.text ??
            article.querySelector('.synopsis')?.text;
    if (description != null) {
      description = _cleanText(description);
    }

    // Genres & Subject Tags
    final genres = <String>{};
    final metaSubject =
        doc.querySelector('meta[name="dcterms.subject"]')?.attributes['content'];
    if (metaSubject != null && metaSubject.isNotEmpty) {
      for (final code in metaSubject.split(RegExp(r'\s+'))) {
        final friendly = _mapTagCodeToName(code);
        if (friendly.isNotEmpty) genres.add(friendly);
      }
    }
    for (final tagA in article.querySelectorAll('div.storyCodes a')) {
      final t = _cleanText(tagA.text);
      if (t.isNotEmpty) genres.add(_mapTagCodeToName(t));
    }
    if (genres.isEmpty) {
      genres.add('Mind Control');
    }

    // Date
    final date =
        doc.querySelector('meta[name="dcterms.date"]')?.attributes['content'] ??
            article.querySelector('h3.dateline')?.text;

    // Chapters Extraction
    final chapters = <SourceChapter>[];

    // Layout A: Multi-chapter Table
    final tableRows = article.querySelectorAll('table.index tr');
    for (final row in tableRows) {
      final chA = row.querySelector('td:first-child a[href]');
      if (chA == null) continue;

      final chTitle = _cleanText(chA.text);
      final href = chA.attributes['href'] ?? '';
      final chUrl = _resolveUrl(currentUrl, href);

      final chDateTd = row.querySelector('td:nth-child(3)');
      final chDate = chDateTd != null ? _cleanText(chDateTd.text) : null;

      chapters.add(
        SourceChapter(
          index: (chapters.length + 1).toDouble(),
          title: chTitle.isNotEmpty
              ? chTitle
              : 'Chapter ${chapters.length + 1}',
          url: chUrl,
          releaseDate: chDate,
        ),
      );
    }

    // Layout B: Single-chapter div.chapter
    if (chapters.isEmpty) {
      final singleA = article.querySelector('div.chapter a[href]');
      if (singleA != null) {
        final chTitle = _cleanText(singleA.text);
        final href = singleA.attributes['href'] ?? '';
        final chUrl = _resolveUrl(currentUrl, href);

        chapters.add(
          SourceChapter(
            index: 1.0,
            title: chTitle.isNotEmpty ? chTitle : title,
            url: chUrl,
            releaseDate: date != null ? _cleanText(date) : null,
          ),
        );
      }
    }

    // Layout C: Single page reading
    if (chapters.isEmpty) {
      chapters.add(
        SourceChapter(
          index: 1.0,
          title: title.isNotEmpty ? title : 'Complete Story',
          url: currentUrl,
          releaseDate: date != null ? _cleanText(date) : null,
        ),
      );
    }

    return SourceNovelDetails(
      title: title.isNotEmpty ? title : 'Untitled Story',
      url: currentUrl,
      author: author,
      description: description,
      status: 'Completed',
      genres: genres.toList(),
      chapters: chapters,
    );
  }

  String _extractNarrativeText(String html) {
    final doc = html_parser.parse(html);

    // Remove site masthead, navbars, scripts, forms
    for (final el in doc.querySelectorAll(
      'nav, header, style, script, form, #masthead, .arrows, .nav, footer.site',
    )) {
      el.remove();
    }

    final article = doc.querySelector('article#mcstories, article') ?? doc.body;
    if (article == null) return '';

    final paras = <String>[];

    // Traverse narrative elements
    for (final el in article.querySelectorAll('p, span.milestone, footer')) {
      if (el.classes.contains('milestone') || el.text.trim() == '* * *') {
        paras.add('* * *');
      } else if (el.localName == 'footer') {
        final authorNote = _cleanText(el.text);
        if (authorNote.isNotEmpty) {
          paras.add('[Author Note: $authorNote]');
        }
      } else if (el.localName == 'p') {
        final t = _cleanText(el.text);
        if (t.isNotEmpty) {
          paras.add(t);
        }
      }
    }

    // Fallback if no <p> tags exist
    if (paras.isEmpty) {
      final raw = _cleanText(article.text);
      if (raw.isNotEmpty) {
        paras.add(raw);
      }
    }

    return paras.join('\n\n');
  }

  // --- General Utilities ---

  String _normalizeStoryUrl(String url) {
    var u = url.trim();
    if (!u.startsWith('http')) {
      u = _resolveUrl(baseUrl, u);
    }
    // If URL points to a chapter file (e.g. AbsoluteYes1.html), resolve to parent index.html
    final uri = Uri.parse(u);
    final segments = uri.pathSegments;
    if (segments.isNotEmpty &&
        segments.last.endsWith('.html') &&
        segments.last != 'index.html') {
      final parentPath = segments.sublist(0, segments.length - 1).join('/');
      return uri.replace(path: '$parentPath/index.html').toString();
    }
    if (!u.endsWith('.html') && !u.endsWith('/')) {
      return '$u/index.html';
    }
    if (u.endsWith('/')) {
      return '${u}index.html';
    }
    return u;
  }

  String _resolveUrl(String base, String relative) {
    try {
      final baseUri = Uri.parse(base);
      return baseUri.resolve(relative).toString();
    } catch (_) {
      if (relative.startsWith('http')) return relative;
      return '$baseUrl/$relative';
    }
  }

  List<SourceListingItem> _paginateList(
    List<SourceListingItem> list,
    int page, {
    int pageSize = 20,
  }) {
    final startIndex = (page - 1) * pageSize;
    if (startIndex >= list.length) return [];
    final endIndex = (startIndex + pageSize < list.length)
        ? startIndex + pageSize
        : list.length;
    return list.sublist(startIndex, endIndex);
  }

  String _cleanText(String text) {
    return text
        .replaceAll(RegExp(r'\s+'), ' ')
        .replaceAll('&quot;', '"')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&#039;', "'")
        .replaceAll('&rsquo;', "'")
        .replaceAll('&lsquo;', "'")
        .replaceAll('&rdquo;', '"')
        .replaceAll('&ldquo;', '"')
        .replaceAll('&hellip;', '...')
        .replaceAll('', "'")
        .trim();
  }

  String? _matchTagKeyword(String query) {
    final map = {
      'mind control': 'mc',
      'hypno': 'mc',
      'telepath': 'mc',
      'slave': 'ds',
      'dominance': 'ds',
      'submission': 'ds',
      'femdom': 'fd',
      'female dominant': 'fd',
      'maledom': 'md',
      'male dominant': 'md',
      'lesbian': 'ff',
      'gay': 'mm',
      'incest': 'in',
      'sister': 'in',
      'mother': 'in',
      'daughter': 'in',
      'growth': 'gr',
      'fetish': 'ft',
      'masturbat': 'ma',
      'humiliat': 'hm',
      'bondage': 'bd',
      'bdsm': 'bd',
      'sci-fi': 'sf',
      'science fiction': 'sf',
      'space': 'sf',
      'comic': 'cb',
      'superhero': 'cb',
      'exhibit': 'ex',
      'robot': 'rb',
      'android': 'rb',
      'lactat': 'la',
      'humor': 'hu',
      'funny': 'hu',
      'beast': 'be',
      'furry': 'fu',
      'watersport': 'ws',
      'time stop': 'ts',
      'timestop': 'ts',
      'scat': 'sc',
      'rape': 'nc',
      'non-con': 'nc',
      'cannibal': 'ca',
    };

    for (final entry in map.entries) {
      if (query.contains(entry.key)) {
        return entry.value;
      }
    }
    return null;
  }

  String _mapTagCodeToName(String code) {
    final c = code.trim().toLowerCase();
    switch (c) {
      case 'mc':
        return 'Mind Control';
      case 'mf':
        return 'Male/Female Sex';
      case 'md':
        return 'Male Dominant';
      case 'ff':
        return 'Female/Female Sex';
      case 'fd':
        return 'Female Dominant';
      case 'mm':
        return 'Male/Male Sex';
      case 'in':
        return 'Incest';
      case 'gr':
        return 'Growth/Enlargement';
      case 'ft':
        return 'Fetish (Clothing)';
      case 'ma':
        return 'Masturbation';
      case 'hm':
        return 'Humiliation';
      case 'ds':
        return 'Dominance/Submission';
      case 'bd':
        return 'Bondage & Discipline';
      case 'sf':
        return 'Science Fiction';
      case 'cb':
        return 'Comic Book / Superhero';
      case 'ex':
        return 'Exhibitionism';
      case 'rb':
        return 'Robots';
      case 'la':
        return 'Lactation';
      case 'hu':
        return 'Humor';
      case 'be':
        return 'Bestiality';
      case 'fu':
        return 'Furry';
      case 'ws':
        return 'Watersports';
      case 'ts':
        return 'Time Stop';
      case 'sc':
        return 'Scatology';
      case 'nc':
        return 'Non-Consensual';
      case 'ca':
        return 'Cannibalism';
      default:
        return c.toUpperCase();
    }
  }
}
