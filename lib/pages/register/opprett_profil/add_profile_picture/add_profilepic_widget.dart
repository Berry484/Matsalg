import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mat_salg/helper_components/widgets/toasts.dart';
import 'package:mat_salg/auth/custom_auth/firebase_auth.dart';
import 'package:mat_salg/my_ip.dart';
import 'package:mat_salg/helper_components/flutter_flow/flutter_flow_widgets.dart';
import 'package:mat_salg/services/image_service.dart';
import 'package:mat_salg/services/user_service.dart';

import '../../../../helper_components/flutter_flow/flutter_flow_theme.dart';
import '../../../../helper_components/flutter_flow/flutter_flow_util.dart';
import '../../../../helper_components/flutter_flow/upload_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'add_profilepic_model.dart';
export 'add_profilepic_model.dart';

class AddProfilePicWidget extends StatefulWidget {
  const AddProfilePicWidget({super.key, this.konto});

  final dynamic konto;

  @override
  State<AddProfilePicWidget> createState() => _AddProfilePicWidgetState();
}

class _AddProfilePicWidgetState extends State<AddProfilePicWidget> {
  final FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  final ApiMultiplePics apiMultiplePics = ApiMultiplePics();
  final UserInfoService userInfoService = UserInfoService();
  late ProfilRedigerModel _model;

