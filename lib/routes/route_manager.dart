import 'package:rta_chart_manager/routes/route.dart';
import 'package:rta_chart_manager/routes/route_names.dart';
import 'package:rta_chart_manager/routes/route_params.dart';

class RouteManager {
  /// チャート一覧へ遷移する
  static void navChartTitle() {
    router.goNamed(RouteNames.chartTitle);
  }

  /// チャプター一覧へ遷移する
  static void navChapterSummary({required String chartId}) {
    router.goNamed(
      RouteNames.chapterSummary,
      pathParameters: {
        RouteParams.chartId: chartId,
      },
    );
  }

  /// チャプター詳細へ遷移する
  static void navChapterDetail({
    required String chartId,
    required String chapterSummaryId,
    String? playId,
    required bool isEdit,
  }) {
    String editMode = isEdit ? 'true' : 'false';

    if (playId == null) {
      // 編集モード時 or プレイ開始時
      router.goNamed(
        RouteNames.chapterDetail,
        pathParameters: {
          RouteParams.chartId: chartId,
          RouteParams.summaryId: chapterSummaryId,
        },
        queryParameters: {
          RouteParams.editMode: editMode,
        },
      );
    } else {
      // プレイ中のチャート進行時
      router.goNamed(
        RouteNames.chapterDetail,
        pathParameters: {
          RouteParams.chartId: chartId,
          RouteParams.summaryId: chapterSummaryId,
        },
        queryParameters: {
          RouteParams.editMode: editMode,
          RouteParams.playId: playId,
        },
      );
    }
  }

  /// リザルト画面へ船員する
  static void navChartResult({
    required String chartId,
    required String playId,
  }) {
    router.goNamed(
      RouteNames.chartResult,
      pathParameters: {
        RouteParams.chartId: chartId,
        RouteParams.playId: playId,
      },
    );
  }
}
