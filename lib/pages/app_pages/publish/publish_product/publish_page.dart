import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mat_salg/helper_components/widgets/dialog_utils.dart';
import 'package:mat_salg/helper_components/widgets/dividers.dart';
import 'package:mat_salg/helper_components/widgets/toasts.dart';
import 'package:mat_salg/my_ip.dart';
import 'package:mat_salg/pages/app_pages/publish/publish_product/publish_services.dart';
import 'package:mat_salg/pages/app_pages/publish/choose_category/category_page.dart';
import 'package:mat_salg/logging.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:mat_salg/models/matvarer.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../choose_location/location_page.dart';
import '../../../../helper_components/flutter_flow/flutter_flow_icon_button.dart';
import '../../../../helper_components/flutter_flow/flutter_flow_theme.dart';
import '../../../../helper_components/flutter_flow/flutter_flow_util.dart';
import '../../../../helper_components/flutter_flow/flutter_flow_widgets.dart';
export 'publish_model.dart';

class PublishPage extends StatefulWidget {
  const PublishPage({
    super.key,
    this.matinfo,
    bool? rediger,
    this.fromChat,
  }) : rediger = rediger ?? false;

  final bool rediger;
  final dynamic matinfo;
  final dynamic fromChat;

  @override
  State<PublishPage> createState() => _LeggUtMatvareWidgetState();
}

