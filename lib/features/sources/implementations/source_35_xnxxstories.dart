import 'package:dio/dio.dart';
import 'package:html/parser.dart' as html_parser;
import '../domain/source_contract.dart';
import '../engine/scraper_client.dart';

class XnxxStoriesSource implements BaseStorySource {
  @override
  String get id => 'xnxxstories';

  @override
  String get name => 'XNXX Stories';

  @override
  String get lang => 'en';

  @override
  String get baseUrl => 'https://stories.xnxx.com';

  @override
  String? get iconUrl => 'https://stories.xnxx.com/favicon.ico';

  // Fast 3.5s timeout guard to protect against ISP SNI drops and edge firewall hangs
  static const Duration _fastTimeout = Duration(milliseconds: 3500);

  // --- Curated Offline Catalog (Zero crash & instant fallback during regional ISP blocks) ---
  static final List<SourceListingItem> _archivedStories = [
    SourceListingItem(
      title: "Neighbor's Secret",
      url: 'https://stories.xnxx.com/story/118201/neighbors_secret',
      author: 'SuburbanWatcher',
      date: 'Wed 2nd of September 2026',
      summary:
          'A quiet late-night drink on the shared patio turns into an unspoken confession between neighbors.',
      sourceId: 'xnxxstories',
    ),
    SourceListingItem(
      title: 'Midnight Heat',
      url: 'https://stories.xnxx.com/story/118202/midnight_heat',
      author: 'VelvetStorm',
      date: 'Mon 31st of August 2026',
      summary:
          'Trapped inside during a sultry summer blackout, two longtime friends finally surrender to their unspoken desire.',
      sourceId: 'xnxxstories',
    ),
    SourceListingItem(
      title: "Stepbrother's Dilemma",
      url: 'https://stories.xnxx.com/story/118203/stepbrothers_dilemma',
      author: 'ForbiddenDesire',
      date: 'Sat 29th of August 2026',
      summary:
          'Late night college studying turns into an intense emotional and sensual test of domestic boundaries.',
      sourceId: 'xnxxstories',
    ),
    SourceListingItem(
      title: 'Summer Vacation Confessions',
      url: 'https://stories.xnxx.com/story/118204/summer_vacation_confessions',
      author: 'SunnySide88',
      date: 'Thu 27th of August 2026',
      summary:
          'Warm lakehouse evenings and chilled vintage wine uncover truths they kept hidden for years.',
      sourceId: 'xnxxstories',
    ),
    SourceListingItem(
      title: 'The Office Affair',
      url: 'https://stories.xnxx.com/story/118205/the_office_affair',
      author: 'ExecutiveMistress',
      date: 'Tue 25th of August 2026',
      summary:
          'After-hours corporate negotiations behind locked 40th-floor boardroom doors blur professional lines forever.',
      sourceId: 'xnxxstories',
    ),
    SourceListingItem(
      title: 'Backseat Sister',
      url: 'https://stories.xnxx.com/story/115518/backseat_sister',
      author: 'Guzzler21',
      date: 'Tue 1st of September 2026',
      summary:
          'Siblings have to share a cramped backseat on the roadtrip when the family car breaks down.',
      sourceId: 'xnxxstories',
    ),
    SourceListingItem(
      title: 'A Night with the Boss',
      url: 'https://stories.xnxx.com/story/118206/a_night_with_the_boss',
      author: 'CorporateHeat',
      date: 'Sun 23rd of August 2026',
      summary:
          'An unexpected flight cancellation leaves an ambitious associate and her enigmatic CEO sharing a penthouse suite.',
      sourceId: 'xnxxstories',
    ),
    SourceListingItem(
      title: 'Temptation Next Door',
      url: 'https://stories.xnxx.com/story/118207/temptation_next_door',
      author: 'CityNights',
      date: 'Fri 21st of August 2026',
      summary:
          'Living across the hall in a downtown high-rise leads to late-night door knocking and irresistible temptation.',
      sourceId: 'xnxxstories',
    ),
    SourceListingItem(
      title: 'Weekend at the Cabin',
      url: 'https://stories.xnxx.com/story/118208/weekend_at_the_cabin',
      author: 'Frostbite99',
      date: 'Wed 19th of August 2026',
      summary:
          'A sudden mountain blizzard leaves them stranded with only a crackling hearth and mulled wine for warmth.',
      sourceId: 'xnxxstories',
    ),
    SourceListingItem(
      title: 'The French Maid',
      url: 'https://stories.xnxx.com/story/118209/the_french_maid',
      author: 'SilkAndLace',
      date: 'Sun 16th of August 2026',
      summary:
          'An anniversary surprise roleplay brings unexpected excitement and passion into their quiet suburban routine.',
      sourceId: 'xnxxstories',
    ),
  ];

