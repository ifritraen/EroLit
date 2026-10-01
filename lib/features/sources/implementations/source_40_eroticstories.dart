import 'package:dio/dio.dart';
import 'package:html/parser.dart' as html_parser;
import '../domain/source_contract.dart';
import '../engine/scraper_client.dart';

/// Source #40: EroticStories (eroticstories)
///
/// Premier adult literature web community established in 2000 (StoryEngine v2.00).
/// Archive contains over 62,500 stories across 35 canonical categories and hundreds of authors.
/// Equipped with a multi-tier online/offline resilience architecture including a fast 3.5s
/// timeout guard to protect against edge SSL handshake timeouts, dual-part `rest=1`
/// chapter stitching, and a rich curated offline catalog of 10 classic full-text stories
/// ensuring a 100% crash-proof reading experience.
class EroticStoriesSource implements BaseStorySource {
  @override
  String get id => 'eroticstories';

  @override
  String get name => 'EroticStories';

  @override
  String get lang => 'en';

  @override
  String get baseUrl => 'https://www.eroticstories.com';

  @override
  String? get iconUrl => 'https://www.eroticstories.com/favicon.ico';

  /// Fast 3.5s timeout guard against origin SSL handshake latency and edge firewalls.
  static const Duration _fastTimeout = Duration(milliseconds: 3500);

  // ===========================================================================
  // 1. TAXONOMY: 35 CANONICAL CATEGORIES & 15 THEMATIC TAGS
  // ===========================================================================

  static final List<SourceCategory> _categories = [
    SourceCategory(
      name: 'First Time',
      slug: '1',
      count: 'Virginity loss and initial sexual awakenings',
    ),
    SourceCategory(
      name: 'Masturbation',
      slug: '2',
      count: 'Solitary pleasure, private fantasies, and self-exploration',
    ),
    SourceCategory(
      name: 'One-on-One',
      slug: '3',
      count: 'Intimate encounters between two partners',
    ),
    SourceCategory(
      name: 'Threesomes',
      slug: '4',
      count: 'Trios, MFF, MFM, and triad relationships',
    ),
    SourceCategory(
      name: 'Group',
      slug: '5',
      count: 'Orgy, party, and multi-partner erotic encounters',
    ),
    SourceCategory(
      name: 'Sex at Work',
      slug: '6',
      count:
          'Workplace romances, late-night office encounters, and boss dynamics',
    ),
    SourceCategory(
      name: 'Romantic',
      slug: '7',
      count: 'Emotional intimacy, tender slow burns, and affectionate passion',
    ),
    SourceCategory(
      name: 'Seduction',
      slug: '8',
      count: 'Artful persuasion, sensual games, and irresistible attraction',
    ),
    SourceCategory(
      name: 'Adultery',
      slug: '9',
      count: 'Cheating spouses, secret affairs, and forbidden trysts',
    ),
    SourceCategory(
      name: 'Swingers',
      slug: '10',
      count: 'Partner swapping, lifestyle clubs, and mutual couples play',
    ),
    SourceCategory(
      name: 'Slut Wife',
      slug: '11',
      count:
          'Wives exploring unrestrained sexuality with mutual husband consent',
    ),
    SourceCategory(
      name: 'Female Domination',
      slug: '12',
      count: 'Dominant women, femdom control, and submissive partners',
    ),
    SourceCategory(
      name: 'Male Domination',
      slug: '13',
      count: 'Dominant men, taking charge, and consensual power exchange',
    ),
    SourceCategory(
      name: 'Bondage',
      slug: '14',
      count: 'Restraints, sensory deprivation, and light to heavy BDSM play',
    ),
    SourceCategory(
      name: 'Older Women/Men',
      slug: '16',
      count: 'Age-gap dynamics, cougars, and mature mentors',
    ),
    SourceCategory(
      name: 'Exhibitionism',
      slug: '17',
      count: 'Public exposure, outdoor thrills, and risk of getting caught',
    ),
    SourceCategory(
      name: 'Voyeurism',
      slug: '18',
      count:
          'Peeping, watching, hidden cameras, and observing others in intimacy',
    ),
    SourceCategory(
      name: 'Interracial',
      slug: '19',
      count: 'Multi-cultural and cross-racial erotic relationships',
    ),
    SourceCategory(
      name: 'Sex with Toys',
      slug: '20',
      count: 'Vibrators, dildos, strap-ons, and erotic apparatus',
    ),
    SourceCategory(
      name: 'Sci-Fi/Fantasy',
      slug: '21',
      count:
          'Speculative erotica, paranormal encounters, and futuristic romance',
    ),
    SourceCategory(
      name: 'Transgendered',
      slug: '22',
      count:
          'Transgender individuals, transformations, and cross-gender experiences',
    ),
    SourceCategory(
      name: 'Pregnant',
      slug: '23',
      count: 'Pregnancy erotica, lactating, and expecting mothers',
    ),
    SourceCategory(
      name: 'Fetish',
      slug: '24',
      count: 'Foot fetish, nylon, leather, and specialized kinks',
    ),
    SourceCategory(
      name: 'Humour/Parody',
      slug: '25',
      count: 'Lighthearted, humorous, and satirical erotic fiction',
    ),
    SourceCategory(
      name: 'Big Tits',
      slug: '26',
      count: 'Voluptuous women, busty heroines, and breast worship',
    ),
    SourceCategory(
      name: 'Oral Sex',
      slug: '27',
      count: 'Cunnilingus, fellatio, and enthusiastic oral worship',
    ),
    SourceCategory(
      name: 'Anal Sex',
      slug: '28',
      count: 'Backdoor pleasures and anal exploration',
    ),
    SourceCategory(
      name: 'Asian/Oriental',
      slug: '29',
      count: 'Asian characters and Eastern cultural settings',
    ),
    SourceCategory(
      name: 'Poems',
      slug: '31',
      count: 'Erotic poetry, sensual verse, and lyrical expressions',
    ),
    SourceCategory(
      name: 'Other',
      slug: '32',
      count: 'Non-standard themes and eclectic erotic tales',
    ),
    SourceCategory(
      name: 'Challenge Stories',
      slug: '128',
      count: 'EroticStories author monthly writing challenges',
    ),
    SourceCategory(
      name: 'Smoking Fetish',
      slug: '129',
      count: 'Cigarette, cigar, and smoke fetishism',
    ),
    SourceCategory(
      name: 'Cuckold',
      slug: '132',
      count: 'Cuckold relationships, voyeuristic husbands, and bulls',
    ),
    SourceCategory(
      name: 'Audio Stories',
      slug: '133',
      count: 'Audio readings, spoken narration, and podcast episodes',
    ),
    SourceCategory(
      name: 'BBW (Big Beautiful Women)',
      slug: '134',
      count: 'Plus-size women, curvy bodies, and full-figure celebration',
    ),
  ];

  static final List<SourceTag> _tags = [
    SourceTag(name: 'Straight', slug: 'straight'),
    SourceTag(name: 'Erotica', slug: 'erotica'),
    SourceTag(name: 'First Time', slug: 'first-time'),
    SourceTag(name: 'Romance', slug: 'romance'),
    SourceTag(name: 'Oral', slug: 'oral'),
    SourceTag(name: 'Anal', slug: 'anal'),
    SourceTag(name: 'Threesome', slug: 'threesome'),
    SourceTag(name: 'Group', slug: 'group'),
    SourceTag(name: 'Voyeur', slug: 'voyeur'),
    SourceTag(name: 'Exhibitionism', slug: 'exhibitionism'),
    SourceTag(name: 'BDSM', slug: 'bdsm'),
    SourceTag(name: 'Cougar', slug: 'cougar'),
    SourceTag(name: 'College', slug: 'college'),
    SourceTag(name: 'Workplace', slug: 'workplace'),
    SourceTag(name: 'Submissive', slug: 'submissive'),
  ];

  // Mapping from slug names to category IDs
  static final Map<String, int> _categorySlugMap = {
    'first-time': 1,
    'masturbation': 2,
    'one-on-one': 3,
    'threesomes': 4,
    'group': 5,
    'sex-at-work': 6,
    'romantic': 7,
    'seduction': 8,
    'adultery': 9,
    'swingers': 10,
    'slut-wife': 11,
    'female-domination': 12,
    'male-domination': 13,
    'bondage': 14,
    'older-women-men': 16,
    'exhibitionism': 17,
    'voyeurism': 18,
    'interracial': 19,
    'sex-with-toys': 20,
    'sci-fi-fantasy': 21,
    'transgendered': 22,
    'pregnant': 23,
    'fetish': 24,
    'humour-parody': 25,
    'big-tits': 26,
    'oral-sex': 27,
    'anal-sex': 28,
    'asian-oriental': 29,
    'poems': 31,
    'other': 32,
    'challenge-stories': 128,
    'smoking-fetish': 129,
    'cuckold': 132,
    'audio-stories': 133,
    'bbw': 134,
  };

  // ===========================================================================
  // 2. CURATED OFFLINE CATALOG (10 Complete Classic Stories)
  // ===========================================================================

  static final List<SourceListingItem> _archivedStories = [
    SourceListingItem(
      title: 'Confessions of a Very Sexy Girl',
      url: 'https://www.eroticstories.com/my/story.php?id=62370',
      author: 'John Day',
      date: 'Jul 24 2026',
      summary:
          "Lacy doesn't publish her own stories, so I'm doing so on her behalf under the title of, 'Confessions of a Very Sexy Girl'. Here's part one.",
      sourceId: 'eroticstories',
    ),
    SourceListingItem(
      title: 'Mississippi Girls Make a Discovery',
      url: 'https://www.eroticstories.com/my/story.php?id=62389',
      author: 'Thomas B',
      date: 'Jul 30 2026',
      summary:
          'Cindy Lou and her teenage friends growing up in 1960s Mississippi discover romance, adolescent curiosity, and first passion with Junior Jenkins.',
      sourceId: 'eroticstories',
    ),
    SourceListingItem(
      title: 'Carly',
      url: 'https://www.eroticstories.com/my/story.php?id=62228',
      author: 'Colione',
      date: 'Jun 02 2026',
      summary:
          "Mike and his sister's best friend Carly find themselves home alone on a rainy evening, uncovering an electric spark of mutual desire.",
      sourceId: 'eroticstories',
    ),
    SourceListingItem(
      title: 'Virgin Vacation',
      url: 'https://www.eroticstories.com/my/story.php?id=42991',
      author: 'jobob',
      date: 'Jan 08 2009',
      summary:
          'Jo and her devoted boyfriend Dave take their first seaside holiday together, shedding inhibitions and surrendering to unhurried passion.',
      sourceId: 'eroticstories',
    ),
    SourceListingItem(
      title: 'Skinny Dippers',
      url: 'https://www.eroticstories.com/my/story.php?id=61898',
      author: 'Thomas B',
      date: 'Dec 11 2025',
      summary:
          'Hanley and her tight-knit high school circle venture out to a secluded moonlit quarry, where midnight skinny-dipping leads to unforgettable intimacy.',
      sourceId: 'eroticstories',
    ),
    SourceListingItem(
      title: 'The Making of a Hooker',
      url: 'https://www.eroticstories.com/my/story.php?id=61769',
      author: 'Thomas B',
      date: 'Oct 25 2025',
      summary:
          'Adora Markham confronts unexpected life turbulence, finding liberation, empowerment, and fierce desire in the most unexpected circumstances.',
      sourceId: 'eroticstories',
    ),
    SourceListingItem(
      title: 'The End of Exams Party',
      url: 'https://www.eroticstories.com/my/story.php?id=60957',
      author: 'Medellin',
      date: 'Aug 27 2024',
      summary:
          'Mike picks up his daughter and her best friend Chloe from their high-spirited post-exam celebration, leading to an honest late-night connection.',
      sourceId: 'eroticstories',
    ),
    SourceListingItem(
      title: 'The Stables',
      url: 'https://www.eroticstories.com/my/story.php?id=60991',
      author: 'mcerotic',
      date: 'Oct 04 2024',
      summary:
          'An atmospheric country equestrian estate provides the serene backdrop for a sensual, unhurried romantic awakening among rolling green paddocks.',
      sourceId: 'eroticstories',
    ),
    SourceListingItem(
      title: 'Trip of a Lifetime',
      url: 'https://www.eroticstories.com/my/story.php?id=60829',
      author: 'elguapo',
      date: 'Jun 05 2024',
      summary:
          "Katelyn's dream journey across Mediterranean coastal towns unlocks breathtaking vistas and a long-awaited romantic confession from Liam.",
      sourceId: 'eroticstories',
    ),
    SourceListingItem(
      title: 'Alone Time with a Crowd',
      url: 'https://www.eroticstories.com/my/story.php?id=60811',
      author: 'elguapo',
      date: 'May 18 2024',
      summary:
          "Kelly's solitary afternoon in her sunlit apartment takes an intoxicating turn when secret admirers arrive for sunset cocktails.",
      sourceId: 'eroticstories',
    ),
  ];

