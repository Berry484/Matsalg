import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
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
  }) : rediger = rediger ?? false;

  final bool rediger;
  final dynamic matinfo;

  @override
  State<PublishPage> createState() => _LeggUtMatvareWidgetState();
}

class _LeggUtMatvareWidgetState extends State<PublishPage>
    with TickerProviderStateMixin {
  final FocusNode _hiddenFocusNode = FocusNode();
  late ScrollController _scrollController;
  late PublishModel _model;
  late PublishServices publishServices;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection !=
          ScrollDirection.idle) {
        FocusScope.of(context).requestFocus(FocusNode());
      }
    });

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

    _model.antallStkTextController ??= TextEditingController();
    _model.antallStkFocusNode ??= FocusNode();

    if (widget.matinfo != null) {
      _model.matvare = Matvarer.fromJson1(widget.matinfo);

      publishServices.getKommune(
          context, _model.matvare.lat ?? 0, _model.matvare.lng ?? 0);
      _model.selectedLatLng =
          LatLng(_model.matvare.lat ?? 0, _model.matvare.lng ?? 0);
      _model.currentselectedLatLng = _model.selectedLatLng;

      _model.selectedValue = _model.matvare.antall ?? 0;
      _model.produktNavnTextController.text = _model.matvare.name ?? '';
      _model.kategori = _model.matvare.kategorier!.first;
      _model.produktBeskrivelseTextController.text =
          _model.matvare.description ?? '';
      _model.accuratePosition = _model.matvare.accuratePosition ?? false;
      _model.produktPrisSTKTextController.text =
          _model.matvare.price.toString();

      if (_model.matvare.antall.toString() == 'null') {
        _model.antallStkTextController.text = '0';
      } else {
        _model.antallStkTextController.text =
            _model.matvare.antall!.toStringAsFixed(0);
      }

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
    _scrollController.dispose();
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
                        Toasts.showErrorToast(context, 'En feil oppstod');
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
                        fontSize: 17,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                  child: GestureDetector(
                    onTap: () async {
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
                              : context.pushNamed(path));
                      safeSetState(() {});
                    },
                    child: Text(
                      'Lagre',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Nunito',
                            color: widget.rediger == true
                                ? FlutterFlowTheme.of(context).alternate
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
                    controller: _scrollController,
                    primary: false,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            SingleChildScrollView(
                              child: Column(
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
                                                                          .w800,
                                                                ),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            '\nLegg til minst 3 bilder for å øke sjansen\nfor salg.',
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
                                                                      15.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                      ),
                                                    ],
                                                  ),
                                                )),
                                          ),
                                          SizedBox(
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
                                                                    ? Image
                                                                        .network(
                                                                        '${ApiConstants.baseUrl}${selectedImage.path}',
                                                                        width:
                                                                            88.0,
                                                                        height:
                                                                            88.0,
                                                                        fit: BoxFit
                                                                            .cover,
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
                                                    .map(
                                                        (placeholder) =>
                                                            Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .fromLTRB(
                                                                      6,
                                                                      8,
                                                                      6,
                                                                      0),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  FlutterFlowIconButton(
                                                                    borderColor:
                                                                        FlutterFlowTheme.of(context)
                                                                            .secondary,
                                                                    borderRadius:
                                                                        15.0,
                                                                    buttonSize:
                                                                        86.0,
                                                                    fillColor: FlutterFlowTheme.of(
                                                                            context)
                                                                        .secondary,
                                                                    icon: Icon(
                                                                      CupertinoIcons
                                                                          .camera,
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .primaryText,
                                                                      size:
                                                                          25.0,
                                                                    ),
                                                                    onPressed:
                                                                        () async {
                                                                      try {
                                                                        FocusScope.of(context)
                                                                            .requestFocus(FocusNode());
                                                                        await publishServices
                                                                            .selectImages(context);

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
                                                            )),
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
                                                      fontSize: 17.0,
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
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Nunito',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        fontSize: 16,
                                                        letterSpacing: 0.0,
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
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondary,
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
                                                                  'kategori',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        'Nunito',
                                                                    color: _model.kategori !=
                                                                            null
                                                                        ? FlutterFlowTheme.of(context)
                                                                            .primaryText
                                                                        : const Color
                                                                            .fromRGBO(
                                                                            113,
                                                                            113,
                                                                            113,
                                                                            1.0),
                                                                    fontSize:
                                                                        17.0,
                                                                    letterSpacing:
                                                                        0.0,
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
                                                          'kategori',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodySmall
                                                              .override(
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
                                                'Beskriv matvaren',
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
                                                'Fortell litt om matvaren, hvor mye er det i hver pakke? osv.',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Nunito',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          fontSize: 15.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w500,
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
                                                      fontSize: 17.0,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FontWeight.w700,
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
                                              maxLines: 7,
                                              validator: _model
                                                  .produktBeskrivelseTextControllerValidator
                                                  .asValidator(context),
                                              inputFormatters: [
                                                LengthLimitingTextInputFormatter(
                                                    200),
                                                TextInputFormatter.withFunction(
                                                    (oldValue, newValue) {
                                                  final lineCount = '\n'
                                                          .allMatches(
                                                              newValue.text)
                                                          .length +
                                                      1;
                                                  if (lineCount > 7) {
                                                    return oldValue;
                                                  }
                                                  return newValue;
                                                }),
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
                                                .fromSTEB(0.0, 0.0, 0.0, 16.0),
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
                                                                fontSize: 17.0,
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
                                                    'Velg antall',
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
                                                        -1.0, 0.0),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          20.0, 0.0, 0.0, 0.0),
                                                  child: Text(
                                                    'Hvor mange pakker/stykk skal være tilgjengelig for kjøperen? Antallet justeres ned automatisk når noen kjøper',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Nunito',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          fontSize: 15.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        0.0, 16.0, 0.0, 20.0),
                                                child: Stack(
                                                  alignment:
                                                      const AlignmentDirectional(
                                                          1.0, -0.3),
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          const AlignmentDirectional(
                                                              0.0, 0.0),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                20.0,
                                                                0.0,
                                                                20.0,
                                                                16.0),
                                                        child: TextFormField(
                                                          autovalidateMode:
                                                              AutovalidateMode
                                                                  .onUserInteraction,
                                                          controller: _model
                                                              .antallStkTextController,
                                                          focusNode: _model
                                                              .antallStkFocusNode,
                                                          onChanged: (_) =>
                                                              EasyDebounce
                                                                  .debounce(
                                                            '_model.antallStkTextController',
                                                            const Duration(
                                                                milliseconds:
                                                                    300),
                                                            () => safeSetState(
                                                                () {}),
                                                          ),
                                                          textCapitalization:
                                                              TextCapitalization
                                                                  .none,
                                                          obscureText: false,
                                                          readOnly:
                                                              true, // Disable the keyboard
                                                          decoration:
                                                              InputDecoration(
                                                            labelText: 'Antall',
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
                                                                      fontSize:
                                                                          17.0,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                    ),
                                                            alignLabelWithHint:
                                                                false,
                                                            hintText:
                                                                'Skriv inn antall',
                                                            hintStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          'Nunito',
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                            enabledBorder:
                                                                OutlineInputBorder(
                                                              borderSide:
                                                                  const BorderSide(
                                                                color: Color(
                                                                    0x00000000),
                                                                width: 1.0,
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.0),
                                                            ),
                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondary,
                                                                width: 1.0,
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.0),
                                                            ),
                                                            errorBorder:
                                                                OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .error,
                                                                width: 1.0,
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.0),
                                                            ),
                                                            focusedErrorBorder:
                                                                OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .error,
                                                                width: 1.0,
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.0),
                                                            ),
                                                            filled: true,
                                                            fillColor:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondary,
                                                            contentPadding:
                                                                const EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                    20.0,
                                                                    30.0,
                                                                    0.0,
                                                                    0.0),
                                                          ),
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Nunito',
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText,
                                                                fontSize: 17.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
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
                                                              const TextInputType
                                                                  .numberWithOptions(
                                                                  decimal:
                                                                      true),
                                                          validator: _model
                                                              .antallStkTextControllerValidator
                                                              .asValidator(
                                                                  context),
                                                          onTap: () {
                                                            List<int>
                                                                getPickerValues() {
                                                              List<int> values =
                                                                  [];
                                                              int step;

                                                              step = 1;
                                                              for (int i = 1;
                                                                  i <= 50;
                                                                  i += step) {
                                                                values.add(i);
                                                              }

                                                              return values;
                                                            }

                                                            showCupertinoModalPopup(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return CupertinoActionSheet(
                                                                  title: const Text(
                                                                      'Velg antall'),
                                                                  message:
                                                                      Column(
                                                                    children: [
                                                                      SizedBox(
                                                                        height:
                                                                            200, // Set a fixed height for the picker
                                                                        child:
                                                                            CupertinoPicker(
                                                                          itemExtent:
                                                                              32.0, // Height of each item
                                                                          scrollController:
                                                                              FixedExtentScrollController(
                                                                            initialItem:
                                                                                getPickerValues().indexOf(_model.selectedValue), // Set initial value
                                                                          ),
                                                                          onSelectedItemChanged:
                                                                              (index) {
                                                                            setState(() {
                                                                              _model.selectedValue = getPickerValues()[index];

                                                                              _model.antallStkTextController.text = _model.selectedValue.toStringAsFixed(0);

                                                                              HapticFeedback.selectionClick();
                                                                            });
                                                                          },
                                                                          children: getPickerValues()
                                                                              .map((value) => Center(
                                                                                    child: Text(value.toStringAsFixed(0)),
                                                                                  ))
                                                                              .toList(),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  cancelButton:
                                                                      CupertinoActionSheetAction(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    child: const Text(
                                                                        'Velg',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              19,
                                                                          color:
                                                                              CupertinoColors.systemBlue,
                                                                        )),
                                                                  ),
                                                                );
                                                              },
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment:
                                                          const AlignmentDirectional(
                                                              0.8, -0.19),
                                                      child: Text(
                                                        'Stk',
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
                                                                      17.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
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
                                                            });
                                                            safeSetState(() {});
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
                                                    child: Container(
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
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondary,
                                                          width: 1,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                12, 0, 12, 0),
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
                                                                  padding:
                                                                      const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                          15,
                                                                          0,
                                                                          0,
                                                                          0),
                                                                  child: Text(
                                                                    _model.kommune !=
                                                                            null
                                                                        ? '${_model.kommune}'
                                                                        : 'Velg posisjon',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Nunito',
                                                                          color: _model.kommune != null
                                                                              ? FlutterFlowTheme.of(context).primaryText
                                                                              : const Color.fromRGBO(113, 113, 113, 1.0),
                                                                          fontSize:
                                                                              17.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight:
                                                                              FontWeight.w700,
                                                                        ),
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
                                                                        '\nKjøpere vil bare se varens\nomtrentlige posisjon', // Additional text
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Nunito',
                                                                          color:
                                                                              FlutterFlowTheme.of(context).secondaryText,
                                                                          fontSize:
                                                                              13.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight:
                                                                              FontWeight.w400,
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
                                                                                13.0,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontWeight:
                                                                                FontWeight.w400,
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
                                          // Align(
                                          //   alignment:
                                          //       const AlignmentDirectional(
                                          //           0.0, 0.05),
                                          //   child: Padding(
                                          //     padding:
                                          //         const EdgeInsetsDirectional
                                          //             .fromSTEB(
                                          //             25.0, 40.0, 25.0, 30.0),
                                          //     child: FFButtonWidget(
                                          //       onPressed: () async {
                                          //         final token =
                                          //             await firebaseAuthService
                                          //                 .getToken(context);
                                          //         if (token == null) {
                                          //           return;
                                          //         } else {
                                          //           if (_isLoading) return;
                                          //           _isLoading = true;
                                          //           List<String>
                                          //               availableFiles = [
                                          //             '/files/69f57a53-e0b5-432c-b113-649cc1c6dda6',
                                          //             '/files/69c6d907-e67a-4b22-b21a-621ff0d54dc9',
                                          //             '/files/6eed2ccc-1c55-4cd1-843e-d3c2f0be5fc4',
                                          //             '/files/4712594f-02ec-4515-8a1f-f6abcb9944a5',
                                          //             '/files/f43e0e6f-eb74-474d-8510-71bb99b87bb4',
                                          //             '/files/1b40e3a1-fb57-4880-acb6-dc5cdbbac44d',
                                          //             '/files/306e14c6-2b54-4315-9433-a9cadbeb7fa2',
                                          //             '/files/e10a7889-f945-4873-adda-42e610726c2e',
                                          //             '/files/d0d9e844-4a07-46a1-a452-e95ccb0b58a5',
                                          //             '/files/cb5c1d29-ef8a-46f6-8f15-8b7d34aae86d',
                                          //             '/files/0af88305-48f3-49bf-89e6-6278bc1fb91b',
                                          //             '/files/157c337b-3953-4486-aec2-85c77c78ffb2',
                                          //             '/files/9f5f2b28-9008-4fbc-a7e2-054c5b27a410',
                                          //             '/files/fc844923-d8a8-473d-9ec4-aba378905302',
                                          //             '/files/7c00ab58-08cd-41fc-b1dd-c5d74b68e95c',
                                          //             '/files/8c5e3097-22c8-4649-84b2-94093250af56',
                                          //             '/files/943dd84f-7beb-4904-9027-2bf353261202',
                                          //             '/files/b0b04b41-31e5-4711-af6d-42546b3ff9b0',
                                          //             '/files/abf4796f-2878-4e09-b206-1b7261418979',
                                          //             '/files/68941723-e377-4770-a634-386c6f08fc9b',
                                          //             '/files/864b30e1-53c4-41d0-8dab-41fb2499a333',
                                          //             '/files/244bdbc2-6d3e-4243-99ed-8af60a309655',
                                          //             '/files/44290e2a-51b8-4d6b-b1c4-d3b3592c695a',
                                          //             '/files/3990fadb-b882-4cec-ad64-5f0a2fc57f36',
                                          //             '/files/6e57daeb-632b-4c84-ba79-65811a60ee59',
                                          //             '/files/ed1e41e6-d11f-404e-98e8-183ea745eebb',
                                          //             '/files/83f5e14c-d4d2-404f-9c68-502f3b0b36ee',
                                          //           ];

                                          //           // List of available categories
                                          //           List<String>
                                          //               availableCategories = [
                                          //             "kjøtt",
                                          //             "grønt",
                                          //             "meieri",
                                          //             "bakverk",
                                          //             "sjømat",
                                          //           ];

                                          //           // Random instance
                                          //           Random random = Random();

                                          //           int listingCounter = 1709;
                                          //           int uploadedListings = 0;

                                          //           while (uploadedListings <
                                          //               10000) {
                                          //             // Generate random file links
                                          //             List<String?> fileLinks =
                                          //                 [
                                          //               availableFiles[
                                          //                   random.nextInt(
                                          //                       availableFiles
                                          //                           .length)],
                                          //               availableFiles[
                                          //                   random.nextInt(
                                          //                       availableFiles
                                          //                           .length)],
                                          //             ];

                                          //             int price = random
                                          //                     .nextInt(491) +
                                          //                 10; // Random price between 10 and 500
                                          //             String category =
                                          //                 availableCategories[
                                          //                     random.nextInt(
                                          //                         availableCategories
                                          //                             .length)]; // Random category
                                          //             String name =
                                          //                 'TestVare$listingCounter'; // Listing name
                                          //             String description =
                                          //                 'Dette er $name'; // Listing description
                                          //             bool accuratePosition = random
                                          //                 .nextBool(); // Randomly true or false for accuratePosition

                                          //             listingCounter++; // Increment the counter

                                          //             final response =
                                          //                 await apiFoodService
                                          //                     .uploadfood(
                                          //               token: token,
                                          //               name: name,
                                          //               imgUrl: fileLinks,
                                          //               description:
                                          //                   description,
                                          //               price: price,
                                          //               kategorier: category,
                                          //               posisjon: LatLng(
                                          //                   FFAppState()
                                          //                       .brukerLat,
                                          //                   FFAppState()
                                          //                       .brukerLng),
                                          //               antall: 50,
                                          //               betaling: null,
                                          //               accuratePosition:
                                          //                   accuratePosition, // Use the random accuratePosition
                                          //               kg: false,
                                          //             );

                                          //             if (response.statusCode ==
                                          //                 200) {
                                          //               print(
                                          //                   "Listing $name uploaded successfully!");
                                          //               uploadedListings++;
                                          //               if (uploadedListings >=
                                          //                   10000) {
                                          //                 print(
                                          //                     "Uploaded $uploadedListings listings. Done!");
                                          //                 break;
                                          //               }
                                          //             } else if (response
                                          //                         .statusCode ==
                                          //                     401 ||
                                          //                 response.statusCode ==
                                          //                     404 ||
                                          //                 response.statusCode ==
                                          //                     500) {
                                          //               print(
                                          //                   "Error uploading listing. Stopping process.");
                                          //               break;
                                          //             }
                                          //           }

                                          //           _isLoading =
                                          //               false; // Reset loading state
                                          //           safeSetState(
                                          //               () {}); // Update UI if needed
                                          //         }
                                          //       },
                                          //       text: 'TestUploads',
                                          //       options: FFButtonOptions(
                                          //         width: double.infinity,
                                          //         height: 50.0,
                                          //         padding:
                                          //             const EdgeInsetsDirectional
                                          //                 .fromSTEB(
                                          //                 0.0, 0.0, 0.0, 0.0),
                                          //         iconPadding:
                                          //             const EdgeInsetsDirectional
                                          //                 .fromSTEB(
                                          //                 0.0, 0.0, 0.0, 0.0),
                                          //         color: FlutterFlowTheme.of(
                                          //                 context)
                                          //             .alternate,
                                          //         textStyle: FlutterFlowTheme
                                          //                 .of(context)
                                          //             .titleMedium
                                          //             .override(
                                          //               fontFamily: 'Nunito',
                                          //               color:
                                          //                   FlutterFlowTheme.of(
                                          //                           context)
                                          //                       .secondary,
                                          //               fontSize: 17.0,
                                          //               letterSpacing: 0.0,
                                          //               fontWeight:
                                          //                   FontWeight.w800,
                                          //             ),
                                          //         elevation: 0.0,
                                          //         borderSide: const BorderSide(
                                          //           color: Colors.transparent,
                                          //           width: 1.0,
                                          //         ),
                                          //         borderRadius:
                                          //             BorderRadius.circular(
                                          //                 14.0),
                                          //       ),
                                          //     ),
                                          //   ),
                                          // ),
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
                                                    await publishServices
                                                        .uploadFood(
                                                            context,
                                                            (title, content) => DialogUtils
                                                                .showSimpleDialog(
                                                                    context:
                                                                        context,
                                                                    title:
                                                                        title,
                                                                    content:
                                                                        content,
                                                                    buttonText:
                                                                        'Ok'),
                                                            (message, error) => error
                                                                ? Toasts
                                                                    .showErrorToast(
                                                                        context,
                                                                        message)
                                                                : Toasts
                                                                    .showAccepted(
                                                                        context,
                                                                        message),
                                                            (path, pop,
                                                                    imgPath) =>
                                                                pop
                                                                    ? Navigator.of(
                                                                            context)
                                                                        .pop()
                                                                    : path ==
                                                                            'BrukerLagtUtInfo'
                                                                        ? context
                                                                            .pushNamed(
                                                                            'BrukerLagtUtInfo',
                                                                            queryParameters: {
                                                                              'picture': serializeParam(
                                                                                imgPath,
                                                                                ParamType.String,
                                                                              ),
                                                                            },
                                                                          )
                                                                        : context
                                                                            .pushNamed(path));
                                                    safeSetState(() {});
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
                                          if (widget.rediger == true)
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
                                                        await publishServices.markSoldOut(
                                                            context,
                                                            (title, content) =>
                                                                DialogUtils.showSimpleDialog(
                                                                    context:
                                                                        context,
                                                                    title:
                                                                        title,
                                                                    content:
                                                                        content,
                                                                    buttonText:
                                                                        'Ok'),
                                                            (message, error) => error
                                                                ? Toasts
                                                                    .showErrorToast(
                                                                        context,
                                                                        message)
                                                                : Toasts.showAccepted(
                                                                    context,
                                                                    message),
                                                            (path, pop) => pop
                                                                ? Navigator.of(
                                                                        context)
                                                                    .pop()
                                                                : context.pushNamed(
                                                                    path));
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
                                                                      17.0,
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