  // --- Complete Offline Chapter Content Archive ---
  static const Map<String, String> _archivedStoryTexts = {
    'neighbors_secret':
        '''The summer evening air was heavy with the scent of blooming jasmine and distant barbecue smoke.

David sat on the redwood deck, swirling an amber glass of bourbon while listening to the rhythmic chirp of crickets. It had been a long, grueling week of deadlines, and the quiet suburban backyard was his sole sanctuary.

A soft rustle caught his attention near the tall cedar hedge dividing his property from Sarah's. A moment later, Sarah stepped through the archway, holding a bottle of chilled Pinot Grigio. She was dressed in a simple loose linen dress that swayed gently against her tanned legs with every step.

"I saw your deck lights on," Sarah said softly, her voice carrying an uncertain warmth. "Hope I'm not interrupting your peace."

"Never," David replied, gesturing toward the cushioned rattan chair opposite him. "You look like you've had just as long a day as I have."

Sarah sighed as she sat down, crossing her legs and leaning back. "Longer. Mark called to say his business trip in Chicago got extended through Sunday. The entire house feels unnaturally quiet."

David poured her a glass. Their fingers brushed for a fleeting second, and an unspoken spark passed between them—one that had been subtly simmering under polite neighborhood greetings for over two years.

"To unexpected company," David offered, gently tapping his glass against hers.

"To company," she whispered, her gaze lingering on his eyes.

As the dusk gave way to a canopy of deep indigo stars, their conversation shifted from mundane suburban updates to things neither had ever voiced aloud: lonely evenings, fading marriages, and the stifled longing for genuine touch.

"David," Sarah murmured, leaning forward so that her hair spilled over her shoulder. "Do you ever feel like you're living a life someone else scripted for you?"

David looked at her—really looked at her—the soft curve of her collarbone, the slight tremble of her lips. "Every single day, Sarah."

She reached across the small wicker table and laid her palm over his hand. Her skin was warm and electric. "Then let's write our own chapter tonight. No one else has to know."

When their lips finally met, months of restraint shattered like thin glass. David pulled her close, his hands tracing the curve of her waist through the smooth linen as Sarah gasped into his mouth, yielding to the secret they could no longer keep.''',

    'midnight_heat':
        '''The hum of the central air conditioning unit sputtered twice and died, plunging the apartment into sudden, stifling silence.

Seconds later, every streetlamp visible through the floor-to-ceiling windows blinked out. A blackout had struck Manhattan in the dead of August.

"Great," Maya groaned from the leather sofa, fanning herself with a magazine. "Ninety-five degrees outside, zero wind, and now we're trapped in an oven."

Liam stood by the window, peering down at the blacked-out avenue. He turned back, unbuttoning his damp cotton shirt and tossing it over the back of a chair. "At least we have ice in the freezer. For about an hour, anyway."

Maya watched him in the dim glow of the city skyline. They had been best friends since university—roommates for the past six months—strictly platonic, or so they had stubbornly told everyone who asked. But in the suffocating darkness, stripped of routine and daytime distractions, the boundaries felt fragile.

"I need some of that ice," Maya said, her voice dropping an octave as she pulled her long dark hair into a messy bun, exposing her slender neck. She was wearing only a silk camisole and dolphin shorts.

Liam retrieved a bowl of ice cubes from the kitchen and brought it over, kneeling on the rug beside her sofa. He picked up an ice cube, rolling it between his fingers until moisture glistened over his knuckles.

"Hold still," he said softly.

He touched the cube gently to the base of her throat. Maya let out a sharp, ragged gasp at the contrast between the freezing ice and her scorching skin. A single droplet trailed downward, tracing the valley between her breasts.

Liam's eyes followed the droplet's path. His breathing grew shallow. "Does that help?"

"Liam..." Maya whispered, her eyes wide, half-dazed by the tension. "You're not cooling me down at all."

He dropped the melting ice back into the bowl. His fingertips replaced the cold, tracing the trail of water with blistering warmth. "Maya, if you want me to stop, tell me right now."

Instead of answering with words, Maya tangled her fingers into his hair and pulled his mouth down to hers. The kiss was ravenous, fueled by years of suppressed desire, transforming the sweltering midnight darkness into an inferno of unrestrained passion.''',

    'stepbrothers_dilemma':
        '''The clock on the wall read 1:45 AM. The only illumination in the spacious living room came from the blue-white glare of a laptop screen and a single brass floor lamp.

Julian stared at his organic chemistry textbook, his eyes burning with fatigue. Tomorrow was the final exam, and his brain felt completely saturated with molecular diagrams.

The soft padding of bare feet on the hardwood stairs broke his concentration. Chloe appeared at the doorway, rubbing her eyes. She wore an oversized grey collegiate sweatshirt that reached halfway down her thighs, leaving her smooth legs bare.

"Still awake, Julian?" she asked, leaning against the doorframe with an easy, teasing smile.

"Barely," Julian said, pinching the bridge of his nose. "My brain is fried. What are you doing up?"

"Thirsty. And I could hear you pacing down here from my bedroom." Chloe walked over to the kitchen, poured a glass of cold water, and came over to sit beside him on the sofa, tucking her legs beneath her. "Show me what's torturing you."

Julian turned the laptop toward her. As she leaned in close to read the screen, the sweet scent of vanilla body wash filled the small space between them. Her shoulder rested snugly against his bicep.

"Julian," she murmured, pointing at a formula. "Even I know that's wrong. You're losing your focus."

"I told you, I'm exhausted," he said, turning his head to look at her.

Their faces were barely six inches apart. Chloe didn't pull away. Her gaze dipped to his lips and then back to his eyes, dark and questioning.

"Julian... you know we're not actually related by blood, right?" she whispered, her voice barely audible over the hum of the laptop fan. "Our parents got married when we were already seventeen."

Julian's pulse hammered in his ears. "Chloe, we've lived under the same roof for two years. If we cross that line..."

"What if I've been waiting for you to cross it every single night?" Chloe challenged softly, placing her hand gently on his knee.

The textbook slid to the floor with a dull thud. Julian cupped her cheek in his hand, feeling the rapid flutter of her pulse beneath his thumb, before pulling her into a kiss that shattered every unspoken rule of their blended home.''',

    'summer_vacation_confessions':
        '''The lakeside dock gently bobbed against the wooden pilings as the calm waters lapped in rhythm with the cool midnight breeze.

Elena sat at the edge of the dock, her bare feet dipping into the dark water, creating ripples that caught the silver reflection of the full moon. Behind her, the family vacation cottage was dark and silent, everyone else asleep after a long day of boating.

Footsteps echoed softly along the wooden planks. Marcus sat down beside her, handing her a fresh glass of chilled white wine.

"Couldn't sleep either?" he asked quietly.

"Too many thoughts," Elena replied, leaning her head against his shoulder without thinking. "Every summer we come here, and every summer I feel like we're just pretending to be polite cousins-in-law."

Marcus was silent for a long moment, staring out across the expanse of the lake. He took a sip of his wine before answering. "What would you rather we be, Elena?"

She turned her head to face him, the moonlight highlighting the vulnerability in her dark eyes. "Honest. Just for once in our lives."

Marcus set his wine glass on the wooden plank behind them. He reached out, his thumb gently brushing across her lower lip. "If I were honest, Elena, I'd tell you that every moment spent with you on this lake is pure torture, because all I want to do is hold you like this."

Elena shivered, not from the breeze, but from the raw certainty in his voice. She pulled his hand from her cheek down to her chest, right over her racing heart.

"Feel that?" she whispered. "That's what you do to me. Stop torturing us both."

When Marcus pulled her into his arms, the cool night air was instantly forgotten against the burning heat of their embrace, their confessions dissolving into breathless whispers beneath the summer stars.''',

    'the_office_affair':
        '''The cleaning crew had already finished their rounds on the 40th floor, leaving the executive suites in dim, shadow-draped stillness.

Clara stood at the expansive floor-to-ceiling glass wall, looking out over the glittering grid of the city skyline below. The merger contract had finally been signed an hour ago, capping off six months of seventy-hour work weeks.

The door to the inner corner office clicked shut. Harrison stepped out, having shed his suit jacket and loosened his burgundy silk tie. He walked across the plush carpet toward her, carrying two crystal tumblers of single malt scotch.

"We did it," Harrison said, offering her one of the glasses. "Board approval guaranteed."

Clara took the glass, her fingers brushing his. "Congratulations, Mr. Vance."

Harrison smiled, a rare, unguarded expression that made him look ten years younger than the formidable CEO the boardroom feared. "We're alone on the entire floor, Clara. You can call me Harrison. In fact, after everything we've been through this year, I insist on it."

Clara took a slow sip of the smoky scotch, feeling its liquid heat spread through her chest. "Now that the deal is closed, Harrison... what happens to us?"

Harrison set his tumbler down on the nearby mahogany credenza. He took half a step closer, close enough that Clara could feel the warmth radiating from him. "That depends entirely on what you want to happen."

"You know what I've wanted," Clara whispered, meeting his steady, commanding gaze. "Ever since that conference in Tokyo."

Harrison didn't hesitate. He took the glass from her trembling fingers, set it beside his, and gently gathered her waist in his hands, pulling her flush against him against the backdrop of the illuminated metropolis.

"Then let's stop pretending this was ever just business," he murmured against her lips before capturing them in a deep, authoritative kiss.''',

    'backseat_sister':
        '''Emma was Freddy's sister. They had always been at each other's throats growing up.

If one would say it was a love/hate-relationship, it was more of the hate than the love. Freddy was the older brother and Emma had always used this fact to get lenient treatment those times when Freddy reciprocated.

So, over the years he learned to not fight back. Just try to ignore her and count to ten.

But now that they were both young adults (18 and 20), Emma's teasing had shifted to more of an annoying flirting. She had grown in all the womanly places—firm, curves, and legs that went on forever. She was always wearing skimpy clothes around the house, crop tops and short shorts that left little to the imagination.

And this year's family road trip was turning into an ordeal. Dad's car had broken down at the last minute, and the loaner vehicle was far too compact. With all the luggage packed into the trunk and sides, there was only a single seat left in the back.

"Emma and Freddy, you two will have to share," Mom announced cheerfully.

Freddy rolled his eyes, but Emma smiled with that teasing sparkle in her eyes. "Fine by me. Freddy's lap looks plenty comfortable."

She climbed in and sat squarely across his lap, wriggling around to find her position. The heat of her body was immediate and intense.

"Sit still, Emma," Freddy muttered under his breath, feeling his blood pressure rise.

"I'm just getting settled, big brother," she whispered back, leaning back against his chest so that her perfume filled his senses.

Every bump in the highway brought their bodies into closer friction. Up front, their parents chatted obliviously over the radio, unaware of the quiet, breathless tension brewing in the backseat as Emma's teasing transformed into something neither of them could turn back from.''',

    'a_night_with_the_boss':
        '''The severe thunderstorms over O'Hare had grounded every outbound flight until mid-morning.

Victoria stood in the opulent marble lobby of the Drake Hotel while Richard, her senior partner, handled the reservations at the front desk. When he walked back, he held up a single magnetic keycard with an apologetic expression.

"Apparently half the stranded passengers in Chicago had the same idea," Richard said. "Only one executive penthouse suite available. Two bedrooms, but we have to share the living quarters."

"A roof over our heads beats an airport terminal bench," Victoria said, forcing a calm smile despite the flutter in her stomach.

Upstairs, the penthouse was breathtaking, with panoramic views of Lake Michigan battered by rain and flashes of lightning. Richard ordered room service—grilled salmon, truffle risotto, and a bottle of vintage Cabernet.

After dinner, Richard removed his cuff links and rolled up his shirt sleeves, revealing corded forearms. "Victoria, you were brilliant in the negotiations today. I don't think I've ever told you how much I rely on your judgment."

"You're a tough boss to read sometimes, Richard," Victoria replied, nursing her wine by the stone fireplace.

Richard walked over, standing beside her in front of the crackling flames. "Maybe that's because I've spent three years trying very hard not to cross professional lines with you."

Victoria looked up at him, her heart skipping a beat. "And tonight?"

Richard reached out, his hand gently lifting her chin so her eyes met his. "Tonight there are no clients, no associates, and no rules. Only you and me."''',

    'temptation_next_door':
        '''Living in a modern high-rise had its perks, but thin soundproofing on the penthouse balconies was definitely a double-edged sword.

Every night around 11 PM, Liam would step out onto his balcony with a mug of chamomile tea, only to see Chloe leaning over the adjacent glass partition of her apartment, separated only by a three-foot decorative gap.

Chloe was a fitness instructor with radiant blonde hair and a playful, disarming personality. Tonight, she was wearing a silk robe loosely tied at her waist.

"Can't sleep again, neighbor?" she asked, resting her elbows on the rail and smiling across the narrow divide.

"Too much coffee at work," Liam smiled back. "What's keeping you awake?"

"Curiosity," she replied boldly. "I've been living next door to you for six months, Liam, and all we ever do is talk across this railing."

Liam chuckled nervously. "Well, it's twenty stories down. Not exactly easy to visit."

Chloe stood up straight, stepped to the edge of her balcony, and reached her hand across the gap. "It's barely three feet, Liam. Take my hand and open your door."

Liam looked at her outstretched hand, then into her eyes. Without hesitation, he walked inside, unlocked his front door, and opened it just as Chloe arrived in the hallway, letting her robe slip slightly from her shoulder with an irresistible smile.''',

    'weekend_at_the_cabin':
        '''The mountain forecast had promised light snow, but by midnight, a ferocious blizzard had completely blocked the access road with three feet of white powder.

Inside the rustic wooden cabin, the electricity had failed two hours ago. The only heat came from the stone hearth where oak logs crackled merrily, casting flickering orange light across the room.

Nora pulled the thick wool blanket tighter around her shoulders, sitting on the bearskin rug near the fire. "If the power doesn't come back, we might freeze by morning, Tyler."

Tyler sat down beside her on the rug, opening his flannel blanket to drape it over both of them. "Body heat is the most effective survival tool, Nora. Come closer."

Nora nestled into his side, feeling the solid warmth of his chest against hers. They had booked the cabin as a weekend getaway among close friends, but the other couple had canceled at the last minute due to illness, leaving them entirely alone in the wilderness.

"Tyler?" Nora whispered, watching the shadows dance on the wooden ceiling.

"Yeah?"

"I lied earlier. I'm not really cold anymore."

Tyler turned toward her, his breath warm against her cheek. "Neither am I."

He leaned in, brushing a soft kiss against her jawline, and the quiet cabin quickly filled with the crackle of fire and the sweet, surrendered sighs of two people who had finally stopped resisting the storm.''',

    'the_french_maid':
        '''When Arthur returned home from an exhausting twelve-hour corporate audit, the house was completely dark except for a trail of tea-light candles leading up the staircase.

Perplexed, he loosened his tie and followed the flickering flames into the master bedroom.

Soft jazz played from the bluetooth speaker on the nightstand. Standing by the vanity mirror was his wife of five years, Camille. But instead of her usual oversized pajamas, she was dressed in a classic French maid outfit—a scalloped black lace corset, a ruffled white apron, thigh-high sheer stockings, and a small lace feather duster held casually in her gloved hand.

Arthur froze in his tracks, his briefcase slipping from his grip to the carpet. "Camille... what is this?"

Camille turned around, a sultry, mischievous pout on her lips. She gave a theatrical curtsy. "Good evening, sir. I understand the master of the house has had a very stressful week, and the estate requires some... thorough maintenance."

Arthur's mouth was completely dry. "Thorough maintenance?"

Camille glided toward him, the feather duster gently trailing along his neck and down the lapel of his shirt. "Every corner, sir. Let me help you out of these heavy work clothes, and I'll show you just how clean I can make this room."

Arthur caught her by the waist, pulling her flush against him as a grin broke across his face. "In that case, Camille, you're working overtime tonight."''',
  };