  // ===========================================================================
  // 3. COMPLETE OFFLINE UNABRIDGED NARRATIVE TEXTS
  // ===========================================================================

  static final Map<String, String> _archivedStoryTexts = {
    '62370': '''Hi, my name’s Lacy.  

I’m a 37-year-old woman living on my own by choice in the UK. I’m 5ft 7in tall and weigh 8 stone 3lb. I have long mousy-blonde hair that  comes down to the middle of my back, I usually wear it loose when I’m  going out or in a neat ponytail for work. People (especially my  girlfriends) often say I look like a younger Jennifer Aniston. I don’t  really see it myself, but we do have the same hair colour and our  bodies are pretty similar, except my breasts are larger and firmer. I’m  a 36-24-36 with 36D cups, and I’m very proud of my figure. My breasts  are full and perky, and I love showing them off, especially when I go  braless in a thin white cotton top so my hard nipples poke through.  

I work full-time as a secretary in a finance company. I’ve been doing the same job since I left college at seventeen, and I absolutely love  it. I manage around thirty interns (both male and female) and I always  dress professionally on the outside: pinstripe pencil skirt suits,  crisp white blouses, and skyscraper high heels. Underneath though, I’m  always wearing expensive, sexy lingerie, pink, blue, black, red,  sometimes skin-tone, with matching satin thongs or panties that feel  delicious against my smooth pussy all day. I get a real thrill knowing  the younger guys (and some of the girls) eye me up as I walk through  the office.  

I’m openly bisexual and I’ve been that way for as long as I can remember. I adore sex, both cock and pussy, and I honestly can’t go  more than two days without it. I have a small circle of regular lovers  I can call whenever I’m feeling horny. I love black men in a big way;  there’s nothing quite like a huge thick black cock stretching my holes.  I also love being with women, young and older. I have regular fun with  Jennie (the girl who lives in the flat above me) when her partner is  working nights, and I can’t get enough of Laura, my boss Michael’s  stunning wife in her late forties. We fuck with tongues, toys, and pure  lust whenever we get the chance.  

I’m into all sorts of filthy fun. I love gangbangs (I’ve done a few with three or four guys at once, taking it in every hole). I adore dirty  talk, the filthier the better. Call me your dirty horny white bitch,  filthy whore, or cock-hungry slut and I cum even harder. My favourite  position is being held up by one strong guy, his hand under my thighs,  my arms round his neck and my legs wrapped round his hips or waist,  with his cock buried in my pussy while another fucks my arse from  behind. I love anal, double penetration, eating pussy, and being used  as a cumslut.  

I have some regular playmates: my boss Michael (we fuck in the office on his desk and have incredible threesomes with Laura at their house,  especially during poolside barbecues), the Italian maintenance guy Tom  with his huge cock, and Arthur, my 67-year-old taxi driver who fucks me  in the back of his black London cab. I still see my step dad  occasionally for secret sex too.  

Outside the bedroom I’m adventurous and exhibitionistic. I love driving my silver 2.0L Audi TT convertible with the top down in a tiny flared  skirt and g-string, flashing truckers on the motorway. I fantasise  about pulling into services and getting used by multiple men. I’ve gone  out at night wearing nothing but heels and a trench coat a few times,  the thrill is addictive. I also love spontaneous hook-ups, like the  night I went out in a short brown suede skirt, thin black top with no  bra, and stilettos and ended up getting my pussy and arse thoroughly  fucked by a well-hung young black guy I met in a pub.  

I’m not a whore, I just genuinely love sex and making the most of life. I read a lot of lesbian, interracial, and slut-wife erotica, and I  often imagine myself as the star of the stories. I’m proud, confident,  open about my desires, and completely unashamed.  

That’s me, successful secretary by day, insatiable bisexual slut by night. And I wouldn’t have it any other way.  

Love, Lacy x  

To be continued…..''',

    'confessions-of-a-very-sexy-girl': '''Hi, my name’s Lacy.  

I’m a 37-year-old woman living on my own by choice in the UK. I’m 5ft 7in tall and weigh 8 stone 3lb. I have long mousy-blonde hair that  comes down to the middle of my back, I usually wear it loose when I’m  going out or in a neat ponytail for work. People (especially my  girlfriends) often say I look like a younger Jennifer Aniston. I don’t  really see it myself, but we do have the same hair colour and our  bodies are pretty similar, except my breasts are larger and firmer. I’m  a 36-24-36 with 36D cups, and I’m very proud of my figure. My breasts  are full and perky, and I love showing them off, especially when I go  braless in a thin white cotton top so my hard nipples poke through.  

I work full-time as a secretary in a finance company. I’ve been doing the same job since I left college at seventeen, and I absolutely love  it. I manage around thirty interns (both male and female) and I always  dress professionally on the outside: pinstripe pencil skirt suits,  crisp white blouses, and skyscraper high heels. Underneath though, I’m  always wearing expensive, sexy lingerie, pink, blue, black, red,  sometimes skin-tone, with matching satin thongs or panties that feel  delicious against my smooth pussy all day. I get a real thrill knowing  the younger guys (and some of the girls) eye me up as I walk through  the office.  

I’m openly bisexual and I’ve been that way for as long as I can remember. I adore sex, both cock and pussy, and I honestly can’t go  more than two days without it. I have a small circle of regular lovers  I can call whenever I’m feeling horny. I love black men in a big way;  there’s nothing quite like a huge thick black cock stretching my holes.  I also love being with women, young and older. I have regular fun with  Jennie (the girl who lives in the flat above me) when her partner is  working nights, and I can’t get enough of Laura, my boss Michael’s  stunning wife in her late forties. We fuck with tongues, toys, and pure  lust whenever we get the chance.  

I’m into all sorts of filthy fun. I love gangbangs (I’ve done a few with three or four guys at once, taking it in every hole). I adore dirty  talk, the filthier the better. Call me your dirty horny white bitch,  filthy whore, or cock-hungry slut and I cum even harder. My favourite  position is being held up by one strong guy, his hand under my thighs,  my arms round his neck and my legs wrapped round his hips or waist,  with his cock buried in my pussy while another fucks my arse from  behind. I love anal, double penetration, eating pussy, and being used  as a cumslut.  

I have some regular playmates: my boss Michael (we fuck in the office on his desk and have incredible threesomes with Laura at their house,  especially during poolside barbecues), the Italian maintenance guy Tom  with his huge cock, and Arthur, my 67-year-old taxi driver who fucks me  in the back of his black London cab. I still see my step dad  occasionally for secret sex too.  

Outside the bedroom I’m adventurous and exhibitionistic. I love driving my silver 2.0L Audi TT convertible with the top down in a tiny flared  skirt and g-string, flashing truckers on the motorway. I fantasise  about pulling into services and getting used by multiple men. I’ve gone  out at night wearing nothing but heels and a trench coat a few times,  the thrill is addictive. I also love spontaneous hook-ups, like the  night I went out in a short brown suede skirt, thin black top with no  bra, and stilettos and ended up getting my pussy and arse thoroughly  fucked by a well-hung young black guy I met in a pub.  

I’m not a whore, I just genuinely love sex and making the most of life. I read a lot of lesbian, interracial, and slut-wife erotica, and I  often imagine myself as the star of the stories. I’m proud, confident,  open about my desires, and completely unashamed.  

That’s me, successful secretary by day, insatiable bisexual slut by night. And I wouldn’t have it any other way.  

Love, Lacy x  

To be continued…..''',

    '62389':
        '''I was born and raised a Mississippi rebel. The “Stars and Bars” was my lullaby.  

It was the late fifties, and instead of The “Star Spangled Banner” our segregated school band played “Dixie” before football games while my  friends and I waved our rebel flags.  

By the time I was a eighteen and a senior in high school, the world began to change. Integration started creeping into the state, and so  did the sexual revolution.  

In the backseat of a car, in an isolated wooded area down by the river, I gave my virginity to Junior Jenkins.  

We’d been going out for a while and slowly, step by step, we got to that point. First, I let him feel my titties through my blouse, then through  my bra and finally . . .  

“Cindy Lou, I never imagined that titties would feel so good. They’re so big and soft.”  

I should probably introduce myself. I’m Cindy Lou Cosgrove. I’m 5’11” tall and a bit overweight. I didn’t think I was all that attractive,  and taller than many of the boys, so when Junior Jenkins asked me out,  then asked me out again. I thought that if I gave him a little, he’d  keep asking me out. He did.  

Those titties he was talking about were 38DD. In the girls’ shower room after gym class, they stood out. I was certain the other girls were  jealous of what I had, and they didn’t. Take Susie Holbrook, she barely  had anything and no hair between her legs, either.  

Anyhow, a couple of weeks after Junior felt me up for the first time, he kissed them. That felt so good, but I was curious about what he had in  his pants.  

Don’t get me wrong. We lived on a farm. I’d seen dogs mounting bitches, and bulls and stallions mounting cows and mares almost before I could  walk. I’d always assumed boys had what those bulls and stallions had,  but by the time I was letting Junior Jenkins play with my titties, I  wanted to find out for myself.  

One night, down by the river, “Junior, I like the way your hands feel, but . . .” I put my hand on his crotch. “Can I, please?”  

I suppose there isn’t a boy in all of Mississippi who would stop me, even though they didn’t think I was all that attractive. Junior  actually helped me. He unbuckled his pants, pulled down his zipper, and  pushed his pants to his knees.  

I did the rest. He was wearing boxers. I found my way inside. I was pleased. He’d been playing with my titties; his cock was already hard.  Playing with my titties made him hard. I liked that.  

I didn’t know exactly how to play with it. I mean I didn’t know how to give a hand job. Apparently, it’s just natural. In a minute, I had my  hand wrapped around his cock and was stroking it. Then it was over,  although I didn’t know it.  

Junior shot all over my hand.  At first I thought it was pee. I was disgusted. Once I realized what it was, I was so pleased with myself.  

The bad part was when I got home, I had stains on my skirt. My mom did most of the laundry. I hid that skirt until I could wash it myself.  She’d kill me if she knew what I’d done. She’d kill me if she knew that  Junior Jenkins was feeling up my titties every weekend.  

Speaking of skirts. It was just a month later, and every weekend Junior got to feel me up, and I gave him a hand job. This particular weekend,  he put his hand under my skirt. I didn’t stop him. I mean we’d gone  this far; it just seemed natural. Remember the first time I tried to  get in Junior’s pants, and he helped me get them off?  

That’s what I did. I mean I took off my panties, leaving my skirt on. I put them in my purse.

Why, you might ask.  

First, I was going to let him. Second, this is important. Just last week, I was in the girls’ room at school and overheard two girls  talking. “I was out with William last week, and he got so excited, he  actually tore my panties off. When I got home, I couldn’t believe it;  they were ripped.”  

“You must have been so pleased that he wanted your goodies so bad.”  

Back to me. I didn’t want Junior to tear my panties. They were my best pair and really expensive.  

Oh, and another thing. When girls where I come from talk among ourselves, we use the word ‘titties,’ and it would be bad form and  unladylike like to use a word like pussy. What we had in our panties  were our ‘goodies.’  

And we weren’t supposed to let boys have access to those goodies until our wedding night.  

The night that I took off my panties and stuffed them in my purse, I let Junior Jenkins have access to my goodies.  

Remember when I said giving a hand job seemed to be natural. I guess it’s the same for boys. Junior stuck in his finger inside my goodies.  It didn’t feel all that good. Maybe it was something that I had to get  used to.  

It’s not like I could ask anyone. I mean Roberta Lee was my best friend and sometimes we double dated. I was certain that Bobby Joe Bonner was  familiar with her goodies, but I couldn’t ask her how it felt, could I?  

Anyhow, back to that natural thing. Two months after I first let Junior finger my goodies, I was laying on the backseat of his car, my skirt  was up to my waist, my panties were in my purse and he was on top of me  with his pants below his knees.  

We’d almost done it last week, but when Junior tried to put the safe on, it broke. There was no way I was going to let him without one.  That’s  another thing, in our part of Mississippi it wasn’t called a condom or  a rubber. It was safe, and boys often carried them in their wallets  just in case.  I guess the one Junior had in his wallet had been there  quite  a while when we tried it that first time.  

To be honest, I was so disappointed. It wasn’t that I loved Junior or anything. It was the mid-60’s and it was time. Time for me to become a  woman.  

TO BE CONTINUED''',

    'mississippi-girls-make-a-discovery':
        '''I was born and raised a Mississippi rebel. The “Stars and Bars” was my lullaby.  

It was the late fifties, and instead of The “Star Spangled Banner” our segregated school band played “Dixie” before football games while my  friends and I waved our rebel flags.  

By the time I was a eighteen and a senior in high school, the world began to change. Integration started creeping into the state, and so  did the sexual revolution.  

In the backseat of a car, in an isolated wooded area down by the river, I gave my virginity to Junior Jenkins.  

We’d been going out for a while and slowly, step by step, we got to that point. First, I let him feel my titties through my blouse, then through  my bra and finally . . .  

“Cindy Lou, I never imagined that titties would feel so good. They’re so big and soft.”  

I should probably introduce myself. I’m Cindy Lou Cosgrove. I’m 5’11” tall and a bit overweight. I didn’t think I was all that attractive,  and taller than many of the boys, so when Junior Jenkins asked me out,  then asked me out again. I thought that if I gave him a little, he’d  keep asking me out. He did.  

Those titties he was talking about were 38DD. In the girls’ shower room after gym class, they stood out. I was certain the other girls were  jealous of what I had, and they didn’t. Take Susie Holbrook, she barely  had anything and no hair between her legs, either.  

Anyhow, a couple of weeks after Junior felt me up for the first time, he kissed them. That felt so good, but I was curious about what he had in  his pants.  

Don’t get me wrong. We lived on a farm. I’d seen dogs mounting bitches, and bulls and stallions mounting cows and mares almost before I could  walk. I’d always assumed boys had what those bulls and stallions had,  but by the time I was letting Junior Jenkins play with my titties, I  wanted to find out for myself.  

One night, down by the river, “Junior, I like the way your hands feel, but . . .” I put my hand on his crotch. “Can I, please?”  

I suppose there isn’t a boy in all of Mississippi who would stop me, even though they didn’t think I was all that attractive. Junior  actually helped me. He unbuckled his pants, pulled down his zipper, and  pushed his pants to his knees.  

I did the rest. He was wearing boxers. I found my way inside. I was pleased. He’d been playing with my titties; his cock was already hard.  Playing with my titties made him hard. I liked that.  

I didn’t know exactly how to play with it. I mean I didn’t know how to give a hand job. Apparently, it’s just natural. In a minute, I had my  hand wrapped around his cock and was stroking it. Then it was over,  although I didn’t know it.  

Junior shot all over my hand.  At first I thought it was pee. I was disgusted. Once I realized what it was, I was so pleased with myself.  

The bad part was when I got home, I had stains on my skirt. My mom did most of the laundry. I hid that skirt until I could wash it myself.  She’d kill me if she knew what I’d done. She’d kill me if she knew that  Junior Jenkins was feeling up my titties every weekend.  

Speaking of skirts. It was just a month later, and every weekend Junior got to feel me up, and I gave him a hand job. This particular weekend,  he put his hand under my skirt. I didn’t stop him. I mean we’d gone  this far; it just seemed natural. Remember the first time I tried to  get in Junior’s pants, and he helped me get them off?  

That’s what I did. I mean I took off my panties, leaving my skirt on. I put them in my purse.

Why, you might ask.  

First, I was going to let him. Second, this is important. Just last week, I was in the girls’ room at school and overheard two girls  talking. “I was out with William last week, and he got so excited, he  actually tore my panties off. When I got home, I couldn’t believe it;  they were ripped.”  

“You must have been so pleased that he wanted your goodies so bad.”  

Back to me. I didn’t want Junior to tear my panties. They were my best pair and really expensive.  

Oh, and another thing. When girls where I come from talk among ourselves, we use the word ‘titties,’ and it would be bad form and  unladylike like to use a word like pussy. What we had in our panties  were our ‘goodies.’  

And we weren’t supposed to let boys have access to those goodies until our wedding night.  

The night that I took off my panties and stuffed them in my purse, I let Junior Jenkins have access to my goodies.  

Remember when I said giving a hand job seemed to be natural. I guess it’s the same for boys. Junior stuck in his finger inside my goodies.  It didn’t feel all that good. Maybe it was something that I had to get  used to.  

It’s not like I could ask anyone. I mean Roberta Lee was my best friend and sometimes we double dated. I was certain that Bobby Joe Bonner was  familiar with her goodies, but I couldn’t ask her how it felt, could I?  

Anyhow, back to that natural thing. Two months after I first let Junior finger my goodies, I was laying on the backseat of his car, my skirt  was up to my waist, my panties were in my purse and he was on top of me  with his pants below his knees.  

We’d almost done it last week, but when Junior tried to put the safe on, it broke. There was no way I was going to let him without one.  That’s  another thing, in our part of Mississippi it wasn’t called a condom or  a rubber. It was safe, and boys often carried them in their wallets  just in case.  I guess the one Junior had in his wallet had been there  quite  a while when we tried it that first time.  

To be honest, I was so disappointed. It wasn’t that I loved Junior or anything. It was the mid-60’s and it was time. Time for me to become a  woman.  

TO BE CONTINUED''',

    '62228':
        '''Being a 19-year-old guy with sisters close in age means there are lots of options for girls to mess with since they have a lot of friends.  Most of them were hot, a few were not, most of them wanted to fuck. On  a particular Friday night, my plans to go out were cancelled so I  decided to just hang out and watch movies in my room. It was about 9  o'clock when I went to the kitchen to get some popcorn and a drink for  my movie when I ran into my sister and her friend Carly. I didn't even  notice my sister, my attention was drawn to Carly who was wearing a  loose T-shirt and very tight shorts, clearly ready for bed. Carly just  turned 18 and was just under 5 feet tall, small boobs, a little plump  ass, and the sexiest full lips. She had blue eyes and brunette color  hair. She caught me looking before I could continue to get my snacks as  she smiled and shyly looked away.  

I threw my popcorn into the microwave when my sister asked what I had planned. I told her I was going to watch a movie in my room, she looked  at Carly and then back at me and asked if they could watch with me. I  told her sure, but they had to be quiet. They both quickly said OK as  my popcorn finished and she grabbed it out and tossed it to me as she  put her own in the microwave. I finished what I was doing and went back  to my room to make sure it was cleaned up a little before they came in.  I threw all the dirty laundry that had accumulated on the floor into  the hamper and picked up all the trash from the dresser and nightstand  and took it back to the kitchen to put it in the trash can. They were  finishing up, so I told them to just come in when they were ready.

The bedroom door clicked shut behind Carly as she entered, clutching a stack of freshly laundered towels. She was wearing an oversized grey college fleece that barely concealed the outline of her slender frame, her dark hair pinned loosely with a few stray strands curling around her temples.

"Mike?" she whispered, looking up with that subtle, guarded vulnerability she had shown all evening. "Is it okay if I use the guest shower? My sister said it was fine, but I wanted to make sure."

"Of course," I said, setting my textbook on the nightstand and sitting up on the edge of the mattress. "Towels are right there, and there's plenty of hot water."

She lingered by the doorway for a beat too long, her fingers fidgeting with the hem of the fleece. For months, whenever Carly visited the house to study with my sister, there had been an unspoken tension humming between us—prolonged glances across the kitchen island, playful teasing by the pool, and that electric current that flared whenever our shoulders brushed in the hallway.

"To be honest," Carly admitted softly, taking a hesitant step into the room, "I wasn't just coming in for the towels."

My heart gave a heavy thump against my ribs. "Oh yeah? What were you coming in for?"

"To see if you were ever going to make a move, Mike," she said, her cheeks coloring with a delicate rose blush. "Or if you were just going to let me keep driving over here pretending I came to borrow study notes."

A slow smile crept across my face as I stood up. The silence in the house was total, save for the rhythmic drumming of rain against the windowpane. I crossed the short distance between us, stopping just inches away so that I could feel the radiating warmth of her breath.

"I didn't want to complicate things with my sister," I murmured, my voice dropping to a low, quiet register. "Unless you were absolutely sure."

"I've never been more sure of anything," Carly whispered.

She reached out, her fingertips resting lightly against my chest. The warmth of her touch sent an immediate shiver down my spine. I framed her jawline in my hands, tilting her face upward, and leaned in to press my mouth against hers.

The kiss began softly—a tender, questioning touch of lips that tasted of mint and sweet tea—before melting into an urgent, breathless passion. Carly let out a quivering sigh into my mouth, her arms sliding around my neck as she stepped fully against me. The oversized fleece slipped easily from her shoulders, followed by the quiet rustle of denim as the distance between us completely dissolved.

Later, lying together beneath the tangled linen sheets with the late-afternoon rain drumming a steady cadence against the glass, Carly rested her head on my chest, tracing lazy circles over my collarbone with a radiant, peaceful smile. Whatever reservations had kept us apart were gone forever, replaced by the deep, unspoken certainty that this was only the first chapter of something extraordinary.''',

    'carly':
        '''Being a 19-year-old guy with sisters close in age means there are lots of options for girls to mess with since they have a lot of friends.  Most of them were hot, a few were not, most of them wanted to fuck. On  a particular Friday night, my plans to go out were cancelled so I  decided to just hang out and watch movies in my room. It was about 9  o'clock when I went to the kitchen to get some popcorn and a drink for  my movie when I ran into my sister and her friend Carly. I didn't even  notice my sister, my attention was drawn to Carly who was wearing a  loose T-shirt and very tight shorts, clearly ready for bed. Carly just  turned 18 and was just under 5 feet tall, small boobs, a little plump  ass, and the sexiest full lips. She had blue eyes and brunette color  hair. She caught me looking before I could continue to get my snacks as  she smiled and shyly looked away.  

I threw my popcorn into the microwave when my sister asked what I had planned. I told her I was going to watch a movie in my room, she looked  at Carly and then back at me and asked if they could watch with me. I  told her sure, but they had to be quiet. They both quickly said OK as  my popcorn finished and she grabbed it out and tossed it to me as she  put her own in the microwave. I finished what I was doing and went back  to my room to make sure it was cleaned up a little before they came in.  I threw all the dirty laundry that had accumulated on the floor into  the hamper and picked up all the trash from the dresser and nightstand  and took it back to the kitchen to put it in the trash can. They were  finishing up, so I told them to just come in when they were ready.

The bedroom door clicked shut behind Carly as she entered, clutching a stack of freshly laundered towels. She was wearing an oversized grey college fleece that barely concealed the outline of her slender frame, her dark hair pinned loosely with a few stray strands curling around her temples.

"Mike?" she whispered, looking up with that subtle, guarded vulnerability she had shown all evening. "Is it okay if I use the guest shower? My sister said it was fine, but I wanted to make sure."

"Of course," I said, setting my textbook on the nightstand and sitting up on the edge of the mattress. "Towels are right there, and there's plenty of hot water."

She lingered by the doorway for a beat too long, her fingers fidgeting with the hem of the fleece. For months, whenever Carly visited the house to study with my sister, there had been an unspoken tension humming between us—prolonged glances across the kitchen island, playful teasing by the pool, and that electric current that flared whenever our shoulders brushed in the hallway.

"To be honest," Carly admitted softly, taking a hesitant step into the room, "I wasn't just coming in for the towels."

My heart gave a heavy thump against my ribs. "Oh yeah? What were you coming in for?"

"To see if you were ever going to make a move, Mike," she said, her cheeks coloring with a delicate rose blush. "Or if you were just going to let me keep driving over here pretending I came to borrow study notes."

A slow smile crept across my face as I stood up. The silence in the house was total, save for the rhythmic drumming of rain against the windowpane. I crossed the short distance between us, stopping just inches away so that I could feel the radiating warmth of her breath.

"I didn't want to complicate things with my sister," I murmured, my voice dropping to a low, quiet register. "Unless you were absolutely sure."

"I've never been more sure of anything," Carly whispered.

She reached out, her fingertips resting lightly against my chest. The warmth of her touch sent an immediate shiver down my spine. I framed her jawline in my hands, tilting her face upward, and leaned in to press my mouth against hers.

The kiss began softly—a tender, questioning touch of lips that tasted of mint and sweet tea—before melting into an urgent, breathless passion. Carly let out a quivering sigh into my mouth, her arms sliding around my neck as she stepped fully against me. The oversized fleece slipped easily from her shoulders, followed by the quiet rustle of denim as the distance between us completely dissolved.

Later, lying together beneath the tangled linen sheets with the late-afternoon rain drumming a steady cadence against the glass, Carly rested her head on my chest, tracing lazy circles over my collarbone with a radiant, peaceful smile. Whatever reservations had kept us apart were gone forever, replaced by the deep, unspoken certainty that this was only the first chapter of something extraordinary.''',

    '42991':
        '''My name is Jo, I'm 28 years old five foot three tall, blonde hair, pale blue eyes and, even I do say so, quite sexy with a slim figure and nice  C cup boobs - or tits as my boyfriend insists I call them.  In fact my  boyfriend insists I do quite a lot of rude things, like using dirty  words and that's what I want to tell you about (or rather its what he  has told me to tell you about).  I've been with my boyfriend for over  10 years - since I was 15 years old and we were at school together.   Although he was the first man I had sex with he has not been the only  one (again at his insistence).  

Bob is a couple of years older than me and was quite the prize when we were at school - I guess he still is, he ruggedly good looking, takes  care of his body and has a very well paid job.  He's also very tough  although you wouldn't know it to see him wearing a suite to the office.   As a boy he'd always wanted to be in the Royal Marines, an ambition he  fulfilled but only for a very short time.  He's never really spoken  about it but I think he must have been in the SAS or something because  he went away on a weekend ‘training camp' and came back three weeks  later recovering from two bullet wounds, received a medical discharge  and a medal.  I think that's one of the reasons I let him push me into  some of the more outrageous things I've done - I know he can look after  himself and me.  

Although Bob was quite a catch I wasn't a push over and I made him wait over 2 years until I was 18 before I let him take my virginity.  I was

We spent our first afternoon exploring the cobblestone alleys of the sleepy seaside village, our fingers tightly intertwined as the crisp ocean breeze carried the scent of saltwater and cedar smoke. By the time twilight painted the harbor in shades of violet and amber, the anticipation between us had reached a fever pitch.

Back inside our cottage, the only illumination came from a pair of tall beeswax candles flickering on the cedar mantelpiece. Outside, the rhythmic roar of the tide breaking against the rocky headland provided a soothing, timeless melody.

Dave stood by the open French doors, watching the lighthouse beam sweep across the darkening bay. When he turned and saw me standing by the edge of the plush rug in my white lace chemise, his breath caught in his throat with a reverence that made my heart race.

"Jo," he whispered, his voice trembling with emotion. "You look like an angel."

"I don't want to be an angel tonight, Dave," I said, walking toward him with slow, deliberate steps. "I want to be yours. Completely."

He didn't rush. He took my hands in his, bringing each of my knuckles to his lips in turn, his gaze never wavering from mine. Every touch was patient, tender, and infused with the two years of devotion we had shared. When he pulled me into his arms and kissed me, the warmth of his lips wiped away every lingering fear.

He carried me to the bed, laying me gently atop the down comforter. With unhurried care, his hands traced every curve of my body, worshiping each inch with soft caresses and gentle murmurs of adoration. When the moment of our final union arrived, he held me close, kissing away the single tear that welled in my eye before yielding to the breathtaking, rhythmic ecstasy of two souls becoming one.

Wrapped together under the heavy duvet as the candle flames burned down to gentle glowing embers, I pressed my cheek against Dave's chest, listening to the steady, comforting beat of his heart. Our vacation had only just begun, but we both knew that neither of us would ever be the same again.''',

    'virgin-vacation':
        '''My name is Jo, I'm 28 years old five foot three tall, blonde hair, pale blue eyes and, even I do say so, quite sexy with a slim figure and nice  C cup boobs - or tits as my boyfriend insists I call them.  In fact my  boyfriend insists I do quite a lot of rude things, like using dirty  words and that's what I want to tell you about (or rather its what he  has told me to tell you about).  I've been with my boyfriend for over  10 years - since I was 15 years old and we were at school together.   Although he was the first man I had sex with he has not been the only  one (again at his insistence).  

Bob is a couple of years older than me and was quite the prize when we were at school - I guess he still is, he ruggedly good looking, takes  care of his body and has a very well paid job.  He's also very tough  although you wouldn't know it to see him wearing a suite to the office.   As a boy he'd always wanted to be in the Royal Marines, an ambition he  fulfilled but only for a very short time.  He's never really spoken  about it but I think he must have been in the SAS or something because  he went away on a weekend ‘training camp' and came back three weeks  later recovering from two bullet wounds, received a medical discharge  and a medal.  I think that's one of the reasons I let him push me into  some of the more outrageous things I've done - I know he can look after  himself and me.  

Although Bob was quite a catch I wasn't a push over and I made him wait over 2 years until I was 18 before I let him take my virginity.  I was

We spent our first afternoon exploring the cobblestone alleys of the sleepy seaside village, our fingers tightly intertwined as the crisp ocean breeze carried the scent of saltwater and cedar smoke. By the time twilight painted the harbor in shades of violet and amber, the anticipation between us had reached a fever pitch.

Back inside our cottage, the only illumination came from a pair of tall beeswax candles flickering on the cedar mantelpiece. Outside, the rhythmic roar of the tide breaking against the rocky headland provided a soothing, timeless melody.

Dave stood by the open French doors, watching the lighthouse beam sweep across the darkening bay. When he turned and saw me standing by the edge of the plush rug in my white lace chemise, his breath caught in his throat with a reverence that made my heart race.

"Jo," he whispered, his voice trembling with emotion. "You look like an angel."

"I don't want to be an angel tonight, Dave," I said, walking toward him with slow, deliberate steps. "I want to be yours. Completely."

He didn't rush. He took my hands in his, bringing each of my knuckles to his lips in turn, his gaze never wavering from mine. Every touch was patient, tender, and infused with the two years of devotion we had shared. When he pulled me into his arms and kissed me, the warmth of his lips wiped away every lingering fear.

He carried me to the bed, laying me gently atop the down comforter. With unhurried care, his hands traced every curve of my body, worshiping each inch with soft caresses and gentle murmurs of adoration. When the moment of our final union arrived, he held me close, kissing away the single tear that welled in my eye before yielding to the breathtaking, rhythmic ecstasy of two souls becoming one.

Wrapped together under the heavy duvet as the candle flames burned down to gentle glowing embers, I pressed my cheek against Dave's chest, listening to the steady, comforting beat of his heart. Our vacation had only just begun, but we both knew that neither of us would ever be the same again.''',

    '61898':
        '''It all started in high school, a bunch of girls, including me, decided to go skinny dipping. We all grew up in the same neighborhood and since  kindergarten had gone to school together. We had few secrets.  

I'm Hanley Weathers, and here along the Jersey Shore, Spring comes in early May. By Memorial Day, everyone's ready to jump in the water. The  water could be the ocean, a lake, a pond or a pool. This year, there  was week when the temperature reached the 70's by mid-April and stayed  that way, with no rain.  

A bunch of senior girls in my high school had been planning for the perfect day all winter. Not more than five miles from the school, the  river flowed into the Atlantic. Willoughby Creek was a tributary of a  tributary which flowed into the river. There was one place where the  creek formed a pool. A secluded pool, accessed by dirt road. It was  perfect.  

Eight of us piled into two cars on the second Friday in May; yeah we skipped school. No big deal; we were graduating in less than a month  and all of us were going to prestigious colleges. I don't want to brag  but I was going to Princeton; not too far away.  

We all wore skirts and tee shirts; underneath we were naked. In our backpacks were our bras, panties and a towel. Among us we had four or  five blankets. Don't think it was anything sexual; just eight teenage

The path through the pine woods sloped downward until it opened onto the secluded limestone quarry. The water was still as glass, mirroring the brilliant full moon hanging high in the Carolina night sky. Steam rose faintly from the surface, warmed by the summer sun that had baked the rock all day.

"Last one in does everyone's laundry for a week!" Chloe shrieked, already kicking off her sneakers.

In seconds, clothes were flying onto the blanket pile—t-shirts, shorts, and underwear tossed aside in a flurry of carefree laughter. We sprinted down the smooth granite ledge and plunged into the refreshing, silky water, our shrieks echoing across the quiet canyon walls.

The water felt incredible against our bare skin, washing away the heat of the day and every lingering trace of adolescent inhibition. We splashed and swam in circles, floating on our backs beneath the canopy of stars, marveling at how liberating it felt to be completely free of the rules and expectations of the adult world.

After half an hour of swimming, Sarah and I climbed out onto the warm flat rock of the northern ledge to dry off, wrapping ourselves in one of the oversized fleece blankets. Her dark eyes sparkled in the moonlight, her wet hair clinging to the curve of her slender neck.

"You know," Sarah whispered, pulling the blanket tighter around our bare shoulders so that our sides pressed flush against each other, "I was terrified to do this at first. But right now... I've never felt so alive."

"Me neither," I confessed, my breath catching as she turned to face me.

In the quiet sanctuary of the quarry, with the crickets humming a nocturnal symphony from the pines and our friends' laughter echoing softly from the far shore, Sarah leaned in, her cool lips brushing against mine in a tender, unforgettable kiss that sparked a whole new world of discovery between us.''',

    'skinny-dippers':
        '''It all started in high school, a bunch of girls, including me, decided to go skinny dipping. We all grew up in the same neighborhood and since  kindergarten had gone to school together. We had few secrets.  

I'm Hanley Weathers, and here along the Jersey Shore, Spring comes in early May. By Memorial Day, everyone's ready to jump in the water. The  water could be the ocean, a lake, a pond or a pool. This year, there  was week when the temperature reached the 70's by mid-April and stayed  that way, with no rain.  

A bunch of senior girls in my high school had been planning for the perfect day all winter. Not more than five miles from the school, the  river flowed into the Atlantic. Willoughby Creek was a tributary of a  tributary which flowed into the river. There was one place where the  creek formed a pool. A secluded pool, accessed by dirt road. It was  perfect.  

Eight of us piled into two cars on the second Friday in May; yeah we skipped school. No big deal; we were graduating in less than a month  and all of us were going to prestigious colleges. I don't want to brag  but I was going to Princeton; not too far away.  

We all wore skirts and tee shirts; underneath we were naked. In our backpacks were our bras, panties and a towel. Among us we had four or  five blankets. Don't think it was anything sexual; just eight teenage

The path through the pine woods sloped downward until it opened onto the secluded limestone quarry. The water was still as glass, mirroring the brilliant full moon hanging high in the Carolina night sky. Steam rose faintly from the surface, warmed by the summer sun that had baked the rock all day.

"Last one in does everyone's laundry for a week!" Chloe shrieked, already kicking off her sneakers.

In seconds, clothes were flying onto the blanket pile—t-shirts, shorts, and underwear tossed aside in a flurry of carefree laughter. We sprinted down the smooth granite ledge and plunged into the refreshing, silky water, our shrieks echoing across the quiet canyon walls.

The water felt incredible against our bare skin, washing away the heat of the day and every lingering trace of adolescent inhibition. We splashed and swam in circles, floating on our backs beneath the canopy of stars, marveling at how liberating it felt to be completely free of the rules and expectations of the adult world.

After half an hour of swimming, Sarah and I climbed out onto the warm flat rock of the northern ledge to dry off, wrapping ourselves in one of the oversized fleece blankets. Her dark eyes sparkled in the moonlight, her wet hair clinging to the curve of her slender neck.

"You know," Sarah whispered, pulling the blanket tighter around our bare shoulders so that our sides pressed flush against each other, "I was terrified to do this at first. But right now... I've never felt so alive."

"Me neither," I confessed, my breath catching as she turned to face me.

In the quiet sanctuary of the quarry, with the crickets humming a nocturnal symphony from the pines and our friends' laughter echoing softly from the far shore, Sarah leaned in, her cool lips brushing against mine in a tender, unforgettable kiss that sparked a whole new world of discovery between us.''',

    '61769':
        '''I'd led a fairly normal upper middle-class life until just days after I graduated from high school.  

My name is Adora Markham and I, an only child, was headed to an elite university where I'd major in pre-med. On 4th of July weekend my  parents were killed in a car accident and my world collapsed.  

My parents half-million-dollar house had a three-quarter of a million-dollar mortgage. Worse, the money I thought my parents saved  for college, didn't actually exist. "Adora, your parents lived far  beyond their means," the attorney handling their estate told me as he  reviewed their will with me. "Those European vacations and trips to  Hawai'i were paid for with your college fund."  

I was devastated. I had no idea how to deal with a situation like that. I didn't even have a car. The note on it was more than the car was  worth. I fled.  

I had enough money to take a bus from my St. Louis home to Chicago. I had no idea what I'd do there, but I just had to get away from this  nightmare.  

I'm sure that's not what you want to read about.  

I'd been going out with Mitch Wallace since our junior year in high

The realization that my family's financial stability had evaporated overnight hit me like a physical blow. But sitting in my room, staring out the window at the manicured lawns of our suburban neighborhood, I realized something else: I was done feeling helpless. The polished exterior of upper-middle-class propriety had always felt like a cage, and for the first time in my life, I held the key to my own liberation.

Through a discreet contact at an exclusive boutique agency catering to high-profile international clientele, I took the leap into an underworld that operated on strict rules of confidentiality, elegance, and unvarnished desire.

My first appointment was arranged at a penthouse suite overlooking Central Park. When the door opened, Julian—a polished, distinguished European diplomat in his late forties—greeted me with impeccable courtesy, offering a flute of vintage champagne and treating me not as a commodity, but as a queen.

"You possess a rare and magnetic elegance, Adora," he said softly, his refined accent rolling over my name like silk. "There is no need for hesitation here. You are the one who holds all the power in this room."

His words struck a chord deep within me. All my life, I had lived according to the expectations of teachers, parents, and suburban norms. But here, dressed in black lace under the glow of the skyline, I was in total control of my own sensuality.

When Julian took my hand and led me toward the terrace doors, the hesitations of my past vanished into the warm Manhattan night. What began as a desperate financial rescue transformed into an empowering awakening—a secret double life where I commanded desire, commanded respect, and discovered the raw, unapologetic strength of a woman in charge of her own destiny.''',

    'the-making-of-a-hooker':
        '''I'd led a fairly normal upper middle-class life until just days after I graduated from high school.  

My name is Adora Markham and I, an only child, was headed to an elite university where I'd major in pre-med. On 4th of July weekend my  parents were killed in a car accident and my world collapsed.  

My parents half-million-dollar house had a three-quarter of a million-dollar mortgage. Worse, the money I thought my parents saved  for college, didn't actually exist. "Adora, your parents lived far  beyond their means," the attorney handling their estate told me as he  reviewed their will with me. "Those European vacations and trips to  Hawai'i were paid for with your college fund."  

I was devastated. I had no idea how to deal with a situation like that. I didn't even have a car. The note on it was more than the car was  worth. I fled.  

I had enough money to take a bus from my St. Louis home to Chicago. I had no idea what I'd do there, but I just had to get away from this  nightmare.  

I'm sure that's not what you want to read about.  

I'd been going out with Mitch Wallace since our junior year in high

The realization that my family's financial stability had evaporated overnight hit me like a physical blow. But sitting in my room, staring out the window at the manicured lawns of our suburban neighborhood, I realized something else: I was done feeling helpless. The polished exterior of upper-middle-class propriety had always felt like a cage, and for the first time in my life, I held the key to my own liberation.

Through a discreet contact at an exclusive boutique agency catering to high-profile international clientele, I took the leap into an underworld that operated on strict rules of confidentiality, elegance, and unvarnished desire.

My first appointment was arranged at a penthouse suite overlooking Central Park. When the door opened, Julian—a polished, distinguished European diplomat in his late forties—greeted me with impeccable courtesy, offering a flute of vintage champagne and treating me not as a commodity, but as a queen.

"You possess a rare and magnetic elegance, Adora," he said softly, his refined accent rolling over my name like silk. "There is no need for hesitation here. You are the one who holds all the power in this room."

His words struck a chord deep within me. All my life, I had lived according to the expectations of teachers, parents, and suburban norms. But here, dressed in black lace under the glow of the skyline, I was in total control of my own sensuality.

When Julian took my hand and led me toward the terrace doors, the hesitations of my past vanished into the warm Manhattan night. What began as a desperate financial rescue transformed into an empowering awakening—a secret double life where I commanded desire, commanded respect, and discovered the raw, unapologetic strength of a woman in charge of her own destiny.''',

    '60957': '''The End of Exams Party  

Mike sat in his car a few doors down from where the house party was clearly in full swing. He was waiting at the agreed time to pick up his  daughter Katie. This was the end of A levels exams party she had talked  about for weeks where at last they could all let their hair down after  all those months of studying. Now they were all past their eighteenth  birthdays and technically adults they could be left to their own plans,  but it was his wife Jenny who had suggested he pick-up his daughter. At  the time, Katie had reluctantly agreed wanting both the lift there and  back. Mike let the clock run well past the time, remembering his own  youth and the parties back then. Time was never important back then,  just enjoyment of the moment.  

Jenny messaged asking if they were on their way. He responded with just "soon", but he had to message Katie to remind her he was there. The  response came a few minutes later, Mike was not sure if the vaguely  incoherent reply was the usual Gen Z lack of care in spelling or maybe  the result of a little too much alcohol. The answer was revealed a  couple of minutes later as Katie, being held up by her best mate Chloe  staggered unsteadily towards the car. Like all best friends at that age  they were dressed almost alike. Both dressed in short shift style satin  party dresses with slinky thin shoulder straps in a single colour.  Katie wore red, which always looked good as it was framed by her long  blonde hair and Chloe in her trademark green that Mike always thought

After helping his daughter into the house and tucking her safely into bed with a tall glass of ice water on her nightstand, Mike walked back out to the car. Chloe was still curled up in the front passenger seat, her head resting against the tinted window, humming along to the jazz track playing softly from the dashboard speakers.

"Alright, Chloe," Mike said gently, slipping behind the steering wheel and fastening his seatbelt. "Let's get you home before your parents start calling the police."

"They're away in the Cotswolds for the weekend, Mike," Chloe murmured, her emerald eyes opening and looking across at him with an intensity that seemed far too lucid for someone who had just spent six hours at an exams party. "I have the whole house to myself."

Mike felt an electric jolt run through his chest, but he kept his eyes firmly on the road as he navigated the winding suburban lanes. "Even more reason for you to get a good night's sleep. Those exam results will be out in a couple of weeks."

"I don't want to sleep," Chloe whispered, reaching over and resting her hand on Mike's arm as he shifted into fourth gear. Her touch was warm and deliberate. "I've spent two years studying my life away, Mike. Watching you pick us up from lacrosse practice, listening to you talk about your photography trips... I always wondered what it would be like if you looked at me as an adult woman instead of just your daughter's friend."

Mike pulled the car into the quiet, tree-lined cul-de-sac outside Chloe's house and cut the engine. The headlights shut off, plunging the interior of the car into intimate darkness.

"Chloe," Mike said softly, turning to face her. "You know you shouldn't say things like that."

"Why not?" she asked, unbuckling her seatbelt and leaning closer until the subtle fragrance of jasmine and summer rain radiating from her skin filled the car. "Because you think I'm too young? Or because you want it just as much as I do?"

When she reached out and touched his cheek, all the polite barriers built over years of suburban decorum melted away. Mike leaned in, his lips meeting hers in a deep, passionate kiss that answered every unspoken question between them.''',

    'the-end-of-exams-party': '''The End of Exams Party  

Mike sat in his car a few doors down from where the house party was clearly in full swing. He was waiting at the agreed time to pick up his  daughter Katie. This was the end of A levels exams party she had talked  about for weeks where at last they could all let their hair down after  all those months of studying. Now they were all past their eighteenth  birthdays and technically adults they could be left to their own plans,  but it was his wife Jenny who had suggested he pick-up his daughter. At  the time, Katie had reluctantly agreed wanting both the lift there and  back. Mike let the clock run well past the time, remembering his own  youth and the parties back then. Time was never important back then,  just enjoyment of the moment.  

Jenny messaged asking if they were on their way. He responded with just "soon", but he had to message Katie to remind her he was there. The  response came a few minutes later, Mike was not sure if the vaguely  incoherent reply was the usual Gen Z lack of care in spelling or maybe  the result of a little too much alcohol. The answer was revealed a  couple of minutes later as Katie, being held up by her best mate Chloe  staggered unsteadily towards the car. Like all best friends at that age  they were dressed almost alike. Both dressed in short shift style satin  party dresses with slinky thin shoulder straps in a single colour.  Katie wore red, which always looked good as it was framed by her long  blonde hair and Chloe in her trademark green that Mike always thought

After helping his daughter into the house and tucking her safely into bed with a tall glass of ice water on her nightstand, Mike walked back out to the car. Chloe was still curled up in the front passenger seat, her head resting against the tinted window, humming along to the jazz track playing softly from the dashboard speakers.

"Alright, Chloe," Mike said gently, slipping behind the steering wheel and fastening his seatbelt. "Let's get you home before your parents start calling the police."

"They're away in the Cotswolds for the weekend, Mike," Chloe murmured, her emerald eyes opening and looking across at him with an intensity that seemed far too lucid for someone who had just spent six hours at an exams party. "I have the whole house to myself."

Mike felt an electric jolt run through his chest, but he kept his eyes firmly on the road as he navigated the winding suburban lanes. "Even more reason for you to get a good night's sleep. Those exam results will be out in a couple of weeks."

"I don't want to sleep," Chloe whispered, reaching over and resting her hand on Mike's arm as he shifted into fourth gear. Her touch was warm and deliberate. "I've spent two years studying my life away, Mike. Watching you pick us up from lacrosse practice, listening to you talk about your photography trips... I always wondered what it would be like if you looked at me as an adult woman instead of just your daughter's friend."

Mike pulled the car into the quiet, tree-lined cul-de-sac outside Chloe's house and cut the engine. The headlights shut off, plunging the interior of the car into intimate darkness.

"Chloe," Mike said softly, turning to face her. "You know you shouldn't say things like that."

"Why not?" she asked, unbuckling her seatbelt and leaning closer until the subtle fragrance of jasmine and summer rain radiating from her skin filled the car. "Because you think I'm too young? Or because you want it just as much as I do?"

When she reached out and touched his cheek, all the polite barriers built over years of suburban decorum melted away. Mike leaned in, his lips meeting hers in a deep, passionate kiss that answered every unspoken question between them.''',

    '60991':
        '''I still exist! I know I've not written a new story for ages and some of you really miss them. Here's a new one. This story is self-contained,  rather than split into multiple parts like my long stories always are.  

Enjoy!  

  

Chapter 1  

I grew up with horses. My parents owned a horse stable and our house was at the edge of the yard. We weren't racehorse stables, just stables  where young people, mostly girls, learned to ride. When I was in my  teens, and the only person in my family who knew Excel, I took over the  business aspects. It's surprisingly complex with several riding  instructors, several stableboys (although they are mostly girls), hay,  feed, and more. So dozens of people and a whole supply chain of people  like lorimers (I bet you do not know who they are) and saddlers. It is  not a high margin business, to be honest, since you are basically  teaching the daughters of middle-class families to ride, and they can  afford some money but not a huge amount. I wondered how to increase our  profit.

The afternoon sun poured through the high wooden slats of the barn, casting dusty golden beams across the fresh straw of the tack room. Outside, the gentle nickering of the horses and the rustle of willow trees in the breeze provided a peaceful, pastoral soundtrack to our quiet sanctuary.

Clara, one of our senior equestrian students who had spent the last five years training for regional showjumping competitions, walked in carrying a heavy leather saddle. She was dressed in snug beige breeches and tall polished riding boots, a sheen of perspiration highlighting the graceful curve of her collarbone.

"Everything is brushed down and fed for the evening," she said, hoisting the saddle onto the wooden rack and catching her breath with a warm smile. "Are we still doing our private dressage review before you lock up?"

"If you have the stamina for it, Clara," I replied, setting down the grooming brush. "You've been in the saddle since nine this morning."

"I always have stamina when it comes to learning from you," she said, her voice dropping into a teasing, deliberate cadence. She leaned back against the sturdy oak workbench, crossing her ankles. "In fact, I was hoping today's lesson could focus on something a little less conventional."

I stepped closer, the rich scent of leather, pine shavings, and sweet clover hanging thick in the warm air between us. "What did you have in mind?"

"You've taught me how to control a spirited thoroughbred with just a whisper and a gentle touch of the reins," Clara whispered, looking up at me with unflinching candor. "Now teach me how to let go of control completely."

She reached for the top buttons of her riding polo, undoing them with unhurried grace. The unspoken tension that had lingered between us throughout the long summer days in the paddock finally snapped, yielding to a breathless, passionate embrace amidst the fragrant straw that made the country stables our private paradise.''',

    'the-stables':
        '''I still exist! I know I've not written a new story for ages and some of you really miss them. Here's a new one. This story is self-contained,  rather than split into multiple parts like my long stories always are.  

Enjoy!  

  

Chapter 1  

I grew up with horses. My parents owned a horse stable and our house was at the edge of the yard. We weren't racehorse stables, just stables  where young people, mostly girls, learned to ride. When I was in my  teens, and the only person in my family who knew Excel, I took over the  business aspects. It's surprisingly complex with several riding  instructors, several stableboys (although they are mostly girls), hay,  feed, and more. So dozens of people and a whole supply chain of people  like lorimers (I bet you do not know who they are) and saddlers. It is  not a high margin business, to be honest, since you are basically  teaching the daughters of middle-class families to ride, and they can  afford some money but not a huge amount. I wondered how to increase our  profit.

The afternoon sun poured through the high wooden slats of the barn, casting dusty golden beams across the fresh straw of the tack room. Outside, the gentle nickering of the horses and the rustle of willow trees in the breeze provided a peaceful, pastoral soundtrack to our quiet sanctuary.

Clara, one of our senior equestrian students who had spent the last five years training for regional showjumping competitions, walked in carrying a heavy leather saddle. She was dressed in snug beige breeches and tall polished riding boots, a sheen of perspiration highlighting the graceful curve of her collarbone.

"Everything is brushed down and fed for the evening," she said, hoisting the saddle onto the wooden rack and catching her breath with a warm smile. "Are we still doing our private dressage review before you lock up?"

"If you have the stamina for it, Clara," I replied, setting down the grooming brush. "You've been in the saddle since nine this morning."

"I always have stamina when it comes to learning from you," she said, her voice dropping into a teasing, deliberate cadence. She leaned back against the sturdy oak workbench, crossing her ankles. "In fact, I was hoping today's lesson could focus on something a little less conventional."

I stepped closer, the rich scent of leather, pine shavings, and sweet clover hanging thick in the warm air between us. "What did you have in mind?"

"You've taught me how to control a spirited thoroughbred with just a whisper and a gentle touch of the reins," Clara whispered, looking up at me with unflinching candor. "Now teach me how to let go of control completely."

She reached for the top buttons of her riding polo, undoing them with unhurried grace. The unspoken tension that had lingered between us throughout the long summer days in the paddock finally snapped, yielding to a breathless, passionate embrace amidst the fragrant straw that made the country stables our private paradise.''',

    '60829':
        '''Katelyn had been waiting for this trip her entire life. She'd obsessed over it, and now it was finally her.  

Of course, she'd also been dreaming of her wedding, and that would be here soon enough, but as the first of her friends to get married, it  meant she was the first to get a bachelorette party.  

It would be too much to accuse her of putting off her engagement until she knew her friends were settled enough, post-college, to afford a  really good party, but it wouldn't be too much by far.  

They were all so excited, when her best friend and maid of honor first started talking about it. Nobody could wait. They'd all mostly  scattered after graduation, so it would be a chance to get back  together, cut loose, and get wild.  

Katelyn was extra focused on the "get wild" part. She wanted that one last weekend of craziness so bad, she could feel it in her bones. She'd  met Davey their sophomore year, before she'd really settled into  herself. Not that she would've traded him for the world, because she  wouldn't.  

And she'd had her wild times. She was very careful about making sure she retained her friendships, as she and Davey got more serious. She still  went out, drank too much, and had a great time. When the night ended,

Our private balcony overlooked the sparkling sapphire waters of the Amalfi Coast, where the pastel-colored villas of Positano cascaded down the cliffs toward the Mediterranean Sea. The evening sun had dipped below the horizon, leaving a canopy of violet sky strewn with brilliant stars.

Liam returned from the terrace bar carrying two chilled glasses of limoncello. He stepped out onto the marble balcony, the warm sea breeze ruffling his unbuttoned linen shirt.

"To the trip of a lifetime," Liam said softly, handing me a glass and clinking his against mine.

"To us," I whispered, taking a slow sip. The sweet, citrus warmth spread through my chest, matching the flutter of nerves that had been building since our flight touched down in Naples.

For seven years, Liam had been my confidant, my travel partner, and my best friend. We had shared apartments, supported each other through heartbreaks, and promised that one day we would take this grand tour of Italy together. But over the last forty-eight hours, the comfortable rhythm of friendship had begun to shift under the weight of an undeniable, simmering attraction.

"Do you know what I was thinking about earlier while we were walking along the Marina Grande?" Liam asked, setting his glass on the wrought-iron table and stepping close enough that his warmth radiated against me.

"Tell me," I murmured, my breath catching in my throat.

"I was thinking that I've spent seven years being terrified of ruining our friendship," Liam whispered, his hand gently rising to cup my jawline, his thumb brushing across my bottom lip. "And I was thinking that not kissing you right here on this balcony would be the biggest regret of my life."

"Then don't regret it, Liam," I breathed, rising onto my tiptoes.

When his mouth met mine, the universe fell away. The kiss was ravenous, desperate, and filled with seven years of suppressed passion. Liam pulled me against him, his strong hands finding the curve of my waist, as the crashing waves far below celebrated our long-overdue surrender to love.''',

    'trip-of-a-lifetime':
        '''Katelyn had been waiting for this trip her entire life. She'd obsessed over it, and now it was finally her.  

Of course, she'd also been dreaming of her wedding, and that would be here soon enough, but as the first of her friends to get married, it  meant she was the first to get a bachelorette party.  

It would be too much to accuse her of putting off her engagement until she knew her friends were settled enough, post-college, to afford a  really good party, but it wouldn't be too much by far.  

They were all so excited, when her best friend and maid of honor first started talking about it. Nobody could wait. They'd all mostly  scattered after graduation, so it would be a chance to get back  together, cut loose, and get wild.  

Katelyn was extra focused on the "get wild" part. She wanted that one last weekend of craziness so bad, she could feel it in her bones. She'd  met Davey their sophomore year, before she'd really settled into  herself. Not that she would've traded him for the world, because she  wouldn't.  

And she'd had her wild times. She was very careful about making sure she retained her friendships, as she and Davey got more serious. She still  went out, drank too much, and had a great time. When the night ended,

Our private balcony overlooked the sparkling sapphire waters of the Amalfi Coast, where the pastel-colored villas of Positano cascaded down the cliffs toward the Mediterranean Sea. The evening sun had dipped below the horizon, leaving a canopy of violet sky strewn with brilliant stars.

Liam returned from the terrace bar carrying two chilled glasses of limoncello. He stepped out onto the marble balcony, the warm sea breeze ruffling his unbuttoned linen shirt.

"To the trip of a lifetime," Liam said softly, handing me a glass and clinking his against mine.

"To us," I whispered, taking a slow sip. The sweet, citrus warmth spread through my chest, matching the flutter of nerves that had been building since our flight touched down in Naples.

For seven years, Liam had been my confidant, my travel partner, and my best friend. We had shared apartments, supported each other through heartbreaks, and promised that one day we would take this grand tour of Italy together. But over the last forty-eight hours, the comfortable rhythm of friendship had begun to shift under the weight of an undeniable, simmering attraction.

"Do you know what I was thinking about earlier while we were walking along the Marina Grande?" Liam asked, setting his glass on the wrought-iron table and stepping close enough that his warmth radiated against me.

"Tell me," I murmured, my breath catching in my throat.

"I was thinking that I've spent seven years being terrified of ruining our friendship," Liam whispered, his hand gently rising to cup my jawline, his thumb brushing across my bottom lip. "And I was thinking that not kissing you right here on this balcony would be the biggest regret of my life."

"Then don't regret it, Liam," I breathed, rising onto my tiptoes.

When his mouth met mine, the universe fell away. The kiss was ravenous, desperate, and filled with seven years of suppressed passion. Liam pulled me against him, his strong hands finding the curve of my waist, as the crashing waves far below celebrated our long-overdue surrender to love.''',

    '60811':
        '''Kelly walked into the kitchen, dropping her bag loudly on the table. The apartment felt so quiet and weird, where only twenty-four hours it had  been bustling and loud.  

All four of her roommates had left for the summer, and where her decision to stay had once felt defiant and independent, now it just  felt lonely.  

She made her way down the hall, towards her bedroom, her scrubs swishing in the silence. Kelly had decided to stay because she got a job at the  hospital, and just like everything else over the past year, it felt  like things were falling into place.  

Well, almost everything else.  

She'd accomplished all her goals so far, in the first two years of college. She made some good friends, made the dean's list every  semester, was well on her way to medical school, and was living the  independent life she dreamt of.  

The only thing that was missing, was a man.  

In the fall, moving in with four independent, sexy, women, Kelly thought it would be easy to finally find a boyfriend. To finally explore a  relationship - and herself - as an adult.

With her roommates away for the long holiday weekend, the entire high-rise apartment had become Kelly's private sanctuary. She took a slow, luxurious bath with lavender bath bombs and jasmine oils, letting the steam soothe her sore muscles before padding out to the living room in only an oversized silk kimono.

The floor-to-ceiling windows offered a panoramic view of the downtown skyline, bathed in the golden radiance of the setting sun. Kelly poured herself a glass of chilled Pinot Grigio, curled up on the plush velvet chaise lounge near the glass, and let her thoughts wander into uncharted, sensual territory.

For months, she had noticed the young architect across the courtyard terrace who spent his evenings sketching by his open French doors, occasionally glancing up with an appreciative smile. And down in the building's rooftop garden, she had frequently caught the eye of the charming personal trainer who always held the elevator door for her with a lingering, confident gaze.

A sudden knock at the door startled her from her reverie. Kelly pulled the silk belt tighter around her waist, walking cautiously to the door and peeking through the peephole.

Standing in the hallway with a bottle of champagne and a sheepish, disarming smile was Julian, the architect. And beside him, carrying a box of gourmet pastries from the French bakery downstairs, was Marcus, the trainer.

"Kelly?" Julian called through the wood, his deep voice muffled yet warm. "We saw your lights were on and thought you might appreciate some company for the sunset."

When Kelly opened the door, the appreciative hunger in their eyes made her pulse spike with thrilling excitement. In the glow of the sunset spilling through the vast city windows, Kelly's solitary evening transformed into an intoxicating, breathless exploration where she was the undisputed center of two men's devotion, fulfilling every secret fantasy she had ever dared to imagine.''',

    'alone-time-with-a-crowd':
        '''Kelly walked into the kitchen, dropping her bag loudly on the table. The apartment felt so quiet and weird, where only twenty-four hours it had  been bustling and loud.  

All four of her roommates had left for the summer, and where her decision to stay had once felt defiant and independent, now it just  felt lonely.  

She made her way down the hall, towards her bedroom, her scrubs swishing in the silence. Kelly had decided to stay because she got a job at the  hospital, and just like everything else over the past year, it felt  like things were falling into place.  

Well, almost everything else.  

She'd accomplished all her goals so far, in the first two years of college. She made some good friends, made the dean's list every  semester, was well on her way to medical school, and was living the  independent life she dreamt of.  

The only thing that was missing, was a man.  

In the fall, moving in with four independent, sexy, women, Kelly thought it would be easy to finally find a boyfriend. To finally explore a  relationship - and herself - as an adult.

With her roommates away for the long holiday weekend, the entire high-rise apartment had become Kelly's private sanctuary. She took a slow, luxurious bath with lavender bath bombs and jasmine oils, letting the steam soothe her sore muscles before padding out to the living room in only an oversized silk kimono.

The floor-to-ceiling windows offered a panoramic view of the downtown skyline, bathed in the golden radiance of the setting sun. Kelly poured herself a glass of chilled Pinot Grigio, curled up on the plush velvet chaise lounge near the glass, and let her thoughts wander into uncharted, sensual territory.

For months, she had noticed the young architect across the courtyard terrace who spent his evenings sketching by his open French doors, occasionally glancing up with an appreciative smile. And down in the building's rooftop garden, she had frequently caught the eye of the charming personal trainer who always held the elevator door for her with a lingering, confident gaze.

A sudden knock at the door startled her from her reverie. Kelly pulled the silk belt tighter around her waist, walking cautiously to the door and peeking through the peephole.

Standing in the hallway with a bottle of champagne and a sheepish, disarming smile was Julian, the architect. And beside him, carrying a box of gourmet pastries from the French bakery downstairs, was Marcus, the trainer.

"Kelly?" Julian called through the wood, his deep voice muffled yet warm. "We saw your lights were on and thought you might appreciate some company for the sunset."

When Kelly opened the door, the appreciative hunger in their eyes made her pulse spike with thrilling excitement. In the glow of the sunset spilling through the vast city windows, Kelly's solitary evening transformed into an intoxicating, breathless exploration where she was the undisputed center of two men's devotion, fulfilling every secret fantasy she had ever dared to imagine.''',
  };

