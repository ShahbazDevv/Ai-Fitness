import 'package:get/get.dart';
import '../services/storage_service.dart';

class MainController extends GetxController {
  final StorageService _storage = Get.find<StorageService>();
  final RxInt selectedIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _restoreTab();
  }

  void _restoreTab() {
    final savedIndex = _storage.getInt('selected_tab');
    if (savedIndex != null && savedIndex >= 0 && savedIndex < 5) {
      selectedIndex.value = savedIndex;
    }
  }

  void changeIndex(int index) {
    selectedIndex.value = index;
    _storage.setInt('selected_tab', index);
  }

  Future<bool> onWillPop() async {
    if (selectedIndex.value != 0) {
      changeIndex(0);
      return false;
    }
    return true;
  }
}