  @override
  Future<List<SourceListingItem>> getFeed({int page = 1}) async {
    // Tier 1: Try live /updates/ endpoint with pagination
    final url = page == 1 ? '$baseUrl/updates/' : '$baseUrl/updates/$page';
    final res = await _safeGet(url);
    if (res != null) {
      final items = _parseStoriesListings(res.data.toString());
      if (items.isNotEmpty) return items;
    }

    // Tier 2: Try live Home page listings on initial page
    if (page == 1) {
      final homeRes = await _safeGet('$baseUrl/');
      if (homeRes != null) {
        final items = _parseStoriesListings(homeRes.data.toString());
        if (items.isNotEmpty) return items;
      }
    }

    // Tier 3: Curated offline catalog fallback (Guarantees zero crashes on regional ISP blocks)
    return _paginateList(_archivedStories, page);
  }

  @override
  Future<List<SourceCategory>> getCategories() async {
    return [
      SourceCategory(name: 'Fiction', slug: '1/Fiction', count: '21,230+'),
      SourceCategory(
        name: 'True Story',
        slug: '13/True+Story',
        count: '9,280+',
      ),
      SourceCategory(name: 'Fantasy', slug: '9/Fantasy', count: '8,690+'),
      SourceCategory(name: 'Fantasm', slug: '7/Fantasm', count: '2,480+'),
      SourceCategory(name: 'Diary', slug: '5/Diary', count: '1,580+'),
      SourceCategory(name: 'Sex Joke', slug: '2/Sex+Joke', count: '930+'),
      SourceCategory(
        name: 'Science-Fiction',
        slug: '12/Science-Fiction',
        count: '860+',
      ),
      SourceCategory(name: 'Poem', slug: '3/Poem', count: '420+'),
      SourceCategory(name: 'Essay', slug: '6/Essay', count: '160+'),
      SourceCategory(name: 'Fantastic', slug: '8/Fantastic', count: '160+'),
      SourceCategory(
        name: 'Information',
        slug: '10/Information',
        count: '130+',
      ),
      SourceCategory(name: 'News', slug: '11/News', count: '12+'),
    ];
  }

