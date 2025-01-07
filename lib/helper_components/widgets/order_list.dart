import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mat_salg/helper_components/flutter_flow/flutter_flow_theme.dart';
import 'package:mat_salg/helper_components/flutter_flow/flutter_flow_util.dart';
import 'package:mat_salg/my_ip.dart';

class OrderList extends StatelessWidget {
  final OrdreInfo ordreInfo;
  final VoidCallback onTap;

  const OrderList({
    super.key,
    required this.ordreInfo,
    required this.onTap,
  });

//---------------------------------------------------------------------------------------------------------------
//--------------------Returns the correct status for the product-------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
  String getStatusText() {
    if (ordreInfo.trekt == true) {
      return ordreInfo.kjopte == true
          ? 'Du trakk budet'
          : 'Kjøperen trakk budet';
    }
    if (ordreInfo.godkjent != true &&
        ordreInfo.hentet != true &&
        ordreInfo.trekt != true &&
        ordreInfo.avvist != true) {
      return ordreInfo.kjopte == true
          ? 'Venter svar fra selgeren'
          : 'Svar på budet';
    }
    if (ordreInfo.avvist == true) {
      return ordreInfo.kjopte == true
          ? 'Selgeren avslo budet'
          : 'Du avslo budet';
    }
    if (ordreInfo.godkjent == true && ordreInfo.hentet != true) {
      return ordreInfo.kjopte == true
          ? 'Budet er godkjent, kontakt selgeren'
          : 'Budet er godkjent, kontakt kjøperen';
    }
    if (ordreInfo.hentet == true) {
      return ordreInfo.kjopte == true
          ? 'Kjøpet er fullført'
          : 'Salget er fullført';
    }
    return '';
  }

//-----------------------------------------------------------------------------------------------------------------------
//--------------------Displays a order that is used in the orders lists--------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: onTap,
                child: Material(
                  color: Colors.transparent,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      shape: BoxShape.rectangle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          if ((ordreInfo.kjopte == true &&
                                  ordreInfo.buyerAlert == true) ||
                              (ordreInfo.kjopte != true &&
                                  ordreInfo.sellerAlert == true))
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF357BF7),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          Stack(
                            children: [
                              Align(
                                alignment:
                                    const AlignmentDirectional(1.76, -0.05),
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 1, 1, 1),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: CachedNetworkImage(
                                        fadeInDuration: Duration.zero,
                                        imageUrl:
                                            '${ApiConstants.baseUrl}${ordreInfo.foodDetails.imgUrls![0]}',
                                        width: 56,
                                        height: 56,
                                        fit: BoxFit.cover,
                                        imageBuilder: (context, imageProvider) {
                                          return Container(
                                            width: 56,
                                            height: 56,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          );
                                        },
                                        errorWidget: (context, url, error) =>
                                            Image.asset(
                                          'assets/images/error_image.jpg',
                                          width: 56,
                                          height: 56,
                                          fit: BoxFit.cover,
                                        ),
                                      )),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                left: 0,
                                child: Container(
                                  width: 25,
                                  height: 25,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.white, width: 0.5),
                                  ),
                                  child: ClipOval(
                                      child: CachedNetworkImage(
                                    fadeInDuration: Duration.zero,
                                    imageUrl: ordreInfo.kjopte == true
                                        ? '${ApiConstants.baseUrl}${ordreInfo.foodDetails.profilepic}'
                                        : '${ApiConstants.baseUrl}${ordreInfo.kjoperProfilePic}',
                                    width: 25,
                                    height: 25,
                                    fit: BoxFit.cover,
                                    imageBuilder: (context, imageProvider) {
                                      return Container(
                                        width: 25,
                                        height: 25,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      );
                                    },
                                    errorWidget: (context, url, error) =>
                                        Image.asset(
                                      'assets/images/profile_pic.png',
                                      width: 25,
                                      height: 25,
                                      fit: BoxFit.cover,
                                    ),
                                  )),
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  8, 0, 4, 0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            ordreInfo.deleted
                                                ? 'deleted_user'
                                                : ordreInfo.kjopte == true
                                                    ? ordreInfo
                                                            .selgerUsername ??
                                                        ''
                                                    : ordreInfo
                                                            .kjoperUsername ??
                                                        '',
                                            softWrap: true,
                                            overflow: TextOverflow.visible,
                                            style: FlutterFlowTheme.of(context)
                                                .headlineSmall
                                                .override(
                                                  fontFamily: 'Nunito',
                                                  fontSize: 16,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          ordreInfo.updatetime != null
                                              ? (DateFormat("d. MMM", "nb_NO")
                                                  .format(ordreInfo.updatetime!
                                                      .toLocal()))
                                              : "",
                                          style: FlutterFlowTheme.of(context)
                                              .headlineSmall
                                              .override(
                                                fontFamily: 'Nunito',
                                                fontSize: 14,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.grey,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 6),
                                    child: Text(
                                      getStatusText(),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Nunito',
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            fontSize: 15,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (ordreInfo.trekt != true &&
                                  ordreInfo.avvist != true)
                                Container(
                                  height: 26.5,
                                  decoration: BoxDecoration(
                                    color: ordreInfo.hentet == true
                                        ? FlutterFlowTheme.of(context).price
                                        : FlutterFlowTheme.of(context)
                                            .alternate,
                                    borderRadius: BorderRadius.circular(13),
                                    border: null,
                                  ),
                                  child: Align(
                                    alignment: const AlignmentDirectional(0, 0),
                                    child: Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              15, 0, 12, 0),
                                      child: Text(
                                        (ordreInfo.kjopte ?? false)
                                            ? '${ordreInfo.prisBetalt} Kr'
                                            : '+${ordreInfo.pris} Kr',
                                        textAlign: TextAlign.start,
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Nunito',
                                              color: ordreInfo.hentet == true
                                                  ? FlutterFlowTheme.of(context)
                                                      .primaryText
                                                  : FlutterFlowTheme.of(context)
                                                      .primary,
                                              fontSize: 14,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                              if (ordreInfo.trekt == true ||
                                  ordreInfo.avvist == true)
                                Container(
                                  height: 26.5,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(13),
                                      border: Border.all(
                                          color: const Color.fromARGB(
                                              44, 87, 99, 108),
                                          width: 1.2)),
                                  child: Stack(
                                    children: [
                                      Align(
                                        alignment:
                                            const AlignmentDirectional(0, 0),
                                        child: Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(15, 0, 12, 0),
                                          child: Stack(
                                            children: [
                                              Positioned(
                                                top: 10,
                                                left: 0,
                                                right: 0,
                                                child: Container(
                                                  height: 0.8,
                                                  color: const Color.fromARGB(
                                                      192, 0, 0, 0),
                                                ),
                                              ),
                                              Text(
                                                (ordreInfo.kjopte ?? false)
                                                    ? '${ordreInfo.prisBetalt} Kr'
                                                    : '${ordreInfo.pris} Kr',
                                                textAlign: TextAlign.start,
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyMedium
                                                    .override(
                                                      fontFamily: 'Nunito',
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText,
                                                      fontSize: 14,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      decoration:
                                                          TextDecoration.none,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
