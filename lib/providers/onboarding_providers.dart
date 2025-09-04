import 'package:riverpod_annotation/riverpod_annotation.dart';

// 생성될 파일 이름을 명시합니다.
part 'onboarding_providers.g.dart';

@Riverpod(keepAlive: true)
class SelectedIndex extends _$SelectedIndex {
  @override
  int build() {
    return 1;
  }

  void setIndex(int newIndex) {
    state = newIndex;
  }
}

@Riverpod(keepAlive: true)
class ResearchResultStep1 extends _$ResearchResultStep1 {
  @override
  int build() {
    return -1;
  }

  void setIndex(int newIndex) {
    state = newIndex;
  }
}

@Riverpod(keepAlive: true)
class ResearchResultStep2 extends _$ResearchResultStep2 {
  @override
  int build() {
    return 0;
  }

  void setIndex(int newIndex) {
    state = newIndex;
  }
}

@Riverpod(keepAlive: true)
class ResearchResultStep3 extends _$ResearchResultStep3 {
  @override
  List<bool> build() {
    return [false, false, false, false];
  }

  void setState(int index, bool value) {
    final newState = [...state];
    newState[index] = value;
    state = newState;
  }
}

@Riverpod(keepAlive: true)
class ResearchResultStep4 extends _$ResearchResultStep4 {
  @override
  double build() {
    return 1.0;
  }

  void setValue(double value) {
    state = value;
  }
}

@Riverpod(keepAlive: true)
class ResearchResultStep5 extends _$ResearchResultStep5 {
  @override
  bool build() {
    return false;
  }

  void validateInputs(String? goal, String? money) {
    bool isValid =
        (goal != null && goal.isNotEmpty) &&
        (money != null &&
            money.isNotEmpty &&
            int.tryParse(money.replaceAll(',', '')) != null &&
            int.tryParse(money.replaceAll(',', ''))! > 0);
    state = isValid;
  }
}

@Riverpod(keepAlive: true)
class ResearchResultStep5_goal extends _$ResearchResultStep5_goal {
  @override
  String? build() {
    return '';
  }

  void setValue(String? value) {
    state = value;
  }
}

@Riverpod(keepAlive: true)
class ResearchResultStep5_money extends _$ResearchResultStep5_money {
  @override
  String? build() {
    return null;
  }

  void setValue(String? value) {
    state = value;
  }
}

@Riverpod(keepAlive: true)
class CurrentSavedMoney extends _$CurrentSavedMoney {
  @override
  String? build() {
    return null;
  }

  void setValue(String? value) {
    state = value;
  }
}