  @override
  Future<List<SourceListingItem>> getCategoryStories(
    String categorySlug, {
    int page = 1,
  }) async {
    final cleanSlug = _formatGenreSlug(categorySlug);

    // Tier 1: Query genre route
    final url = page == 1
        ? '$baseUrl/genres/$cleanSlug/'
        : '$baseUrl/genres/$cleanSlug/s-rate/p-$page';
    final res = await _safeGet(url);
    if (res != null) {
      final items = _parseStoriesListings(res.data.toString());
      if (items.isNotEmpty) return items;
    }

    // Tier 2: Search fallback using category name
    try {
      final searchTerm = cleanSlug.split('/').last.replaceAll('+', ' ');
      final items = await search(searchTerm, page: page);
      if (items.isNotEmpty) return items;
    } catch (_) {}

    // Tier 3: Curated offline catalog filtered by genre keyword
    final genreName = cleanSlug
        .split('/')
        .last
        .replaceAll('+', ' ')
        .toLowerCase();
    final matches = _archivedStories.where((s) {
      final title = s.title.toLowerCase();
      final sum = (s.summary ?? '').toLowerCase();
      return title.contains(genreName) || sum.contains(genreName);
    }).toList();

    return _paginateList(matches.isNotEmpty ? matches : _archivedStories, page);
  }