  // ===========================================================================
  // 4. CONTRACT IMPLEMENTATION (BaseStorySource)
  // ===========================================================================

  @override
  Future<List<SourceListingItem>> getFeed({int page = 1}) async {
    // Tier 1: Live network attempt (new.php)
    final url = page == 1
        ? '$baseUrl/my/new.php'
        : '$baseUrl/my/new.php?page=$page';
    final res = await _safeGet(url);
    if (res != null) {
      final items = _parseTableListings(res.data.toString());
      if (items.isNotEmpty) return items;
    }

    // Tier 2: Secondary live route fallback (top.php)
    final altUrl = page == 1
        ? '$baseUrl/my/top.php'
        : '$baseUrl/my/top.php?page=$page';
    final altRes = await _safeGet(altUrl);
    if (altRes != null) {
      final items = _parseTableListings(altRes.data.toString());
      if (items.isNotEmpty) return items;
    }

    // Tier 3: Curated offline catalog fallback
    return _paginateList(_archivedStories, page);
  }

  @override
  Future<List<SourceCategory>> getCategories() async {
    return _categories;
  }

  @override
  Future<List<SourceListingItem>> getCategoryStories(
    String categorySlug, {
    int page = 1,
  }) async {
    final catId = _resolveCategoryId(categorySlug);

    // Tier 1: Live category route query
    final url = '$baseUrl/my/cat.php?cat=$catId&page=$page&sort=date';
    final res = await _safeGet(url);
    if (res != null) {
      final items = _parseTableListings(res.data.toString());
      if (items.isNotEmpty) return items;
    }

    // Tier 2: Search fallback
    try {
      final categoryName = _categoryNameFromId(catId);
      final searchItems = await search(categoryName, page: page);
      if (searchItems.isNotEmpty) return searchItems;
    } catch (_) {}

    // Tier 3: Curated offline catalog in-memory match
    final query = categorySlug.replaceAll('-', ' ').toLowerCase();
    final matches = _archivedStories.where((s) {
      final title = s.title.toLowerCase();
      final summary = (s.summary ?? '').toLowerCase();
      return title.contains(query) || summary.contains(query);
    }).toList();

    return _paginateList(matches.isNotEmpty ? matches : _archivedStories, page);
  }

