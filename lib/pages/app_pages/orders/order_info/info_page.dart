import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mat_salg/auth/custom_auth/firebase_auth.dart';
import 'package:mat_salg/helper_components/widgets/toasts.dart';
import 'package:mat_salg/my_ip.dart';
import 'package:mat_salg/pages/app_pages/orders/give_rating/rating_page.dart';
import 'package:mat_salg/pages/app_pages/orders/order_info/info_services.dart';
import 'package:mat_salg/services/purchase_service.dart';
import 'package:mat_salg/services/user_service.dart';
import '../../../../helper_components/flutter_flow/flutter_flow_theme.dart';
import '../../../../helper_components/flutter_flow/flutter_flow_util.dart';
import '../../../../helper_components/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'info_model.dart';
export 'info_model.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({
    super.key,
    this.info,
    this.ordre,
  });

  final dynamic info;
  final dynamic ordre;

  @override
  State<InfoPage> createState() => _GodkjentebudWidgetState();
}

class _GodkjentebudWidgetState extends State<InfoPage> {
  final FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  final UserInfoService userInfoService = UserInfoService();
  late InfoModel _model;
  late Matvarer matvare;
  late OrdreInfo ordreInfo;
  late InfoServices infoServices;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => InfoModel());
    matvare = widget.info;
    ordreInfo = widget.ordre;
    infoServices = InfoServices(model: _model, ordreInfo: ordreInfo);
    markRead();
  }

  void markRead() async {
    String? token = await firebaseAuthService.getToken(context);
    if (token == null) {
      return;
    } else {
      if (ordreInfo.kjopte == true) {
        PurchaseService.markRead(
            id: ordreInfo.id,
            buyerAlert: false,
            sellerAlert: null,
            token: token);
      } else {
        PurchaseService.markRead(
            id: ordreInfo.id,
            buyerAlert: null,
            sellerAlert: false,
            token: token);
      }
    }
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      height: 510,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primary,
        boxShadow: const [
          BoxShadow(
            blurRadius: 4,
            color: Color(0x25090F13),
            offset: Offset(
              0.0,
              2,
            ),
          )
        ],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(0),
          bottomRight: Radius.circular(0),
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 12),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(
                    height: 22,
                    thickness: 4,
                    indent: MediaQuery.of(context).size.width * 0.4,
                    endIndent: MediaQuery.of(context).size.width * 0.4,
                    color: Colors.black12,
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            await infoServices.enterConversation(context);
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    6.0, 0.0, 0.0, 0.0),
                                child: Container(
                                  width: 34.0,
                                  height: 34.0,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        '${ApiConstants.baseUrl}${ordreInfo.kjopte == true ? ordreInfo.foodDetails.profilepic : ordreInfo.kjoperProfilePic}',
                                    fit: BoxFit.cover,
                                    imageBuilder: (context, imageProvider) {
                                      return Container(
                                        width: 34.0,
                                        height: 34.0,
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
                                      width: 34.0,
                                      height: 34.0,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            8.0, 0.0, 0.0, 0.0),
                                    child: Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: ordreInfo.deleted
                                                ? 'deleted_user'
                                                : ordreInfo.kjopte == true
                                                    ? ordreInfo.selgerUsername
                                                    : ordreInfo.kjoperUsername,
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Nunito',
                                                  fontSize: 15.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: const AlignmentDirectional(0, 0),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 0, 0),
                            child: InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                try {
                                  Navigator.pop(context);
                                } on SocketException {
                                  Toasts.showErrorToast(
                                      context, 'Ingen internettforbindelse');
                                } catch (e) {
                                  Toasts.showErrorToast(
                                      context, 'En feil oppstod');
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 0, 15, 0),
                                child: Text(
                                  'Lukk',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Nunito',
                                        fontSize: 17,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () async {
                try {
                  try {
                    context.pushNamed(
                      'KjopDetaljVentende1',
                      extra: {
                        'mine': ordreInfo.kjopte == true ? false : true,
                        'ordre': ordreInfo, // Example order object
                      },
                    );
                  } on SocketException {
                    Toasts.showErrorToast(
                        context, 'Ingen internettforbindelse');
                  } catch (e) {
                    Toasts.showErrorToast(context, 'En feil oppstod');
                  }
                } on SocketException {
                  Toasts.showErrorToast(context, 'Ingen internettforbindelse');
                } catch (e) {
                  Toasts.showErrorToast(context, 'En feil oppstod');
                }
              },
              child: Material(
                color: Colors.transparent,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Container(
                  height: 86,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primary,
                    borderRadius: BorderRadius.circular(13),
                    shape: BoxShape.rectangle,
                  ),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    4, 3, 1, 1),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(13),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        '${ApiConstants.baseUrl}${ordreInfo.foodDetails.imgUrls![0]}',
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    imageBuilder: (context, imageProvider) {
                                      return Container(
                                        width: 60,
                                        height: 60,
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
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    8, 0, 4, 0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0, 0, 0, 0),
                                      child: Text(
                                        matvare.name ?? '',
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
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0, 0, 0, 0),
                                      child: Text(
                                        infoServices.getStatusText(),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Nunito',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              fontSize: 14,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 8, 10, 0),
                                child: Text(
                                  '${ordreInfo.kjopte == true ? ordreInfo.prisBetalt : ordreInfo.pris} Kr',
                                  textAlign: TextAlign.end,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Nunito',
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        fontSize: 17,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.bold,
                                      ),
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
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        0.0, 16.0, 16.0, 5.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(children: [
                          const SizedBox(
                            height: 40,
                            child: VerticalDivider(
                              thickness: 1,
                              color: Color.fromARGB(48, 113, 113, 113),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'PRIS',
                                textAlign: TextAlign.start,
                                style: FlutterFlowTheme.of(context)
                                    .titleMedium
                                    .override(
                                      fontFamily: 'Nunito',
                                      fontSize: 13.0,
                                      letterSpacing: 0.0,
                                      color: const Color.fromARGB(
                                          255, 113, 113, 113),
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Text(
                                '${matvare.price}Kr',
                                textAlign: TextAlign.start,
                                style: FlutterFlowTheme.of(context)
                                    .titleMedium
                                    .override(
                                      fontFamily: 'Nunito',
                                      fontSize: 13.0,
                                      letterSpacing: 0.0,
                                      color: const Color.fromARGB(
                                          255, 113, 113, 113),
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                        ]),
                        Row(
                          children: [
                            const SizedBox(
                              height: 40,
                              child: VerticalDivider(
                                thickness: 1,
                                color: Color.fromARGB(48, 113, 113, 113),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ANTALL',
                                  textAlign: TextAlign.start,
                                  style: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .override(
                                        fontFamily: 'Nunito',
                                        fontSize: 13.0,
                                        letterSpacing: 0.0,
                                        color: const Color.fromARGB(
                                            255, 113, 113, 113),
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 0),
                                  child: Text(
                                    '${ordreInfo.antall.toStringAsFixed(0)} ${matvare.kg == true ? 'Kg' : 'stk'}',
                                    textAlign: TextAlign.start,
                                    style: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .override(
                                          fontFamily: 'Nunito',
                                          fontSize: 13.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.bold,
                                          color: const Color.fromARGB(
                                              255, 113, 113, 113),
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const SizedBox(
                              height: 40,
                              child: VerticalDivider(
                                thickness: 1,
                                color: Color.fromARGB(48, 113, 113, 113),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'UTLØPER',
                                  textAlign: TextAlign.start,
                                  style: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .override(
                                        fontFamily: 'Nunito',
                                        fontSize: 13.0,
                                        letterSpacing: 0.0,
                                        color: const Color.fromARGB(
                                            255, 113, 113, 113),
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      5, 0, 0, 0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        ordreInfo.updatetime != null
                                            ? (DateFormat(
                                                    "d. MMM  HH:mm", "nb_NO")
                                                .format(ordreInfo.updatetime!
                                                    .toLocal()
                                                    .add(Duration(days: 3))))
                                            : "",
                                        textAlign: TextAlign.start,
                                        style: FlutterFlowTheme.of(context)
                                            .titleMedium
                                            .override(
                                              fontFamily: 'Nunito',
                                              fontSize: 13.0,
                                              letterSpacing: 0.0,
                                              color: const Color.fromARGB(
                                                  255, 113, 113, 113),
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (ordreInfo.rated != true &&
                ordreInfo.kjopte != true &&
                ordreInfo.hentet == true)
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                  ),
                  Align(
                    alignment: const AlignmentDirectional(0, 0),
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 2),
                      child: FFButtonWidget(
                        onPressed: () async {
                          try {
                            if (_model.loading) {
                              return;
                            }
                            _model.loading = true;
                            await showModalBottomSheet(
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              barrierColor: const Color.fromARGB(60, 17, 0, 0),
                              useRootNavigator: true,
                              context: context,
                              builder: (context) {
                                return GestureDetector(
                                  onTap: () => FocusScope.of(context).unfocus(),
                                  child: Padding(
                                    padding: MediaQuery.viewInsetsOf(context),
                                    child: RatingPage(
                                      kjop: false,
                                      username: ordreInfo.kjoper,
                                      salgInfoId: ordreInfo.id,
                                    ),
                                  ),
                                );
                              },
                            ).then((value) => setState(() {
                                  _model.loading = false;
                                }));
                            return;
                          } on SocketException {
                            if (!context.mounted) return;
                            Toasts.showErrorToast(
                                context, 'Ingen internettforbindelse');
                          } catch (e) {
                            if (!context.mounted) return;
                            Toasts.showErrorToast(context, 'En feil oppstod');
                          }
                        },
                        text: 'Vurder kjøperen',
                        options: FFButtonOptions(
                          width: double.infinity,
                          height: 47,
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(11, 0, 0, 0),
                          iconPadding:
                              const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                          color: FlutterFlowTheme.of(context).primary,
                          textStyle: FlutterFlowTheme.of(context)
                              .titleSmall
                              .override(
                                fontFamily: 'Nunito',
                                color: FlutterFlowTheme.of(context).alternate,
                                fontSize: 16,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.bold,
                              ),
                          elevation: 0,
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).alternate,
                            width: 0.7,
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 35),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  if (ordreInfo.godkjent == true &&
                      ordreInfo.hentet != true &&
                      ordreInfo.kjopte == true &&
                      ordreInfo.avvist != true &&
                      ordreInfo.trekt != true)
                    Align(
                      alignment: const AlignmentDirectional(0, 0),
                      child: Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                        child: FFButtonWidget(
                          onPressed: () {
                            infoServices.confirmReceived(context);
                          },
                          text: 'Bekreft mottatt',
                          options: FFButtonOptions(
                            width: double.infinity,
                            height: 47,
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                11, 0, 0, 0),
                            iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 0, 0),
                            color: FlutterFlowTheme.of(context).primary,
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  fontFamily: 'Nunito',
                                  color: FlutterFlowTheme.of(context).alternate,
                                  fontSize: 16,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                ),
                            elevation: 0,
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).alternate,
                              width: 0.7,
                            ),
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                  ),
                  if (ordreInfo.kjopte != true
                      ? (ordreInfo.godkjent == true ||
                          ordreInfo.godkjent == false ||
                          ordreInfo.trekt == true ||
                          ordreInfo.avvist == true)
                      : true)
                    Align(
                      alignment: const AlignmentDirectional(0, 0),
                      child: Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                        child: FFButtonWidget(
                          onPressed: () async {
                            await infoServices.enterConversation(context);
                          },
                          text: 'Melding',
                          options: FFButtonOptions(
                            width: double.infinity,
                            height: 47,
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                11, 0, 0, 0),
                            iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 0, 0),
                            color: FlutterFlowTheme.of(context).alternate,
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  fontFamily: 'Nunito',
                                  color: FlutterFlowTheme.of(context).primary,
                                  fontSize: 17,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                ),
                            elevation: 0,
                            borderSide: const BorderSide(
                              color: Colors.transparent,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  if (ordreInfo.godkjent != true &&
                      ordreInfo.hentet != true &&
                      ordreInfo.kjopte == true &&
                      ordreInfo.avvist != true &&
                      ordreInfo.trekt != true)
                    Align(
                      alignment: const AlignmentDirectional(0, 0),
                      child: Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                        child: FFButtonWidget(
                          onPressed: () async {
                            await infoServices.cancelBid(context);
                          },
                          text: 'Trekk bud',
                          options: FFButtonOptions(
                            width: double.infinity,
                            height: 47,
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                11, 0, 0, 0),
                            iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 0, 0),
                            color: FlutterFlowTheme.of(context).primary,
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  fontFamily: 'Nunito',
                                  color: FlutterFlowTheme.of(context).error,
                                  fontSize: 16,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w800,
                                ),
                            elevation: 0,
                            borderSide: const BorderSide(
                              color: Color(0x5957636C),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  if (ordreInfo.godkjent != true &&
                      ordreInfo.hentet != true &&
                      ordreInfo.kjopte != true &&
                      ordreInfo.avvist != true &&
                      ordreInfo.trekt != true)
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
                          child: FFButtonWidget(
                            onPressed: () async {
                              await infoServices.declineBid(context);
                            },
                            text: 'Avslå',
                            options: FFButtonOptions(
                              width: 155,
                              height: 47,
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 0, 0),
                              iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 0, 0),
                              color: Colors.white,
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
                                    fontFamily: 'Nunito',
                                    color:
                                        FlutterFlowTheme.of(context).alternate,
                                    fontSize: 16,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w800,
                                  ),
                              elevation: 0,
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).alternate,
                                width: 0.6,
                              ),
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                        Builder(
                          builder: (context) => Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                5, 0, 0, 0),
                            child: FFButtonWidget(
                              onPressed: () async {
                                await infoServices.acceptBid(context);
                              },
                              text: 'Godkjenn',
                              options: FFButtonOptions(
                                width: 155,
                                height: 47,
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 0, 0, 0),
                                iconPadding:
                                    const EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 0, 0),
                                color: FlutterFlowTheme.of(context).alternate,
                                textStyle: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .override(
                                      fontFamily: 'Nunito',
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      fontSize: 16,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w800,
                                    ),
                                elevation: 0,
                                borderSide: const BorderSide(
                                  color: Colors.transparent,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