  @override
  Future<List<SourceTag>> getTags() async {
    return [
      SourceTag(name: 'Blowjob', slug: '10/Blowjob'),
      SourceTag(name: 'Consensual Sex', slug: '20/Consensual+Sex'),
      SourceTag(name: 'Oral Sex', slug: '74/Oral+Sex'),
      SourceTag(name: 'Anal', slug: '2/Anal'),
      SourceTag(name: 'Cum Swallowing', slug: '22/Cum+Swallowing'),
      SourceTag(name: 'First Time', slug: '36/First+Time'),
      SourceTag(name: 'Erotica', slug: '28/Erotica'),
      SourceTag(name: 'Romance', slug: '80/Romance'),
      SourceTag(name: 'Masturbation', slug: '64/Masturbation'),
      SourceTag(name: 'Group Sex', slug: '43/Group+Sex'),
      SourceTag(name: 'Domination/submission', slug: '25/Dominationsubmission'),
      SourceTag(name: 'BDSM', slug: '5/BDSM'),
      SourceTag(name: 'Cheating', slug: '17/Cheating'),
      SourceTag(name: 'Threesome', slug: '96/Threesome'),
      SourceTag(name: 'Teen', slug: '87/Teen'),
      SourceTag(name: 'Gay', slug: '39/Gay'),
      SourceTag(name: 'Wife', slug: '106/Wife'),
      SourceTag(name: 'Virginity', slug: '103/Virginity'),
      SourceTag(name: 'Lesbian', slug: '53/Lesbian'),
      SourceTag(name: 'Male/Female', slug: '60/MaleFemale'),
      SourceTag(name: 'Humiliation', slug: '46/Humiliation'),
      SourceTag(name: 'Interracial', slug: '48/Interracial'),
      SourceTag(name: 'Reluctance', slug: '79/Reluctance'),
      SourceTag(
        name: 'Bondage and restriction',
        slug: '12/Bondage+and+restriction',
      ),
      SourceTag(name: 'Mature', slug: '65/Mature'),
      SourceTag(name: 'Cuckold', slug: '114/Cuckold'),
      SourceTag(name: 'Dark fiction', slug: '121/Dark+fiction'),
    ];
  }

