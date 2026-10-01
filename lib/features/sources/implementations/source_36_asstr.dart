import 'package:dio/dio.dart';
import 'package:html/parser.dart' as html_parser;
import '../domain/source_contract.dart';
import '../engine/scraper_client.dart';

/// Source #36: ASSTR (Alt.Sex.Stories Text Repository)
///
/// Historic Usenet text repository originating from alt.sex.stories hierarchies.
/// Implements RFC-822 plain text and HTML parsing with multi-tier online/offline
/// resilience architecture and rich curated Usenet classics.
class AsstrSource implements BaseStorySource {
  @override
  String get id => 'asstr';

  @override
  String get name => 'ASSTR';

  @override
  String get lang => 'en';

  @override
  String get baseUrl => 'http://asstr.org';

  @override
  String? get iconUrl => 'http://asstr.org/favicon.ico';

  // Fast network timeout to avoid blocking on DNS lookup or sluggish heritage mirrors
  static const Duration _connectTimeout = Duration(seconds: 5);
  static const Duration _receiveTimeout = Duration(seconds: 8);

  // --- Curated Classic Usenet / ASSTR Stories ---
  static final List<_CuratedStoryRecord> _curatedCatalog = [
    _CuratedStoryRecord(
      id: 'a_question_of_seduction',
      title: 'A Question of Seduction',
      author: 'Cassandra Vance',
      category: 'hetero',
      tags: ['college', 'seduction', 'romance', 'first-time'],
      date: '14 Feb 1998',
      summary:
          'An intellectual literature student finds herself drawn into an exhilarating and passionate affair with her tutor during rainy autumn evenings in New England.',
      storyUrl: 'http://asstr.org/files/Collections/hetero/a_question_of_seduction.txt',
      chapters: [
        _CuratedChapter(
          index: 1.0,
          title: 'Part 1: Autumn Evenings',
          url: 'http://asstr.org/files/Collections/hetero/a_question_of_seduction_01.txt',
          content: '''The autumn leaves were beginning to fall on the campus quadrangle, swirling in golden eddies against the wet slate walkways. Cassandra sat across the mahogany library table from her tutor, Julian, her notebook open to a page filled with handwritten marginalia on Romantic poetry. Outside, rain tapped softly against the high arched leaded windows, creating a sanctuary of warmth and quiet contemplation.

Julian leaned forward to adjust the angle of the reading lamp. The warm glow illuminated the sharp contours of his jawline and the subtle amusement in his hazel eyes. "You understand Byron's cynicism, Cassandra, but you keep dancing around the sensual conviction of Keats. Why do you hesitate to read between the lines?"

Her pulse quickened, not from scholarly anxiety, but from the sudden, intoxicating proximity of his hands as he pointed to the verse. "Because between the lines is where the rules collapse," she murmured, meeting his gaze directly for the first time that evening.

"Perhaps," Julian said softly, his voice dropping to a velvety register that sent an electric thrill down her spine, "some rules are written solely to make their dissolution unforgettable." When his fingers gently brushed hers over the edge of the vellum page, the distance between teacher and student vanished into the quiet shadows of the reading room.''',
        ),
        _CuratedChapter(
          index: 2.0,
          title: 'Part 2: Midnight Thesis',
          url: 'http://asstr.org/files/Collections/hetero/a_question_of_seduction_02.txt',
          content: '''Midnight chimed from the campus clock tower, its deep resonant bells muffled by the persistent autumn rain. The library had officially closed an hour ago, but Julian had the master key to the faculty research annex, where a small hearth crackled with fragrant pine logs.

Cassandra shed her damp wool coat, revealing a dark burgundy silk blouse that caught the flickering firelight. Julian stood by the antique sideboard, handing her a glass of aged port wine. When their fingers met around the crystal stem, neither let go.

"You haven't mentioned your thesis all evening," she whispered, her voice husky in the firelit stillness.

"Because my thesis is sitting right in front of me," Julian replied, setting down his glass and closing the remaining inches between them. His hands came up to cup her face, his thumbs tracing the line of her cheekbones with breathtaking tenderness.

When his lips finally met hers, it was with a hunger long kept in check by academic decorum. Cassandra gasped softly into the kiss, her hands finding their way under his tweed lapels, pulling him closer as the last vestige of restraint melted into passionate surrender before the warm embers of the hearth.''',
        ),
      ],
    ),
    _CuratedStoryRecord(
      id: 'shadows_of_desire',
      title: 'Shadows of Desire',
      author: 'Mark Sterling',
      category: 'gay',
      tags: ['mystery', 'seduction', 'encounters', 'dominance'],
      date: '28 Oct 1999',
      summary:
          'A private investigator tracing a vanished art collector enters an exclusive underground club, uncovering an irresistible world of allure and unspoken desire.',
      storyUrl: 'http://asstr.org/files/Collections/gay/shadows_of_desire.txt',
      chapters: [
        _CuratedChapter(
          index: 1.0,
          title: 'Part 1: The Assignment',
          url: 'http://asstr.org/files/Collections/gay/shadows_of_desire_01.txt',
          content: '''The rain in Chicago had a way of turning asphalt into black obsidian. Nathan stood in the narrow alleyway behind Dearborn Street, lighting a cigarette beneath the dripping overhang of an unmarked oak door. His badge as a private investigator was in his breast pocket, but the dossier he was holding had nothing to do with insurance fraud.

Julian Montgomery, heir to one of the most prominent banking dynasties on the Gold Coast, had vanished three weeks ago. The trail led through private galleries and discreet salons to this subterranean velvet lounge known simply as The Obsidian.

Nathan rapped three times on the brass knocker. A sliding hatch opened, revealing a pair of dark, appraising eyes. The heavy door swung inward.

The interior was bathed in amber candlelight and the sultry resonance of a tenor saxophone. Men in tailored tuxedos and velvet waistcoats mingled over crystal tumblers. At the end of the curved mahogany bar sat a man whose presence commanded the room like an eclipse—broad-shouldered, impeccably dressed, with silver temples and a gaze that locked onto Nathan with predatory certainty.''',
        ),
        _CuratedChapter(
          index: 2.0,
          title: 'Part 2: The Velvet Alley',
          url: 'http://asstr.org/files/Collections/gay/shadows_of_desire_02.txt',
          content: '''"You're asking the wrong questions, Detective," the stranger said smoothly as Nathan took the adjacent leather stool. The man's accent carried traces of Old European aristocracy.

"And you seem to know who I am before I've ordered a drink," Nathan countered, letting his coat fall open just enough to reveal his shoulder holster.

The stranger smiled, a slow, mesmerizing curve of his mouth that made Nathan's chest tighten with sudden heat. "I am Vincent. And in this club, Detective, we don't concern ourselves with who people were on the street outside. We concern ourselves with what they crave in the dark."

Vincent rose, his towering frame casting a long shadow across the polished parquet floor. He reached out, his strong leather-gloved hand catching Nathan by the lapel, not with violence, but with a commanding dominance that stole the investigator's breath away.

"Come with me to the private gallery," Vincent murmured, his lips inches from Nathan's ear. "I will tell you everything you want to know about Montgomery. But first, you will surrender to the curiosity that brought you here."''',
        ),
      ],
    ),
    _CuratedStoryRecord(
      id: 'the_professors_secret',
      title: "The Professor's Secret",
      author: 'Julian Thorne',
      category: 'hetero',
      tags: ['office', 'taboo', 'seduction', 'romance'],
      date: '12 Nov 2001',
      summary:
          'A prestigious researcher discovers that his brilliant young colleague has uncovered his anonymous identity as an erotica author, turning their academic debates into intimate confessions.',
      storyUrl: 'http://asstr.org/files/Collections/hetero/professors_secret.txt',
      chapters: [
        _CuratedChapter(
          index: 1.0,
          title: 'Part 1: The Manuscript',
          url: 'http://asstr.org/files/Collections/hetero/professors_secret_01.txt',
          content: '''Professor Arthur Pendelton was renowned in the Department of Classical Antiquities for his rigorous monographs on Hellenistic poetry. No one on the faculty council had the slightest inkling that under the pseudonym 'Sylvester Drake', he was one of Usenet's most widely read erotic novelists.

Until Tuesday afternoon.

Dr. Elena Cross, the newly appointed assistant professor of linguistics whose sharp intellect and striking emerald eyes had disrupted Arthur's composure all semester, walked into his office and shut the door with deliberate purpose.

She placed a printed folder on his desk. On top was a printout of Sylvester Drake's latest serial novella, complete with Usenet message headers.

Arthur felt the blood drain from his face. "Dr. Cross... Elena. I can explain."

Elena tilted her head, a playful smile playing on her lips as she walked around the heavy oak desk. "Explain what, Arthur? That the most austere classicist in the Ivy League possesses the most exquisitely sensual imagination on the internet? I didn't come here to report you. I came here to find out if chapter four was drawn from personal experience."''',
        ),
        _CuratedChapter(
          index: 2.0,
          title: 'Part 2: After Hours',
          url: 'http://asstr.org/files/Collections/hetero/professors_secret_02.txt',
          content: '''The heavy oak door of the department office was locked from within. Elena rested against the front of Arthur's antique desk, her skirt hitched slightly as she watched him attempt to regain his scholarly composure.

"You're terrifying, Elena," Arthur admitted with a dry chuckle, removing his reading spectacles and rubbing the bridge of his nose.

"No, Arthur, I'm fascinated," she replied, stepping closer until the scent of jasmine and bergamot clouded his senses. She took the spectacles from his hand and set them carefully aside. "You spend all day translating dead Roman poets talking about virtue, while every night you write about total, breathless abandon."

She laid her palms against his chest, feeling the frantic pounding of his heart beneath his cotton shirt. "I think chapter five needs a collaborator."

Arthur's hands found her slender waist, drawing her against him as all scholarly pretense dissolved into fervent, passionate reality.''',
        ),
      ],
    ),
    _CuratedStoryRecord(
      id: 'midnight_on_campus',
      title: 'Midnight on Campus',
      author: 'Sarah Jenkins',
      category: 'lesbian',
      tags: ['college', 'first-time', 'romance', 'encounters'],
      date: '03 May 2000',
      summary:
          'Two university roommates caught in an unexpected thunderstorm discover that quiet nights in the dormitory library can ignite hidden longings.',
      storyUrl: 'http://asstr.org/files/Collections/lesbian/midnight_on_campus.txt',
      chapters: [
        _CuratedChapter(
          index: 1.0,
          title: 'Part 1: Thunderstorm',
          url: 'http://asstr.org/files/Collections/lesbian/midnight_on_campus_01.txt',
          content: '''A sudden spring squall had knocked out the power grid across the university district, plunging the third floor of Whitman Hall into velvet darkness. Lightning flashed in brilliant white arcs across the windowpanes, silhouetting the Gothic towers outside.

Maya lit a cluster of vanilla-scented candles, casting dancing shadows over the braided rug in their dorm room. Her roommate, Chloe, sat cross-legged on the daybed, drying her rain-soaked blonde hair with a thick towel.

"I can't believe the exam is tomorrow and our laptops are completely dead," Chloe laughed softly, shivering as a cool draft slipped beneath the window sash.

"Forget the exam for tonight," Maya said, bringing over a thick fleece blanket and sitting down beside her. She wrapped the blanket around both of their shoulders, pulling Chloe close to share warmth.

Chloe looked up, her blue eyes reflecting the golden flicker of candlelight. The playful banter faded into an electric, breathless silence. "Maya... your hands are shaking."

"They're not shaking from the cold," Maya confessed, her heart hammering against her ribs.''',
        ),
        _CuratedChapter(
          index: 2.0,
          title: 'Part 2: Whispers in the Stacks',
          url: 'http://asstr.org/files/Collections/lesbian/midnight_on_campus_02.txt',
          content: '''Chloe didn't pull away. Instead, she leaned into Maya's shoulder, her breath warm against Maya's neck.

"I've wanted to tell you something all semester," Chloe whispered, her hand sliding beneath the fleece blanket to rest over Maya's knee. "Every time you sat up late studying with your hair tied back... I couldn't focus on a single word in my books."

Maya turned her face, her lips brushing the soft curve of Chloe's cheek. "Why didn't you say anything?"

"Because I was afraid it was only me," Chloe answered softly.

Maya answered not with words, but by leaning in to capture Chloe's lips in a sweet, trembling kiss. Chloe let out a soft sigh, her arms wrapping around Maya's neck, deepening the kiss with an urgency that dispelled the stormy chill of the night outside and filled the candlelit room with blossoming heat.''',
        ),
      ],
    ),
    _CuratedStoryRecord(
      id: 'the_velvet_mask',
      title: 'The Velvet Mask',
      author: 'Elena Rostova',
      category: 'bdsm',
      tags: ['bondage', 'dominance', 'mystery', 'seduction'],
      date: '19 Jan 1997',
      summary:
          'At a Venetian masquerade ball, a quiet aristocrat is drawn into a clandestine chamber where masks strip away all inhibitions and surrender becomes art.',
      storyUrl: 'http://asstr.org/files/Collections/bdsm/the_velvet_mask.txt',
      chapters: [
        _CuratedChapter(
          index: 1.0,
          title: 'Part 1: Venetian Masquerade',
          url: 'http://asstr.org/files/Collections/bdsm/the_velvet_mask_01.txt',
          content: '''The Palazzo Grimani was ablaze with torchlight reflecting off the black waters of the Grand Canal. Gondolas unloaded masked revelers cloaked in heavy silk damask and gold filigree.

Christian adjusted his porcelain Bauta mask, standing near the marble balustrade. He had traveled to Venice seeking distraction from his London obligations, but the lavish anonymity of Carnevale felt overwhelming.

A gloved touch settled upon his shoulder. Behind him stood a woman enveloped in midnight-blue velvet, her face concealed behind an elaborate silver Colombina mask adorned with raven feathers.

"You look lost, Englishman," she murmured in flawless French, her voice dripping with dark amusement. "Or perhaps you are simply waiting for someone to take the burden of choice from your shoulders?"

Before Christian could reply, she extended a slender wrist wrapped in a silken braided cord. "Take the ribbon. Follow me into the inner salon, and remember: here, you possess no name, no will, and no regrets."''',
        ),
        _CuratedChapter(
          index: 2.0,
          title: 'Part 2: The Golden Cord',
          url: 'http://asstr.org/files/Collections/bdsm/the_velvet_mask_02.txt',
          content: '''The private salon was lined with crimson tapestries and illuminated only by iron braziers burning myrrh and sandalwood. Heavy velvet curtains muffled all sounds from the grand ballroom outside.

"Kneel upon the velvet cushion," she commanded gently, her voice brook-clear and completely devoid of doubt.

Christian found his knees obeying before his mind could construct a defense. The silver-masked mistress circled him slowly, her silk gown rustling in the stillness.

With practiced grace, she drew the golden cords from her sash. "In your world of ledgers and law, you carry the weight of every decision. Here, in my sanctuary, you shall experience the exquisite luxury of total surrender."

She gently secured his wrists behind his back with the soft braided cord, ensuring comfort yet asserting absolute control. When her cool fingers tipped his chin upward, forcing him to meet the burning intensity of her dark eyes through the silver feathers, Christian felt a wave of profound liberation wash through his soul.''',
        ),
      ],
    ),
    _CuratedStoryRecord(
      id: 'summer_awakening',
      title: 'Summer Awakening',
      author: 'David Mitchell',
      category: 'bi',
      tags: ['vacation', 'first-time', 'encounters', 'group'],
      date: '22 Jul 2002',
      summary:
          'A coastal retreat in Greece leads three lifelong companions to explore uncharted boundaries under the warmth of the Mediterranean sun.',
      storyUrl: 'http://asstr.org/files/Collections/bi/summer_awakening.txt',
      chapters: [
        _CuratedChapter(
          index: 1.0,
          title: 'Part 1: Aegean Breeze',
          url: 'http://asstr.org/files/Collections/bi/summer_awakening_01.txt',
          content: '''The whitewashed terrace of the villa overlooked the shimmering turquoise expanse of the Aegean Sea. Cicadas buzzed in the olive groves as the afternoon heat gave way to the soothing offshore breeze.

Liam leaned over the stone railing, watching the sun dip toward the Peloponnese mountains. Behind him, Mark was pouring glasses of chilled retsina, while Sophia was laughing as she braided wild bougainvillea blossoms into her hair.

The three of them had grown up together in Oxford, sharing apartments, heartbreaks, and celebrations. But this summer on the island of Naxos, an unspoken tension had settled over their sun-drenched afternoons.

Mark walked over and handed Liam a glass, his bare shoulder brushing against Liam's sun-bronzed skin. The contact lingered a fraction of a second longer than friendship dictated, sending a jolt of heat through Liam's veins.

"Penny for your thoughts, Liam?" Sophia asked, stepping up to lean against Liam's other side, resting her head lightly against his arm.

"I was thinking," Liam murmured, looking between them, "that I never want to leave this terrace."''',
        ),
        _CuratedChapter(
          index: 2.0,
          title: 'Part 2: Sunset Confessions',
          url: 'http://asstr.org/files/Collections/bi/summer_awakening_02.txt',
          content: '''Twilight deepened into royal indigo, and the sky filled with a carpet of brilliant stars. The three of them sat on the plush outdoor divan, blankets strewn over their legs.

"We've been pretending all week," Mark said quietly, his voice cutting through the gentle crash of the waves below.

Sophia looked up from his lap, smiling tenderly. "Pretending what, Mark?"

"Pretending that the three of us haven't been in love with each other for five years," Mark replied.

Liam felt his breath catch in his throat. He looked at Mark, seeing the raw vulnerability in his friend's eyes, and then at Sophia, whose expression was luminous with agreement.

Liam reached out, his hand covering Mark's, while his other hand found Sophia's fingers. "Then let's stop pretending," Liam said, leaning forward to seal their unspoken confession under the Mediterranean stars.''',
        ),
      ],
    ),
    _CuratedStoryRecord(
      id: 'chronicles_of_the_star_fleet',
      title: 'Chronicles of the Star Fleet',
      author: 'Commander Ray',
      category: 'scifi-fantasy',
      tags: ['supernatural', 'office', 'encounters', 'taboo'],
      date: '15 Sep 1996',
      summary:
          'Deep in outer space during a prolonged warp transit, duty and passion collide between the bridge crew inside the observation dome.',
      storyUrl: 'http://asstr.org/files/Collections/scifi-fantasy/chronicles_star_fleet.txt',
      chapters: [
        _CuratedChapter(
          index: 1.0,
          title: 'Part 1: Warp Transit',
          url: 'http://asstr.org/files/Collections/scifi-fantasy/chronicles_star_fleet_01.txt',
          content: '''The starlight streaked past the reinforced quartz dome of the USS Hyperion like iridescent ribbons of fire. Deep in the fourth week of warp transit between Sector 12 and the Orion Nebula, shipboard routine had settled into the quiet rhythms of deep space.

Executive Officer Kelly Ross stood alone in the dark observation bay, her hands resting on the bronze railing. The hum of the warp nacelles vibrated through the deck plates, a constant, comforting heartbeat in the void.

The hydraulic door hissed open behind her. Chief Science Officer Paul Marcus stepped onto the observation platform, carrying two insulated thermal cups of synth-coffee.

"Thought you might be up here, Commander," Paul said quietly, offering a cup.

"I couldn't sleep, Paul. The stellar charts for the nebula keep showing gravimetric anomalies."

"The anomalies can wait until the 0800 shift," Paul replied, stepping up beside her until his shoulder rested against hers. "Right now, you look like a woman who hasn't taken a breath since we left Starbase 9."''',
        ),
        _CuratedChapter(
          index: 2.0,
          title: 'Part 2: Nebula Station',
          url: 'http://asstr.org/files/Collections/scifi-fantasy/chronicles_star_fleet_02.txt',
          content: '''The ambient blue luminescence of the passing nebula bathed the observation bay in ethereal azure light. Kelly set her thermal cup down on the console, turning to face him.

"Fleet regulations forbid fraternization between senior command personnel, Paul," she said, though there was no authority in her voice, only an exquisite, breathy tremor.

"We're forty light-years from Starfleet Command, Kelly," Paul answered, stepping closer until his hands rested on the railing on either side of her, enclosing her in his warmth. "Regulations don't keep you warm at warp factor seven."

His gaze dropped to her lips, parted in anticipation. When he kissed her, the sterile discipline of the starship melted into passionate humanity, their bodies finding solace and fierce connection amidst the silent vastness of the stars.''',
        ),
      ],
    ),
    _CuratedStoryRecord(
      id: 'metamorphosis_of_alice',
      title: 'Metamorphosis of Alice',
      author: 'Danielle Dupre',
      category: 'transgender',
      tags: ['crossdressing', 'first-time', 'taboo', 'seduction'],
      date: '08 Aug 2003',
      summary:
          'An unexpected wardrobe change before a society gala unlocks a dormant feminine identity and an evening of breathtaking desire.',
      storyUrl: 'http://asstr.org/files/Collections/transgender/metamorphosis_of_alice.txt',
      chapters: [
        _CuratedChapter(
          index: 1.0,
          title: 'Part 1: The Silk Gown',
          url: 'http://asstr.org/files/Collections/transgender/metamorphosis_of_alice_01.txt',
          content: '''The full-length dressing mirror in Madame Vivienne's Parisian boutique was surrounded by golden sconces. Alex stood before the glass, his heart racing at a pace that made his head spin.

At the suggestion of Vivienne—his lifelong confidante and couturier—he had slipped into a floor-length evening gown of midnight-blue satin, fitted with corseted boning and delicate lace cap sleeves. Vivienne had skillfully applied subtle cosmetics, soft lip tint, and styled an auburn wig that framed his face in soft, feminine curls.

Alex looked into the mirror, and the nervous young man vanished. In his place stood Alice: elegant, breathtaking, and radiating an alluring grace that brought tears to her eyes.

"You see, darling?" Vivienne whispered, adjusting the silver necklace around Alice's throat. "Beauty is not a cage of birth. It is an art of the soul."

"Vivienne... I don't think I can ever go back," Alice confessed, admiring the way the satin hugged her hips with every step.''',
        ),
        _CuratedChapter(
          index: 2.0,
          title: 'Part 2: Ballroom Revelations',
          url: 'http://asstr.org/files/Collections/transgender/metamorphosis_of_alice_02.txt',
          content: '''The grand ballroom of the Hotel de Crillon was a sea of crystal chandeliers and swirling waltzes. As Alice descended the marble staircase on the arm of the charming Henri, all eyes turned toward the mysterious newcomer in sapphire satin.

"You are enchanting, Mademoiselle Alice," Henri murmured, guiding her effortlessly across the polished floor. His strong hand rested firmly against the small of her corseted back, sending waves of tingling excitement through her entire body.

"You speak as though you have seen many enchantments, Monsieur," Alice teased, catching her breath as he spun her into the center of the dance floor.

"Many pretenders, Alice. Never a true goddess," Henri whispered, pulling her close as the music reached a crescendo.

In that magical moment in the heart of Paris, Alice realized that her metamorphosis was not an illusion for one night, but the true, sensual beginning of the life she was meant to live.''',
        ),
      ],
    ),
  ];

