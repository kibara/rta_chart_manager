import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rta_chart_manager/routes/route_names.dart';
import 'package:rta_chart_manager/routes/route_params.dart';
import 'package:rta_chart_manager/screen/chapter_details.dart';
import 'package:rta_chart_manager/screen/chapter_summary.dart';
import 'package:rta_chart_manager/screen/chart_play_history.dart';
import 'package:rta_chart_manager/screen/chart_titles.dart';

final router = GoRouter(
  routes: [
    // チャート一覧
    GoRoute(
      path: '/',
      name: RouteNames.chartTitle,
      builder: (context, state) => const ChartTitles(
        title: 'RTA Chart List',
      ),
    ),
    // チャプター一覧
    GoRoute(
      path: "/chart_summary/:chartId",
      name: RouteNames.chapterSummary,
      builder: (context, state) => ChapterSummary(
        key: Key(state.pathParameters[RouteParams.chartId] as String),
        chartTitleId: state.pathParameters[RouteParams.chartId] as String,
      ),
    ),
    // チャプター詳細
    GoRoute(
      path: '/chapter_detail/:chartId/:summaryId',
      name: RouteNames.chapterDetail,
      builder: (context, state) => ChapterDetails(
        key: Key(state.pathParameters[RouteParams.summaryId] as String),
        chartTitleId: state.pathParameters[RouteParams.chartId] as String,
        chapterSummaryId: state.pathParameters[RouteParams.summaryId] as String,
        chartPlayId: state.uri.queryParameters[RouteParams.playId],
        isEditMode:
            bool.parse(state.uri.queryParameters[RouteParams.editMode]!),
      ),
    ),
    // チャートリザルト
    GoRoute(
      path: '/chart_result/:chartId/:playId',
      name: RouteNames.chartResult,
      builder: (context, state) => ChartPlayResult(
        key: Key(state.pathParameters[RouteParams.playId] as String),
        chartTitleId: state.pathParameters[RouteParams.chartId] as String,
        chartPlayId: state.pathParameters[RouteParams.playId] as String,
      ),
    ),
  ],
);
