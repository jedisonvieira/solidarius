import 'dart:io';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:solidarius/api/firebaseApi.dart';
import 'package:solidarius/shared/repositories/request_repository.dart';
import 'package:solidarius/shared/datas/request_data.dart';
import 'package:solidarius/shared/models/user_model.dart';
import 'package:solidarius/shared/util/constants.dart';
import 'package:solidarius/shared/util/methods.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import '../request_page.dart';

class RequestFormPage extends StatefulWidget {
  final UserModel model;
  final RequestData? requestData;

  const RequestFormPage(this.model, {this.requestData});

  @override
  _RequestFormPageState createState() => _RequestFormPageState();
}

class _RequestFormPageState extends State<RequestFormPage> {
  File? file;
  Reference? ref;
  int _currentStep = 0;
  bool _isEdited = false;
  bool _isRequestFormValid = false;
  RequestData _editedRequest = RequestData();
  String fileName = "Nenhum arquivo anexado.";

  final GlobalKey<FormState> _requestDataFormkey = GlobalKey<FormState>();
  final GlobalKey<FormState> _personalDataFormKey = GlobalKey<FormState>();

  final TextEditingController _pixController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _requesterController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _neighborhoodController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.requestData != null) {
      setState(() {
        _editedRequest = RequestData(
            id: widget.requestData!.id,
            pix: widget.requestData!.pix,
            city: widget.requestData!.city,
            status: widget.requestData!.status,
            address: widget.requestData!.address,
            creator: widget.requestData!.creator,
            requester: widget.requestData!.requester,
            description: widget.requestData!.description,
            neighborhood: widget.requestData!.neighborhood,
            attachmentURL: widget.requestData!.attachmentURL);

        if (widget.requestData!.attachmentURL.isNotEmpty) {
          ref = FirebaseStorage.instance
              .refFromURL(widget.requestData!.attachmentURL);
          fileName = ref!.name;
        }

        _pixController.text = _editedRequest.pix!;
        _cityController.text = _editedRequest.city!;
        _addressController.text = _editedRequest.address!;
        _requesterController.text = _editedRequest.requester!;
        _descriptionController.text = _editedRequest.description!;
        _neighborhoodController.text = _editedRequest.neighborhood!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (file != null) fileName = path.basename(file!.path);

    return WillPopScope(
      onWillPop: () {
        return Methods().editionPop(context, _isEdited);
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
          title: Text(
            "Pedido de auxílio",
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          backgroundColor: Theme.of(context).backgroundColor,
          actions: [
            Visibility(
              visible: _editedRequest.status != null,
              child: IconButton(
                  tooltip: "Anexar comprovante ou arquivo",
                  icon: const Icon(Icons.attach_file),
                  onPressed: () => _attachFile()),
            ),
            Visibility(
              visible:
                  widget.model.isUserLogged() && _editedRequest.status != null,
              child: IconButton(
                  icon: Icon(
                    Icons.delete_forever,
                    color: Constants.red,
                  ),
                  onPressed: () => _deleteRequest(context)),
            ),
          ],
        ),
        floatingActionButton: Visibility(
          visible: _isRequestFormValid && widget.model.isUserLogged(),
          child: FloatingActionButton(
            onPressed: _checkButtonPress,
            child: Icon(
              Icons.check,
              color: Theme.of(context).primaryColor,
            ),
            backgroundColor: Theme.of(context).backgroundColor,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Theme(
                data: ThemeData(
                    colorScheme: ColorScheme.light(
                        primary: Theme.of(context).primaryColor)),
                child: Stepper(
                    onStepTapped: _tapped,
                    currentStep: _currentStep,
                    steps: [
                      Step(
                          isActive: _currentStep >= 0,
                          state: _currentStep >= 0
                              ? StepState.complete
                              : StepState.disabled,
                          title: const Text("Dados pessoais"),
                          content: Form(
                              key: _personalDataFormKey,
                              child: Column(
                                children: [
                                  _formFieldFactory(
                                      label: "Nome do auxiliado",
                                      isMandatory: true,
                                      keyboard: TextInputType.name,
                                      controller: _requesterController),
                                  _formFieldFactory(
                                      label: "Endereço",
                                      isMandatory: true,
                                      keyboard: TextInputType.streetAddress,
                                      controller: _addressController),
                                  _formFieldFactory(
                                      label: "Bairro",
                                      isMandatory: true,
                                      controller: _neighborhoodController,
                                      keyboard: TextInputType.streetAddress),
                                  _formFieldFactory(
                                      label: "Cidade",
                                      isMandatory: true,
                                      controller: _cityController,
                                      keyboard: TextInputType.streetAddress),
                                  _formFieldFactory(
                                      label: "Pix (opcional)",
                                      isMandatory: false,
                                      controller: _pixController,
                                      keyboard: TextInputType.number)
                                ],
                              ))),
                      Step(
                          isActive: _currentStep >= 1,
                          state: _currentStep >= 1
                              ? StepState.complete
                              : StepState.disabled,
                          title: const Text("Descrição do auxilio"),
                          content: Form(
                            key: _requestDataFormkey,
                            child: Column(
                              children: [
                                TextFormField(
                                  maxLines: 5,
                                  autocorrect: true,
                                  onChanged: _validateRequestForm,
                                  controller: _descriptionController,
                                  keyboardType: TextInputType.multiline,
                                  decoration: const InputDecoration(
                                    labelText: "Descrição completa",
                                  ),
                                  validator: (description) {
                                    if (description!.trim().isEmpty) {
                                      return "Campo obrigatório";
                                    }
                                  },
                                )
                              ],
                            ),
                          ))
                    ],
                    onStepContinue: () => _continued(),
                    onStepCancel: () => _cancelled()),
              ),
              Visibility(
                visible: _editedRequest.status != null,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: TextButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(Icons.attach_file),
                        Text(
                          fileName,
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    onPressed: () {
                      _showAttachmentDialog(_editedRequest.attachmentURL);
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _deleteRequest(BuildContext context) {
    Methods().actionPop(
        context: context,
        title: "Excluir pedido",
        content: "Deseja realmente excluir este pedido?",
        onYesPress: () => RequestReposiroty().deleteRequest(
            id: _editedRequest.id!,
            onSuccess: () => _requestDeleted(context),
            onFail: (error) => _requestDeletionError(context, error)));
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason>
      _requestDeletionError(BuildContext context, error) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
        content: Text("$error")));
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> _requestDeleted(
      BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        duration: Duration(seconds: 3),
        backgroundColor: Colors.redAccent,
        content: Text("Pedido de auxílio excluído.")));
  }

  TextFormField _formFieldFactory(
      {required controller,
      required label,
      required bool isMandatory,
      required TextInputType keyboard}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      decoration: InputDecoration(labelText: label),
      onChanged: (value) {
        setState(() {
          _isEdited = true;
        });
      },
      validator: (field) {
        if (isMandatory && field!.trim().isEmpty) {
          return "Campo obrigatório";
        }
      },
    );
  }

  void _tapped(int step) {
    setState(() => _currentStep = step);
  }

  void _validateRequestForm(String? value) {
    if (_requestDataFormkey.currentState!.validate()) {
      setState(() {
        _isRequestFormValid = true;
      });
    } else {
      setState(() {
        _isRequestFormValid = false;
      });
    }
  }

  void _continued() {
    if (_currentStep <= 0 && _personalDataFormKey.currentState!.validate()) {
      setState(() {
        _currentStep += 1;
      });
    } else {
      _validateRequestForm("value");
    }
  }

  void _cancelled() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep -= 1;
      });
    } else {
      if (_editedRequest.status == null) {
        Methods().editionPop(context, _isEdited);
      } else if (widget.model.isUserLogged()) {
        _deleteRequest(context);
      }
    }
  }

  void _checkButtonPress() {
    setState(() {
      if (_editedRequest.id == null) {
        _editedRequest.creator = widget.model.firebaseUser!.uid;
      } else {
        _editedRequest.lastEditor = widget.model.firebaseUser!.uid;
      }

      _editedRequest.pix = _pixController.text;
      _editedRequest.city = _cityController.text;
      _editedRequest.status = Constants.idStatusOpen;
      _editedRequest.address = _addressController.text;
      _editedRequest.requester = _requesterController.text;
      _editedRequest.description = _descriptionController.text;
      _editedRequest.neighborhood = _neighborhoodController.text;
    });

    _uploadFile().then((value) {
      RequestReposiroty()
          .saveRequest(
              id: _editedRequest.id,
              requestData: RequestData().toMap(_editedRequest))
          .then((value) => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const RequestPage())));
    });
  }

  Future<void> _attachFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;

    final path = result.files.single.path;
    setState(() {
      file = File(path!);
    });
  }

  Future<void> _uploadFile() async {
    if (file == null) return;

    final fileName = path.basename(file!.path);
    final destination = 'files/$fileName';

    UploadTask? task = FirebaseApi.uploadFile(destination, file!);

    if (task == null) return;

    final snapshot = await task.whenComplete(() => {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    setState(() {
      _editedRequest.attachmentURL = urlDownload;
    });
  }

  Future<void> _showAttachmentDialog(String attachmentURL) async {
    if (ref == null || !widget.model.isUserLogged()) return;

    await ref!.getData().then((bytes) => {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text(
                  'Anexo do pedido de auxílio',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                content: SizedBox(child: Image.memory(bytes!)),
              );
            },
          )
        });
  }
}