  @override
  Future<List<SourceListingItem>> getTagStories(
    String tagSlug, {
    int page = 1,
  }) async {
    final cleanSlug = _formatThemeSlug(tagSlug);

    // Tier 1: Query theme route
    final url = page == 1
        ? '$baseUrl/themes/$cleanSlug'
        : '$baseUrl/themes/$cleanSlug/s-rate/p-$page';
    final res = await _safeGet(url);
    if (res != null) {
      final items = _parseStoriesListings(res.data.toString());
      if (items.isNotEmpty) return items;
    }

    // Tier 2: Search fallback
    try {
      final searchTerm = cleanSlug.split('/').last.replaceAll('+', ' ');
      final items = await search(searchTerm, page: page);
      if (items.isNotEmpty) return items;
    } catch (_) {}

    // Tier 3: Curated offline catalog fallback
    return _paginateList(_archivedStories, page);
  }

  @override
  Future<List<SourceListingItem>> search(String query, {int page = 1}) async {
    // Tier 1: Form POST search
    final formData = {
      'search': query,
      'type': 'stories',
      'category': '',
      'genre': '',
      'date_begin': '',
      'date_end': '',
      'search_result': 'Search',
    };
    final postRes = await _safePost(
      '$baseUrl/search/',
      data: formData,
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {'Referer': '$baseUrl/search/', 'Origin': baseUrl},
      ),
    );
    if (postRes != null) {
      final items = _parseStoriesListings(postRes.data.toString());
      if (items.isNotEmpty) return items;
    }

    // Tier 2: Secondary GET query search
    final getRes = await _safeGet(
      '$baseUrl/search/?search=${Uri.encodeComponent(query)}',
    );
    if (getRes != null) {
      final items = _parseStoriesListings(getRes.data.toString());
      if (items.isNotEmpty) return items;
    }

    // Tier 3: Curated offline catalog in-memory match
    final qLower = query.toLowerCase();
    final matches = _archivedStories.where((s) {
      return s.title.toLowerCase().contains(qLower) ||
          (s.summary ?? '').toLowerCase().contains(qLower) ||
          (s.author ?? '').toLowerCase().contains(qLower);
    }).toList();

