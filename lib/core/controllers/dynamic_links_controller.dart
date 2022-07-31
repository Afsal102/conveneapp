import 'dart:async';

import 'package:conveneapp/apis/firebase/firebase_api_providers.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum DynamicRouteType { joinClub, empty }

class DynamicLinkState extends Equatable {
  final DynamicRouteType routeType;
  final Map<String, dynamic> routeParams;

  const DynamicLinkState({
    required this.routeType,
    required this.routeParams,
  });

  @override
  List<Object> get props => [routeType, routeParams];

  static const empty = DynamicLinkState(
    routeType: DynamicRouteType.empty,
    routeParams: {},
  );
}

final dynamicLinksProvider = StateNotifierProvider<DynamicLinksController, DynamicLinkState>(
  (ref) => DynamicLinksController(
    firebaseDynamicLinks: ref.watch(
      firebaseDynamicLinksProvider,
    ),
  ),
);

class DynamicLinksController extends StateNotifier<DynamicLinkState> {
  DynamicLinksController({
    required FirebaseDynamicLinks firebaseDynamicLinks,
  })  : _firebaseDynamicLinks = firebaseDynamicLinks,
        super(DynamicLinkState.empty) {
    _getInitialDynamicLink();
    _listenForDynamicLinks();
  }

  final FirebaseDynamicLinks _firebaseDynamicLinks;

  StreamSubscription<PendingDynamicLinkData>? _pendingDynamicLinkDataSubscription;

  void _listenForDynamicLinks() {
    _pendingDynamicLinkDataSubscription?.cancel();
    _pendingDynamicLinkDataSubscription = _firebaseDynamicLinks.onLink.listen((event) {
      final queryParams = event.link.queryParameters;
      _handleLink(queryParams);
    });
  }

  void _handleLink(Map<String, String> queryParams) {
    if (queryParams.containsKey('clubId')) {
      state = DynamicLinkState(
        routeType: DynamicRouteType.joinClub,
        routeParams: {
          'clubId': queryParams['clubId'],
        },
      );
      return;
    }
    return;
  }

  Future<void> _getInitialDynamicLink() async {
    final pendingDynamicLinkData = await _firebaseDynamicLinks.getInitialLink();
    if (pendingDynamicLinkData == null) return;

    _handleLink(
      pendingDynamicLinkData.link.queryParameters,
    );
  }

  @override
  void dispose() {
    _pendingDynamicLinkDataSubscription?.cancel();
    super.dispose();
  }
}