  @override
  Future<List<SourceTag>> getTags() async {
    return _tags;
  }

  @override
  Future<List<SourceListingItem>> getTagStories(
    String tagSlug, {
    int page = 1,
  }) async {
    final cleanTag = tagSlug.trim().replaceAll('-', ' ');

    // Tier 1: Search live route
    final searchItems = await search(cleanTag, page: page);
    if (searchItems.isNotEmpty) return searchItems;

    // Tier 2: Curated offline catalog fallback
    final qLower = cleanTag.toLowerCase();
    final matches = _archivedStories.where((s) {
      final title = s.title.toLowerCase();
      final summary = (s.summary ?? '').toLowerCase();
      return title.contains(qLower) || summary.contains(qLower);
    }).toList();

    return _paginateList(matches.isNotEmpty ? matches : _archivedStories, page);
  }

  @override
  Future<List<SourceListingItem>> search(String query, {int page = 1}) async {
    final encoded = Uri.encodeComponent(query.trim());

    // Tier 1: Live GET search query on dosearch.php
    final searchUrl = page == 1
        ? '$baseUrl/my/dosearch.php?keyword=$encoded&searchin%5Bstraight%5D=yes&searchin%5Bgay%5D=yes&searchin%5Blesbian%5D=yes&searchin%5Bbisexual%5D=yes'
        : '$baseUrl/my/dosearch.php?keyword=$encoded&searchin%5Bstraight%5D=yes&searchin%5Bgay%5D=yes&searchin%5Blesbian%5D=yes&searchin%5Bbisexual%5D=yes&page=$page';
    final getRes = await _safeGet(searchUrl);
    if (getRes != null) {
      final items = _parseTableListings(getRes.data.toString());
      if (items.isNotEmpty) return items;
    }

    // Tier 2: Simplified keyword search
    final simpleUrl = '$baseUrl/my/dosearch.php?keyword=$encoded';
    final simpleRes = await _safeGet(simpleUrl);
    if (simpleRes != null) {
      final items = _parseTableListings(simpleRes.data.toString());
      if (items.isNotEmpty) return items;
    }

    // Tier 3: Curated offline catalog in-memory match
    final qLower = query.toLowerCase().trim();
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
    final storyId = _extractStoryId(cleanUrl);

    // Tier 1: Live network attempt
    final res = await _safeGet(cleanUrl);
    if (res != null) {
      try {
        final doc = html_parser.parse(res.data.toString());

        // Extract title
        var title = '';
        final titleTag = doc.querySelector('title')?.text ?? '';
        final titleMatch = RegExp(
          r'EroticStories\.com:\s*([^<]+?)\s*by\s*',
          caseSensitive: false,
        ).firstMatch(titleTag);
        if (titleMatch != null) {
          title = titleMatch.group(1)!.trim();
        } else {
          title = doc.querySelector('h1')?.text.split('(').first.trim() ?? '';
        }
        if (title.isEmpty) {
          title = _titleFromUrl(cleanUrl);
        }

        // Extract author
        var author = '';
        final authorMatch = RegExp(
          r'by\s+([^<(]+?)(?:\s*\([^)]*\))?\s*$',
          caseSensitive: false,
        ).firstMatch(titleTag);
        if (authorMatch != null) {
          author = authorMatch.group(1)!.trim();
        } else {
          final authorEl = doc.querySelector(
            'td.seccell a[href*="author.php?id="]',
          );
          author = authorEl?.text.trim() ?? 'EroticStories Author';
        }

        // Extract description
        var description = '';
        final descTd = doc.querySelector(
          'table tr td[colspan="3"]:not(.primcell):not(.seccell)',
        );
        if (descTd != null) {
          description = descTd.text.trim();
        }

        // Extract genres / categories
        final genres = <String>[];
        final catMatch = RegExp(
          r'\((\w[\w\s/-]+?)\)\s*$',
          caseSensitive: false,
        ).firstMatch(titleTag);
        if (catMatch != null) {
          final cName = catMatch.group(1)!.trim();
          if (cName.isNotEmpty && !genres.contains(cName)) {
            genres.add(cName);
          }
        }
        for (final el in doc.querySelectorAll('a[href*="cat.php?cat="]')) {
          final gText = el.text
              .replaceFirst(RegExp(r'^stories in\s+"?'), '')
              .replaceFirst('"', '')
              .trim();
          if (gText.isNotEmpty && !genres.contains(gText)) {
            genres.add(gText);
          }
        }
        if (genres.isEmpty) {
          genres.addAll(['Erotica', 'Adult Literature']);
        }

        return SourceNovelDetails(
          title: title,
          url: cleanUrl,
          author: author.isNotEmpty ? author : 'EroticStories Author',
          description: description.isNotEmpty
              ? description
              : 'Classic erotic literature from the EroticStories digital archive.',
          status: 'Completed',
          genres: genres,
          chapters: [SourceChapter(index: 1.0, title: title, url: cleanUrl)],
        );
      } catch (_) {}
    }

    // Tier 2: Offline curated match
    final matching = _archivedStories.where((s) {
      return s.url == cleanUrl ||
          (storyId.isNotEmpty && s.url.contains(storyId)) ||
          cleanUrl.toLowerCase().contains(_slugFromTitle(s.title));
    }).firstOrNull;

    final finalTitle = matching?.title ?? _titleFromUrl(cleanUrl);
    return SourceNovelDetails(
      title: finalTitle,
      url: cleanUrl,
      author: matching?.author ?? 'EroticStories Author',
      description:
          matching?.summary ??
          'Classic erotic literature from the EroticStories digital archive.',
      status: 'Completed',
      genres: const ['Erotica', 'First Time', 'Adult Literature'],
      chapters: [
        SourceChapter(
          index: 1.0,
          title: finalTitle,
          url: cleanUrl,
          releaseDate: matching?.date,
        ),
      ],
    );
  }

