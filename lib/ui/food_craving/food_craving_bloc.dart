import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/domain/poll_model/i_poll_repository.dart';
import 'package:mismedidasb/domain/poll_model/poll_model.dart';
import 'package:mismedidasb/domain/single_selection_model.dart';
import 'package:mismedidasb/ui/_base/bloc_base.dart';
import 'package:mismedidasb/ui/_base/bloc_error_handler.dart';
import 'package:mismedidasb/ui/_base/bloc_loading.dart';
import 'package:rxdart/subjects.dart';
import 'package:mismedidasb/utils/extensions.dart';

class FoodCravingBloC extends BaseBloC with LoadingBloC, ErrorHandlerBloC {
  final IPollRepository _iPollRepository;
  FoodCravingBloC(this._iPollRepository);

  BehaviorSubject<List<TitleSubTitlesModel>> _pollsController = new BehaviorSubject();

  Stream<List<TitleSubTitlesModel>> get pollsResult => _pollsController.stream;

  void loadData(int conceptId) async {
    final cravings = TitleSubTitlesModel.getCravingLiterals();
    _pollsController.sinkAddSafe(cravings);
//    isLoading = true;
//    final res = await _iPollRepository.getPollsByConcept(conceptId);
//    if(res is ResultSuccess<List<PollModel>>){
//      _pollsController.sinkAddSafe(res.value);
//    }
//    isLoading = false;
  }

  @override
  void dispose() {
    _pollsController.close();
  }
}