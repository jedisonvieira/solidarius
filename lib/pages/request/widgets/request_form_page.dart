import 'package:solidarius/shared/repositories/request_repository.dart';
import 'package:solidarius/shared/datas/request_data.dart';
import 'package:solidarius/shared/models/user_model.dart';
import 'package:solidarius/shared/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:solidarius/shared/util/methods.dart';
import '../request_page.dart';

class RequestFormPage extends StatefulWidget {
  final UserModel model;
  final RequestData? requestData;

  const RequestFormPage(this.model, {this.requestData});

  @override
  _RequestFormPageState createState() => _RequestFormPageState();
}

class _RequestFormPageState extends State<RequestFormPage> {
  int _currentStep = 0;
  bool _isEdited = false;
  bool _isRequestFormValid = false;
  RequestData _editedRequest = RequestData();

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
            address: widget.requestData!.address,
            creator: widget.requestData!.creator,
            requester: widget.requestData!.requester,
            description: widget.requestData!.description,
            neighborhood: widget.requestData!.neighborhood);

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
        ),
        floatingActionButton: Visibility(
          visible: _isRequestFormValid,
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
                                  onChanged: _validateRequestForm,
                                  maxLines: 10,
                                  controller: _descriptionController,
                                  keyboardType: TextInputType.multiline,
                                  decoration: const InputDecoration(
                                      labelText: "Descrição completa",
                                      border: OutlineInputBorder()),
                                  validator: (description) {
                                    if (description!.trim().isEmpty) {
                                      return "Campo obrigatório";
                                    }
                                  },
                                ),
                              ],
                            ),
                          ))
                    ],
                    onStepContinue: () => _continued(),
                    onStepCancel: () => _cancelled()),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                child: TextButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Constants.red)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        Text(
                          "Excluir pedido",
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                    onPressed: () => _deleteRequest(context)),
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
      _deleteRequest(context);
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

    RequestReposiroty()
        .saveRequest(
            id: _editedRequest.id,
            requestData: RequestData().toMap(_editedRequest))
        .then((value) => Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const RequestPage())));
  }
}