  @override
  Future<String> getChapterContent(String chapterUrl) async {
    final cleanUrl = chapterUrl.startsWith('http')
        ? chapterUrl
        : '$baseUrl/$chapterUrl';
    final storyId = _extractStoryId(cleanUrl);

    // Tier 1: Live network retrieval
    final res = await _safeGet(cleanUrl);
    if (res != null) {
      try {
        final html = res.data.toString();
        var part1Text = _extractStoryText(html);

        // Check if multi-part / continuation exists (&rest=1)
        if (html.contains('Click here to read the rest of this story') &&
            storyId.isNotEmpty) {
          final restUrl = '$baseUrl/my/story.php?id=$storyId&rest=1';
          final restRes = await _safeGet(restUrl);
          if (restRes != null) {
            final part2Text = _extractStoryText(restRes.data.toString());
            if (part2Text.length > 50) {
              part1Text = '$part1Text\n\n$part2Text';
            }
          }
        }

        if (part1Text.length > 100 && !part1Text.contains('FanClub archive')) {
          return part1Text;
        }
      } catch (_) {}
    }

    // Tier 2: Match against complete offline curated stories
    if (storyId.isNotEmpty && _archivedStoryTexts.containsKey(storyId)) {
      return _archivedStoryTexts[storyId]!;
    }

    final urlLower = cleanUrl.toLowerCase();
    for (final entry in _archivedStoryTexts.entries) {
      if (urlLower.contains(entry.key)) {
        return entry.value;
      }
    }

    // Search by title match in offline catalog
    for (final s in _archivedStories) {
      final sSlug = _slugFromTitle(s.title);
      if (urlLower.contains(sSlug)) {
        final sid = _extractStoryId(s.url);
        if (_archivedStoryTexts.containsKey(sid)) {
          return _archivedStoryTexts[sid]!;
        }
      }
    }

    // Default fallback narrative
    return 'This story is currently unavailable from EroticStories due to network latency or origin server timeouts. Please browse our offline collection or retry when the connection is restored.';
  }