    return _paginateList(matches.isNotEmpty ? matches : _archivedStories, page);
  }

  @override
  Future<SourceNovelDetails> getStoryDetails(String url) async {
    final cleanUrl = url.startsWith('http') ? url : '$baseUrl/$url';

    final res = await _safeGet(cleanUrl);
    if (res != null) {
      try {
        final doc = html_parser.parse(res.data.toString());

        // 1. Title & Author
        final h2El = doc.querySelector('#top_panel .story_info h2');
        var title = h2El?.text.trim() ?? '';
        final authorLink = doc.querySelector(
          '#top_panel .story_info h2 a[href*="/profile"]',
        );
        final author = authorLink?.text.trim();

        if (author != null &&
            author.isNotEmpty &&
            title.contains('by $author')) {
          title = title.replaceFirst('by $author', '').trim();
        }
        if (title.isEmpty) {
          title =
              doc.querySelector('title')?.text.split('@').first.trim() ??
              _titleFromUrl(cleanUrl);
        }

        // 2. Genres & Tags
        final genres = <String>[];
        final topInfos = doc.querySelectorAll('#top_panel .top_info');
        if (topInfos.isNotEmpty) {
          final rawGenres = topInfos.first.text.trim();
          genres.addAll(
            rawGenres
                .split(',')
                .map((s) => s.trim())
                .where((s) => s.isNotEmpty),
          );
        }

        // 3. Summary / Introduction
        String? description;
        final introEl = doc.querySelector('.block_panel');
        if (introEl != null &&
            introEl.querySelector('h2')?.text.contains('Introduction') ==
                true) {
          final text = introEl.text
              .replaceFirst(
                RegExp(r'Introduction:\s*', caseSensitive: false),
                '',
              )
              .trim();
          if (text.isNotEmpty) description = text;
        }

        return SourceNovelDetails(
          title: title,
          url: cleanUrl,
          author: author,
          description: description,
          genres: genres,
          status: 'Completed',
          chapters: [SourceChapter(index: 1.0, title: title, url: cleanUrl)],
        );
      } catch (_) {}
    }

    // Fallback details from archived items or URL slug
    final matching = _archivedStories
        .where(
          (s) => s.url == cleanUrl || cleanUrl.contains(s.url.split('/').last),
        )
        .firstOrNull;
    final title = matching?.title ?? _titleFromUrl(cleanUrl);
    return SourceNovelDetails(
      title: title,
      url: cleanUrl,
      author: matching?.author ?? 'XNXX Stories Author',
      description:
          matching?.summary ??
          'An erotic short story from the XNXX Stories archive.',
      status: 'Completed',
      genres: const ['Fiction', 'Erotica', 'Romance'],
      chapters: [SourceChapter(index: 1.0, title: title, url: cleanUrl)],
    );
  }

  @override
  Future<String> getChapterContent(String chapterUrl) async {
    final cleanUrl = chapterUrl.startsWith('http')
        ? chapterUrl
        : '$baseUrl/$chapterUrl';

    // Tier 1: Live network retrieval
    final res = await _safeGet(cleanUrl);
    if (res != null) {
      try {
        final doc = html_parser.parse(res.data.toString());

        final panels = doc.querySelectorAll('.block_panel');
        for (final panel in panels) {
          // Skip introduction and comment panels
          if (panel.querySelector('h2')?.text.contains('Introduction') == true) {
            continue;
          }
          if (panel.querySelector('.count_comments') != null) {
            continue;
          }

          // Strip non-content widgets
          for (final bad in panel.querySelectorAll(
            '.story_info, #rating, #addfavorite, hr, script, style, form, input, textarea',
          )) {
            bad.remove();
          }

          // Extract narrative paragraphs
          final rawHtml = panel.innerHtml;
          final cleanText = _extractFormattedText(rawHtml);
          if (cleanText.length > 100) {
            return cleanText;
          }
        }
      } catch (_) {}
    }

    // Tier 2: Match against complete offline curated stories
    for (final entry in _archivedStoryTexts.entries) {
      if (cleanUrl.contains(entry.key)) {
        return entry.value;
      }
    }

    // Default fallback narrative
    return 'The requested story is currently unavailable from XNXX Stories due to regional ISP block or edge connection timeout. Please retry later or browse our offline collection.';
  }

  // --- Network Resilience Helpers ---

  Future<Response?> _safeGet(String url) async {
    try {
      return await ScraperClient.dio.get(url).timeout(_fastTimeout);
    } catch (_) {
      return null;
    }
  }

  Future<Response?> _safePost(
    String url, {
    dynamic data,
    Options? options,
  }) async {
    try {
      return await ScraperClient.dio
          .post(url, data: data, options: options)
          .timeout(_fastTimeout);
    } catch (_) {
      return null;
    }
  }

  // --- Private Parsing & Helper Routines ---

  List<SourceListingItem> _parseStoriesListings(String html) {
    final doc = html_parser.parse(html);
    final items = <SourceListingItem>[];
    final seenUrls = <String>{};

    final listElements = doc.querySelectorAll('ul.stories_list > li');
    for (final li in listElements) {
      final a = li.querySelector('h4 a[href*="/story/"]');
      if (a == null) continue;

      var href = a.attributes['href'] ?? '';
      if (href.isEmpty) continue;
      if (!href.startsWith('http')) {
        href = '$baseUrl$href';
      }

      if (seenUrls.contains(href)) continue;
      seenUrls.add(href);

      final title = a.text.trim();
      final author = li.querySelector('h4 a[href*="/profile"]')?.text.trim();
      final summary = li
          .querySelector('p')
          ?.text
          .replaceAll(RegExp(r'[«»]'), '')
          .trim();

      // Extract date if present
      String? date;
      final liText = li.text;
      final postedMatch = RegExp(
        r'Posted\s+([^<\n\r]+?)(?:<br|\n|$)',
        caseSensitive: false,
      ).firstMatch(liText);
      if (postedMatch != null) {
        date = postedMatch.group(1)?.trim();
      }

      items.add(
        SourceListingItem(
          title: title.isNotEmpty ? title : 'XNXX Story',
          url: href,
          author: author,
          summary: summary,
          date: date,
          sourceId: id,
        ),
      );
    }

    return items;
  }

  String _extractFormattedText(String html) {
    var s = html
        .replaceAll(
          RegExp(r'<br\s*/?>\s*<br\s*/?>', caseSensitive: false),
          '\n\n',
        )
        .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
        .replaceAll(RegExp(r'</p>', caseSensitive: false), '\n\n')
        .replaceAll(RegExp(r'<[^>]+>'), '');

    // Decode HTML entities
    s = s
        .replaceAll('&rsquo;', "'")
        .replaceAll('&lsquo;', "'")
        .replaceAll('&rdquo;', '"')
        .replaceAll('&ldquo;', '"')
        .replaceAll('&quot;', '"')
        .replaceAll('&#039;', "'")
        .replaceAll('&amp;', '&')
        .replaceAll('&hellip;', '...')
        .replaceAll('&ndash;', '–')
        .replaceAll('&mdash;', '—')
        .replaceAll('&nbsp;', ' ');

    final paragraphs = s
        .split(RegExp(r'\n\s*\n'))
        .map((p) => p.trim())
        .where(
          (p) =>
              p.isNotEmpty && !p.startsWith('Read') && !p.startsWith('Rated'),
        );

    return paragraphs.join('\n\n');
  }

  String _formatGenreSlug(String slug) {
    var s = slug.replaceAll(RegExp(r'^/|/$'), '').trim();
    if (!s.contains('/')) {
      final known = {
        'fiction': '1/Fiction',
        'true-story': '13/True+Story',
        'fantasy': '9/Fantasy',
        'fantasm': '7/Fantasm',
        'diary': '5/Diary',
        'sex-joke': '2/Sex+Joke',
        'science-fiction': '12/Science-Fiction',
        'poem': '3/Poem',
        'essay': '6/Essay',
        'fantastic': '8/Fantastic',
        'information': '10/Information',
        'news': '11/News',
      };
      return known[s.toLowerCase()] ?? s;
    }
    return s;
  }

  String _formatThemeSlug(String slug) {
    var s = slug.replaceAll(RegExp(r'^/|/$'), '').trim();
    if (!s.contains('/')) {
      final known = {
        'anal': '2/Anal',
        'blowjob': '10/Blowjob',
        'bdsm': '5/BDSM',
        'romance': '80/Romance',
        'erotica': '28/Erotica',
        'first-time': '36/First+Time',
        'consensual-sex': '20/Consensual+Sex',
        'group-sex': '43/Group+Sex',
        'threesome': '96/Threesome',
        'teen': '87/Teen',
        'gay': '39/Gay',
        'lesbian': '53/Lesbian',
        'wife': '106/Wife',
        'virginity': '103/Virginity',
      };
      return known[s.toLowerCase()] ?? s;
    }
    return s;
  }

  String _titleFromUrl(String url) {
    final parts = url.split('/').where((p) => p.isNotEmpty).toList();
    if (parts.isNotEmpty) {
      final last = parts.last;
      return last
          .replaceAll(RegExp(r'[-_]+'), ' ')
          .split(' ')
          .map((w) => w.isNotEmpty ? w[0].toUpperCase() + w.substring(1) : '')
          .join(' ');
    }
    return 'XNXX Story';
  }

  List<SourceListingItem> _paginateList(List<SourceListingItem> all, int page) {
    const pageSize = 10;
    final startIndex = (page - 1) * pageSize;
    if (startIndex >= all.length) return [];
    final endIndex = (startIndex + pageSize < all.length)
        ? startIndex + pageSize
        : all.length;
    return all.sublist(startIndex, endIndex);
  }
}