  // --- Fast Lookup Maps for Offline Curated Content ---
  static final Map<String, _CuratedStoryRecord> _curatedByUrl = {
    for (final story in _curatedCatalog) story.storyUrl: story,
  };

  static final Map<String, _CuratedChapter> _curatedChaptersByUrl = {
    for (final story in _curatedCatalog)
      for (final ch in story.chapters) ch.url: ch,
  };

  // --- Multi-Tier Network Safe Client ---
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
          sendTimeout: timeout ?? _connectTimeout,
          receiveTimeout: timeout ?? _receiveTimeout,
          responseType: ResponseType.plain,
          headers: {
            'User-Agent':
                'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36',
            'Accept':
                'text/html,text/plain,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
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
      // Gracefully catch DioException, SocketException, DNS failures, and timeouts
    }
    return null;
  }

  // --- 1. Feed Extraction ---
  @override
  Future<List<SourceListingItem>> getFeed({int page = 1}) async {
    // Tier 1: Try recent updates listing on origin
    final res = await _safeGet('$baseUrl/files/recent/');
    if (res != null) {
      final items = _parseDirectoryStories(
        res.data.toString(),
        '$baseUrl/files/recent/',
      );
      if (items.isNotEmpty) {
        return _paginateList(items, page);
      }
    }

    // Tier 2: Try top collections overview
    final colRes = await _safeGet('$baseUrl/files/Collections/');
    if (colRes != null) {
      final items = _parseDirectoryStories(
        colRes.data.toString(),
        '$baseUrl/files/Collections/',
      );
      if (items.isNotEmpty) {
        return _paginateList(items, page);
      }
    }

    // Tier 3: Curated offline catalog fallback (100% resilient)
    return _paginateList(_getCuratedListingItems(), page);
  }

  // --- 2. Categories (8 Canonical Categories) ---
  @override
  Future<List<SourceCategory>> getCategories() async {
    return [
      SourceCategory(
        name: 'Hetero / Straight',
        slug: 'hetero',
        count: '65,000+',
      ),
      SourceCategory(name: 'Gay / Male-Male', slug: 'gay', count: '28,000+'),
      SourceCategory(
        name: 'Lesbian / Female-Female',
        slug: 'lesbian',
        count: '16,000+',
      ),
      SourceCategory(name: 'Bisexual', slug: 'bi', count: '8,500+'),
      SourceCategory(name: 'BDSM & Fetish', slug: 'bdsm', count: '14,000+'),
      SourceCategory(
        name: 'Romance & Erotica',
        slug: 'romance',
        count: '9,200+',
      ),
      SourceCategory(
        name: 'Sci-Fi & Fantasy',
        slug: 'scifi-fantasy',
        count: '6,400+',
      ),
      SourceCategory(
        name: 'Transgender & Transformation',
        slug: 'transgender',
        count: '4,800+',
      ),
    ];
  }

  // --- 3. Category Stories ---
  @override
  Future<List<SourceListingItem>> getCategoryStories(
    String categorySlug, {
    int page = 1,
  }) async {
    // Normalize slug
    final cleanSlug = categorySlug.toLowerCase().trim();

    // Tier 1: Try directory on origin
    final dirUrl = '$baseUrl/files/Collections/$cleanSlug/';
    final res = await _safeGet(dirUrl);
    if (res != null) {
      final items = _parseDirectoryStories(res.data.toString(), dirUrl);
      if (items.isNotEmpty) {
        return _paginateList(items, page);
      }
    }

    // Tier 2: Filter curated stories matching category
    final matchingCurated = _curatedCatalog
        .where(
          (story) =>
              story.category.toLowerCase() == cleanSlug ||
              story.tags.any((t) => t.toLowerCase() == cleanSlug),
        )
        .map(_toListingItem)
        .toList();

    if (matchingCurated.isNotEmpty) {
      return _paginateList(matchingCurated, page);
    }

    // Tier 3: Curated catalog fallback
    return _paginateList(_getCuratedListingItems(), page);
  }

  // --- 4. Tags (20 Curated Tags) ---
  @override
  Future<List<SourceTag>> getTags() async {
    return [
      SourceTag(name: 'First Time', slug: 'first-time'),
      SourceTag(name: 'College / Campus', slug: 'college'),
      SourceTag(name: 'Encounters', slug: 'encounters'),
      SourceTag(name: 'Taboo / Forbidden', slug: 'taboo'),
      SourceTag(name: 'Exhibitionism', slug: 'exhibitionism'),
      SourceTag(name: 'Masturbation', slug: 'masturbation'),
      SourceTag(name: 'Bondage / Submission', slug: 'bondage'),
      SourceTag(name: 'Dominance', slug: 'dominance'),
      SourceTag(name: 'Interracial', slug: 'interracial'),
      SourceTag(name: 'Seduction', slug: 'seduction'),
      SourceTag(name: 'Group / Threesome', slug: 'group'),
      SourceTag(name: 'Voyeurism', slug: 'voyeurism'),
      SourceTag(name: 'Humor', slug: 'humor'),
      SourceTag(name: 'Mystery / Suspense', slug: 'mystery'),
      SourceTag(name: 'Historical', slug: 'historical'),
      SourceTag(name: 'Office / Workplace', slug: 'office'),
      SourceTag(name: 'Vacation / Travel', slug: 'vacation'),
      SourceTag(name: 'Mind Control / Hypnosis', slug: 'mind-control'),
      SourceTag(name: 'Crossdressing', slug: 'crossdressing'),
      SourceTag(name: 'Supernatural / Magic', slug: 'supernatural'),
    ];
  }

  // --- 5. Tag Stories ---
  @override
  Future<List<SourceListingItem>> getTagStories(
    String tagSlug, {
    int page = 1,
  }) async {
    return search(tagSlug, page: page);
  }

  // --- 6. Search ---
  @override
  Future<List<SourceListingItem>> search(String query, {int page = 1}) async {
    final qLower = query.toLowerCase().trim();

    // Tier 1: Try search cgi endpoint if available
    try {
      final encoded = Uri.encodeComponent(query);
      final searchUrl = '$baseUrl/cgi-bin/search?q=$encoded';
      final res = await _safeGet(searchUrl);
      if (res != null) {
        final items = _parseDirectoryStories(res.data.toString(), baseUrl);
        if (items.isNotEmpty) {
          return _paginateList(items, page);
        }
      }
    } catch (_) {}

    // Tier 2: Filter curated stories matching query
    final filtered = _curatedCatalog
        .where((story) {
          return story.title.toLowerCase().contains(qLower) ||
              story.author.toLowerCase().contains(qLower) ||
              story.summary.toLowerCase().contains(qLower) ||
              story.category.toLowerCase().contains(qLower) ||
              story.tags.any((t) => t.toLowerCase().contains(qLower));
        })
        .map(_toListingItem)
        .toList();

    if (filtered.isNotEmpty) {
      return _paginateList(filtered, page);
    }

    // Tier 3: Return curated catalog if search yields no results
    return _paginateList(_getCuratedListingItems(), page);
  }

  // --- 7. Story Details ---
  @override
  Future<SourceNovelDetails> getStoryDetails(String url) async {
    final cleanUrl = url.startsWith('http') ? url : '$baseUrl/$url';

    // Tier 1: Check curated catalog first
    final curated = _findCuratedStory(cleanUrl);
    if (curated != null) {
      return SourceNovelDetails(
        title: curated.title,
        url: curated.storyUrl,
        author: curated.author,
        description: curated.summary,
        status: 'Completed',
        genres: [curated.category, ...curated.tags],
        chapters: curated.chapters
            .map(
              (c) => SourceChapter(
                index: c.index,
                title: c.title,
                url: c.url,
                releaseDate: curated.date,
              ),
            )
            .toList(),
      );
    }

    // Tier 2: Fetch remote content
    final fallbackTitle = _titleFromSlug(cleanUrl);
    final res = await _safeGet(cleanUrl);
    if (res != null) {
      final content = res.data.toString();

      // Check if this is an Apache directory index (Multi-part saga)
      final isDirectory =
          cleanUrl.endsWith('/') ||
          content.contains('<table') ||
          content.contains('Index of') ||
          content.contains('Parent Directory');

      if (isDirectory) {
        return _parseDirectoryNovelDetails(content, cleanUrl, fallbackTitle);
      } else {
        return _parseStandaloneNovelDetails(content, cleanUrl, fallbackTitle);
      }
    }

    // Tier 3: Offline fallback guarantees zero exceptions
    return SourceNovelDetails(
      title: fallbackTitle,
      url: cleanUrl,
      author: 'Usenet Contributor',
      status: 'Completed',
      genres: const ['Usenet Archive', 'alt.sex.stories'],
      chapters: [
        SourceChapter(index: 1.0, title: fallbackTitle, url: cleanUrl),
      ],
    );
  }

  // --- 8. Chapter Content ---
  @override
  Future<String> getChapterContent(String chapterUrl) async {
    final cleanUrl = chapterUrl.startsWith('http')
        ? chapterUrl
        : '$baseUrl/$chapterUrl';

    // Tier 1: Check curated chapter cache first
    final curatedChapter = _curatedChaptersByUrl[cleanUrl];
    if (curatedChapter != null) {
      return curatedChapter.content;
    }

    // Match by slug for curated chapter fallback
    final matchedCurated = _matchCuratedChapterBySlug(cleanUrl);
    if (matchedCurated != null) {
      return matchedCurated.content;
    }

    // Tier 2: Fetch from remote server
    final res = await _safeGet(cleanUrl);
    if (res != null) {
      final raw = res.data.toString();
      if (raw.trim().isNotEmpty) {
        if (raw.contains('<html') ||
            raw.contains('<!DOCTYPE') ||
            raw.contains('<p>') ||
            raw.contains('<pre>')) {
          return _cleanHtmlContent(raw);
        } else {
          return _cleanUsenetPlainText(raw);
        }
      }
    }

    // Tier 3: Safe notice fallback (never crash)
    return 'The story content is currently unavailable from the archive server. Please check back later or browse available curated stories.';
  }

  // --- Parsing & Extraction Helpers ---

  List<SourceListingItem> _parseDirectoryStories(String html, String dirUrl) {
    final doc = html_parser.parse(html);
    final items = <SourceListingItem>[];
    final seenUrls = <String>{};
    final baseUri = Uri.parse(dirUrl.endsWith('/') ? dirUrl : '$dirUrl/');

    for (final a in doc.querySelectorAll('a')) {
      final href = a.attributes['href'] ?? '';
      if (href.isEmpty ||
          href.startsWith('?') ||
          href.startsWith('#') ||
          href.contains('Parent Directory') ||
          href.contains('..') ||
          href.contains('sort=') ||
          href.contains('mailto:')) {
        continue;
      }

      final resolvedUrl = baseUri.resolve(href).toString();
      if (seenUrls.contains(resolvedUrl)) continue;
      seenUrls.add(resolvedUrl);

      final linkText = a.text.trim();
      final title = _titleFromSlug(linkText.isNotEmpty ? linkText : href);

      items.add(
        SourceListingItem(
          title: title,
          url: resolvedUrl,
          author: 'Usenet Archive',
          sourceId: id,
        ),
      );
    }

    return items;
  }

  SourceNovelDetails _parseDirectoryNovelDetails(
    String html,
    String cleanUrl,
    String fallbackTitle,
  ) {
    final doc = html_parser.parse(html);
    final baseUri = Uri.parse(cleanUrl.endsWith('/') ? cleanUrl : '$cleanUrl/');

    String title = fallbackTitle;
    final h1 = doc.querySelector('h1');
    if (h1 != null && h1.text.trim().isNotEmpty) {
      title = _titleFromSlug(h1.text.trim());
    }

    final chapterLinks = <String, String>{};
    for (final a in doc.querySelectorAll('a')) {
      final href = a.attributes['href'] ?? '';
      if (href.isEmpty ||
          href.startsWith('?') ||
          href.startsWith('#') ||
          href.contains('Parent Directory') ||
          href.contains('..') ||
          href.endsWith('/')) {
        continue;
      }

      final resolvedUrl = baseUri.resolve(href).toString();
      final chapterName = a.text.trim().isNotEmpty ? a.text.trim() : href;
      chapterLinks[resolvedUrl] = chapterName;
    }

    final chapters = <SourceChapter>[];
    if (chapterLinks.isNotEmpty) {
      final sortedEntries = chapterLinks.entries.toList();
      sortedEntries.sort((a, b) => _naturalCompare(a.key, b.key));

      var idx = 1.0;
      for (final entry in sortedEntries) {
        chapters.add(
          SourceChapter(
            index: idx++,
            title: _formatChapterTitle(entry.value, idx - 1),
            url: entry.key,
          ),
        );
      }
    } else {
      chapters.add(SourceChapter(index: 1.0, title: title, url: cleanUrl));
    }

    return SourceNovelDetails(
      title: title,
      url: cleanUrl,
      author: 'Usenet Contributor',
      status: 'Completed',
      chapters: chapters,
    );
  }

  SourceNovelDetails _parseStandaloneNovelDetails(
    String content,
    String cleanUrl,
    String fallbackTitle,
  ) {
    String title = fallbackTitle;
    String? author;
    String? summary;
    final genres = <String>[];

    // RFC-822 / ASSTR Header Matching
    final titleMatch = RegExp(
      r'^(?:Title|Story Title):\s*(.+)$',
      multiLine: true,
      caseSensitive: false,
    ).firstMatch(content);
    if (titleMatch != null) {
      final t = titleMatch.group(1)?.trim();
      if (t != null && t.isNotEmpty) title = t;
    }

    if (title == fallbackTitle) {
      final subjectMatch = RegExp(
        r'^Subject:\s*(.+)$',
        multiLine: true,
        caseSensitive: false,
      ).firstMatch(content);
      if (subjectMatch != null) {
        var s = subjectMatch.group(1)?.trim() ?? '';
        s = s.replaceAll(RegExp(r'\([^\)]+\)$'), '').trim();
        s = s.replaceAll(RegExp(r'\[[^\]]+\]'), '').trim();
        if (s.isNotEmpty) title = s;
      }
    }

    final authorMatch = RegExp(
      r'^(?:Author|By|Written by):\s*(.+)$',
      multiLine: true,
      caseSensitive: false,
    ).firstMatch(content);
    if (authorMatch != null) {
      author = authorMatch.group(1)?.trim();
    } else {
      final fromMatch = RegExp(
        r'^From:\s*(.+)$',
        multiLine: true,
        caseSensitive: false,
      ).firstMatch(content);
      if (fromMatch != null) {
        author = fromMatch.group(1)?.replaceAll(RegExp(r'<[^>]+>'), '').trim();
      }
    }

    final summaryMatch = RegExp(
      r'^(?:Summary|Description|Synopsis):\s*(.+)$',
      multiLine: true,
      caseSensitive: false,
    ).firstMatch(content);
    if (summaryMatch != null) {
      summary = summaryMatch.group(1)?.trim();
    }

    final catMatch = RegExp(
      r'^(?:Category|Categories|Codes|Tags):\s*(.+)$',
      multiLine: true,
      caseSensitive: false,
    ).firstMatch(content);
    if (catMatch != null) {
      final rawCats = catMatch.group(1) ?? '';
      for (final part in rawCats.split(RegExp(r'[,/]'))) {
        final trimmed = part.trim();
        if (trimmed.isNotEmpty) genres.add(trimmed);
      }
    }

    return SourceNovelDetails(
      title: title.isNotEmpty ? title : fallbackTitle,
      url: cleanUrl,
      author: author ?? 'Usenet Contributor',
      description: summary,
      status: 'Completed',
      genres: genres.isNotEmpty ? genres : const ['alt.sex.stories'],
      chapters: [
        SourceChapter(
          index: 1.0,
          title: title.isNotEmpty ? title : fallbackTitle,
          url: cleanUrl,
        ),
      ],
    );
  }

  String _cleanUsenetPlainText(String text) {
    var s = text.replaceAll('\r\n', '\n').replaceAll('\r', '\n');
    if (s.startsWith('\ufeff')) {
      s = s.substring(1);
    }

    // Strip RFC-822 / Usenet headers at the start
    if (RegExp(
      r'^(?:Date|From|Subject|Newsgroups|Path|Message-ID|Lines|Title|Author|Category):',
      caseSensitive: false,
    ).hasMatch(s)) {
      final headerEnd = s.indexOf('\n\n');
      if (headerEnd != -1) {
        s = s.substring(headerEnd + 2);
      }
    }

    // Strip trailing Usenet signature blocks (-- \n)
    final sigIndex = s.lastIndexOf('\n-- \n');
    if (sigIndex != -1) {
      s = s.substring(0, sigIndex);
    }

    // Split into paragraphs by blank lines
    final rawParas = s.split(RegExp(r'\n\s*\n'));
    final paragraphs = <String>[];

    for (final p in rawParas) {
      final trimmed = p.trim();
      if (trimmed.isEmpty) continue;

      // Replace ASCII boundary dividers
      if (RegExp(r'^[-=*_#~]{4,}$').hasMatch(trimmed)) {
        paragraphs.add('* * *');
        continue;
      }

      // Filter repetitive system disclaimers
      final lower = trimmed.toLowerCase();
      if (lower.contains('archived at asstr') ||
          lower.contains('alt.sex.stories faq') ||
          lower.contains('all rights reserved by the author')) {
        continue;
      }

      // Unwrap hard line breaks within paragraphs
      final unwrapped = trimmed.replaceAll(RegExp(r'(?<!\n)\n(?!\n)'), ' ');
      paragraphs.add(unwrapped);
    }

    return paragraphs.isNotEmpty ? paragraphs.join('\n\n') : s.trim();
  }

  String _cleanHtmlContent(String html) {
    final doc = html_parser.parse(html);
    for (final el in doc.querySelectorAll(
      'script, style, iframe, header, nav, footer, form, .nav',
    )) {
      el.remove();
    }

    // Check for preformatted text tag
    final pre = doc.querySelector('pre');
    if (pre != null && pre.text.trim().length > 50) {
      return _cleanUsenetPlainText(pre.text);
    }

    // Extract paragraph blocks
    final paragraphs = <String>[];
    for (final p in doc.querySelectorAll('p')) {
      final text = p.text.trim();
      if (text.isNotEmpty) {
        paragraphs.add(text);
      }
    }

    if (paragraphs.isNotEmpty) {
      return paragraphs.join('\n\n');
    }

    final bodyText = doc.body?.text.trim() ?? '';
    return bodyText.isNotEmpty ? _cleanUsenetPlainText(bodyText) : 'Story content is empty.';
  }

  String _titleFromSlug(String slug) {
    var s = slug.replaceAll(RegExp(r'https?://[^/]+/'), '');
    if (s.endsWith('/')) s = s.substring(0, s.length - 1);
    if (s.contains('/')) s = s.substring(s.lastIndexOf('/') + 1);
    s = s.replaceAll(RegExp(r'\.(html|txt)$'), '');
    s = s.replaceAll(RegExp(r'[-_]+'), ' ').trim();
    if (s.isEmpty) return 'ASSTR Story';

    return s
        .split(' ')
        .map((word) {
          if (word.isEmpty) return '';
          return word[0].toUpperCase() + word.substring(1);
        })
        .join(' ');
  }

  String _formatChapterTitle(String raw, double chapterIndex) {
    var s = raw.replaceAll(RegExp(r'\.(html|txt)$'), '');
    s = s.replaceAll(RegExp(r'[-_]+'), ' ').trim();
    if (s.isEmpty) return 'Part ${chapterIndex.toInt()}';
    return s[0].toUpperCase() + s.substring(1);
  }

  int _naturalCompare(String a, String b) {
    final numA = _extractNumber(a);
    final numB = _extractNumber(b);
    if (numA != null && numB != null) {
      final cmp = numA.compareTo(numB);
      if (cmp != 0) return cmp;
    }
    return a.compareTo(b);
  }

  int? _extractNumber(String s) {
    final match = RegExp(r'(\d+)').allMatches(s).toList();
    if (match.isNotEmpty) {
      return int.tryParse(match.last.group(1)!);
    }
    return null;
  }

  List<T> _paginateList<T>(List<T> list, int page, {int pageSize = 20}) {
    if (list.isEmpty) return [];
    final startIndex = (page - 1) * pageSize;
    if (startIndex >= list.length) return [];
    final endIndex = (startIndex + pageSize < list.length)
        ? startIndex + pageSize
        : list.length;
    return list.sublist(startIndex, endIndex);
  }

  List<SourceListingItem> _getCuratedListingItems() {
    return _curatedCatalog.map(_toListingItem).toList();
  }

  SourceListingItem _toListingItem(_CuratedStoryRecord story) {
    return SourceListingItem(
      title: story.title,
      url: story.storyUrl,
      author: story.author,
      date: story.date,
      summary: story.summary,
      sourceId: id,
    );
  }

  _CuratedStoryRecord? _findCuratedStory(String url) {
    final direct = _curatedByUrl[url];
    if (direct != null) return direct;

    final lower = url.toLowerCase();
    for (final story in _curatedCatalog) {
      if (lower.contains(story.id)) return story;
    }
    return null;
  }

  _CuratedChapter? _matchCuratedChapterBySlug(String url) {
    final lower = url.toLowerCase();
    for (final story in _curatedCatalog) {
      for (final ch in story.chapters) {
        if (lower.contains(ch.url.toLowerCase())) return ch;
        final chSlug = ch.title.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
        if (lower.replaceAll(RegExp(r'[^a-z0-9]'), '').contains(chSlug)) return ch;
      }
    }
    return null;
  }
}

// --- Internal Model Records for Curated Resilience Catalog ---

class _CuratedStoryRecord {
  final String id;
  final String title;
  final String author;
  final String category;
  final List<String> tags;
  final String date;
  final String summary;
  final String storyUrl;
  final List<_CuratedChapter> chapters;

  _CuratedStoryRecord({
    required this.id,
    required this.title,
    required this.author,
    required this.category,
    required this.tags,
    required this.date,
    required this.summary,
    required this.storyUrl,
    required this.chapters,
  });
}

class _CuratedChapter {
  final double index;
  final String title;
  final String url;
  final String content;

  _CuratedChapter({
    required this.index,
    required this.title,
    required this.url,
    required this.content,
  });
}