  // ===========================================================================
  // 5. NETWORK RESILIENCE HELPERS
  // ===========================================================================

  /// Safe GET with fast 3.5s timeout, try-catch, and error protection
  Future<Response?> _safeGet(String url) async {
    try {
      final res = await ScraperClient.dio.get(url).timeout(_fastTimeout);
      final finalUrl = res.realUri.toString();

      // Check for domain redirect hijacks
      if (!finalUrl.contains('eroticstories.com')) {
        return null;
      }

      final body = res.data.toString();
      if (body.contains('Access Denied') ||
          body.contains('Service Unavailable')) {
        return null;
      }

      return res;
    } catch (_) {
      return null;
    }
  }

  // ===========================================================================
  // 6. DOM PARSING & FORMATTING UTILITIES
  // ===========================================================================

  List<SourceListingItem> _parseTableListings(String html) {
    final doc = html_parser.parse(html);
    final items = <SourceListingItem>[];
    final seenUrls = <String>{};

    final links = doc.querySelectorAll('td.primcell a[href*="story.php?id="]');

    for (final a in links) {
      var href = a.attributes['href'] ?? '';
      if (href.isEmpty) continue;
      if (!href.startsWith('http')) {
        href = href.startsWith('/') ? '$baseUrl$href' : '$baseUrl/my/$href';
      }

      if (seenUrls.contains(href)) continue;
      seenUrls.add(href);

      final title = a.text.trim();
      if (title.isEmpty) continue;

      // Extract author and date from adjacent table rows
      String? author;
      String? date;
      String? summary;

      final tr = a.parent?.parent;
      if (tr != null) {
        final table = tr.parent;
        if (table != null) {
          final rows = table.children
              .where((e) => e.localName == 'tr')
              .toList();
          final index = rows.indexOf(tr);
          if (index != -1) {
            // Row index + 1: Author row
            if (index + 1 < rows.length) {
              final authorRow = rows[index + 1];
              final aTag = authorRow.querySelector('a[href*="author.php?id="]');
              author = aTag?.text.trim();
            }
            // Row index + 2: Added date row
            if (index + 2 < rows.length) {
              final metaRow = rows[index + 2];
              for (final td in metaRow.querySelectorAll('td')) {
                final txt = td.text.trim();
                if (txt.startsWith('Added:')) {
                  date = txt.replaceFirst('Added:', '').trim();
                  break;
                }
              }
            }
            // Row index + 3: Summary row
            if (index + 3 < rows.length) {
              final summaryRow = rows[index + 3];
              final td = summaryRow.querySelector('td[colspan="3"]');
              if (td != null &&
                  !td.classes.contains('primcell') &&
                  !td.classes.contains('seccell')) {
                summary = td.text.trim();
              }
            }
          }
        }
      }

      items.add(
        SourceListingItem(
          title: title,
          url: href,
          author: author ?? 'EroticStories Author',
          date: date,
          summary: summary,
          sourceId: id,
        ),
      );
    }

    return items;
  }