  bool _isloading = false;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProfilRedigerModel());
    FFAppState().profilepic = '';
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            iconTheme:
                IconThemeData(color: FlutterFlowTheme.of(context).primaryText),
            automaticallyImplyLeading: false,
            scrolledUnderElevation: 0.0,
            title: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
              child: Align(
                alignment: const AlignmentDirectional(0, 0),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                  child: SafeArea(
                    child: Container(
                      width: valueOrDefault<double>(
                        MediaQuery.sizeOf(context).width,
                        500.0,
                      ),
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primary,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          context.goNamed('Hjem');
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Hopp over',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Nunito',
                                    color:
                                        FlutterFlowTheme.of(context).alternate,
                                    fontSize: 17,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            actions: [],
            centerTitle: true,
            elevation: 0.0,
          ),
          body: SafeArea(
            top: true,
            bottom: false,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 30, 50),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Legg til et profilbilde',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Nunito',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              fontSize: 22,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Fullfør profilen din ved å legge til et profilbilde',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Nunito',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              fontSize: 14,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Align(
                                  alignment: const AlignmentDirectional(1, -1),
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      try {
                                        final selectedMedia =
                                            await selectMediaWithSourceBottomSheet(
                                          context: context,
                                          maxWidth: 500.00,
                                          maxHeight: 500.00,
                                          allowPhoto: true,
                                        );
                                        if (selectedMedia != null &&
                                            selectedMedia.every((m) =>
                                                validateFileFormat(
                                                    m.storagePath, context))) {
                                          safeSetState(() =>
                                              _model.isDataUploading = true);
                                          var selectedUploadedFiles =
                                              <FFUploadedFile>[];

                                          try {
                                            selectedUploadedFiles =
                                                selectedMedia
                                                    .map((m) => FFUploadedFile(
                                                          name: m.storagePath
                                                              .split('/')
                                                              .last,
                                                          bytes: m.bytes,
                                                          height: m.dimensions
                                                              ?.height,
                                                          width: m.dimensions
                                                              ?.width,
                                                          blurHash: m.blurHash,
                                                        ))
                                                    .toList();
                                          } finally {
                                            _model.isDataUploading = false;
                                          }
                                          if (selectedUploadedFiles.length ==
                                              selectedMedia.length) {
                                            safeSetState(() {
                                              _model.uploadedLocalFile =
                                                  selectedUploadedFiles.first;
                                            });
                                          } else {
                                            safeSetState(() {});
                                            return;
                                          }
                                        }
                                      } on SocketException {
                                        Toasts.showErrorToast(context,
                                            'Ingen internettforbindelse');
                                      } catch (e) {
                                        Toasts.showErrorToast(
                                            context, 'En feil oppstod');
                                      }
                                    },
                                    child: Stack(
                                      alignment:
                                          const AlignmentDirectional(1, -1),
                                      children: [
                                        if (_model
                                            .uploadedLocalFile.bytes!.isEmpty)
                                          Column(
                                            children: [
                                              Align(
                                                alignment:
                                                    const AlignmentDirectional(
                                                        0, -0.5),
                                                child: Container(
                                                  width: 135,
                                                  clipBehavior: Clip.antiAlias,
                                                  decoration:
                                                      const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Image.network(
                                                    '${ApiConstants.baseUrl}${FFAppState().profilepic}',
                                                    fit: BoxFit.cover,
                                                    width: 135,
                                                    height: 135,
                                                    errorBuilder: (context,
                                                            error,
                                                            stackTrace) =>
                                                        Image.asset(
                                                      'assets/images/profile_pic.png',
                                                      width: 135,
                                                      height: 135,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(0, 8, 0, 0),
                                                child: Text(
                                                  'Last opp bilde',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .labelLarge
                                                      .override(
                                                        fontFamily: 'Nunito',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .alternate,
                                                        fontSize: 17,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        if (_model.uploadedLocalFile.bytes!
                                            .isNotEmpty)
                                          Column(
                                            children: [
                                              Align(
                                                alignment:
                                                    const AlignmentDirectional(
                                                        0, -0.5),
                                                child: Container(
                                                  width: 135,
                                                  clipBehavior: Clip.antiAlias,
                                                  decoration:
                                                      const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Image.memory(
                                                    _model.uploadedLocalFile
                                                            .bytes ??
                                                        Uint8List.fromList([]),
                                                    width: 135,
                                                    height: 135,
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (context,
                                                            error,
                                                            stackTrace) =>
                                                        Image.asset(
                                                      'assets/images/profile_pic.png',
                                                      width: 135,
                                                      height: 135,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(0, 8, 0, 0),
                                                child: Text(
                                                  'Last opp bilde',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .labelLarge
                                                      .override(
                                                        fontFamily: 'Nunito',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .alternate,
                                                        fontSize: 17,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        if ((_model.uploadedLocalFile.bytes
                                                ?.isNotEmpty ??
                                            false))
                                          GestureDetector(
                                            onTap: () async {
                                              safeSetState(() {
                                                _model.isDataUploading = false;
                                                _model.uploadedLocalFile =
                                                    FFUploadedFile(
                                                        bytes:
                                                            Uint8List.fromList(
                                                                []));
                                              });
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(0, 5, 0, 0),
                                              child: Container(
                                                width: 29, // Matches buttonSize
                                                height: 29,
                                                decoration: BoxDecoration(
                                                  color: Colors
                                                      .black, // Black fill
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: Colors
                                                        .white, // White outline
                                                    width:
                                                        0.8, // Thickness of the outline
                                                  ),
                                                ),
                                                child: Center(
                                                  child: FaIcon(
                                                    FontAwesomeIcons.times,
                                                    color: Colors
                                                        .white, // Icon color to stand out on black
                                                    size: 16,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ]
                                  .addToStart(const SizedBox(width: 15))
                                  .addToEnd(const SizedBox(width: 15)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // First rectangle
                          Container(
                            width: 30,
                            height: 5.5,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).alternate,
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          const SizedBox(width: 10), // Space between rectangles
                          // Second rectangle
                          Container(
                            width: 30,
                            height: 5.5,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).alternate,
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: const AlignmentDirectional(0, 0),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              20, 0, 20, 40),
                          child: FFButtonWidget(
                            onPressed: () async {
                              try {
                                if (_isloading) {
                                  return;
                                }
                                _isloading = true;
                                String? token =
                                    await firebaseAuthService.getToken(context);
                                if (token == null) {
                                  FFAppState().login = false;
                                  context.goNamed('registrer');
                                  return;
                                } else {
                                  String? filelink;

                                  // Check if a file is selected and ready to upload
                                  if (_model.uploadedLocalFile.bytes
                                          ?.isNotEmpty ??
                                      false) {
                                    final List<Uint8List?> filesData = [
                                      _model.uploadedLocalFile.bytes
                                    ];

                                    // Upload file and retrieve the list of links
                                    final List<String>? fileLinks =
                                        await apiMultiplePics.uploadPictures(
                                            token: token, filesData: filesData);

                                    // Set filelink to the first link if available
                                    if (fileLinks!.isNotEmpty) {
                                      filelink = fileLinks.first;
                                    }
                                  }

                                  // Only include profilepic in updateUserInfo if filelink is non-null
                                  final response =
                                      await userInfoService.updateUserInfo(
                                    token: token,
                                    username: null,
                                    firstname: null,
                                    lastname: null,
                                    email: null,
                                    bio: null,
                                    profilepic:
                                        filelink, // Null if no file was uploaded
                                  );
                                  if (response.statusCode == 200) {
                                    final decodedBody =
                                        utf8.decode(response.bodyBytes);
                                    final decodedResponse =
                                        jsonDecode(decodedBody);
                                    // Update local app state with server response
                                    FFAppState().brukernavn =
                                        decodedResponse['username'] ?? '';
                                    FFAppState().email =
                                        decodedResponse['email'] ?? '';
                                    FFAppState().firstname =
                                        decodedResponse['firstname'] ?? '';
                                    FFAppState().lastname =
                                        decodedResponse['lastname'] ?? '';
                                    FFAppState().bio =
                                        decodedResponse['bio'] ?? '';
                                    FFAppState().profilepic =
                                        decodedResponse['profilepic'] ?? '';

                                    _isloading = false;
                                    setState(() {});
                                    context.goNamed('Hjem');
                                    return;
                                  } else if (response.statusCode == 401) {
                                    _isloading = false;
                                    FFAppState().login = false;
                                    context.goNamed('registrer');
                                    return;
                                  }
                                }
                                _isloading = false;
                              } catch (e) {
                                _isloading = false;
                                showCupertinoDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CupertinoAlertDialog(
                                      title: const Text('En feil oppstod'),
                                      content: const Text(
                                          'Prøv på nytt senere eller ta kontakt hvis problemet vedvarer'),
                                      actions: <Widget>[
                                        CupertinoDialogAction(
                                          onPressed: () async {
                                            Navigator.pop(context);
                                          },
                                          child: const Text(
                                            'Ok',
                                            style:
                                                TextStyle(color: Colors.blue),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                            text: 'Neste',
                            options: FFButtonOptions(
                              width: double.infinity,
                              height: 50.0,
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              color: FlutterFlowTheme.of(context).alternate,
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleMedium
                                  .override(
                                    fontFamily: 'Nunito',
                                    color:
                                        FlutterFlowTheme.of(context).secondary,
                                    fontSize: 17.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w800,
                                  ),
                              elevation: 0.0,
                              borderSide: const BorderSide(
                                color: Colors.transparent,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(14.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
