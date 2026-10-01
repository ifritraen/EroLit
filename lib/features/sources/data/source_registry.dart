import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/source_contract.dart';
import '../implementations/source_01_audiosexstories.dart';
import '../implementations/source_02_banglachotiboi.dart';
import '../implementations/source_03_chotigolpobd.dart';
import '../implementations/source_04_dirtysextales.dart';
import '../implementations/source_05_chotimaster.dart';
import '../implementations/source_06_mychoti.dart';
import '../implementations/source_07_indiansexstories3.dart';
import '../implementations/source_08_antarvasnasexstories.dart';
import '../implementations/source_09_eroticatale.dart';
import '../implementations/source_10_hindipornstories.dart';
import '../implementations/source_11_desitales2.dart';
import '../implementations/source_12_desikahani2.dart';
import '../implementations/source_13_xxxindianstories.dart';
import '../implementations/source_14_theindiansexstory.dart';
import '../implementations/source_15_eroticindianstories.dart';
import '../implementations/source_16_desibahu.dart';
import '../implementations/source_17_desiadultstory.dart';
import '../implementations/source_18_banglachotikahinii.dart';
import '../implementations/source_19_bdsexstory.dart';
import '../implementations/source_20_xossipy.dart';
import '../implementations/source_21_newsexstory.dart';
import '../implementations/source_22_literotica.dart';
import '../implementations/source_23_storiesonline.dart';
import '../implementations/source_24_lushstories.dart';
import '../implementations/source_25_ao3.dart';
import '../implementations/source_26_nifty.dart';
import '../implementations/source_27_sexstories.dart';
import '../implementations/source_28_mcstories.dart';
import '../implementations/source_29_tgstorytime.dart';
import '../implementations/source_30_adultfanfiction.dart';
import '../implementations/source_31_questionablequesting.dart';
import '../implementations/source_32_scribblehub.dart';
import '../implementations/source_33_bigcloset.dart';
import '../implementations/source_34_bdsmlibrary.dart';
import '../implementations/source_35_xnxxstories.dart';
import '../implementations/source_36_asstr.dart';
import '../implementations/source_37_theeroticlibrary.dart';
import '../implementations/source_38_eroticshortstories.dart';
import '../implementations/source_39_chyoa.dart';
import '../implementations/source_40_eroticstories.dart';
import '../implementations/source_41_naughtyfiction.dart';
import '../implementations/source_42_darkerotica.dart';

class SourceRegistry {
  static final List<BaseStorySource> initialSources = [
    AudioSexStoriesSource(),
    BanglaChotiBoiSource(),
    ChotiGolpoBDSource(),
    DirtySexTalesSource(),
    ChotiMasterSource(),
    MyChotiSource(),
    IndianSexStories3Source(),
    AntarvasnaSexStoriesSource(),
    EroticaTaleSource(),
    HindiPornStoriesSource(),
    DesiTales2Source(),
    DesiKahani2Source(),
    XxxIndianStoriesSource(),
    TheIndianSexStorySource(),
    EroticIndianStoriesSource(),
    DesiBahuSource(),
    DesiAdultStorySource(),
    BanglaChotiKahiniSource(),
    BdSexStorySource(),
    XossipySource(),
    NewSexStorySource(),
    LiteroticaSource(),
    StoriesOnlineSource(),
    LushStoriesSource(),
    AO3Source(),
    NiftySource(),
    SexStoriesSource(),
    McStoriesSource(),
    TGStorytimeSource(),
    AdultFanfictionSource(),
    QuestionableQuestingSource(),
    ScribbleHubSource(),
    BigClosetSource(),
    BDSMLibrarySource(),
    XnxxStoriesSource(),
    AsstrSource(),
    TheEroticLibrarySource(),
    EroticShortStoriesSource(),
    ChyoaSource(),
    EroticStoriesSource(),
    NaughtyFictionSource(),
    DarkEroticaSource(),
  ];

  static BaseStorySource? getSourceById(String id) {
    try {
      return initialSources.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }
}

final allSourcesProvider = Provider<List<BaseStorySource>>((ref) {
  return SourceRegistry.initialSources;
});

final selectedSourceLanguageFilterProvider = StateProvider<String?>((ref) => null);