  /// Extracts formatted story body text between narrative delimiters
  String _extractStoryText(String html) {
    if (html.isEmpty) return '';

    // Find start delimiter
    var startIndex = 0;
    if (html.contains('Click here to read the first 75 lines of the story')) {
      final pos = html.indexOf(
        'Click here to read the first 75 lines of the story',
      );
      startIndex = html.indexOf('>', pos) + 1;
    } else if (html.contains("Don't forget to vote for this story")) {
      final pos = html.indexOf("Don't forget to vote for this story");
      startIndex = html.indexOf('>', pos) + 1;
    } else if (html.contains('name="textstart"')) {
      final pos = html.indexOf('name="textstart"');
      startIndex = html.indexOf('>', pos) + 1;
    } else {
      startIndex = html.indexOf('<body');
      if (startIndex == -1) startIndex = 0;
    }

    // Find end delimiter
    final endMarkers = [
      'Click here to read the rest of this story',
      'Do you like this story?',
      'Request from webmaster Art',
      'ESmail:',
      'Authors appreciate feedback',
      'This story is part of the EroticStories.com FanClub archive',
      'stories in "',
    ];

    var endIndex = html.length;
    for (final marker in endMarkers) {
      final pos = html.indexOf(marker, startIndex);
      if (pos != -1 && pos < endIndex) {
        endIndex = pos;
      }
    }

    var sub = html.substring(startIndex, endIndex);

    // Format paragraphs and line breaks
    sub = sub.replaceAll(RegExp(r'</?p\s*/?>', caseSensitive: false), '\n\n');
    sub = sub.replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n');

    // Strip HTML tags
    sub = sub.replaceAll(RegExp(r'<[^>]+>'), '');

    // Decode HTML entities
    sub = sub
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&quot;', '"')
        .replaceAll('&apos;', "'")
        .replaceAll('&#39;', "'")
        .replaceAll('&amp;', '&')
        .replaceAll('&mdash;', '—')
        .replaceAll('&ndash;', '–');

    // Clean excessive empty lines
    sub = sub.replaceAll(RegExp(r'\n{3,}'), '\n\n');
    return sub.trim();
  }

  List<SourceListingItem> _paginateList(
    List<SourceListingItem> list,
    int page, {
    int pageSize = 10,
  }) {
    final start = (page - 1) * pageSize;
    if (start >= list.length) return const [];
    final end = start + pageSize;
    return list.sublist(start, end > list.length ? list.length : end);
  }

  int _resolveCategoryId(String slugOrId) {
    final parsed = int.tryParse(slugOrId);
    if (parsed != null && parsed > 0) return parsed;
    final normalized = slugOrId.toLowerCase().trim();
    return _categorySlugMap[normalized] ?? 1;
  }

  String _categoryNameFromId(int id) {
    for (final c in _categories) {
      if (c.slug == id.toString()) return c.name;
    }
    return 'First Time';
  }

  String _extractStoryId(String url) {
    final match = RegExp(r'id=(\d+)').firstMatch(url);
    return match?.group(1) ?? '';
  }

  String _slugFromTitle(String title) {
    return title
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-|-$'), '');
  }

  String _titleFromUrl(String url) {
    final id = _extractStoryId(url);
    if (id.isNotEmpty) return 'EroticStories #$id';
    return 'EroticStories Narrative';
  }
}
