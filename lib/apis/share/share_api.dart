import 'package:conveneapp/apis/firebase/firebase_api_providers.dart';
import 'package:conveneapp/core/constants/constants.dart';
import 'package:conveneapp/core/errors/errors.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

final shareApiProvider = Provider<ShareApi>(
  (ref) => ShareApi(
    firebaseDynamicLinks: ref.watch(firebaseDynamicLinksProvider),
  ),
);

@visibleForTesting
class ShareApi {
  final FirebaseDynamicLinks _firebaseDynamicLinks;

  ShareApi({
    required FirebaseDynamicLinks firebaseDynamicLinks,
  }) : _firebaseDynamicLinks = firebaseDynamicLinks;

  Future<Either<Failure, void>> shareClub({
    required String clubId,
    required String clubTitle,
    String? clubDescription,
    String? imageUrl,
  }) async {
    try {
      final dynamicLinkParams = DynamicLinkParameters(
        link: Uri.parse(
          ApiConstants.deeplinkDataDomainUri + '/convene?clubId=$clubId',
        ),
        uriPrefix: ApiConstants.deeplinkDomainUri,
        androidParameters: const AndroidParameters(
          //TODO(afzal): get package id from build.gradle file autmoatically
          packageName: 'com.convene.conveneapp',
        ),
        socialMetaTagParameters: SocialMetaTagParameters(
          title: clubTitle,
          description: clubDescription,
          imageUrl: imageUrl != null ? Uri.parse(imageUrl) : null,
        ),
      );

      final result = await _firebaseDynamicLinks.buildShortLink(
        dynamicLinkParams,
      );
      final shareUrl = result.shortUrl.toString();

      return right(
        Share.share(shareUrl),
      );
    } catch (e) {
      //TODO(afzal): add proper error message's
      return left(
        ShareFailure(
          'Unable to generate share link',
        ),
      );
    }
  }
}