class _LeggUtMatvareWidgetState extends State<PublishPage>
    with TickerProviderStateMixin {
  final FocusNode _hiddenFocusNode = FocusNode();
  late PublishModel _model;
  late PublishServices publishServices;
  Map<String, dynamic> keyMap = {
    'timestamp': DateTime.now().toString(),
    'uniqueId': 'from-chat',
  };
  bool _isButtonDisabled = false;
  bool _navigate = false;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PublishModel());
    publishServices = PublishServices(model: _model);

    if (!widget.rediger) {
      publishServices.getUserLocation(context);
      _model.currentselectedLatLng = _model.selectedLatLng;
    }
    _model.produktNavnTextController ??= TextEditingController();
    _model.produktNavnFocusNode ??= FocusNode();

    _model.produktBeskrivelseTextController ??= TextEditingController();
    _model.produktBeskrivelseFocusNode ??= FocusNode();

    _model.produktPrisSTKTextController ??= TextEditingController();
    _model.produktPrisSTKFocusNode ??= FocusNode();

    if (widget.matinfo != null) {
      _model.matvare = Matvarer.fromJson1(widget.matinfo);

      publishServices.getKommune(
          context, _model.matvare.lat ?? 0, _model.matvare.lng ?? 0);
      _model.selectedLatLng =
          LatLng(_model.matvare.lat ?? 0, _model.matvare.lng ?? 0);
      _model.currentselectedLatLng = _model.selectedLatLng;

      _model.produktNavnTextController.text = _model.matvare.name ?? '';
      _model.kategori = _model.matvare.kategorier!.first;
      _model.produktBeskrivelseTextController.text =
          _model.matvare.description ?? '';
      _model.accuratePosition = _model.matvare.accuratePosition ?? false;
      _model.produktPrisSTKTextController.text =
          _model.matvare.price.toString();

      _model.kjopt = _model.matvare.kjopt;

      if (_model.matvare.imgUrls != null) {
        if (_model.matvare.imgUrls != null &&
            _model.matvare.imgUrls!.isNotEmpty) {
          for (int i = 0; i < _model.matvare.imgUrls!.length; i++) {
            if (i < _model.unselectedImages.length) {
              _model.unselectedImages[i] = XFile(_model.matvare.imgUrls![i]);
            }
          }
        }
      }
    } else {
      _model.matvare = Matvarer.fromJson1({'imgUrl': []});
    }
    if (_model.accuratePosition == false) {
      _model.selectedLocationOption = 'approximate';
    }
    if (_model.accuratePosition == true) {
      _model.selectedLocationOption = 'exact';
    }
  }

  @override
  void dispose() {
    _model.dispose();
    _hiddenFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) {
            return;
          }
        },
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: FlutterFlowTheme.of(context).primary,
          appBar: AppBar(
            backgroundColor: FlutterFlowTheme.of(context).primary,
            automaticallyImplyLeading: false,
            scrolledUnderElevation: 0.0,
            title: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                  child: GestureDetector(
                    onTap: () async {
                      try {
                        if (publishServices.hasChanges(
                            context, widget.rediger)) {
                          showCupertinoDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CupertinoAlertDialog(
                                title: const Text('Forkast endringer?'),
                                content: const Text(
                                  'Alle endringer vil forsvinne',
                                ),
                                actions: [
                                  CupertinoDialogAction(
                                    isDestructiveAction: true,
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Ja, forkast endringer'),
                                  ),
                                  CupertinoDialogAction(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text(
                                      'Fortsett å redigere',
                                      style: TextStyle(
                                          color: CupertinoColors.systemBlue),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          context.safePop();
                        }
                      } on SocketException {
                        Toasts.showErrorToast(
                            context, 'Ingen internettforbindelse');
                      } catch (e) {
                        logger.e('En feil oppstod: $e');
                      }
                    },
                    child: Text(
                      'Avbryt',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Nunito',
                            color: FlutterFlowTheme.of(context).primaryText,
                            fontSize: 16,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),
                Text(
                  widget.rediger == true ? 'Rediger' : 'Ny annonse',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Nunito',
                        color: FlutterFlowTheme.of(context).primaryText,
                        fontSize: 18,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                  child: GestureDetector(
                    onTap: () async {
                      if (widget.fromChat) {
                        final appState = FFAppState();
                        appState.updateUI();
                      }
                      await publishServices.saveFoodUpdates(
                          context,
                          (title, content) => DialogUtils.showSimpleDialog(
                              context: context,
                              title: title,
                              content: content,
                              buttonText: 'Ok'),
                          (message, error) => error
                              ? Toasts.showErrorToast(context, message)
                              : Toasts.showAccepted(context, message),
                          (path, pop) => pop
                              ? Navigator.of(context).pop()
                              : widget.fromChat
                                  ? context.goNamed('Profil')
                                  : context.pushNamed(path));
                      safeSetState(() {});
                    },
                    child: Text(
                      'Lagre',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Nunito',
                            color: widget.rediger == true
                                ? Colors.blue
                                : Colors.transparent,
                            fontSize: 16,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                )
              ],
            ),
            actions: const [],
            centerTitle: true,
            elevation: 0.0,
          ),
          body: SafeArea(
            top: true,
            bottom: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    primary: false,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            SingleChildScrollView(
                              child: Column(
                                key: _model.topKey,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Form(
                                    key: _model.formKey,
                                    autovalidateMode: AutovalidateMode.disabled,
                                    child: GestureDetector(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Align(
                                            alignment:
                                                const AlignmentDirectional(
                                                    -1.0, 0.0),
                                            child: Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        20.0, 40.0, 0.0, 0.0),
                                                child: RichText(
                                                  text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: 'Legg til bilder',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Nunito',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryText,
                                                                  fontSize:
                                                                      19.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                ),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            '\nLegg til minst 3 bilder for å øke sjansen\nfor salg.',
                                                        style: FlutterFlowTheme
                                                                .of(context)
                                                            .bodyMedium
                                                            .override(
                                                              fontFamily:
                                                                  'Nunito',
                                                              color: Colors
                                                                  .grey[700],
                                                              fontSize: 15.0,
                                                              letterSpacing:
                                                                  0.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                            ),
                                                      ),
                                                    ],
                                                  ),
                                                )),
                                          ),
                                          SizedBox(
                                            key: _model.imageKey,
                                            height: 150,
                                            width: double.infinity,
                                            child: ListView(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      12, 0, 12, 0),
                                              scrollDirection: Axis.horizontal,
                                              children: [
                                                ReorderableListView.builder(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  shrinkWrap: true,
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  buildDefaultDragHandles:
                                                      false,
                                                  onReorder:
                                                      (oldIndex, newIndex) {
                                                    setState(() {
                                                      final nonPlaceholderImages =
                                                          _model
                                                              .unselectedImages
                                                              .where((image) =>
                                                                  image.path !=
                                                                  'ImagePlaceHolder.jpg')
                                                              .toList();

                                                      if (oldIndex < newIndex) {
                                                        newIndex -= 1;
                                                      }

                                                      final movedImage =
                                                          nonPlaceholderImages
                                                              .removeAt(
                                                                  oldIndex);
                                                      nonPlaceholderImages
                                                          .insert(newIndex,
                                                              movedImage);

                                                      _model.unselectedImages =
                                                          [
                                                        ...nonPlaceholderImages,
                                                        ..._model
                                                            .unselectedImages
                                                            .where((image) =>
                                                                image.path ==
                                                                'ImagePlaceHolder.jpg'),
                                                      ];
                                                    });
                                                  },
                                                  itemCount: _model
                                                      .unselectedImages
                                                      .where((image) =>
                                                          image.path !=
                                                          'ImagePlaceHolder.jpg')
                                                      .length,
                                                  proxyDecorator: (child, index,
                                                      animation) {
                                                    return Transform.scale(
                                                      scale: 1.0,
                                                      child: child,
                                                    );
                                                  },
                                                  itemBuilder: (context,
                                                      reorderableIndex) {
                                                    final nonPlaceholderImages =
                                                        _model.unselectedImages
                                                            .where((image) =>
                                                                image.path !=
                                                                'ImagePlaceHolder.jpg')
                                                            .toList();
                                                    final selectedImage =
                                                        nonPlaceholderImages[
                                                            reorderableIndex];

                                                    return Stack(
                                                      key: ValueKey(
                                                          selectedImage),
                                                      alignment:
                                                          const AlignmentDirectional(
                                                              1.0, -0.73),
                                                      children: [
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      8),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8.0),
                                                                child: selectedImage
                                                                        .path
                                                                        .contains(
                                                                            '/files/')
                                                                    ? CachedNetworkImage(
                                                                        fadeInDuration:
                                                                            Duration.zero,
                                                                        imageUrl:
                                                                            '${ApiConstants.baseUrl}${selectedImage.path}',
                                                                        width:
                                                                            88.0,
                                                                        height:
                                                                            88.0,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                        placeholder:
                                                                            (context, url) =>
                                                                                const SizedBox(),
                                                                      )
                                                                    : Image
                                                                        .file(
                                                                        File(selectedImage
                                                                            .path),
                                                                        width:
                                                                            88.0,
                                                                        height:
                                                                            88.0,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                              ),
                                                              ReorderableDragStartListener(
                                                                index:
                                                                    reorderableIndex,
                                                                child:
                                                                    Container(
                                                                  color: Colors
                                                                      .transparent,
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .fromLTRB(
                                                                            25,
                                                                            0,
                                                                            25,
                                                                            5),
                                                                    child:
                                                                        Center(
                                                                      child: Transform
                                                                          .rotate(
                                                                        angle:
                                                                            1.5708,
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .drag_indicator,
                                                                          color:
                                                                              Colors.grey,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () async {
                                                            safeSetState(() {
                                                              final imageIndex = _model
                                                                  .unselectedImages
                                                                  .indexOf(
                                                                      selectedImage);
                                                              _model.unselectedImages[
                                                                      imageIndex] =
                                                                  XFile(
                                                                      'ImagePlaceHolder.jpg');

                                                              _model
                                                                  .unselectedImages
                                                                  .sort((a, b) {
                                                                if (a.path ==
                                                                        'ImagePlaceHolder.jpg' &&
                                                                    b.path !=
                                                                        'ImagePlaceHolder.jpg') {
                                                                  return 1;
                                                                }
                                                                if (b.path ==
                                                                        'ImagePlaceHolder.jpg' &&
                                                                    a.path !=
                                                                        'ImagePlaceHolder.jpg') {
                                                                  return -1;
                                                                }
                                                                return 0;
                                                              });
                                                            });
                                                          },
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .fromLTRB(
                                                                    0, 8, 0, 5),
                                                            child: Container(
                                                              width: 24,
                                                              height: 24,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .black,
                                                                shape: BoxShape
                                                                    .circle,
                                                                border:
                                                                    Border.all(
                                                                  color: Colors
                                                                      .white,
                                                                  width: 0.8,
                                                                ),
                                                              ),
                                                              child:
                                                                  const Center(
                                                                child: FaIcon(
                                                                  FontAwesomeIcons
                                                                      .xmark,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 16,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                ),
                                                ..._model.unselectedImages
                                                    .where((image) =>
                                                        image.path ==
                                                        'ImagePlaceHolder.jpg')
                                                    .map((placeholder) {
                                                  int index = _model
                                                      .unselectedImages
                                                      .indexOf(
                                                          placeholder); // Get the index
                                                  return Container(
                                                    margin: const EdgeInsets
                                                        .fromLTRB(6, 8, 6, 0),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        FlutterFlowIconButton(
                                                          borderColor: index ==
                                                                      0 &&
                                                                  _model.errorImage !=
                                                                      null
                                                              ? FlutterFlowTheme
                                                                      .of(
                                                                          context)
                                                                  .error
                                                              : FlutterFlowTheme
                                                                      .of(context)
                                                                  .secondary,
                                                          borderRadius: 15.0,
                                                          borderWidth: 1.3,
                                                          buttonSize: 86.0,
                                                          fillColor:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondary,
                                                          icon: Icon(
                                                            CupertinoIcons
                                                                .camera,
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primaryText,
                                                            size: 25.0,
                                                          ),
                                                          onPressed: () async {
                                                            try {
                                                              FocusScope.of(
                                                                      context)
                                                                  .requestFocus(
                                                                      FocusNode());
                                                              await publishServices
                                                                  .selectImages(
                                                                      context);

                                                              safeSetState(
                                                                  () {});
                                                            } catch (e) {
                                                              logger.e(
                                                                  'Error occurred');
                                                            }
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }),
                                              ],
                                            ),
                                          ),
                                          if (_model.errorImage != null)
                                            Align(
                                              alignment:
                                                  const AlignmentDirectional(
                                                      -1.0, 0.0),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        20.0, 0.0, 0.0, 5.0),
                                                child: Text(
                                                  textAlign: TextAlign.left,
                                                  _model.errorImage ?? '',
                                                  style: TextStyle(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .error,
                                                    fontSize: 13.0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          Dividers.simpleDivider(),
                                          Align(
                                            alignment:
                                                const AlignmentDirectional(
                                                    -1.0, 0.0),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      20.0, 20.0, 0.0, 10.0),
                                              child: Text(
                                                'Hva skal du selge?',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Nunito',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          fontSize: 18.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                        ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            key: _model.titleKey,
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(
                                                20.0, 0.0, 20.0, 16.0),
                                            child: TextFormField(
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              controller: _model
                                                  .produktNavnTextController,
                                              focusNode:
                                                  _model.produktNavnFocusNode,
                                              obscureText: false,
                                              textCapitalization:
                                                  TextCapitalization.sentences,
                                              decoration: InputDecoration(
                                                labelText: 'Tittel',
                                                labelStyle: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyMedium
                                                    .override(
                                                      fontFamily: 'Nunito',
                                                      color:
                                                          const Color.fromRGBO(
                                                              113,
                                                              113,
                                                              113,
                                                              1.0),
                                                      fontSize: 16.0,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                hintStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .labelMedium
                                                        .override(
                                                          fontFamily: 'Nunito',
                                                          letterSpacing: 0.0,
                                                        ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Color(0x00000000),
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondary,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                errorBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .error,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                focusedErrorBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .error,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                filled: true,
                                                fillColor:
                                                    FlutterFlowTheme.of(context)
                                                        .secondary,
                                                contentPadding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        20.0, 30.0, 0.0, 0.0),
                                              ),
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    fontFamily: 'Nunito',
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryText,
                                                    fontSize: 16,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                              maxLength: 24,
                                              maxLengthEnforcement:
                                                  MaxLengthEnforcement.enforced,
                                              buildCounter: (context,
                                                      {required currentLength,
                                                      required isFocused,
                                                      maxLength}) =>
                                                  null,
                                              validator: _model
                                                  .produktNavnTextControllerValidator
                                                  .asValidator(context),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              try {
                                                FocusScope.of(context)
                                                    .requestFocus(FocusNode());
                                                String? velgkategori =
                                                    await showModalBottomSheet<
                                                        String>(
                                                  isScrollControlled: true,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  barrierColor:
                                                      const Color.fromARGB(
                                                          60, 17, 0, 0),
                                                  context: context,
                                                  builder: (context) {
                                                    return GestureDetector(
                                                      onTap: () =>
                                                          FocusScope.of(context)
                                                              .unfocus(),
                                                      child: Padding(
                                                        padding: MediaQuery
                                                            .viewInsetsOf(
                                                                context),
                                                        child: CategoryPage(
                                                            kategori: _model
                                                                .kategori),
                                                      ),
                                                    );
                                                  },
                                                );

                                                setState(() {
                                                  if (velgkategori != null) {
                                                    _model.errorCategory = null;
                                                    _model.kategori =
                                                        velgkategori;
                                                    _model.isFocused = true;
                                                  }
                                                });
                                              } catch (e) {
                                                if (context.mounted) {
                                                  Toasts.showErrorToast(context,
                                                      'En feil oppstod');
                                                }
                                              }
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      20, 0, 20, 16),
                                              child: Stack(
                                                clipBehavior: Clip.none,
                                                children: [
                                                  // Custom container with optional red border and error state
                                                  Container(
                                                    width: MediaQuery.sizeOf(
                                                            context)
                                                        .width,
                                                    height: 57,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondary,
                                                      border: Border.all(
                                                        color: _model
                                                                    .errorCategory ==
                                                                null
                                                            ? FlutterFlowTheme
                                                                    .of(context)
                                                                .secondary
                                                            : FlutterFlowTheme
                                                                    .of(context)
                                                                .error,
                                                        width: 1,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 12),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Icon(
                                                              CupertinoIcons
                                                                  .square_grid_2x2,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryText,
                                                              size: 25,
                                                            ),
                                                            const SizedBox(
                                                                width: 15),
                                                            Text(
                                                              _model.kategori ??
                                                                  'Kategori',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        'Nunito',
                                                                    color: const Color
                                                                        .fromRGBO(
                                                                        113,
                                                                        113,
                                                                        113,
                                                                        1),
                                                                    fontSize:
                                                                        16,
                                                                    letterSpacing:
                                                                        0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                  ),
                                                            ),
                                                          ],
                                                        ),
                                                        Icon(
                                                          CupertinoIcons
                                                              .chevron_forward,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          size: 22,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  // Positioned label on focus or if category is selected
                                                  if (_model.isFocused ||
                                                      _model.kategori != null)
                                                    Positioned(
                                                      top: -10,
                                                      left: 18,
                                                      child: Container(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondary,
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                    4.0),
                                                        child: Text(
                                                          'Kategori',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodySmall
                                                              .copyWith(
                                                                fontFamily:
                                                                    'Nunito',
                                                                fontSize: 13.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: const Color
                                                                    .fromRGBO(
                                                                    113,
                                                                    113,
                                                                    113,
                                                                    1.0),
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                  // Error message under the container
                                                  if (_model.errorCategory !=
                                                      null)
                                                    Positioned(
                                                      bottom: -16,
                                                      left: 18,
                                                      child: Text(
                                                        _model.errorCategory ??
                                                            '',
                                                        style: TextStyle(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .error,
                                                          fontSize: 12.0,
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Dividers.simpleDivider(),
                                          Align(
                                            alignment:
                                                const AlignmentDirectional(
                                                    -1.0, 0.0),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      20.0, 20.0, 0.0, 5.0),
                                              child: Text(
                                                'Beskriv varen',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Nunito',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          fontSize: 18.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                        ),
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment:
                                                const AlignmentDirectional(
                                                    -1.0, 0.0),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      20.0, 0.0, 20.0, 10.0),
                                              child: Text(
                                                'Fortell litt om varen, hvor mye er det i hver pakke? Hvor mange har du tilgjenlig? Osv.',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Nunito',
                                                          color:
                                                              Colors.grey[700],
                                                          fontSize: 15.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(
                                                20.0, 0.0, 20.0, 16.0),
                                            child: TextFormField(
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              controller: _model
                                                  .produktBeskrivelseTextController,
                                              focusNode: _model
                                                  .produktBeskrivelseFocusNode,
                                              textCapitalization:
                                                  TextCapitalization.sentences,
                                              obscureText: false,
                                              decoration: InputDecoration(
                                                labelStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Nunito',
                                                          fontSize: 14.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                hintText: 'Beskrivelse',
                                                hintStyle: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyMedium
                                                    .override(
                                                      fontFamily: 'Nunito',
                                                      color:
                                                          const Color.fromRGBO(
                                                              113,
                                                              113,
                                                              113,
                                                              1.0),
                                                      fontSize: 16.0,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Color(0x00000000),
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondary,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                errorBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .error,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                focusedErrorBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .error,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                filled: true,
                                                fillColor:
                                                    FlutterFlowTheme.of(context)
                                                        .secondary,
                                                contentPadding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        20.0, 30.0, 0.0, 0.0),
                                              ),
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Nunito',
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        letterSpacing: 0.0,
                                                      ),
                                              textAlign: TextAlign.start,
                                              minLines: 3,
                                              maxLines: null,
                                              validator: _model
                                                  .produktBeskrivelseTextControllerValidator
                                                  .asValidator(context),
                                              inputFormatters: [
                                                LengthLimitingTextInputFormatter(
                                                    700),
                                              ],
                                            ),
                                          ),
                                          Dividers.simpleDivider(),
                                          Align(
                                            alignment:
                                                const AlignmentDirectional(
                                                    -1.0, 0.0),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      20.0, 20.0, 0.0, 10.0),
                                              child: Text(
                                                'Pris',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Nunito',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          fontSize: 18.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                        ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0.0, 0.0, 0.0, 20.0),
                                            child: Stack(
                                              alignment:
                                                  const AlignmentDirectional(
                                                      1.0, -0.3),
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          20.0, 0.0, 20.0, 0.0),
                                                  child: TextFormField(
                                                    autovalidateMode:
                                                        AutovalidateMode
                                                            .onUserInteraction,
                                                    controller: _model
                                                        .produktPrisSTKTextController,
                                                    focusNode: _model
                                                        .produktPrisSTKFocusNode,
                                                    onChanged: (_) =>
                                                        EasyDebounce.debounce(
                                                      '_model.produktPrisSTKTextController',
                                                      const Duration(
                                                          milliseconds: 300),
                                                      () => safeSetState(() {}),
                                                    ),
                                                    textCapitalization:
                                                        TextCapitalization.none,
                                                    obscureText: false,
                                                    decoration: InputDecoration(
                                                      labelText: 'Pris',
                                                      labelStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Nunito',
                                                                color: const Color
                                                                    .fromRGBO(
                                                                    113,
                                                                    113,
                                                                    113,
                                                                    1.0),
                                                                fontSize: 16.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                              ),
                                                      alignLabelWithHint: false,
                                                      hintStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .labelMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Nunito',
                                                                letterSpacing:
                                                                    0.0,
                                                              ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                          color:
                                                              Color(0x00000000),
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondary,
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                      ),
                                                      errorBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .error,
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                      ),
                                                      focusedErrorBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .error,
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                      ),
                                                      filled: true,
                                                      fillColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondary,
                                                      contentPadding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(20.0,
                                                              30.0, 0.0, 0.0),
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Nunito',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          fontSize: 17.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                    maxLength: 5,
                                                    maxLengthEnforcement:
                                                        MaxLengthEnforcement
                                                            .enforced,
                                                    buildCounter: (context,
                                                            {required currentLength,
                                                            required isFocused,
                                                            maxLength}) =>
                                                        null,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    validator: _model
                                                        .produktPrisSTKTextControllerValidator
                                                        .asValidator(context),
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .allow(
                                                              RegExp('[0-9]'))
                                                    ],
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      const AlignmentDirectional(
                                                          0.8, -0.19),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(
                                                            0, 8, 0, 0),
                                                    child: Text(
                                                      'NOK',
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily:
                                                                'Nunito',
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primaryText,
                                                            fontSize: 17.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Dividers.simpleDivider(),
                                          Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Align(
                                                alignment:
                                                    const AlignmentDirectional(
                                                        -1.0, 0.0),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(20.0, 20.0,
                                                          0.0, 10.0),
                                                  child: Text(
                                                    'Velg din posisjon',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Nunito',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          fontSize: 18.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                alignment:
                                                    const AlignmentDirectional(
                                                        -1, 0),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          20, 0, 20, 16),
                                                  child: GestureDetector(
                                                    onTap: () async {
                                                      try {
                                                        FocusScope.of(context)
                                                            .requestFocus(
                                                                FocusNode());

                                                        _model.selectedLatLng =
                                                            await showModalBottomSheet<
                                                                LatLng>(
                                                          isScrollControlled:
                                                              true,
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          barrierColor:
                                                              const Color
                                                                  .fromARGB(
                                                                  60, 17, 0, 0),
                                                          context: context,
                                                          builder: (context) {
                                                            return GestureDetector(
                                                              onTap: () =>
                                                                  FocusScope.of(
                                                                          context)
                                                                      .unfocus(),
                                                              child: Padding(
                                                                padding: MediaQuery
                                                                    .viewInsetsOf(
                                                                        context),
                                                                child:
                                                                    LocationPage(
                                                                  currentLocation:
                                                                      _model
                                                                          .currentselectedLatLng,
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        );
                                                        setState(() {
                                                          if (_model
                                                                  .selectedLatLng ==
                                                              const LatLng(
                                                                  0, 0)) {
                                                            _model.selectedLatLng =
                                                                null;
                                                          } else {
                                                            safeSetState(() {
                                                              publishServices.getKommune(
                                                                  context,
                                                                  _model.selectedLatLng
                                                                          ?.latitude ??
                                                                      0,
                                                                  _model.selectedLatLng
                                                                          ?.longitude ??
                                                                      0);
                                                              _model.currentselectedLatLng =
                                                                  _model
                                                                      .selectedLatLng;
                                                              _model.errorLocation =
                                                                  null;
                                                            });
                                                          }
                                                        });
                                                      } on SocketException {
                                                        if (context.mounted) {
                                                          Toasts.showErrorToast(
                                                              context,
                                                              'Ingen internettforbindelse');
                                                        }
                                                      } catch (e) {
                                                        if (context.mounted) {
                                                          Toasts.showErrorToast(
                                                              context,
                                                              'En feil oppstod');
                                                        }
                                                      }
                                                    },
                                                    child: Stack(
                                                      clipBehavior: Clip.none,
                                                      children: [
                                                        Container(
                                                          width:
                                                              MediaQuery.sizeOf(
                                                                      context)
                                                                  .width,
                                                          height: 57,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .secondary,
                                                            border: Border.all(
                                                              color: _model
                                                                          .errorLocation ==
                                                                      null
                                                                  ? FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondary
                                                                  : Colors.red,
                                                              width: 1,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                    12,
                                                                    0,
                                                                    12,
                                                                    0),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Icon(
                                                                      CupertinoIcons
                                                                          .placemark,
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .primaryText,
                                                                      size: 25,
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                          15,
                                                                          0,
                                                                          0,
                                                                          0),
                                                                      child:
                                                                          Text(
                                                                        _model.kommune !=
                                                                                null
                                                                            ? '${_model.kommune}'
                                                                            : 'Velg posisjon',
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .copyWith(
                                                                              fontFamily: 'Nunito',
                                                                              color: _model.kommune != null ? FlutterFlowTheme.of(context).primaryText : const Color.fromRGBO(113, 113, 113, 1.0),
                                                                              fontSize: 17.0,
                                                                              fontWeight: FontWeight.w700,
                                                                            ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Icon(
                                                                  CupertinoIcons
                                                                      .chevron_forward,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryText,
                                                                  size: 22,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        if (_model
                                                                .errorLocation !=
                                                            null)
                                                          Positioned(
                                                            bottom: -16,
                                                            left: 18,
                                                            child: Text(
                                                              _model.errorLocation ??
                                                                  '',
                                                              style: TextStyle(
                                                                color:
                                                                    Colors.red,
                                                                fontSize: 12.0,
                                                              ),
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        _model.selectedLocationOption =
                                                            'approximate';
                                                        _model.accuratePosition =
                                                            false;
                                                      });
                                                    },
                                                    child: Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              vertical: 0,
                                                              horizontal: 0),
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              16, 20, 16, 23),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(14),
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Row(children: [
                                                            Radio(
                                                              value:
                                                                  'approximate',
                                                              activeColor:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .alternate,
                                                              groupValue: _model
                                                                  .selectedLocationOption,
                                                              onChanged:
                                                                  (value) {
                                                                setState(() {
                                                                  _model.selectedLocationOption =
                                                                      value!;
                                                                });
                                                              },
                                                            ),
                                                            SizedBox(width: 10),
                                                            RichText(
                                                              text: TextSpan(
                                                                children: [
                                                                  TextSpan(
                                                                    text:
                                                                        'Generell beliggenhet', // First part of the text
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Nunito',
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryText,
                                                                          fontSize:
                                                                              16.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight:
                                                                              FontWeight.w700,
                                                                        ),
                                                                  ),
                                                                  TextSpan(
                                                                    text:
                                                                        '\nKjøpere vil bare se varens\nomtrentlige posisjon',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Nunito',
                                                                          color:
                                                                              FlutterFlowTheme.of(context).secondaryText,
                                                                          fontSize:
                                                                              14.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                        ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ]),
                                                          ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                            child: Image.asset(
                                                              'assets/images/ApproximatePosition.png',
                                                              width: 75.0,
                                                              height: 75.0,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        _model.selectedLocationOption =
                                                            'exact';
                                                        _model.accuratePosition =
                                                            true;
                                                      });
                                                    },
                                                    child: Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              vertical: 0,
                                                              horizontal: 0),
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              16, 0, 16, 10),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Radio(
                                                                value: 'exact',
                                                                activeColor:
                                                                    FlutterFlowTheme.of(
                                                                            context)
                                                                        .alternate,
                                                                groupValue: _model
                                                                    .selectedLocationOption,
                                                                onChanged:
                                                                    (value) {
                                                                  setState(() {
                                                                    _model.selectedLocationOption =
                                                                        value!;
                                                                  });
                                                                },
                                                              ),
                                                              SizedBox(
                                                                  width: 10),
                                                              RichText(
                                                                text: TextSpan(
                                                                  children: [
                                                                    TextSpan(
                                                                      text:
                                                                          'Nøyaktig beliggenhet',
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .override(
                                                                            fontFamily:
                                                                                'Nunito',
                                                                            color:
                                                                                FlutterFlowTheme.of(context).primaryText,
                                                                            fontSize:
                                                                                16.0,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontWeight:
                                                                                FontWeight.w700,
                                                                          ),
                                                                    ),
                                                                    TextSpan(
                                                                      text:
                                                                          '\nKjøpere vil se varens\nnøyaktige posisjon', // Additional text
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .override(
                                                                            fontFamily:
                                                                                'Nunito',
                                                                            color:
                                                                                FlutterFlowTheme.of(context).secondaryText,
                                                                            fontSize:
                                                                                14.0,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                          ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                            child: Image.asset(
                                                              'assets/images/AccuratePosition.png',
                                                              width: 75.0,
                                                              height: 75.0,
                                                              fit: BoxFit.cover,
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
                                          if (widget.rediger == false)
                                            Align(
                                              alignment:
                                                  const AlignmentDirectional(
                                                      0.0, 0.05),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        25.0, 40.0, 25.0, 30.0),
                                                child: FFButtonWidget(
                                                  onPressed: () async {
                                                    if (_navigate ||
                                                        _isButtonDisabled ||
                                                        _model
                                                            .oppdaterLoading) {
                                                      return;
                                                    }
                                                    _isButtonDisabled = true;
                                                    _model.oppdaterLoading =
                                                        true;

                                                    try {
                                                      await publishServices
                                                          .uploadFood(
                                                        context,
                                                        (title, content) =>
                                                            DialogUtils
                                                                .showSimpleDialog(
                                                          context: context,
                                                          title: title,
                                                          content: content,
                                                          buttonText: 'Ok',
                                                        ),
                                                        (message, error) {
                                                          if (error) {
                                                            Toasts
                                                                .showErrorToast(
                                                                    context,
                                                                    message);
                                                          } else {
                                                            Toasts.showAccepted(
                                                                context,
                                                                message);
                                                          }
                                                        },
                                                        (path, pop, imgPath) {
                                                          if (pop) {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          } else if (path ==
                                                              'BrukerLagtUtInfo') {
                                                            _navigate = true;
                                                            context.goNamed(
                                                              'BrukerLagtUtInfo',
                                                              queryParameters: {
                                                                'picture':
                                                                    serializeParam(
                                                                        imgPath,
                                                                        ParamType
                                                                            .String),
                                                              },
                                                            );
                                                            return;
                                                          } else {
                                                            context.pushNamed(
                                                                path);
                                                          }
                                                        },
                                                      );
                                                      if (!context.mounted) {
                                                        return;
                                                      }
                                                      Navigator.of(context).pop;
                                                    } catch (error) {
                                                      if (!context.mounted) {
                                                        return;
                                                      }
                                                      context.pop();
                                                      safeSetState(() {
                                                        _model.oppdaterLoading =
                                                            false;
                                                        _isButtonDisabled =
                                                            false;
                                                        _navigate = false;
                                                      });
                                                      logger.d(
                                                          'Error occurred: $error');
                                                    } finally {
                                                      if (context.mounted) {
                                                        Navigator.of(context)
                                                            .pop;
                                                      }
                                                      _isButtonDisabled = false;
                                                      _model.oppdaterLoading =
                                                          false;
                                                      safeSetState(() {});
                                                    }
                                                  },
                                                  text: 'Publiser',
                                                  options: FFButtonOptions(
                                                    width: double.infinity,
                                                    height: 50.0,
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(
                                                            0.0, 0.0, 0.0, 0.0),
                                                    iconPadding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(
                                                            0.0, 0.0, 0.0, 0.0),
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .alternate,
                                                    textStyle: FlutterFlowTheme
                                                            .of(context)
                                                        .titleMedium
                                                        .override(
                                                          fontFamily: 'Nunito',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondary,
                                                          fontSize: 16.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                    elevation: 0.0,
                                                    borderSide:
                                                        const BorderSide(
                                                      color: Colors.transparent,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            14.0),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          if (widget.rediger == true &&
                                              _model.kjopt == false)
                                            Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Align(
                                                  alignment:
                                                      const AlignmentDirectional(
                                                          0.0, 0.05),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(25.0,
                                                            80.0, 25.0, 0.0),
                                                    child: FFButtonWidget(
                                                      onPressed: () async {
                                                        if (_model.matvare
                                                                    .kjopt ==
                                                                true &&
                                                            _model.kjopt ==
                                                                false) {
                                                          safeSetState(() {
                                                            _model.kjopt = true;
                                                          });
                                                          return;
                                                        }
                                                        await publishServices
                                                            .markSoldOut(
                                                          context,
                                                          (title, content) =>
                                                              DialogUtils
                                                                  .showSimpleDialog(
                                                            context: context,
                                                            title: title,
                                                            content: content,
                                                            buttonText: 'Ok',
                                                          ),
                                                          (message, error) => error
                                                              ? Toasts
                                                                  .showErrorToast(
                                                                      context,
                                                                      message)
                                                              : Toasts
                                                                  .showAccepted(
                                                                      context,
                                                                      message),
                                                          (path, pop) {
                                                            if (pop) {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            } else if (widget
                                                                .fromChat) {
                                                              final appState =
                                                                  FFAppState();
                                                              appState
                                                                  .updateUI();
                                                              context.goNamed(
                                                                  'Profil');
                                                            } else {
                                                              context.pushNamed(
                                                                  path);
                                                            }
                                                          },
                                                        );

                                                        safeSetState(() {});
                                                      },
                                                      text: 'Marker utsolgt',
                                                      options: FFButtonOptions(
                                                        width: double.infinity,
                                                        height: 50.0,
                                                        padding:
                                                            const EdgeInsetsDirectional
                                                                .fromSTEB(0.0,
                                                                0.0, 0.0, 0.0),
                                                        iconPadding:
                                                            const EdgeInsetsDirectional
                                                                .fromSTEB(0.0,
                                                                0.0, 0.0, 0.0),
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .alternate,
                                                        textStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .titleMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Nunito',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondary,
                                                                  fontSize:
                                                                      16.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                ),
                                                        elevation: 0.0,
                                                        borderSide:
                                                            const BorderSide(
                                                          color: Colors
                                                              .transparent,
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(14.0),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          if (widget.rediger == true &&
                                              _model.kjopt == true)
                                            Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Align(
                                                  alignment:
                                                      const AlignmentDirectional(
                                                          0.0, 0.05),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(25.0,
                                                            80.0, 25.0, 0.0),
                                                    child: TextButton(
                                                      onPressed: () {
                                                        safeSetState(() {
                                                          _model.kjopt = false;
                                                        });
                                                      },
                                                      style:
                                                          TextButton.styleFrom(
                                                        backgroundColor: Colors
                                                            .transparent, // Transparent background
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 15.0),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      14.0),
                                                        ),
                                                      ),
                                                      child: Text(
                                                        ' Merk som tilgjengelig ',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .titleMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Nunito',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .alternate, // Alternate text color
                                                                  fontSize:
                                                                      17.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                        ].addToEnd(
                                            const SizedBox(height: 40.0)),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
