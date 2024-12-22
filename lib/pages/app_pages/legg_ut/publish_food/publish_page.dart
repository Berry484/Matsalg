import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mat_salg/helper_components/dialog_utils.dart';
import 'package:mat_salg/helper_components/dividers.dart';
import 'package:mat_salg/helper_components/Toasts.dart';
import 'package:mat_salg/my_ip.dart';
import 'package:mat_salg/pages/app_pages/legg_ut/publish_food/publish_actions.dart';
import 'package:mat_salg/pages/app_pages/legg_ut/publish_food/publish_services.dart';
import 'package:mat_salg/pages/app_pages/legg_ut/velg_kategori/velg_kategori_widget.dart';
import 'package:mat_salg/logging.dart';
import '../velg_pos/velg_pos_widget.dart';
import '../../../../helper_components/flutter_flow/flutter_flow_icon_button.dart';
import '../../../../helper_components/flutter_flow/flutter_flow_theme.dart';
import '../../../../helper_components/flutter_flow/flutter_flow_util.dart';
import '../../../../helper_components/flutter_flow/flutter_flow_widgets.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
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
  late PublishModel model;
  late PublishServices publishServices;
  late PublishActions publishActions;

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
    model = createModel(context, () => PublishModel());
    publishServices = PublishServices(model: model);
    publishActions = PublishActions(model: model);
    publishServices.getUserLocation(context);

    model.produktNavnTextController ??= TextEditingController();
    model.produktNavnFocusNode ??= FocusNode();

    model.produktBeskrivelseTextController ??= TextEditingController();
    model.produktBeskrivelseFocusNode ??= FocusNode();

    model.produktPrisSTKTextController ??= TextEditingController();
    model.produktPrisSTKFocusNode ??= FocusNode();

    model.antallStkTextController ??= TextEditingController();
    model.antallStkFocusNode ??= FocusNode();

    if (widget.matinfo != null) {
      model.matvare = Matvarer.fromJson1(widget.matinfo);

      publishServices.getKommune(
          context, model.matvare.lat ?? 0, model.matvare.lng ?? 0);
      model.selectedLatLng =
          LatLng(model.matvare.lat ?? 0, model.matvare.lng ?? 0);

      model.selectedValue = model.matvare.antall ?? 0;
      model.produktNavnTextController.text = model.matvare.name ?? '';
      model.kategori = model.matvare.kategorier!.first;
      model.produktBeskrivelseTextController.text =
          model.matvare.description ?? '';
      model.produktPrisSTKTextController.text = model.matvare.price.toString();

      if (model.matvare.antall.toString() == 'null') {
        model.antallStkTextController.text = '0';
      } else {
        model.antallStkTextController.text =
            model.matvare.antall!.toStringAsFixed(0);
      }

      if (model.matvare.imgUrls != null) {
        if (model.matvare.imgUrls != null &&
            model.matvare.imgUrls!.isNotEmpty) {
          for (int i = 0; i < model.matvare.imgUrls!.length; i++) {
            if (i < model.unselectedImages.length) {
              model.unselectedImages[i] = XFile(model.matvare.imgUrls![i]);
            }
          }
        }
      }
    } else {
      model.matvare = Matvarer.fromJson1({'imgUrl': []});
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    model.dispose();
    _hiddenFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: WillPopScope(
        onWillPop: () async => false,
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
                                      Navigator.of(context)
                                          .pop(); // Just close the dialog
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
                        // context.safePop();
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
                  widget.rediger == true ? 'Rediger' : 'Ny model.matvare',
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
                      await publishActions.saveFoodUpdates(
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
                                    key: model.formKey,
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
                                                        text:
                                                            'Legg til bilder', // First part of the text
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
                                                          model.unselectedImages
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

                                                      model.unselectedImages = [
                                                        ...nonPlaceholderImages,
                                                        ...model
                                                            .unselectedImages
                                                            .where((image) =>
                                                                image.path ==
                                                                'ImagePlaceHolder.jpg'),
                                                      ];
                                                    });
                                                  },
                                                  itemCount: model
                                                      .unselectedImages
                                                      .where((image) =>
                                                          image.path !=
                                                          'ImagePlaceHolder.jpg')
                                                      .length,
                                                  proxyDecorator: (child, index,
                                                      animation) {
                                                    return Transform.scale(
                                                      scale:
                                                          1.0, // Keep the scale of the item as is
                                                      child: child,
                                                    );
                                                  },
                                                  itemBuilder: (context,
                                                      reorderableIndex) {
                                                    final nonPlaceholderImages =
                                                        model.unselectedImages
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
                                                              final imageIndex = model
                                                                  .unselectedImages
                                                                  .indexOf(
                                                                      selectedImage);
                                                              model.unselectedImages[
                                                                      imageIndex] =
                                                                  XFile(
                                                                      'ImagePlaceHolder.jpg');

                                                              model
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
                                                                      .times,
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
                                                ...model.unselectedImages
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
                                              controller: model
                                                  .produktNavnTextController,
                                              focusNode:
                                                  model.produktNavnFocusNode,
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
                                              validator: model
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
                                                        child:
                                                            VelgKategoriWidget(
                                                                kategori: model
                                                                    .kategori),
                                                      ),
                                                    );
                                                  },
                                                );

                                                setState(() {
                                                  if (velgkategori != null) {
                                                    model.kategori =
                                                        velgkategori;
                                                    model.isFocused = true;
                                                  }
                                                });
                                              } catch (e) {
                                                Toasts.showErrorToast(
                                                    context, 'En feil oppstod');
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
                                                              model.kategori ??
                                                                  'kategori',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        'Nunito',
                                                                    color: model.kategori !=
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
                                                  if (model.isFocused ||
                                                      model.kategori != null)
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
                                              controller: model
                                                  .produktBeskrivelseTextController,
                                              focusNode: model
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
                                              validator: model
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
                                                    controller: model
                                                        .produktPrisSTKTextController,
                                                    focusNode: model
                                                        .produktPrisSTKFocusNode,
                                                    onChanged: (_) =>
                                                        EasyDebounce.debounce(
                                                      'model.produktPrisSTKTextController',
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
                                                    validator: model
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
                                                          controller: model
                                                              .antallStkTextController,
                                                          focusNode: model
                                                              .antallStkFocusNode,
                                                          onChanged: (_) =>
                                                              EasyDebounce
                                                                  .debounce(
                                                            'model.antallStkTextController',
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
                                                          validator: model
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
                                                                      Container(
                                                                        height:
                                                                            200, // Set a fixed height for the picker
                                                                        child:
                                                                            CupertinoPicker(
                                                                          itemExtent:
                                                                              32.0, // Height of each item
                                                                          scrollController:
                                                                              FixedExtentScrollController(
                                                                            initialItem:
                                                                                getPickerValues().indexOf(model.selectedValue), // Set initial value
                                                                          ),
                                                                          onSelectedItemChanged:
                                                                              (index) {
                                                                            setState(() {
                                                                              model.selectedValue = getPickerValues()[index];

                                                                              model.antallStkTextController.text = model.selectedValue.toStringAsFixed(0);

                                                                              HapticFeedback.lightImpact();
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
                                                        -1.0, 0.0),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          20.0, 0.0, 0.0, 10.0),
                                                  child: Text(
                                                    'Andre vil ikke kunne se din nøyaktige posisjon.',
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

                                                        // Capture the returned LatLng from the modal bottom sheet
                                                        model.selectedLatLng =
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
                                                                    VelgPosWidget(
                                                                  currentLocation:
                                                                      model
                                                                          .currentselectedLatLng,
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        );
                                                        setState(() {
                                                          if (model
                                                                  .selectedLatLng ==
                                                              const LatLng(
                                                                  0, 0)) {
                                                            model.selectedLatLng =
                                                                null;
                                                          } else {
                                                            publishServices.getKommune(
                                                                context,
                                                                model.selectedLatLng
                                                                        ?.latitude ??
                                                                    0,
                                                                model.selectedLatLng
                                                                        ?.longitude ??
                                                                    0);
                                                            model.currentselectedLatLng =
                                                                model
                                                                    .selectedLatLng;
                                                            publishServices
                                                                .updateSelectedLatLng(
                                                                    context,
                                                                    model
                                                                        .selectedLatLng);
                                                            safeSetState(() {});
                                                          }
                                                        });
                                                      } on SocketException {
                                                        Toasts.showErrorToast(
                                                            context,
                                                            'Ingen internettforbindelse');
                                                      } catch (e) {
                                                        Toasts.showErrorToast(
                                                            context,
                                                            'En feil oppstod');
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
                                                                    model.kommune !=
                                                                            null
                                                                        ? '${model.kommune}'
                                                                        : 'Velg posisjon',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Nunito',
                                                                          color: model.kommune != null
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
                                                    await publishActions.uploadFood(
                                                        context,
                                                        (title, content) =>
                                                            DialogUtils
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
                                                            ? Toasts.showErrorToast(
                                                                context, message)
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
                                                          fontSize: 17.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w800,
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
                                                        await publishActions.markSoldOut(
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
                                                                          .w800,
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
